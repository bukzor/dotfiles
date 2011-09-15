alias ssh-dev="ssh -ttA dev06 tmux attach"

#because I've used csh for too long
function setenv() {
    export=`echo "$@" | sed 's/ /="/; s/^/export /; s/$/"/'`
    eval "$export"
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [[ -e /nail/scripts/aliases.sh ]]; then
	. /nail/scripts/aliases.sh
	PATH="$PATH:$BT/tools:$BT/aws/bin"
fi

# vim:syntax=sh:
