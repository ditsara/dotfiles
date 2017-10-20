#!/bin/sh

sudo apt-get install -y \
  git \
  mosh \
  openvpn

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
