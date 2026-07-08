#!/bin/sh
# Fans out every *_test.sh to a <name>.<shell>.tested per installed shell.
# Absent shells skip (crostini, CI, and macOS carry different sets).
set -eu
exec >&2

targets=
for t in .profile_test.sh .config/sh/functions.d/*_test.sh; do
  name=${t%_test.sh}
  for shell in dash ash bash zsh; do
    case $shell in ash) cmd=busybox ;; *) cmd=$shell ;; esac
    if command -v "$cmd" >/dev/null; then
      targets="$targets $name.$shell.tested"
    else
      echo "skip: $shell not installed"
    fi
  done
done

# shellcheck disable=SC2086  # word-splitting the target list is the point
redo-ifchange $targets
