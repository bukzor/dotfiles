#!/bin/sh
set -eu
here=$(dirname "$0")
. "$here/../../../lib/sh/assert.sh"
. "$here/config2lines.sh"

assert_eq "trailing comment stripped" \
  "keep" \
  "$(printf 'keep # comment\n' | config2lines)"

assert_eq "full-line comment dropped" \
  "" \
  "$(printf '# only a comment\n' | config2lines)"

assert_eq "escaped hash survives as literal" \
  "a#b" \
  "$(printf 'a\\#b\n' | config2lines)"

assert_eq "leading and trailing whitespace stripped" \
  "word" \
  "$(printf '   word   \n' | config2lines)"

assert_eq "blank lines dropped" \
  "$(printf 'one\ntwo')" \
  "$(printf 'one\n\n   \ntwo\n' | config2lines)"

assert_eq "embedded spaces preserved" \
  "one two" \
  "$(printf '  one two  # note\n' | config2lines)"

assert_done
