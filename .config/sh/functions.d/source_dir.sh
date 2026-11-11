#!/bin/sh
# Stolen from /etc/profile.
source_dir() {
  for dirname in "$@"; do
    if [ -d "$dirname" ]; then
      for source in "$dirname"/*.sh; do
        case "$source" in
          *_test.sh) continue ;; # tests live beside the code; never source them
        esac
        if [ -r "$source" ]; then
          # Deliberately not `. "$source" || warn ...`: that suspends errexit
          # for the whole file, turning a fatal failure mid-file into a silently
          # skipped one. Under errexit this aborts; without it, a file whose
          # last command failed at least says so.
          . "$source"
          source_status=$?
          if [ "$source_status" -ne 0 ]; then
            warn "failed to source ($source_status): $source"
          fi
        fi
      done
    fi
    unset source source_status
  done
}
