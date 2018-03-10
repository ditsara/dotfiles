#!/bin/sh

sudo apt-get install -y \
  git \
  autossh \
  openvpn \
  ruby \
  xclip

VUNDLE_DIR=~/.vim/bundle/Vundle.vim
if [ ! -d $VUNDLE_DIR/.git ]; then
  echo 'Vundle not found; retrieving from GitHub'
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
