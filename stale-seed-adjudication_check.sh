#!/bin/sh
# Regression for reunify-dotfiles task 002 (stale-seed adjudication): the
# two files resolved so far (.config/gh/.gitignore, .config/pnpm/rc) took
# main's version outright. Confirm the affected tools still start.
# (kitty/.gitmodules and the rest of the 9-file list turned out to be
# genuinely mixed, not stale-seed -- escalated to todo 004, not checked here.)
set -eu
here=$(dirname "$0")
. "$here/lib/sh/assert.sh"

if command -v gh >/dev/null; then
  assert_eq "gh starts" "" "$(gh --version >/dev/null 2>&1 || echo FAILED)"
else
  echo "skip: gh not installed" >&2
fi

if command -v pnpm >/dev/null; then
  assert_eq "pnpm starts" "" "$(pnpm --version >/dev/null 2>&1 || echo FAILED)"
else
  echo "skip: pnpm not installed" >&2
fi

assert_done
