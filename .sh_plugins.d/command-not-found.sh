#
# brew-command-not-found script for macOS
#
# Usage: Source it somewhere in your .bashrc (bash) or .zshrc (zsh)
#
# Author: Baptiste Fontaine
# URL: https://github.com/Homebrew/homebrew-command-not-found
# License: MIT
# Version: 0.2.0
#
# The code below is based off this Linux Journal article:
#   http://www.linuxjournal.com/content/bash-command-not-found

if [ -n "$BASH_VERSION" ]; then
    command_not_found_handle() {
        command-not-found-hook "$1"
        return $?
    }
elif [ -n "$ZSH_VERSION" ]; then
    command_not_found_handler() {
        command-not-found-hook "$1"
        return $?
    }
fi
