#!/bin/sh
# Stolen from /etc/profile.
source_dir() {
  for dirname in "$@"; do
    if [ -d "$dirname" ]; then
      for source in "$dirname"/*.sh; do
        if [ -r "$source" ]; then
          . "$source"
        fi
      done
    fi
    unset source
  done
}
