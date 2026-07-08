#!/bin/sh
set -eu
here=$(dirname "$0")
. "$here/../../../lib/sh/assert.sh"
. "$here/config2lines.sh"
. "$here/each_config_line.sh"

collect() {
  count=$((count + 1))
  acc="$acc|$1"
}

count=0
acc=""
each_config_line collect <<EOF
  one two   # embedded space kept, comment dropped

  three
EOF

# The load-bearing property: mutations made inside the callback are
# visible here, after each_config_line returns. A piped (subshell)
# implementation would leave count=0 and acc empty.
assert_eq "callback mutations survive the loop" 2 "$count"
assert_eq "one call per decluttered line, spaces unsplit" "|one two|three" "$acc"

prefixed() {
  acc="$acc|$1=$2"
}
acc=""
each_config_line prefixed key <<EOF
  value
EOF
assert_eq "extra args pass through before the line" "|key=value" "$acc"

assert_done
