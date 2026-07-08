#!/bin/sh
# compatibility: dash, busybox sh, zsh, bash

# path MODE VARNAME [ENTRY...]
# Apply MODE (prepend/append) to each ENTRY against $VARNAME. With no
# ENTRY args, reads entries from stdin instead (one per line, via
# each_config_line) -- so a call site can pass either a heredoc or an
# explicit argument list.
path() {
  local mode="$1" varname="$2"
  shift 2
  local path_func="__sh_functions_d_path__$mode"

  eval "local path_val=\"\$$varname\""
  path_val="$(printf '%s' "$path_val" | __sh_functions_d_path__prepare)"

  __sh_functions_d_path__apply_one() {
    path_val="$(printf '%s' "$path_val" | "$path_func" "$1")"
  }

  if [ "$#" -eq 0 ]; then # no explicit entries: read from stdin
    each_config_line __sh_functions_d_path__apply_one
  else
    local newpath
    for newpath in "$@"; do
      __sh_functions_d_path__apply_one "$newpath"
    done
  fi

  path_val="$(printf '%s' "$path_val" | __sh_functions_d_path__cleanup)"
  eval "$varname=\"\$path_val\""
}

__sh_functions_d_path__prepare() { # NOTE: result will need cleanup
  tr ':' '\n'
}

__sh_functions_d_path__prepend() { # NOTE: removed if present, last wins, idempotent
  printf '%s\n' "$1"
  __sh_functions_d_path__remove "$1"
}

__sh_functions_d_path__append() { # NOTE: kept in place if present, first wins, idempotent
  awk -v entry="$1" '
    { print }
    $0 == entry { found = 1 }
    END { if (!found) print entry }
  '
}

__sh_functions_d_path__remove() { # remove any/all matching entries
  grep -Fx -v "$1"
}

__sh_functions_d_path__cleanup() {
  grep . |
    tr '\n' ':' |
    sed 's/:*$//' \
    ;
}
