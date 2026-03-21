#!/bin/bash
#
# ThinkPad X270 Fingerprint Reader Setup Script
# ==============================================
#
# PURPOSE:
# --------
# Installs and configures python-validity drivers and open-fprintd to enable
# fingerprint authentication on ThinkPad X270 with Validity 138a:0097 sensor.
# Standard libfprint does not support this hardware, requiring community drivers.
#
# PREREQUISITES:
# --------------
# - Root account must have a valid SSH key registered with GitHub
#   (Script clones repositories via SSH: git@github.com:uunicorn/...)
#   To set up: sudo ssh-keygen -t ed25519, then add ~/.ssh/id_ed25519.pub to GitHub
#
# WHAT THIS SCRIPT DOES:
# ----------------------
# 1. Verifies hardware presence (Validity 138a:0097) and root privileges
# 2. Removes conflicting standard fprintd packages
# 3. Installs build dependencies (Python, DBus, system libraries)
# 4. Clones and builds two repositories using pip with --break-system-packages:
#    - uunicorn/python-validity (core driver)
#    - uunicorn/open-fprintd (DBus service replacement)
# 5. Installs and configures systemd services with corrected paths
# 6. Creates DBus policy files for service security
# 7. Downloads firmware and performs hardware initialization
# 8. Starts services with enhanced error reporting
# 9. Configures PAM for fingerprint authentication
# 10. Displays manual enrollment instructions
#
# OBSTACLES ENCOUNTERED AND FIXED:
# --------------------------------
# 1. fprintd-clients repository: Does not exist on GitHub (removed from plan)
#
# 2. Missing python3-setuptools: Required for pip to build packages
#    Fix: Added to Phase 2 dependency installation
#
# 3. Missing innoextract: Required to extract Windows driver firmware archive
#    Fix: Added to Phase 2 system libraries installation
#
# 4. Wrong service file paths: pip installs to /usr/local/lib but service files
#    specify /usr/lib for ExecStart paths
#    Fix: Added sed commands to update both python3-validity.service and
#         open-fprintd.service with correct paths
#
# 5. Python 3.13 shutil.copy behavior: validity-sensors-firmware script calls
#    shutil.copy(file, directory) which fails in Python 3.13 with IsADirectoryError
#    Fix: Patched /usr/local/bin/validity-sensors-firmware to use os.path.join()
#         to construct full destination file path
#
# 6. Permission errors: Services couldn't write to /var/run/python-validity/ due
#    to running as non-root user by default
#    Fix: Injected "User=root" into [Service] section of both service files for
#         USB device access and filesystem permissions
#
# 7. DBus security policies: Services failed with "Connection not allowed to own
#    service due to security policies in configuration file"
#    Fix: Created manual DBus policy files at /etc/dbus-1/system.d/:
#         - net.reactivated.Fprint.conf (for open-fprintd)
#         - python3-validity.conf (for python-validity)
#         Added systemctl reload dbus after policy installation
#
# 8. Backoff file from previous failures: Service attempts create backoff timestamps
#    in /var/run/python-validity/backoff which prevent immediate retry
#    Fix: Added rm -f /var/run/python-validity/backoff in Phase 5 before starting
#
# 9. Error reporting with set -e: Script would exit before showing diagnostic info
#    Fix: Added || true to systemctl commands and immediate status checking with
#         enhanced error output (service status, logs, manual test run)
#
# 10. open-fprintd.service [Install] section: Missing WantedBy directive causes
#     systemctl enable to show warning about "no installation config"
#     Fix: Handled gracefully - service uses DBus activation, warning is harmless
#
# DEBIAN TRIXIE SPECIFICS:
# ------------------------
# - Python 3.13 with PEP 668 protection requires --break-system-packages flag
# - Python 3.13 shutil.copy() requires explicit filename in destination path
# - Service files need manual path corrections for /usr/local/lib locations
# - DBus policy files must be manually created (not found in repository archives)
# - DBus must be reloaded after policy file installation
#
# USAGE:
# ------
# sudo ./setup-fingerprint.sh
#
# After successful completion, enroll fingerprints with:
#   fprintd-enroll
#   fprintd-enroll -f right-index-finger  (for specific finger)
#
# Test authentication with:
#   sudo -k  (clear sudo cache)
#   sudo ls  (should prompt for fingerprint)
#

