#!/bin/sh

sudo apt-get install -y \
  git \
  autossh \
  openvpn \
  python \
  python-pip \
  ruby

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
pip install awscli --upgrade --user
