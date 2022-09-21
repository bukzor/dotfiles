#!/bin/sh
trysource() {
  for source in "$@"; do
    if [ -f "$source" ]; then
      . "$source"
    fi
  done
}
