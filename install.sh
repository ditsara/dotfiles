#!/bin/sh

sudo apt-get install -y \
  git \
  cmake \
  build-essential \
  xsel \
  openvpn

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
