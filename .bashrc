#!/not/executable/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

#unmap CTRL-S and CTRL-Q
stty -ixon -ixoff

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f ~/prefices/brew/etc/bash_completion ]; then
    . ~/prefices/brew/etc/bash_completion
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
  # My own completions
  if [ -d ~/.bash_completion.d ]; then
    source ~/.bash_completion.d/*.sh
  fi

  # completions for travis, added by travis gem
  [ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
fi

if [[ $TMUX ]]; then
  PROMPT_COMMAND='eval `~/bin/tmux-env`; '"$PROMPT_COMMAND"
fi
if which aactivator >/dev/null; then
  eval "$(aactivator init)"
fi
# vim:et:sw=2:sts=2:
