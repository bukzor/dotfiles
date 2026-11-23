#!/bin/bash
# https://github.com/Linuxbrew/brew/wiki/Alpine-Linux#install-linuxbrew-on-alpine-linux
set -euxo pipefail
sudo apk update
sudo apk add bash build-base curl file git gzip libc6-compat ncurses ruby-full sudo
# sudo adduser -D -s /bin/bash linuxbrew
# echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers
### su -l linuxbrew
### sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"


# Homebrew's portable ruby is glibc-only; ~/bin/brew runs brew under this one.
"$(dirname "$0")"/homebrew-ruby.sh
brew update
brew doctor
