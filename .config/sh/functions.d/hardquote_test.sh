#!/bin/sh
set -eu
here=$(dirname "$0")
. "$here/../../../lib/sh/assert.sh"
. "$here/hardquote.sh"

str="it's got 'embedded' quotes"
eval "set -- $(printf '%s\n' "$str" | hardquote)"
assert_eq "embedded single-quotes round-trip through eval" "$str" "$1"

# Output is one quoted token per line; multi-token eval needs an
# explicit join, since a bare newline separates *commands* under eval.
eval "set -- $(printf '%s\n%s\n' "a b" "c'd" | hardquote | tr '\n' ' ')"
assert_eq "one token per input line" 2 "$#"
assert_eq "spaces stay within their token" "a b" "$1"
assert_eq "second token intact" "c'd" "$2"

assert_done
