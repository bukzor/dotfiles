# From: https://github.com/popstas/zsh-command-time
typeset -gF SECONDS

_command_time_preexec() {
    export ZSH_COMMAND_TIME_START=$SECONDS

    export ZSH_COMMAND_TIME_MIN_SECONDS=${ZSH_COMMAND_TIME_MIN_SECONDS:-3}
    export ZSH_COMMAND_TIME_FORMAT=${ZSH_COMMAND_TIME_MSG:-"%T.%N"}
    export ZSH_COMMAND_TIME_COLOR=${ZSH_COMMAND_TIME_COLOR:-"white"}
}

_command_time_postexec() {
  export ZSH_COMMAND_TIME_END=$SECONDS
  export ZSH_COMMAND_TIME_DELTA=$(($ZSH_COMMAND_TIME_END - $ZSH_COMMAND_TIME_START))
  if [[ $ZSH_COMMAND_TIME_DELTA -ge ${ZSH_COMMAND_TIME_MIN_SECONDS} ]]; then
    print -P '%F{$ZSH_COMMAND_TIME_COLOR}$(date +"$ZSH_COMMAND_TIME_FORMAT" -u -d "@$ZSH_COMMAND_TIME_DELTA")%f'
  fi
}

precmd_functions+=(_command_time_postexec)
preexec_functions+=(_command_time_preexec)

_command_time_preexec  # Initialize.
