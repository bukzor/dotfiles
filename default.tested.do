#!/bin/sh
# Builds <name>.<shell>.tested by running <name>_test.sh under <shell>,
# for any test co-located with its code (X_test.sh tests X).
# Shells: dash, ash (busybox), bash, zsh (in sh emulation).
set -eu
name=${2%.*}
shell=${2##*.}

# Only the shared assert lib and the test itself are universal deps; the
# shell-config surface (absent on a pre-convergence checkout, e.g. main
# before task 000 lands) is an extra staleness dep where present, not a
# hard requirement -- a test that doesn't source it shouldn't need it to
# exist.
deps="lib/sh/assert.sh ${name}_test.sh"
for f in .config/sh/functions.sh .config/sh/functions.d/*.sh \
  .profile .bashrc .config/sh/bashrc.d/*.sh; do
  if [ -e "$f" ]; then
    deps="$deps $f"
  fi
done
# shellcheck disable=SC2086  # word-splitting the dep list is the point
redo-ifchange $deps

case $shell in
  ash) set -- busybox ash ;;
  zsh) set -- zsh --emulate sh ;;
  *) set -- "$shell" ;;
esac

TEST_SH="$*" "$@" "${name}_test.sh" >&2

# stdout is the target: a gitignored pass certificate
date -Iseconds # not -Ins: BSD/macOS date has no ns timespec
