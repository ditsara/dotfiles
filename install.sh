#!/bin/sh

sudo apt-get install -y \
  git \
  python3 \
  cmake \
  python-dev \
  python3-dev \
  build-essential \
  vim-youcompleteme \
  xsel \
  msttcorefonts fonts-droid fonts-noto \
  python-pip \
  openvpn

printf "Updating fonts config file...\n"
printf "<?xml version='1.0'?>\n<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>\n<fontconfig>\n<match target="font">\n<edit mode="assign" name="rgba">\n<const>rgb</const>\n</edit>\n</match>\n<match target="font">\n<edit mode="assign" name="hinting">\n<bool>true</bool>\n</edit>\n</match>
<match target="font">\n<edit mode="assign" name="hintstyle">\n<const>hintslight</const>\n</edit>\n</match>\n<match target="font">\n<edit mode="assign" name="antialias">\n<bool>true</bool>\n</edit>\n</match>\n<match target="font">\n<edit mode="assign" name="lcdfilter">\n<const>lcddefault</const>\n</edit>\n</match>\n</fontconfig>\n" >> ~/.fonts.conf

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


