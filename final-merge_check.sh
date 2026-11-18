#!/bin/sh
# Regression for reunify-dotfiles task 006: main and svelte-crostini have
# no common ancestor and must merge with zero conflicts. Trivially green
# once one branch contains the other; skips once the other is gone.
set -eu
redo-always
here=$(dirname "$0")
. "$here/lib/sh/assert.sh"

case $(git rev-parse --abbrev-ref HEAD) in
  main) other=svelte-crostini ;;
  svelte-crostini) other=main ;;
  *)
    echo "skip: HEAD is neither main nor svelte-crostini" >&2
    exit 0
    ;;
esac
if ! git rev-parse -q --verify "origin/$other^{commit}" >/dev/null; then
  echo "skip: no origin/$other" >&2
  exit 0
fi

# exit 1 means conflicts; anything else nonzero is merge-tree failing
rc=0
out=$(git merge-tree --write-tree --allow-unrelated-histories \
  HEAD "origin/$other") || rc=$?
assert_eq "merge-tree HEAD origin/$other exits 0" 0 "$rc"
assert_eq "merge-tree CONFLICT lines" "" \
  "$(printf '%s\n' "$out" | sed -n '/^CONFLICT/p')"

assert_done
