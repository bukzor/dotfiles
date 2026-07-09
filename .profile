#!/not-executable/bash
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# bootstrap HOME/USER: everything below is located via $HOME, so this can't
# itself move into profile.d/00-basics.sh (which needs source_dir, which
# needs functions.sh, which needs $HOME).
if [ -z "$HOME" ]; then
  export HOME USER
  USER=$(whoami)
  HOME=$(eval "echo ~$USER")
fi

# get source_dir, path, has, nproc, ... (functions.d)
. "$HOME/.config/sh/functions.sh"

# HOME/USER/PATH basics (idempotent re-check), then all noninteractive env
source_dir "$HOME/.config/sh/profile.d"
source_dir "$HOME/.config/sh/env.d"

# if running bash, hand off for interactive-only additions
if [ -n "$BASH_VERSION" ]; then
  . "$HOME/.bashrc"
fi

alias login="source ~/.profile"

env > ~/profile.env
