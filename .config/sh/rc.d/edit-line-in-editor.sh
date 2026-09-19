# shellcheck shell=bash  # sourced by bash and zsh; sh never interprets this
# ctrl-g: edit the current command line in $EDITOR, then hand it back to the
# prompt for review -- the same binding claude-code uses.
if [ -n "${ZSH_VERSION:-}" ]; then
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey '^g' edit-command-line    # viins
  bindkey -a '^g' edit-command-line # vicmd
elif (( ${BASH_VERSINFO[0]:-0} >= 4 )); then
  # Readline's built-in edit-and-execute-command (C-x C-e) runs the result on
  # editor exit instead. Displaces readline's `abort`, but isearch (C-r)
  # handles C-g itself, so cancelling a search still works.
  # READLINE_LINE needs bash 4.0+: macOS /bin/bash is 3.2, where this would
  # replace the line with an empty buffer; homebrew bash is fine.
  edit_line_in_editor() {
    local tmpdir
    tmpdir=$(mktemp -d) # a dir: the .sh suffix is portable there (BSD mktemp has no --suffix)
    printf '%s\n' "$READLINE_LINE" > "$tmpdir/line.sh"
    # shellcheck disable=SC2086  # $EDITOR may carry flags ("code --wait")
    ${VISUAL:-${EDITOR:-vi}} "$tmpdir/line.sh" < /dev/tty > /dev/tty
    READLINE_LINE=$(< "$tmpdir/line.sh") # $(<) drops the trailing newline
    READLINE_POINT=${#READLINE_LINE}
    rm -r -- "$tmpdir"
  }
  bind -x '"\C-g": edit_line_in_editor'
fi
