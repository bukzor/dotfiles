# a shim to make bash match zsh with a $precmd_functions array

prompt_commands=(
  'history -a;history -n'
)
PROMPT_COMMAND='for cmd in "${prompt_commands[@]}"; do eval "$cmd"; done'
