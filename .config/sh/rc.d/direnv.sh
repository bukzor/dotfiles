# Cross-shell direnv hook: runs before each new prompt, applying whatever
# .envrc the current directory calls for. Hand-rolled from `direnv hook
# {bash,zsh}`'s actual output rather than eval'd dynamically, so shells
# start correctly even when direnv isn't installed (the direnv check
# happens inside the hook body, at prompt time, not here at shell-init
# time). zsh has a native precmd_functions array for this; bash has no
# such hook, hence the PROMPT_COMMAND splice below.
if [ -n "${ZSH_VERSION:-}" ]; then
  _direnv_hook() {
    trap -- '' SIGINT
    if command -v direnv > /dev/null; then
      eval "$(direnv export zsh)"
    fi
    trap - SIGINT
  }
  typeset -ga precmd_functions
  if (( ! ${precmd_functions[(Ie)_direnv_hook]} )); then
    precmd_functions+=(_direnv_hook)
  fi
else
  _direnv_hook() {
    local previous_exit_status=$?;
    trap -- '' SIGINT;
    if command -v direnv > /dev/null; then
      eval "$("direnv" export bash)";
    fi
    trap - SIGINT;
    return $previous_exit_status;
  };
  if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
    PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
  fi
fi
