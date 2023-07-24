#!/not-executable/bash
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

function path_prepend() { # NOTE: last wins
  local one_more newpath
  one_more="$(sed 's@/@\\/@g' <<< "$1")"
  if newpath=$(
    # shellcheck disable=2016  # I know about hard quotes
    sed -r '
      # affix colons on either side of $PATH to simplify matching
      s/^:*/:/
      s/:*$/:/
      # clean up repeated colons
      s/::+/:/g
      # remove preexisting entry
      s/:'"$one_more"':/:/g
      # prepend
      s/^:/'"$one_more"':/
      # clean up trailing colon
      s/:$//
    ' <<< "$PATH"
  ); then
	PATH="$newpath"
  fi
}

# set some defaults
export CLICOLOR=truecolor
export COLORTERM=truecolor
export EDITOR=vim
export MAKEFLAGS="-j $(($(nproc) * 3))"
export HOMEBREW_CC=clang

export GOROOT="$PREFIX/goroot"
export CARGO_INSTALL_ROOT="$PREFIX/cargo"


# NOTE: in path_prepend, last wins
# enabling meta-tools: rustup, volta, etc.
path_prepend "$HOME/.local/share/nvim/mason/bin"
path_prepend "$HOME/bin/shim"
path_prepend "$PREFIX/pnpm/bin"
path_prepend "$GOROOT/bin"
path_prepend "/opt/homebrew/bin"
export VOLTA_HOME="$HOME/.volta"
path_prepend "$VOLTA_HOME/bin"
path_prepend "$CARGO_INSTALL_ROOT/bin"

# enable ~/bin/ unconditionally, so we can create it after login
path_prepend "$HOME/.local/bin"  # similar, but XDG style
path_prepend "$HOME/bin/alternatives"
path_prepend "$HOME/bin"
