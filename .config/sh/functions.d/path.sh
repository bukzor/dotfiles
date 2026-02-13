#!/bin/sh
# compatibility: dash, busybox sh, zsh, bash
sep="" # "Unit Separator" -- the first separator higher than space

dehumanize() {
  sed -r '
    # delete all:
    s/^ +//             # leading whitespace
    s/(^|[^\\])#.*/\1/  # comments
    s/\\#/#/g           # comment-escapes
    s/ +$//             # trailing whitespace
    /^$/ d              # empty lines
  '
}

hardquote() {
  sed -r "
    s/'/'\\''/g  # escape any literal hardquotes
    s/(^|$)/'/g  # hardquote
  "
}

stdin_to_argv() {
  # Convert a configuration on stdin to arguments (whitespace, comments stripped).
  local func="$1"
  shift 1

  if tty -s; then # stdin unset
    "$func" "$@"
  else
    args=$(
      dehumanize |
        hardquote |
        tr '\n' ' '
    )
    eval "$func" "$@" "$args"
  fi
}

path() {
  stdin_to_argv _path "$@"
}

_path() {
  local func="__sh_functions_d_path__$1"
  local varname="$2"
  shift 2

  eval 'local val="$'"$varname"'"'
  val="$(printf "%s" "$val" | __sh_functions_d_path__prepare)"
  for newpath in "$@"; do
    val="$(printf "%s" "$val" | "$func" "$newpath")"
  done
  val="$(printf "%s" "$val" | __sh_functions_d_path__cleanup)"
  eval "$varname"'="$val"'
}

__sh_functions_d_path__prepare() { # NOTE: result will need cleanup
  tr ':' '\n'
}

__sh_functions_d_path__prepend() { # NOTE: removed if present, last wins, idempotent
  printf "%s\n" "$1"
  __sh_functions_d_path__remove "$1"
}

__sh_functions_d_path__append() { # NOTE: removed if present, first wins, idempotent
  __sh_functions_d_path__remove "$1"
  printf "\n%s" "$1"
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
