# shellcheck shell=bash  # sourced by bash and zsh; sh never interprets this
# A terminal's title is where a program says what work it holds; tmux keeps it
# as #{pane_title} and the status bar shows it. Programs that know their task
# declare one (claude names its conversation); a shell only knows its
# directory, but declaring that beats the alternative -- a title outlives the
# program that set it, so a pane whose program exited keeps advertising work
# that ended, and an undeclared pane reports the hostname instead.
_pane_title_hook() {
  case "$-" in
    *i*) ;;
    *) return 0 ;;
  esac
  [ -t 1 ] || return 0

  _pane_title_pwd="$PWD"
  case "$_pane_title_pwd" in
    "$HOME") _pane_title_pwd='~' ;;
    "$HOME"/*) _pane_title_pwd="~${_pane_title_pwd#"$HOME"}" ;;
  esac
  printf '\033]2;%s\007' "$_pane_title_pwd"
}

if [ -n "${ZSH_VERSION:-}" ]; then
  typeset -ga precmd_functions
  # shellcheck disable=SC2004  # (Ie) is a zsh subscript flag, not arithmetic
  if (( ! ${precmd_functions[(Ie)_pane_title_hook]} )); then
    precmd_functions+=(_pane_title_hook)
  fi
else
  # bashrc.d/050-precmd-functions.sh runs this array before each prompt
  case " ${prompt_commands[*]:-} " in
    *_pane_title_hook*) ;;
    *) prompt_commands+=('_pane_title_hook') ;;
  esac
fi
