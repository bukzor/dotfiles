#!/bin/sh
set -eu
here=$(dirname "$0")
. "$here/lib/sh/assert.sh"
repo=$(cd "$here" && pwd)

# Hermetic HOME: a throwaway dir symlinking just what .profile needs,
# so the test exercises this checkout's files without touching the live
# home (.profile writes $HOME/profile.env as a side effect).
tmphome=$(mktemp -d)
trap 'rm -r "$tmphome"' EXIT
for f in .profile .bashrc .config bin; do
  [ -e "$repo/$f" ] && ln -s "$repo/$f" "$tmphome/$f"
done

# Regression: .profile once called a renamed-away function (path_stdin);
# every login shell printed "not found" and PATH silently lost its
# prepends. Assert both halves: clean stderr, and the prepends present.
# shellcheck disable=SC2086  # TEST_SH may carry args ("busybox ash")
err=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" PATH=/usr/bin:/bin \
  ${TEST_SH:-sh} -c '. "$HOME/.profile"' 2>&1 >/dev/null) || {
    echo "not ok - .profile failed to source under ${TEST_SH:-sh}: $err"
    exit 1
  }
assert_eq "sourcing .profile emits no errors (regression: not found)" "" "$err"

# shellcheck disable=SC2086  # TEST_SH may carry args ("busybox ash")
got=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" PATH=/usr/bin:/bin \
  ${TEST_SH:-sh} -c '. "$HOME/.profile" 2>/dev/null; printf %s "$PATH"')

assert_eq "last heredoc entry wins the front of PATH" \
  "$tmphome/bin" "${got%%:*}"

case ":$got:" in
  *":$tmphome/bin:$tmphome/.local/bin:"*) order=in-order ;;
  *) order="wrong: $got" ;;
esac
assert_eq "later heredoc entries precede earlier ones (last wins)" in-order "$order"

case ":$got:" in
  *:/usr/bin:*) kept=yes ;;
  *) kept="lost: $got" ;;
esac
assert_eq "inherited PATH entries retained" yes "$kept"

# COLUMNS: noninteractive shells (git, etc.) fall back to 80 columns unless
# COLUMNS is exported; .profile must set this itself (not rely on .bashrc's
# side effect) since a `bash -lc` invocation is login-but-noninteractive.
# shellcheck disable=SC2086
got_columns=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" PATH=/usr/bin:/bin \
  ${TEST_SH:-sh} -c '. "$HOME/.profile" 2>/dev/null; printf %s "$COLUMNS"')
assert_eq "COLUMNS is set (git/etc. non-interactive width)" 132 "$got_columns"

# Idempotent re-source: PATH must not grow or reorder on a second sourcing
# in the same shell (interactive shells re-source env.d via .bashrc too).
# shellcheck disable=SC2086
once=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" PATH=/usr/bin:/bin \
  ${TEST_SH:-sh} -c '. "$HOME/.profile" 2>/dev/null; printf %s "$PATH"')
# shellcheck disable=SC2086
twice=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" PATH=/usr/bin:/bin \
  ${TEST_SH:-sh} -c '. "$HOME/.profile" 2>/dev/null; . "$HOME/.profile" 2>/dev/null; printf %s "$PATH"')
assert_eq "re-sourcing .profile leaves PATH unchanged (idempotent)" "$once" "$twice"

assert_done
