HISTFILE="$HOME/.zsh_history"
# same sizes as bashrc.d/history.sh, one source of truth for "how much"
HISTSIZE=$((10 * 1000))
SAVEHIST=$((100 * 1000))

setopt EXTENDED_HISTORY          # write history in ":start:elapsed;command" format
setopt SHARE_HISTORY             # share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # expire duplicate entries first when trimming
setopt HIST_IGNORE_ALL_DUPS      # delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # don't display a line previously found
setopt HIST_SAVE_NO_DUPS         # don't write duplicate entries to the history file

function history() {
  if [[ "$#" -eq 0 ]]; then
    # modify default options
    set -- -LDi -n
  elif [[ "$#" -eq 1 ]] && [[ "$1" -ne 0 ]]; then
    set -- -n -- -"$1"
  fi
  # > same as `fc -l`
  builtin history "$@"
}
