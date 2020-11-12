#!/bin/sh

pacman -Syu && \
  pacman -S bash-completion \
    git \
    openvpn \
    ruby \
    nodejs \
    npm \
    yarn \
    docker \
    docker-compose \
    neovim
