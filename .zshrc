#
# Executes commands at the start of any interactive session.
# Shell options, functions, and aliases go here!
# Environment variables do *not* go here. They go in .zprofile.
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# no ding!
ZBEEP=""

# allow variables in PS1
setopt PROMPT_SUBST

setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt COMPLETE_IN_WORD          # tab in the middle of a word works correctly!
setopt ALWAYS_TO_END
setopt INTERACTIVE_COMMENTS      # sometimes I copy-paste comments

# enable advanced completions
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select insert-unambiguous

HISTFILE="$HOME/.zsh_history"

function history() {
    builtin history -LDi -n "$@"
}

. ~/.sh_rc

zkbd_dir="${ZDOTDIR:-$HOME}/.zkbd"
zkbd_file="$zkbd_dir/$TERM-$VENDOR-$OSTYPE"
ln -sf $zkbd_file $zkbd_dir/$TERM.tmp
if ! source "$zkbd_file"; then
    autoload zkbd && zkbd
    source "$zkbd_file"
fi
unset zkbd_file

# reset and enable vim bindings
bindkey -d
bindkey -v

# Anoyances:
# allow backspace after vi-A
bindkey "$key[Backspace]" backward-delete-char
# backspace doesn't work if you were ever in normal mode
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line

# tab completion is over-eager
unsetopt MENU_COMPLETE
setopt AUTO_MENU
bindkey "^[[Z" reverse-menu-complete


# can't move cursor left to previous line
bindkey "^[OC" forward-char
bindkey "^[OD" backward-char
bindkey "^[OF" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[C" forward-char
bindkey "^[[D" backward-char

# fix home/end keys
bindkey "$key[Home]" beginning-of-line
bindkey "$key[End]" end-of-line
bindkey -a "$key[Home]" beginning-of-line
bindkey -a "$key[End]" end-of-line

# esc-v to edit command in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# jj for normal mode
bindkey 'jj' vi-cmd-mode

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
bindkey '^s' history-incremental-pattern-search-forward
bindkey '^r' history-incremental-pattern-search-backward

# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history

# this makes more sense, to me:
bindkey -a '/' history-incremental-pattern-search-forward
bindkey -a '?' history-incremental-pattern-search-backward

# up and down keys only search through the local history
# use ctrl-P/N for shared history {
    up-line-or-local-history() {
        zle set-local-history -n 1
        zle up-line-or-history
        zle set-local-history -N
    }
    zle -N up-line-or-local-history
    bindkey "$key[Up]" up-line-or-local-history
    bindkey -a "k" up-line-or-local-history

    down-line-or-local-history() {
        zle set-local-history -n 1
        zle down-line-or-history
        zle set-local-history -N
    }
    zle -N down-line-or-local-history
    bindkey "$key[Down]" down-line-or-local-history
    bindkey -a "j" down-line-or-local-history

# opam configuration
if [ -r ~/.opam/opam-init/init.zsh ]; then
  . ~/.opam/opam-init/init.zsh
fi

if [ -e "$HOME/private-dotfiles/.zshrc" ]; then
    source "$HOME/private-dotfiles/.zshrc"
fi
