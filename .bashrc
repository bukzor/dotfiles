#!/not/executable/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# bash options  ==============================================================
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

# allow regex-type functionality in globs
shopt -s extglob

# General shell environment, shared by zsh
if [ -f ~/.sh_env ]; then
    source ~/.sh_env
fi
if [ -f ~/.sh_aliases ]; then
    source ~/.sh_aliases
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
 GREEN='\[\e[1;32m\]'
YELLOW='\[\e[1;33m\]'
  BLUE='\[\e[1;34m\]'
PURPLE='\[\e[1;35m\]'
  TEAL='\[\e[1;36m\]'
   END='\[\e[0;39m\]'
   PS1='$(noerr __git_ps1 "'"${TEAL}(%s)${END} "'")${debian_chroot:+($debian_chroot)}'"${BLUE}\u${END}@${GREEN}\h${END}:${YELLOW}\w${END} \n${PURPLE}[\D{%a %m-%d %I:%M:%S%p}]${END}\$ "

case "$TERM" in
*-256col*)
    # All's well.
    ;;
*-col*)
    echo "LOW COLOR TERM: $TERM ($terminal)"
    ;;
*)
    echo "NO COLOR TERM: $TERM ($terminal)"
    PS1=$(echo "$PS1" | uncolor)
    ;;
esac

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
