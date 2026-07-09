#!/bin/sh
# Regression: shell config accreted across eras (~/.sh_* -> ~/.config/env/ ->
# ~/.config/sh/), leaving shims that pointed at the extinct ~/.sh/ tree.
set -eu
here=$(dirname "$0")
repo=$(cd "$here/../.." && pwd)
. "$repo/lib/sh/assert.sh"

hits=$(grep -rn '\.sh/' "$repo/.config/sh" 2>/dev/null | grep -v '_check\.sh:' || true)
assert_eq "no references to the extinct ~/.sh/ tree under .config/sh" "" "$hits"

assert_done
