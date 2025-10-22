#!/bin/sh
# compatibility: dash, busybox sh, zsh, bash
sep=""  # "Unit Separator" -- the first separator higher than space

path() { # NOTE: last wins
  local var val newpath
  if [ "$#" -lt 2 ] || [ "$1" ]; then
    return 1
  fi

  case $(IFS="$sep"; echo "$*") in
    pre$sep*) func=_path_prepend ;;
    post$sep*) func=_path_append ;;
    rm$sep*) func=_noop ;;
    *)
      echo >&2 "path: usage: path [pre|post] [VARNAME] [PATH ...]"
      return 1
      ;;
  esac
  shift 1

  eval 'val="$'"$varname"'"'
  for newpath in "$@"; do
    val="$(
      echo "$val" |
      _path_prepare |
      _path_remove "$newpath" |
        "$func" "$val" "$newpath" |
        _path_cleanup
    )"
  done
  eval "$varname"'="$val"'
}

_noop() { :; }

_path_prepend() { # NOTE: removed if present, last wins, idempotent
  local newpath="$2"

  # shellcheck disable=2016  # I know about hard quotes
  # prepend
  sed -r 's/^:/'"$newpath"':/'
}

_path_prepare() {  # NOTE: result will need cleanup
  sep="${1:-:}"
  # double all colons and affix colons on either end, to simplify matching
  sed -r "
    s/$sep/$sep$sep/g

    s/^/$sep/
    s/\$/$sep/
  "
}

_path_remove() { # remove any/all matching entries
  local newpath="$1"
  sed -r 's/:'"$newpath"':/:/g'
}


_path_append() { # NOTE: removed if present, first wins, idempotent
  local newpath
  newpath="$1"
  sep="${2:-:}"

  # append
  sed -r "s/$sep\$/$sep$newpath/"
}

_path_cleanup() {
  sep="${1:-:}"
  sed -r "
      # clean up repeated separators
      s/$sep$sep+/$sep/g
      # clean up: leading/trailing separator
      s/^$sep//
      s/$sep\$//
  "
}
