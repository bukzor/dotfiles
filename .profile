#!/not-executable/bash
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -z "$HOME" ]; then
  export HOME USER
  USER=$(whoami)
  HOME=$(eval "echo ~$USER")
  ##@#exit 0   # ???
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  . "$HOME/.bashrc"
fi

# `nproc` and `path`
. ~/.config/sh/functions.sh

# set some defaults
export CLICOLOR=truecolor
export COLORTERM=truecolor
export EDITOR=vim
export MAKEFLAGS="-j $(($(nproc) * 3))"
export HOMEBREW_CC=clang

export PREFIX=$HOME/prefix
export GOPATH="$PREFIX/golang"
export CARGO_INSTALL_ROOT="$PREFIX/cargo"

export VOLTA_HOME="$HOME/.volta"

# NOTE: in path_prepend, last wins
# enabling meta-tools: rustup, volta, etc.
path prepend PATH <<EOF
  $HOME/.local/share/nvim/mason/bin
  $HOME/bin/shim
  $PREFIX/pnpm/bin
  $GOROOT/bin
  /opt/homebrew/bin
  $VOLTA_HOME/bin
  $CARGO_INSTALL_ROOT/bin
  $HOME/.cargo/bin

  # enable ~/bin/ unconditionally, so we can create it after login
  $HOME/.local/bin  # similar, but XDG style
  $HOME/bin
EOF

## for preferred_shell in "$(which zsh)"; do
##   if [ ! "$SHELL" -ef "$preferred_shell" -a -x "$preferred_shell" ]; then
##     SHELL="$preferred_shell" exec "$preferred_shell" -il
##   fi
## done
