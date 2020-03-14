#!/bin/sh

# nodejs + npm
curl -sL https://deb.nodesource.com/setup_12.x | bash -

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt update && \
  apt install -y \
    git \
    openvpn \
    ruby \
    nodejs \
    yarn
