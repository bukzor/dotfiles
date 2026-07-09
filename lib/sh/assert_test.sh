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

if command -v script >/dev/null && command -v bash >/dev/null; then
  : >"$errfile"
  with_pty 'bash -i -c exit' 2>"$errfile" >/dev/null
  assert_eq "with_pty suppresses interactive job-control noise on stderr" \
    "" "$(cat "$errfile")"

  rc=0
  with_pty 'exit 3' >/dev/null 2>&1 || rc=$?
  assert_eq "with_pty propagates the wrapped command's exit status" 3 "$rc"
else
  echo "skip: script or bash not installed (with_pty tests)" >&2
fi

assert_done
