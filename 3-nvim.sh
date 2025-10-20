#!/bin/sh

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

apt install -y neovim

rsync -avI $SCRIPT_DIR/nvim/ ~

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \

nvim -E -u NONE -S ~/.config/nvim/init.lua +PlugInstall +qall > /dev/null || true
