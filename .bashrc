# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    export PATH=~/bin:"${PATH}"
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#MY PREFERENCES ==============================================================
export EDITOR VISUAL GIT_EDITOR
EDITOR=vim
VISUAL=$EDITOR
GIT_EDITOR=$EDITOR

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=erasedups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#unmap CTRL-S and CTRL-Q
stty -ixon -ixoff

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ "$TERM" == "xterm" ] && [ "$COLORTERM" == "gnome-terminal" ]; then
    # Gnome terminal supports 256 colors, but doesn't have a way to edit $TERM
    export TERM=xterm-256color
fi

noerr () {
    "$@" 2>/dev/null 
}

if [[ -e /nail/scripts/aliases.sh ]]; then
       # work-specific stuff
       source /nail/scripts/aliases.sh
       PATH="$PATH:$BT/tools:$BT/aws/bin"

       source /etc/profile
       unset YELPCODE
       unset BT
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
    echo LOW COLOR TERM: $TERM
    ;;
*)
    echo NO COLOR TERM: $TERM
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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi
# My own completions
if [ -d ~/.bash_completion.d ]; then
    source ~/.bash_completion.d/*.sh
fi
