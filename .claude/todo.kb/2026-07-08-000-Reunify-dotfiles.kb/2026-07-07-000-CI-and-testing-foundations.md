---
managed-by: Skill(llm-subtask)
status: open
---

# CI and testing foundations

**Priority:** High — runs FIRST, before all 2026-07-06-* groups; they each open with
a "unit tests" task that assumes this system exists
**Complexity:** Low (was Medium — the harness decision and skeleton landed 2026-07-08)
**Branch:** author once, land on both (it's also convergence content)
**Context:** parent goal in `.claude/todo.md`; per-group test needs below

## Decided and live (2026-07-08)

Built by `../2026-07-07-001-shell-function-unit-testing-and-ci-regression-harness.md`
(done); full rationale in
`~/docs/dev/devlog/2026-07-08-000-cross-shell-test-harness--redo-as-the-test-runner.md`:

- **Runner: apenwarr redo.** Each (test, shell) pair is a target
  (`default.tested.do` at repo root); `redo test` fans out the matrix.
  bats-core and a TAP-runner prototype were both rejected.
- **Layout: co-located.** `X_test.sh` beside `X.sh` (`.profile_test.sh`
  included); shared POSIX asserts in `lib/sh/assert.sh`; both sourcing paths
  skip `*_test.sh`. No `tests/` tree; `bin/dotfiles-test` rejected
  (`redo test` is already one command).
- **CI live:** `.github/workflows/check-sh.yml` — dash / busybox ash / bash /
  zsh(sh-emulation) matrix, ~14s per push, green.
- **Zero-dependency checkouts: vendored minimal/do**
  (`.local/share/redo/do`, see its README) runs the whole suite on a bare
  tree — this is how CI, the main clone, and a scratch merge checkout get
  tested without installing anything.
- **`.tested` targets materialize as timestamp certificates** (gitignored),
  identical under both redo implementations.

## Survey of test needs (from the 2026-07-06-* files)

| Group | Need | Shape |
|---|---|---|
| 000 unification | shell-startup matrix: bash -l / -i / -lc; COLUMNS, PATH correct + idempotent re-source, prompt, no dead-path refs | `X_test.sh` (hermetic HOME); `-i` needs pty allowance; dead-path grep is a `X_check.sh` |
| 001 fast-forwards | cross-branch byte-identity over a path list | `X_check.sh` + redo-always; CI full-fetch |
| 002 stale-seed | tool-still-starts checks (kitty, gh, pnpm) | `X_check.sh`, skip-if-absent |
| 003 triage | dangling-reference sweep after deletes | `X_check.sh` |
| 004 hand-merges | bin/ script smoke runs; config parse/load (git config -l, headless vim, tmux -f) | `X_check.sh`, skip-if-absent |
| 005 zsh port | startup matrix, native zsh (not sh-emulation) | `X_check.sh` invoking zsh directly; pty allowance |
| 006 merge | merge-tree conflict count == 0; all suites green on merged tree | `X_check.sh` + vendored do in a scratch checkout |
| ../2026-07-07-001 | functions.d unit tests, cross-shell parity, regression drills, `env -i` .profile smoke | DONE — `X_test.sh` matrix |

Derived requirements, status:

1. one command, seconds, per commit — **DONE** (`redo test`, ~2s incremental)
2. hermetic HOME / test any checkout — **DONE** (`.profile_test.sh`'s
   symlink-HOME under `env -i` is checkout-relative; vendored do removes the
   install dependency)
3. skip-if-absent — **DONE** for shells (test.do); tool-level helper still to add
4. cross-ref tests need two refs — **TODO** (run-once class + full fetch)
5. shell-agnostic assertions — **DONE** (`lib/sh/assert.sh` is POSIX)
6. cross-shell parity matrix — **DONE**

## Remaining work

- [x] run-once check class: `X_check.sh` → `X.checked` target, no shell
      fan-out (`default.checked.do`; `test.do` enumerates both classes via
      `git ls-files --cached --others --exclude-standard -- '*_check.sh'`
      — repo-scoped and gitignore-aware; a plain `find .` was tried first
      and rejected: it walks all of `~`, permission-denied under
      `.solargraph`, and false-positives on vendored `trash/` content).
      Serves the git cross-ref checks (001, 006), grep sweeps (000, 003),
      tool smoke/parse checks (002, 004), and native-zsh startup (005).
      Ref-dependent checks still need `redo-always` under real redo
      (branch tips aren't file deps); vendored do always builds fresh, so
      CI is covered without it.
- [x] skip-if-absent helper in `lib/sh/assert.sh` (kitty, tmux, vim, brew —
      degrade to skip, never fail; shells already handled in test.do):
      `skip_if_absent TOOL...` prints `skip: TOOL not installed` to stderr
      and exits 0, short-circuiting the rest of the check body. Test-driven
      via a new co-located `lib/sh/assert_test.sh`, which required adding
      `lib/sh/*_test.sh` to `test.do`'s fan-out glob (previously only
      `.profile_test.sh` and `functions.d/*_test.sh` were discovered).
- [x] pty allowance for interactive (`-i`) startup tests: without a tty,
      bash/zsh/busybox-ash emit job-control noise on stderr, colliding with
      the empty-stderr assertion style — wrap those cells in `script -qc`
      (or grant per-mode expected-stderr patterns). Added `with_pty` to
      `lib/sh/assert.sh` (`script -qec 'CMD' /dev/null`); `-e/--return`
      propagates the wrapped command's exit status. **Review note:** this
      is a util-linux-only flag (>= 2.35); BSD/macOS `script(1)` takes no
      `-c`/`-e` and would need a different wrapper if a startup test ever
      needs to run there — flagged in sessions.kb, not yet a blocker since
      current runners (crostini, GitHub ubuntu-latest) are both Linux.
- [ ] CI: `fetch-depth: 0` + fetch both branches once cross-ref checks land
- [ ] document invocation in-repo (how a group adds `X_test.sh` /
      `X_check.sh`; local per-commit usage)
- [ ] land the harness identically on main (this is itself convergence
      content — same tree both sides)

## Open Questions

- Does crostini's environment differ enough from GitHub's ubuntu runner that startup
  tests need a container image, or is plain ubuntu-latest close enough? (Start plain;
  containerize only when a real discrepancy bites.)
- What of main's existing `.github/` should be absorbed or retired? (svelte
  carries check-sh.yml, Check Vim, Check Neovim, and a broken lint-lua —
  survey both sides when landing the harness on main.)

## Success Criteria

- [ ] `redo test` (or `./.local/share/redo/do test`) green on both branches,
      locally and in CI
- [x] a group agent adds a matrix test by dropping `X_test.sh` beside the
      code — zero harness work
- [x] same for a run-once `X_check.sh`
- [ ] main's tree is testable from the clone without touching live `~`

## Notes

Numbering: this file is 2026-07-07-000, which sorts after the 2026-07-06-* group
files by name; execution order is defined by
`../2026-07-08-000-Reunify-dotfiles.md`, where this is first.
