#!/bin/sh
# this library is meant to be compatible with busybox sh and zsh as well
# shellcheck disable=SC3003  # even busybox supports $'\xff': 

has() {
  command -v "$1" > /dev/null
}
show() {
  set -x
  "$@"
  { set  +x; } 2> /dev/null
}

_init_ps4() {
  if tty -s <&1; then
    PS4=$'\n\x1b[36;1m$\x1b[m '
  else
    PS4=$'\n$ '
  fi
}
minimal_init() {
  _init_ps4
}
minimal_init
