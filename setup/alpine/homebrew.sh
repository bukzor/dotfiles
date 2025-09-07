#!/bin/bash
# https://github.com/Linuxbrew/brew/wiki/Alpine-Linux#install-linuxbrew-on-alpine-linux
set -euxo pipefail
sudo apk update
sudo apk add bash build-base curl file git gzip libc6-compat ncurses ruby-full sudo
sudo adduser -D -s /bin/bash linuxbrew
echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers
### su -l linuxbrew
### sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
### PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH
### brew update
### brew doctor
