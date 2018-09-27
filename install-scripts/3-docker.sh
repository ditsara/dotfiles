#!/bin/sh

DISTRO=$(lsb_release -as | head -1 | awk '{print tolower($0)}')
CODENAME=$(lsb_release -cs)

sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo apt-key add -


sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$DISTRO $CODENAME stable"

