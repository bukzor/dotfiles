# reset then enable vim-style command-line editing
bindkey -d
bindkey -v

# only bind a zkbd-derived key if 030-zkbd.sh actually resolved it (it may
# not have, absent a real controlling terminal -- see its comment)
bindkey_zkbd() { # bindkey_zkbd [bindkey-flags...] KEYNAME WIDGET
  [[ -n "${key[${@[-2]}]:-}" ]] && bindkey "${@[1,-3]}" "${key[${@[-2]}]}" "${@[-1]}"
}

# Annoyances:
# allow backspace after vi-A
bindkey_zkbd Backspace backward-delete-char
# backspace doesn't work if you were ever in normal mode
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line

# tab completion is over-eager
unsetopt MENU_COMPLETE
setopt AUTO_MENU
bindkey "^[[Z" reverse-menu-complete

# default vim bindings can't move cursor left to previous line
bindkey "^[OC" forward-char
bindkey "^[OD" backward-char
bindkey "^[OF" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[C" forward-char
bindkey "^[[D" backward-char

# fix home/end keys
bindkey_zkbd Home beginning-of-line
bindkey_zkbd End end-of-line
bindkey_zkbd -a Home beginning-of-line
bindkey_zkbd -a End end-of-line

# esc-v to edit command in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# jj for normal mode
bindkey 'jj' vi-cmd-mode

# ctrl-w remove word backwards
bindkey '^w' backward-kill-word

# ctrl-s/ctrl-r search history
bindkey '^s' history-incremental-pattern-search-forward
bindkey '^r' history-incremental-pattern-search-backward

# ctrl-P/N reach the full shared history (up/down below are local-only)
bindkey '^P' up-history
bindkey '^N' down-history

# this makes more sense, to me:
bindkey -a '/' history-incremental-pattern-search-forward
bindkey -a '?' history-incremental-pattern-search-backward

# up/down keys only search through this session's local history
up-line-or-local-history() {
  zle set-local-history -n 1
  zle up-line-or-history
  zle set-local-history -N
}
zle -N up-line-or-local-history
bindkey_zkbd Up up-line-or-local-history
bindkey -a "k" up-line-or-local-history

down-line-or-local-history() {
  zle set-local-history -n 1
  zle down-line-or-history
  zle set-local-history -N
}
zle -N down-line-or-local-history
bindkey_zkbd Down down-line-or-local-history
bindkey -a "j" down-line-or-local-history

unset -f bindkey_zkbd
