#!/bin/sh
# Regression/invariant guard for reunify-dotfiles task 005 (zsh port).
# Native zsh startup (-i, -lc) -- NOT the harness's `zsh --emulate sh` cell
# in test.do, which only proves POSIX compatibility, not that
# .zshenv/.zprofile/.zshrc actually work as zsh.
set -eu
redo-always
here=$(dirname "$0")
. "$here/lib/sh/assert.sh"
repo=$(cd "$here" && pwd)

skip_if_absent zsh

tmphome=$(mktemp -d)
trap 'rm -r "$tmphome"' EXIT
for f in .zshenv .zprofile .zshrc .profile .bashrc .config bin; do
  [ -e "$repo/$f" ] && ln -s "$repo/$f" "$tmphome/$f"
done
# .zsh_completion is copied under umask 022, not symlinked: compinit
# refuses (prompting on the tty) an fpath dir that is group-writable by a
# shared group, which is how CI checks the repo out.
(umask 022 && cp -R "$repo/.zsh_completion" "$tmphome/.zsh_completion")
# stubbed, not symlinked from $repo: .cargo is a per-machine toolchain
# install, not repo content -- absent in a bare clone/CI checkout (unlike
# the live homedir this repo normally lives in). .zshenv sources it
# unconditionally, so a stub keeps this check checkout-portable.
mkdir -p "$tmphome/.cargo"
: > "$tmphome/.cargo/env"
# .zkbd is copied, not symlinked: zkbd's autoload wizard writes generated
# keymaps (and stray $TERM.tmp partials when it gives up) back into it --
# a symlink would leak those writes into the real tracked directory.
[ -e "$repo/.zkbd" ] && cp -R "$repo/.zkbd" "$tmphome/.zkbd"

# Pre-seed a valid 24-key keymap for this test's $TERM-$VENDOR-$OSTYPE combo
# (reusing an existing committed file's escape sequences -- content doesn't
# need to match this exact terminal, only satisfy 030-zkbd.sh's "already
# resolved" check). Without this, no committed file matches this host's
# real $VENDOR/$OSTYPE, so 030-zkbd.sh's tty-gated autoload wizard would run:
# it races real terminal-negotiation timing against redo's own process
# environment, which is exactly the kind of nondeterminism a check should
# not depend on.
# must match the same zsh binary the -lc/-i invocations below resolve
# (PATH=/usr/bin:/bin) -- this host has two: homebrew's ($VENDOR=pc) and
# apt's system one ($VENDOR=debian), and they disagree. Under $tmphome, so
# .zshenv runs first: env.d/010-ostype.sh rewrites zsh's $OSTYPE (linux-gnu
# -> linux); the bare built-in names a file zkbd never looks up, and its
# wizard then blocks on CI's pty.
vendor_ostype=$(env -i HOME="$tmphome" PATH=/usr/bin:/bin zsh --no-globalrcs -c 'print -r -- "$VENDOR-$OSTYPE"')
mkdir -p "$tmphome/.zkbd"
cp "$repo/.zkbd/xterm-256color-debian-linux-gnu" "$tmphome/.zkbd/xterm-$vendor_ostype"

# -lc: login + noninteractive -- exercises .zshenv, then .zprofile
# (symlinked to .profile) -- not .zshrc. Real separate stdout/stderr, no
# pty needed (matches .profile_test.sh's noninteractive style).
err_lc=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" TERM=xterm PATH=/usr/bin:/bin \
  zsh --no-globalrcs -lc 'exit' 2>&1 >/dev/null)
assert_eq "zsh -lc emits no errors" "" "$err_lc"

got_ostype=$(env -i HOME="$tmphome" USER="${USER:-$(whoami)}" TERM=xterm PATH=/usr/bin:/bin \
  zsh --no-globalrcs -lc 'printf %s "$OSTYPE"' 2>/dev/null)
assert_eq "zsh -lc: env.d exports present (OSTYPE, via .zprofile)" \
  "$(uname -s | tr '[:upper:]' '[:lower:]')" "$got_ostype"

# -i: interactive, non-login -- exercises .zshenv, then .zshrc (setopts,
# history, zkbd, keybindings, completion, rc.d/prompt.sh, rc.d/direnv.sh).
# Needs a pty (job-control noise on a real tty) -- same reasoning and
# quoting trick as .bashrc_test.sh; stdout/stderr are necessarily merged
# through the pty, so (as in .bashrc_test.sh) we grep for expected lines
# rather than asserting on the raw stream.
sq="'"
cmd='printf "PS1=%s\n" "${PS1:+set}"; printf "compdef=%s\n" "$(( $+functions[compdef] ))"; printf "OSTYPE=%s\n" "$OSTYPE"'
# timeout: in CI this zsh has hung until the job timeout; bounded, it fails
# with its transcript instead. --foreground keeps zsh in the pty's
# foreground process group, so its tty reads don't stop it (SIGTTIN).
full="timeout --foreground 20 env -i HOME=$tmphome USER=${USER:-$(whoami)} TERM=xterm PATH=/usr/bin:/bin zsh --no-globalrcs -i -c $sq$cmd$sq"
raw_i=$(with_pty "$full" 2>&1 | tr -d '\r') || :
got_i=$(echo "$raw_i" | sed -n -E '/^(PS1|compdef|OSTYPE)=/p')
case "$got_i" in
  *PS1=set*compdef=1*) ;;
  *) printf '%s\n' "zsh -i transcript:" "$raw_i" >&2 ;;
esac

ps1_i=$(echo "$got_i" | sed -n 's/^PS1=//p')
assert_eq "zsh -i sets a prompt" "set" "$ps1_i"

compdef_i=$(echo "$got_i" | sed -n 's/^compdef=//p')
assert_eq "zsh -i initializes completion (compdef defined)" "1" "$compdef_i"

ostype_i=$(echo "$got_i" | sed -n 's/^OSTYPE=//p')
assert_eq "zsh -i: env.d exports present (OSTYPE)" \
  "$(uname -s | tr '[:upper:]' '[:lower:]')" "$ostype_i"

assert_done
