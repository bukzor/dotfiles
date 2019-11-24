#!/not/executable/bash
SH_EXIT_CODE_PREEXEC=true
_exit_code_preexec() {
  SH_EXIT_CODE_PREEXEC=true
}

_exit_code_postexec() {
  local code="$?"
  if "$SH_EXIT_CODE_PREEXEC"; then
    SH_EXIT_CODE_PREEXEC=false
  else
    return
  fi

  if [[ "$code" -ne 0 ]]; then
    echo "exit code: $RED$code$RESET"
  fi
}

precmd_functions+=(_exit_code_postexec)
preexec_functions+=(_exit_code_preexec)
