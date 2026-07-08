#!/bin/sh
# Builds <name>.<shell>.tested by running <name>_test.sh under <shell>,
# for any test co-located with its code (X_test.sh tests X).
# Shells: dash, ash (busybox), bash, zsh (in sh emulation).
set -eu
name=${2%.*}
shell=${2##*.}

redo-ifchange lib/sh/assert.sh "${name}_test.sh" \
  .config/sh/functions.sh .config/sh/functions.d/*.sh \
  .profile .bashrc .config/sh/bashrc.d/*.sh

case $shell in
  ash) set -- busybox ash ;;
  zsh) set -- zsh --emulate sh ;;
  *) set -- "$shell" ;;
esac

TEST_SH="$*" "$@" "${name}_test.sh" >&2

# stdout is the target: a gitignored pass certificate
date -Iseconds # not -Ins: BSD/macOS date has no ns timespec
