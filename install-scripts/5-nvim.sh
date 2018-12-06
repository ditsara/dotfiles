#!/bin/sh

sudo apt-get install -y neovim silversearcher-ag fzy

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \

nvim -E -u NONE -S ~/.config/nvim/init.vim +PlugInstall +qall > /dev/null || true
