#!/not/executable/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# coshells are "interactive" (ish)
case "$-${COSHELL_VERSION:+i}" in
    *i*) ;;
      *) return;;
esac


# bash options  ==============================================================

# append to the history file, don't overwrite it
shopt -s histappend
# let me fix it if history-substition fails.
shopt -s histreedit

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# allow regex-like functionality in globs
shopt -s extglob

# shell settings and aliases, shared by zsh
. ~/.sh_rc

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f "$HOMEBREW_PREFIX"/etc/bash_completion ]; then
    . "$HOMEBREW_PREFIX"/etc/bash_completion
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  . ~/.sh_lib/functions.d/source_dir.sh
  source_dir ~/.bash_completion/
fi
# vim:et:sw=2:sts=2:
