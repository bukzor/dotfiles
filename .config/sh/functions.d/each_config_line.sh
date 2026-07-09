#!/bin/sh
# compatibility: dash, busybox sh, zsh, bash

# each_config_line FUNC [ARGS...]
# For each line of stdin (comments/whitespace/blank-lines stripped via
# config2lines), call: FUNC ARGS... LINE
#
# Heredoc-fed (not piped!) so FUNC can mutate the calling shell's own
# variables on every call -- a pipe's right-hand side runs in a
# subshell, and any mutation there is lost when it exits.
each_config_line() {
  func="$1"
  shift
  while IFS= read -r line; do
    "$func" "$@" "$line"
  done <<__EACH_CONFIG_LINE__
$(config2lines)
__EACH_CONFIG_LINE__
}
