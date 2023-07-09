# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extendedglob nomatch
unsetopt autocd beep notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bukzor/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ls='ls --color -F'
alias grep='grep --color'

PS1='%n@%M %c $ '
