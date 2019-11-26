#!/not/executable/bash
# Adapted from: https://github.com/popstas/zsh-command-time
SH_RUN_TIME_MINIMUM="$((100 * 1000 * 1000))"
SH_RUN_TIME_FORMAT="duration: $GREEN\$duration$RESET"
SH_RUN_TIME_PREEXEC=true
_run_time_nanonow() { date +%s%N; }
SH_RUN_TIME_START="$(_run_time_nanonow)"

_run_time_preexec() {
  SH_RUN_TIME_PREEXEC=true
  SH_RUN_TIME_START="$(_run_time_nanonow)"
}

_run_time_postexec() {
  if "$SH_RUN_TIME_PREEXEC"; then
    SH_RUN_TIME_PREEXEC=false
  else
    return
  fi
  local end="$(_run_time_nanonow)"
  local duration="$((end - SH_RUN_TIME_START))"
  if [[ "$duration" -ge "$SH_RUN_TIME_MINIMUM" ]]; then
    local duration="$(duration "$duration")"
    sed 's/$duration/'"$duration"'/' <<< "$SH_RUN_TIME_FORMAT"
  fi
}

precmd_functions+=(_run_time_postexec)
preexec_functions+=(_run_time_preexec)
