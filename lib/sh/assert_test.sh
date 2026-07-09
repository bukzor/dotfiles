#!/bin/sh
set -eu
here=$(dirname "$0")
. "$here/assert.sh"

errfile=$(mktemp)
trap 'rm -f "$errfile"' EXIT

out=$(skip_if_absent sh; echo continued)
assert_eq "present command lets execution continue" continued "$out"

out=$(skip_if_absent definitely-not-a-real-command-xyz123 2>"$errfile"; echo unreached)
assert_eq "absent command short-circuits remaining check body" "" "$out"
assert_eq "absent command logs a skip line to stderr" \
  "skip: definitely-not-a-real-command-xyz123 not installed" "$(cat "$errfile")"

assert_done
