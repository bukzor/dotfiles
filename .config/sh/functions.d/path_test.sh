#!/bin/sh
set -eu
here=$(dirname "$0")
. "$here/../../../lib/sh/assert.sh"
. "$here/config2lines.sh"
. "$here/each_config_line.sh"
. "$here/path.sh"

PVAR="/a:/b:/c"
path prepend PVAR /new
assert_eq "prepend puts a new entry first" "/new:/a:/b:/c" "$PVAR"

PVAR="/a:/b:/c"
path prepend PVAR /b
assert_eq "prepend moves an existing entry to front (last wins)" "/b:/a:/c" "$PVAR"

PVAR="/a:/b:/c"
path append PVAR /new
assert_eq "append puts a new entry last" "/a:/b:/c:/new" "$PVAR"

PVAR="/a:/b:/c"
path append PVAR /b
assert_eq "append keeps an existing entry in place (first wins)" "/a:/b:/c" "$PVAR"

PVAR="/a"
path prepend PVAR /x /y
assert_eq "argv form: each arg prepended in turn, last wins" "/y:/x:/a" "$PVAR"

# Regression: the stdin/heredoc call form must actually process its
# entries. This once silently no-opped (bad array reference expanded to
# nothing under set +u), leaving the variable untouched with no error.
PVAR="/a:/b"
path prepend PVAR <<EOF
  /h1   # comment noise
  /b

  /h2
EOF
assert_eq "heredoc form processes every line (regression: silent no-op)" \
  "/h2:/b:/h1:/a" "$PVAR"

assert_done
