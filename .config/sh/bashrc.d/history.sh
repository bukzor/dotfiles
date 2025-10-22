# don't put duplicate lines in the history.
HISTCONTROL=ignoredup

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=$((10 * 1000))
HISTFILESIZE=$((100 * 1000))

# append to the history file, don't overwrite it
shopt -s histappend

prompt_commands+=(
  'history -a;history -n'
)
