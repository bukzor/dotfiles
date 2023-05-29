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

function path_add() { # NOTE: last wins
  one_more="$1"
  # affix colons on either side of $PATH to simplify matching
  case ":$PATH:" in
    *":$one_more:"*) : already done! ;;
    # Prepending path in case a system-installed rustc needs to be overridden
    *) export PATH="$one_more:$PATH" ;;
  esac
}

# set some defaults
export CLICOLOR=truecolor
export COLORTERM=truecolor
export EDITOR=vim
export MAKEFLAGS="-j $(($(nproc) * 2))"


# enabling meta-tools: rustup, volta, etc.
path_add "$HOME/prefix/pnpm/bin"
path_add "/opt/homebrew/bin"
export VOLTA_HOME="$HOME/.volta"
path_add "$VOLTA_HOME/bin"
path_add "$HOME/.cargo/bin"

# enable ~/bin/ unconditionally, so we can create it after login
path_add "$HOME/.local/bin"  # similar, but XDG style
path_add "$HOME/bin/alternatives"
path_add "$HOME/bin"
