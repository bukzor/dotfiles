#!/bin/sh
# Builds <name>.checked by running <name>_check.sh once under sh:
# run-once repo/tool checks, no shell fan-out (that's default.tested.do).
# A ref-dependent check (branch tips aren't file deps) calls redo-always
# itself; the vendored minimal do stubs it and always rebuilds anyway.
set -eu
name=$2

redo-ifchange lib/sh/assert.sh "${name}_check.sh"

sh "${name}_check.sh" >&2

# stdout is the target: a gitignored pass certificate
date -Iseconds # not -Ins: BSD/macOS date has no ns timespec
