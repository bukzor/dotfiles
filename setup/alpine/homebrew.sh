#!/bin/bash
# https://github.com/Linuxbrew/brew/wiki/Alpine-Linux#install-linuxbrew-on-alpine-linux
set -euxo pipefail
sudo apk update
sudo apk add bash build-base curl file git gzip libc6-compat ncurses ruby-full sudo
# sudo adduser -D -s /bin/bash linuxbrew
# echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers
### su -l linuxbrew
### sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"


# Homebrew's portable ruby is glibc-only, so brew runs on this locally built one.
# Broken as of 2026-11: current brew requires Ruby 4.0 (utils/ruby.sh), and
# Alpine 3.23's own ruby is 3.3. Every `brew` auto-updates past 4.0.28 unless
# HOMEBREW_NO_AUTO_UPDATE=1. Meanwhile, prefer apk (e.g. `apk add neovim`).
PATH="$HOME/prefix/ruby26/bin:$PATH"

./ruby26.sh
brew update
brew doctor
