# add a chpwd_functions array to bash, to match zsh
# functions named in the array are executed when pwd changes

typeset -ga chpwd_functions=()
typeset -g __chpwd_curr="(no previous pwd)"

# facility for running code "on cd"
__chpwd() {
  if [ "$__chpwd_curr" = "$PWD" ]; then
    return 0
  fi
  __chpwd_curr="$PWD"

  local chpwd_function
  for chpwd_function in "${chpwd_functions[@]}"; do
    "$chpwd_function"
  done
}

precmd_functions+=(__chpwd)
