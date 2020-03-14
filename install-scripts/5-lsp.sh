#!/bin/sh
gem install bundler -v '~>2'
gem install bundler -v '~>1'
gem install irb reline solargraph

mkdir "${HOME}/.npm-packages"
npm config set prefix "${HOME}/.npm-packages"
npm install -g typescript-language-server
