#!/bin/sh

apt install -y rbenv

# ruby-build for RBEnv
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv init
