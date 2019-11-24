#!/not/executable/bash
# Adapted from: https://github.com/popstas/zsh-command-time
SH_RUN_TIME_MINIMUM=0.2
SH_RUN_TIME_FORMAT="duration: $GREEN\$duration$RESET"
SH_RUN_TIME_PREEXEC=true
SH_RUN_TIME_START="$(date +%s.%N)"

_run_time_preexec() {
  SH_RUN_TIME_PREEXEC=true
  SH_RUN_TIME_START="$(date +%s.%N)"
}

_duration_fmt() {
  duration="$1"
  days="$(bc <<< "$duration / 60 / 60 / 24")"
  if [[ "$days" -gt 0 ]]; then
    printf "$days-"
  fi

  echo "$(date +"%T.%3N" -u -d "@0$duration" | sed 's/00://g; s/^0*//')"
}

_run_time_postexec() {
  if "$SH_RUN_TIME_PREEXEC"; then
    SH_RUN_TIME_PREEXEC=false
  else
    return
  fi
  local end="$(date +%s.%N)"
  local delta="$(bc <<< "$end - $SH_RUN_TIME_START")"
  if [[ "$(bc <<< "$delta >= $SH_RUN_TIME_MINIMUM")" -eq 1 ]]; then
    duration="$(_duration_fmt "$delta")" envsubst '$duration' <<< "$SH_RUN_TIME_FORMAT"
  fi
}

precmd_functions+=(_run_time_postexec)
preexec_functions+=(_run_time_preexec)
