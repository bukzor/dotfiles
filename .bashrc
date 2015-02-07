# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    export PATH=~/bin:"${PATH}"
fi
if [ -d ~/prefices/brew/bin ] ; then
    export PATH=~/prefices/brew/sbin:~/prefices/brew/bin:"${PATH}"
    export HOMEBREW_CASK_OPTS="--caskroom=~/Caskroom --binarydir=~/prefices/brew/bin"
fi
if [ -d ~/.local/bin ] ; then
    export PATH=~/.local/bin:"${PATH}"
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#MY PREFERENCES ==============================================================
export EDITOR VISUAL GIT_EDITOR
EDITOR=vim
VISUAL=$EDITOR
GIT_EDITOR=$EDITOR

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

terminal=$(ps -o comm= $PPID)
case "$terminal" in
lxterminal|gnome-terminal|xfce4-terminal)
    export TERM=xterm-256color
    ;;
esac

noerr () {
    "$@" 2>/dev/null 
}

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
    echo LOW COLOR TERM: $TERM, $terminal
    ;;
*)
    echo NO COLOR TERM: $TERM, $terminal
    PS1='$(noerr __git_ps1 "%s ")${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

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

  # Further environment
  export TREES=$HOME/trees
  export PROJECT_HOME=$TREES/mine
  export WORKON_HOME=$HOME/venv
  export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
  if [[ -x $(which virtualenvwrapper.sh) ]]; then
    source $(which virtualenvwrapper.sh)
  fi
  mkdir -p $WORKON_HOME $PROJECT_HOME

  # My very own python!
  if [ -f ~/venv/mypy/bin/activate ]; then
    function activate() { workon mypy; }
    if [[ $TMUX ]]; then
      PROMPT_COMMAND='eval `~/bin/tmux-env`'
      activate
    fi
  fi
fi

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# vim:et:sw=2:sts=2:
