#!/bin/sh

DISTRO=$(lsb_release -as | head -1 | awk '{print tolower($0)}')
CODENAME=$(lsb_release -cs)

sudo apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo apt-key add -


sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$DISTRO $CODENAME stable"

sudo apt-get update && sudo apt-get install -y docker-ce

sudo curl -L --fail https://github.com/docker/compose/releases/download/1.23.1/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
