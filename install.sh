#!/bin/sh

sudo apt-get install -y \
  git \
  python3 \
  cmake \
  python-dev \
  python3-dev \
  build-essential

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


