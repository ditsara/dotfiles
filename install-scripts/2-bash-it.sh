#!/bin/sh

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent --no-modify-config
ln -s ~/.bash_it/aliases/available/git.aliases.bash ~/.bash_it/enabled/150---git.aliases.bash
ln -s ~/.bash_it/aliases/available/vim.aliases.bash ~/.bash_it/enabled/150---vim.aliases.bash
