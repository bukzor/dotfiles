#!/bin/sh
set -eu
here=$(dirname "$0")
. "$here/lib/sh/assert.sh"
repo=$(cd "$here" && pwd)

# Hermetic HOME: same symlink-farm pattern as .profile_test.sh.
tmphome=$(mktemp -d)
trap 'rm -r "$tmphome"' EXIT
for f in .profile .bashrc .config bin; do
  [ -e "$repo/$f" ] && ln -s "$repo/$f" "$tmphome/$f"
done

# Single-quote character stashed in a var, for building a -c argument that
# must carry $-expansions through to the *nested* bash unexpanded.
sq="'"

# $PS1/$ll must be expanded by the nested bash (after sourcing .bashrc),
# never by this test script -- assigned via single quotes so it's stored
# literally.
inner='[ -n "${PS1:-}" ] && echo PS1=set || echo PS1=unset; echo "ls=$(type -t ls 2>/dev/null || echo undefined)"'
cmd=". \"\$HOME/.bashrc\" 2>/dev/null; ${inner}"

# Regression: interactive_only.sh's `return` only exited itself (sourcing a
# file's `return` unwinds the `.` builtin, not the caller), so noninteractive
# shells (e.g. `bash -lc`) got the whole interactive-only payload -- aliases,
# prompt, PROMPT_COMMAND -- anyway. The guard must be real.
got=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" PATH=/usr/bin:/bin \
  bash --noprofile -c "$cmd")
assert_eq "noninteractive .bashrc returns before interactive-only content" \
  "PS1=unset
ls=file" "$got"

skip_if_absent script bash

# Interactive: guard must NOT return early -- prompt and aliases present.
# with_pty avoids a real tty's job-control noise polluting stderr; a real
# pty also makes bash read system-wide interactive rc files (/etc/bash.bashrc
# and whatever it injects, e.g. shell-integration hooks) ahead of our
# hermetic $HOME/.bashrc -- grep down to our own sentinel lines so that
# noise doesn't make this assertion flaky.
full="env -i HOME=$tmphome USER=${USER:-$(whoami)} TERM=xterm PATH=/usr/bin:/bin bash --noprofile -i -c $sq$cmd$sq"
got_i=$(with_pty "$full" 2>&1 | tr -d '\r' | grep -E '^(PS1|ls)=')
assert_eq "interactive .bashrc sets a prompt and defines aliases" \
  "PS1=set
ls=alias" "$got_i"

assert_done
