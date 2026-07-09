# Hacking

## Tests

`redo test` runs the whole suite (shell-startup matrix + run-once checks),
~2s incremental. No redo installed? `./.local/share/redo/do test` -- the
vendored minimal `do`, same contract, what CI uses.

### Adding a shell-matrix test

Drop `X_test.sh` beside `X.sh` (e.g. `.profile_test.sh`,
`.config/sh/functions.d/foo_test.sh`, `lib/sh/foo_test.sh`). `test.do`
discovers it and runs it under dash / busybox ash / bash / zsh --
no harness changes needed. Source `lib/sh/assert.sh` for
`assert_eq`/`assert_done` (POSIX -- must run under all four shells).

### Adding a run-once check

Drop `X_check.sh` anywhere in the repo (tracked, or untracked-but-not-ignored
so it's still found pre-commit). Runs once under `sh`, no shell fan-out --
use for cross-ref checks, tool smoke tests, dangling-reference sweeps. Same
`lib/sh/assert.sh` asserts.

- `skip_if_absent TOOL...` -- degrade to skip (never fail) when an optional
  tool isn't installed.
- `with_pty 'CMD STRING'` -- run CMD under a pty (`script -qec`), so an
  interactive-shell (`-i`) startup doesn't emit job-control noise on
  stderr. Linux/util-linux only; no macOS equivalent yet.

## CI

`.github/workflows/check-sh.yml` runs `./.local/share/redo/do test` on
push/PR -- the vendored runner, no redo install needed.