set -e

# Cleanup mode
if [ "$1" == "--cleanup" ]; then
    echo "========================================="
    echo "ThinkPad X270 Fingerprint Cleanup"
    echo "========================================="
    echo ""
    
    if [ "$EUID" -ne 0 ]; then
        echo "ERROR: Cleanup must be run as root (use sudo)"
        exit 1
    fi
    
    echo "[1/5] Stopping and disabling services..."
    systemctl stop python3-validity 2>/dev/null || true
    systemctl stop open-fprintd 2>/dev/null || true
    systemctl disable python3-validity 2>/dev/null || true
    systemctl unmask fprintd 2>/dev/null || true
    echo "  ✓ Services stopped"
    
    echo ""
    echo "[2/5] Removing service and configuration files..."
    rm -f /lib/systemd/system/python3-validity.service
    rm -f /lib/systemd/system/open-fprintd.service
    systemctl daemon-reload
    rm -f /etc/dbus-1/system.d/python3-validity.conf
    rm -f /etc/dbus-1/system.d/net.reactivated.Fprint.conf
    systemctl reload dbus 2>/dev/null || true
    echo "  ✓ Configuration files removed"
    
    echo ""
    echo "[3/5] Uninstalling Python packages..."
    pip3 uninstall -y python-validity 2>/dev/null || true
    pip3 uninstall -y open-fprintd 2>/dev/null || true
    echo "  ✓ Python packages uninstalled"
    
    echo ""
    echo "[4/5] Removing installed files and data..."
    rm -rf /usr/local/lib/python-validity/
    rm -rf /usr/local/lib/open-fprintd/
    rm -rf /usr/local/share/python-validity/
    rm -rf /usr/local/lib/python3.13/dist-packages/*validity*
    rm -rf /usr/local/lib/python3.13/dist-packages/*fprintd*
    rm -f /usr/local/bin/validity-sensors-firmware
    rm -rf /var/run/python-validity/
    rm -rf /var/lib/fprint/
    echo "  ✓ Files and data removed"
    
    echo ""
    echo "[5/5] System packages (optional cleanup)..."
    echo "The following packages were installed and can be removed if not needed:"
    echo "  - python3-setuptools"
    echo "  - innoextract"
    echo "  - fprintd (client tools)"
    echo ""
    echo "To remove them: sudo apt remove python3-setuptools innoextract fprintd"
    echo ""
    echo "Don't forget to run 'sudo pam-auth-update' to disable fingerprint authentication!"
    echo ""
    echo "========================================="
    echo "Cleanup complete!"
    echo "========================================="
    exit 0
fi

echo "========================================="
echo "ThinkPad X270 Fingerprint Setup"
echo "Validity 138a:0097 Driver Installation"
echo "========================================="
echo ""

# Phase 1: Validation & Preparation
echo "[1/8] Validation & Preparation"

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root (use sudo)"
    exit 1
fi
echo "  ✓ Running as root"

if ! lsusb | grep -q "138a:0097"; then
    echo "ERROR: Validity 138a:0097 fingerprint sensor not found"
    echo "Please check that your hardware is connected"
    lsusb | grep -i validity || true
    exit 1
fi
echo "  ✓ Validity 138a:0097 sensor detected"

echo "  → Removing conflicting packages..."
apt-get remove -y fprintd libpam-fprintd 2>/dev/null || true
echo "  ✓ Conflicting packages removed"

# NOTE: assume this is done prior by the user
# echo "  → Updating package cache..."
# apt-get update -qq
# echo "  ✓ Package cache updated"

# Phase 2: Dependency Installation
echo ""
echo "[2/8] Installing Dependencies"

echo "  → Installing build tools..."
apt-get install -y git build-essential
echo "  ✓ Build tools installed"

echo "  → Installing Python dependencies..."
apt-get install -y python3-pip python3-setuptools python3-cryptography python3-usb python3-yaml
echo "  ✓ Python dependencies installed"

echo "  → Installing system libraries..."
apt-get install -y libdbus-1-dev innoextract
echo "  ✓ System libraries installed"

echo "  → Installing fprintd client tools (without daemon)..."
apt-get install -y --no-install-recommends fprintd
# Ensure the standard fprintd daemon doesn't interfere
systemctl stop fprintd 2>/dev/null || true
systemctl disable fprintd 2>/dev/null || true
systemctl mask fprintd 2>/dev/null || true
echo "  ✓ Client tools installed, daemon masked"

# Phase 3: Repository Cloning & Building
echo ""
echo "[3/8] Cloning & Building Repositories"

BUILD_DIR=$(mktemp -d)
echo "  → Using temporary directory: $BUILD_DIR"

cd "$BUILD_DIR"

echo "  → Cloning python-validity..."
git clone --depth 1 git@github.com:uunicorn/python-validity.git
echo "  ✓ python-validity cloned"

echo "  → Cloning open-fprintd..."
git clone --depth 1 git@github.com:uunicorn/open-fprintd.git
echo "  ✓ open-fprintd cloned"

echo "  → Installing python-validity..."
cd python-validity
pip3 install . --break-system-packages
cd ..
echo "  ✓ python-validity installed"

echo "  → Installing open-fprintd..."
cd open-fprintd
pip3 install . --break-system-packages
cd ..
echo "  ✓ open-fprintd installed"

# Phase 4: Systemd Service Setup
echo ""
echo "[4/8] Setting Up Systemd Services"

echo "  → Installing python3-validity service..."
if [ -f python-validity/debian/python3-validity.service ]; then
    cp python-validity/debian/python3-validity.service /lib/systemd/system/
elif [ -f python-validity/python3-validity.service ]; then
    cp python-validity/python3-validity.service /lib/systemd/system/
else
    echo "ERROR: python3-validity.service not found"
    exit 1
fi
# Fix ExecStart path to match actual installation location
sed -i 's|/usr/lib/python-validity/dbus-service|/usr/local/lib/python-validity/dbus-service|g' /lib/systemd/system/python3-validity.service
# Ensure service runs as root (needed for USB access and file permissions)
if ! grep -q "^User=" /lib/systemd/system/python3-validity.service; then
    sed -i '/\[Service\]/a User=root' /lib/systemd/system/python3-validity.service
fi
# Copy DBus policy file if exists
if [ -f python-validity/debian/python3-validity.conf ]; then
    cp python-validity/debian/python3-validity.conf /etc/dbus-1/system.d/
elif [ -f python-validity/python3-validity.conf ]; then
    cp python-validity/python3-validity.conf /etc/dbus-1/system.d/
else
    echo "  ⚠ DBus policy not found in repo, creating manually..."
    cat > /etc/dbus-1/system.d/python3-validity.conf << 'EOF'
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
  <policy user="root">
    <allow own="io.github.uunicorn.Fprint"/>
    <allow send_destination="io.github.uunicorn.Fprint"/>
  </policy>
  <policy context="default">
    <allow send_destination="io.github.uunicorn.Fprint"/>
  </policy>
</busconfig>
EOF
fi
echo "  ✓ python3-validity.service installed"

echo "  → Installing open-fprintd service..."
if [ -f open-fprintd/debian/open-fprintd.service ]; then
    cp open-fprintd/debian/open-fprintd.service /lib/systemd/system/
elif [ -f open-fprintd/open-fprintd.service ]; then
    cp open-fprintd/open-fprintd.service /lib/systemd/system/
else
    echo "ERROR: open-fprintd.service not found"
    exit 1
fi
# Fix ExecStart path to match actual installation location
sed -i 's|/usr/lib/open-fprintd/open-fprintd|/usr/local/lib/open-fprintd/open-fprintd|g' /lib/systemd/system/open-fprintd.service
# Ensure service runs as root (needed for accessing python3-validity)
if ! grep -q "^User=" /lib/systemd/system/open-fprintd.service; then
    sed -i '/\[Service\]/a User=root' /lib/systemd/system/open-fprintd.service
fi
# Copy DBus policy file if exists
if [ -f open-fprintd/debian/net.reactivated.Fprint.conf ]; then
    cp open-fprintd/debian/net.reactivated.Fprint.conf /etc/dbus-1/system.d/
elif [ -f open-fprintd/net.reactivated.Fprint.conf ]; then
    cp open-fprintd/net.reactivated.Fprint.conf /etc/dbus-1/system.d/
else
    echo "  ⚠ DBus policy not found in repo, creating manually..."
    cat > /etc/dbus-1/system.d/net.reactivated.Fprint.conf << 'EOF'
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
  <policy user="root">
    <allow own="net.reactivated.Fprint"/>
    <allow send_destination="net.reactivated.Fprint"/>
    <allow send_interface="net.reactivated.Fprint.Device"/>
    <allow send_interface="net.reactivated.Fprint.Manager"/>
  </policy>
  <policy context="default">
    <allow send_destination="net.reactivated.Fprint"/>
    <allow send_interface="net.reactivated.Fprint.Device"/>
    <allow send_interface="net.reactivated.Fprint.Manager"/>
  </policy>
</busconfig>
EOF
fi
echo "  ✓ open-fprintd.service installed"

echo "  → Reloading systemd daemon..."
systemctl daemon-reload
echo "  ✓ Systemd daemon reloaded"

echo "  → Reloading DBus configuration..."
systemctl reload dbus
echo "  ✓ DBus configuration reloaded"

echo "  → Enabling services..."
systemctl enable python3-validity
systemctl enable open-fprintd 2>/dev/null || echo "  ⚠ open-fprintd has no [Install] section (will be socket-activated)"
echo "  ✓ Services enabled"

# Phase 5: Hardware Initialization
echo ""
echo "[5/8] Initializing Hardware"

echo "  → Cleaning any previous backoff state..."
rm -f /var/run/python-validity/backoff
# Also ensure the directory has correct permissions
chmod 755 /var/run/python-validity/
echo "  ✓ Backoff cleared"

echo "  → Starting python3-validity service (needed for firmware directory)..."
systemctl start python3-validity
sleep 3
# Verify it's actually running and not just in backoff
if [ -f /var/run/python-validity/backoff ]; then
    echo "  ⚠ Service entered backoff mode, checking USB access..."
    # The service might need the firmware in a different location
    if [ ! -f /var/run/python-validity/6_07f_lenovo_mis_qm.xpfwext ]; then
        echo "  → Firmware not in runtime directory, creating link..."
        ln -sf /var/lib/fprint/6_07f_lenovo_mis_qm.xpfwext /var/run/python-validity/ 2>/dev/null || true
    fi
fi
echo "  ✓ python3-validity started"

echo "  → Downloading firmware..."
cd python-validity
# Create proper firmware directory structure
mkdir -p /var/lib/fprint
mkdir -p /var/run/python-validity
# Patch the firmware script to handle Python 3.13 shutil.copy behavior
sed -i 's|shutil.copy(fwpath, PYTHON_VALIDITY_DATA_DIR)|shutil.copy(fwpath, os.path.join(PYTHON_VALIDITY_DATA_DIR, os.path.basename(fwpath)))|g' /usr/local/bin/validity-sensors-firmware
sed -i '1a import os' /usr/local/bin/validity-sensors-firmware
# Now run it
validity-sensors-firmware
# Verify and copy to both locations
FIRMWARE=$(ls /var/run/python-validity/*.xpfwext 2>/dev/null | head -1)
if [ -n "$FIRMWARE" ]; then
    cp "$FIRMWARE" /var/lib/fprint/
    echo "  ✓ Firmware downloaded and installed to both locations"
else
    echo "  ⚠ Firmware download may have failed"
fi

echo "  → Running factory reset..."
# Stop service first to release USB device
systemctl stop python3-validity 2>/dev/null || true
sleep 2
if [ -f /usr/local/share/python-validity/playground/factory-reset.py ]; then
    python3 /usr/local/share/python-validity/playground/factory-reset.py
    echo "  ✓ Factory reset completed"
elif [ -f playground/factory-reset.py ]; then
    python3 playground/factory-reset.py
    echo "  ✓ Factory reset completed"
elif [ -f factory-reset.py ]; then
    python3 factory-reset.py
    echo "  ✓ Factory reset completed"
else
    echo "  ⚠ factory-reset.py not found, skipping (may cause issues if sensor was locked)"
fi

cd "$BUILD_DIR"

# Phase 6: Service Activation
echo ""
echo "[6/8] Activating Services"

echo "  → Restarting python3-validity service..."
systemctl restart python3-validity || true
if ! systemctl is-active --quiet python3-validity; then
    echo "ERROR: python3-validity service failed to start"
    echo ""
    echo "=== Service Status ==="
    systemctl status python3-validity --no-pager -l || true
    echo ""
    echo "=== Last 30 log lines ==="
    journalctl -u python3-validity -n 30 --no-pager || true
    echo ""
    echo "=== Manual test ==="
    /usr/local/lib/python-validity/dbus-service --debug 2>&1 | head -20 &
    TEST_PID=$!
    sleep 2
    kill $TEST_PID 2>/dev/null || true
    wait $TEST_PID 2>&1 || true
    exit 1
fi
echo "  ✓ python3-validity restarted"

echo "  → Starting open-fprintd service..."
systemctl start open-fprintd || true
if ! systemctl is-active --quiet open-fprintd; then
    echo "ERROR: open-fprintd service failed to start"
    echo ""
    echo "=== Service Status ==="
    systemctl status open-fprintd --no-pager -l || true
    echo ""
    echo "=== Last 30 log lines ==="
    journalctl -u open-fprintd -n 30 --no-pager || true
    echo ""
    echo "=== Manual test ==="
    /usr/local/lib/open-fprintd/open-fprintd --debug 2>&1 | head -20 &
    TEST_PID=$!
    sleep 2
    kill $TEST_PID 2>/dev/null || true
    wait $TEST_PID 2>&1 || true
    exit 1
fi
echo "  ✓ open-fprintd started"

echo "  → Verifying services are running..."
if ! systemctl is-active --quiet python3-validity; then
    echo "ERROR: python3-validity service failed to start"
    echo "=== Service Status ==="
    systemctl status python3-validity --no-pager -l || true
    echo ""
    echo "=== Last 30 log lines ==="
    journalctl -u python3-validity -n 30 --no-pager || true
    echo ""
    echo "=== Manual test ==="
    /usr/local/lib/python-validity/dbus-service --debug 2>&1 | head -20 &
    TEST_PID=$!
    sleep 2
    kill $TEST_PID 2>/dev/null || true
    wait $TEST_PID 2>&1 || true
    exit 1
fi

if ! systemctl is-active --quiet open-fprintd; then
    echo "ERROR: open-fprintd service failed to start"
    echo "=== Service Status ==="
    systemctl status open-fprintd --no-pager -l || true
    echo ""
    echo "=== Last 30 log lines ==="
    journalctl -u open-fprintd -n 30 --no-pager || true
    echo ""
    echo "=== Manual test ==="
    /usr/local/lib/open-fprintd/open-fprintd --debug 2>&1 | head -20 &
    TEST_PID=$!
    sleep 2
    kill $TEST_PID 2>/dev/null || true
    wait $TEST_PID 2>&1 || true
    exit 1
fi
echo "  ✓ All services running"

# Phase 7: PAM Configuration
echo ""
echo "[7/8] Configuring PAM Authentication"

echo "  → Running pam-auth-update..."
echo "Please enable 'Fingerprint authentication' in the dialog that appears."
sleep 2
pam-auth-update
echo "  ✓ PAM configuration updated"

# Phase 8: Cleanup & Instructions
echo ""
echo "[8/8] Cleanup & Final Steps"

echo "  → Removing temporary build directory..."
cd /
rm -rf "$BUILD_DIR"
echo "  ✓ Build directory cleaned up"

echo ""
echo "========================================="
echo "Installation Complete!"
echo "========================================="
echo ""
echo "Fingerprint setup complete! To enroll your fingerprints:"
echo ""
echo "  1. Run: fprintd-enroll"
echo "  2. Follow the prompts to scan your finger multiple times"
echo "  3. Repeat for additional fingers if desired"
echo "  4. Test with: sudo -k followed by a sudo command"
echo ""
echo "Your fingerprint should now work for login and sudo authentication."
echo ""
echo "Verification commands:"
echo "  systemctl status python3-validity"
echo "  systemctl status open-fprintd"
echo "  fprintd-list"
echo ""
