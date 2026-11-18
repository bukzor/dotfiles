# Devlog: 2026-07-12 — Zsh port: test-first caught two real bugs, one scope-widening decision

## Focus

Reunify-dotfiles task 005: give svelte-crostini a real interactive zsh
setup (it had only a cargo line in `.zshenv`), porting main's mature
zsh config onto the unified `.config/sh` structure from task 000
instead of resurrecting the old `.sh_rc` family. Land on both branches.

## Decisions

### Shared cross-shell prompt, not a zsh-only one

Task 005's own checklist ("port cross-shell PS1 from main's `.sh_rc`
into `rc.d`") conflicted with its own success criterion ("bash behavior
unchanged"), since `rc.d` is sourced by both `.bashrc` and `.zshrc`.
Asked the user directly rather than picking a side. Chose: replace
`bashrc.d/prompt.sh`'s plain Debian-style prompt with the shared,
colored, multi-line `rc.d/prompt.sh` for both shells — a deliberate,
recorded supersession of that criterion, not an oversight.

**Alternatives considered:** zsh-only prompt matching bash's current
look (zero visual change to bash); or zsh gets the fancy prompt while
bash keeps its own (two different-looking prompts depending on shell).

### `.sh_lib` stays on main, not retired

Task 005's checklist said retire `.sh_env`/`.sh_rc`/`.sh_advanced_rc`/
`.sh_lib`/`.sh_plugins.d` together once the port lands. Found `bin/
gcpenv` (already byte-identical on both branches, fast-forwarded in
task 001) independently sources `.sh_lib/minimal.sh` — unrelated to
the zsh-shell-startup chain being retired. Deleting `.sh_lib` would
have broken a real, working tool on main. It's already broken the same
way on svelte (svelte never had `.sh_lib`; pre-existing gap, unrelated
to this task). Kept `.sh_lib`, retired the other four, filed a
follow-up in the task file instead of silently deleting or silently
expanding this task's scope to fix gcpenv too.

### zkbd's interactive wizard needs a real tty — gate on `tty -s`

`zkbd`'s terminal-capability autoload has no committed keymap matching
this host's actual `$TERM-$VENDOR-$OSTYPE`, and needs a real
controlling terminal to complete. Without one (CI, non-interactive
invocations, this session's own non-tty sandbox) it stalls ~10s on the
first key, then fails every subsequent key with "not interactive and
can't open terminal" — leaving `$key` empty and breaking 7 `bindkey`
calls with "cannot bind to an empty key sequence". Fixed by gating the
autoload attempt on `tty -s` in `030-zkbd.sh`, and guarding every
zkbd-derived binding in `040-keybindings.sh` via a small
`bindkey_zkbd` helper so an unresolved keymap is silent, not an error.

**Alternatives considered:** none seriously — a real terminal doing
this wizard on first login is normal, expected zkbd behavior; the fix
targets only the no-tty case.

## Bugs found (not just main-parity gaps)

- `rc.d/direnv.sh`'s new zsh branch (native `precmd_functions`, added
  alongside bash's untouched `PROMPT_COMMAND` splice) errored with
  "bad math expression: operand expected at end of string" the first
  time `precmd_functions` had never been declared as an array. Fixed
  with `typeset -ga precmd_functions` before the subscript search.
- The new `zsh-startup_check.sh` was flaky under `redo` specifically
  (passed run-directly, failed under redo, deterministically each way)
  — chased through: `.zkbd` writes leaking into the real tracked
  directory (symlink → copy), then discovered this host has two `zsh`
  binaries (homebrew's `$VENDOR=pc` vs. apt's `/usr/bin/zsh`
  `$VENDOR=debian`) that disagree, and the check was computing
  `$VENDOR` via the wrong one relative to which binary the
  restricted-PATH test invocations actually resolved. Fixed by
  computing it the same way. Also found, once running against the
  main-reunify clone: the check assumed `$repo/.cargo` exists, true in
  a real homedir but not an arbitrary clone — now stubs `.cargo/env`
  instead.

## Conventions Established

- Native-zsh startup invariants (`-i`, `-lc`) need a run-once
  `X_check.sh`, not the existing `test.do` zsh cell (which only runs
  `zsh --emulate sh`, proving POSIX compatibility, not real zsh
  behavior). Pre-seed any interactive-detection state (zkbd keymaps,
  here) rather than letting it run live in an automated check —
  terminal-negotiation timing is not something a check should depend on.
- Hermetic test sandboxes must not symlink directories a program under
  test might *write* to (like `.zkbd`) — copy them instead, or the test
  leaks state into the real tracked tree.

## Corrections made mid-session (self-caught after user pushback)

- Reflexively ran the vendored `.local/share/redo/do` (meant for
  CI/bare checkouts per its own docs) without first checking whether
  real `redo` was installed here (it was). User caught it immediately.
- Reported "full suite green" once based on a run where `redo` had
  silently skipped a batch of `*.tested`/`*.checked` targets it
  considered externally modified ("you modified it; skipping") — stale
  certificates left over from the vendored-`do` run above. User caught
  this too; cleared the certificates and reran for a real pass.

## Open Questions

- `bin/gcpenv`'s `.sh_lib/minimal.sh` dependency: port `minimal.sh`'s
  tiny surface (`has`/`show`/`minimal_init`) into `.config/sh/
  functions.d/`, or rewrite gcpenv to drop the dependency? Either way
  is what finally lets `.sh_lib` retire from main.
- Two known zsh annoyances from `docs/annoyances/zsh` were
  reproduced, not fixed (out of scope for this task): shared history
  syncs a little too eagerly between sessions; history search needs
  enter pressed twice. A third (cursor highlight on scroll-left) is
  plugin-dependent (`zsh-syntax-highlighting`) and doesn't apply — no
  such plugin was ported.

## References

- Task file: `.claude/todo.kb/2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-005-Port-zsh-config-into-config-sh-structure.md`
- Working agreements: `.claude/todo.kb/2026-07-08-000-Reunify-dotfiles.kb/CLAUDE.md`
- Session notes: `~/.claude/sessions.kb/penguin/reunify-dotfiles-lineages.md`
- Commits: svelte-crostini `0881278`, main `8efa600`, both pushed
