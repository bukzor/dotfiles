---
managed-by: Skill(llm-subtask)
status: active
---

# CI and testing foundations

**Priority:** High — runs FIRST, before all 2026-07-06-* groups; they each open with
a "unit tests" task that assumes this system exists
**Complexity:** Medium
**Branch:** author once, land on both (it's also convergence content)
**Context:** parent goal in `.claude/todo.md`; per-group test needs below

## Problem Statement

Every convergence group needs tests, and each would otherwise invent its own harness.
One session to survey the needs, pick a system, and stand up the skeleton — so group
work starts with `dotfiles-test` (or equivalent) already answering pass/fail.

## Survey of test needs (from the 2026-07-06-* files)

| Group | Need | CI-able? |
|---|---|---|
| 000 unification | shell-startup matrix: bash -l / -i / -lc; COLUMNS, PATH correct + idempotent re-source, prompt, no dead-path refs | yes |
| 001 fast-forwards | cross-branch byte-identity over a path list | yes (needs both refs) |
| 002 stale-seed | tool-still-starts checks (kitty, gh, pnpm) | partial — skip-if-absent |
| 003 triage | dangling-reference sweep after deletes | yes |
| 004 hand-merges | bin/ script smoke runs; config parse/load (git config -l, headless vim, tmux -f) | mostly |
| 005 zsh port | same startup matrix, zsh columns | yes |
| 006 merge | merge-tree conflict count == 0; all suites green on merged tree | yes |
| ../2026-07-07-001 (independent) | functions.d unit tests with **cross-shell parity: dash, busybox ash, bash, zsh**; literal regression tests for two shipped bugs; `env -i` .profile smoke test | yes |

Derived requirements:

1. **One command**, seconds not minutes, runnable per commit locally.
2. **Hermetic HOME**: must test *any checkout* (the main clone, a merged tree), not
   just live `~` — key trick: `env HOME=<checkout> bash -lc ...` makes startup tests
   tree-relative. Without this, main-side changes can't be tested before switchover.
3. **Skip-if-absent** for optional tools (zsh, kitty, tmux) — degrade to skip, never
   fail, so the same suite runs on crostini, CI, and (someday) macOS.
4. **Cross-ref tests** (001, 006) need two refs — run from either checkout,
   full-history fetch in CI.
5. Shell-agnostic assertions where possible; per-shell only for startup matrices.
6. **Cross-shell parity matrix** (from ../2026-07-07-001, a hard requirement there):
   run the same test body under dash, busybox ash, bash, zsh with per-shell
   pass/fail. The harness decision here must satisfy that file too — decide once.

## Implementation Steps

- [ ] decide harness: bats-core vs plain-bash TAP runner (house bash conventions
      apply either way; bats is apt/brew-installable and gives per-test reporting —
      likely winner, but confirm it tolerates the hermetic-HOME trick cleanly)
- [ ] decide layout: `tests/` at repo root + `bin/dotfiles-test` entry point
- [ ] skeleton: hermetic-HOME helper, skip-if-absent helper, one real test per
      category (startup matrix, byte-identity, dangling-ref sweep) as proof
- [ ] CI: GitHub Actions workflow — push to main + svelte-crostini, ubuntu runner,
      matrix {bash, zsh}, full-fetch for cross-ref tests
- [ ] document invocation in the repo (README or CLAUDE.md): local per-commit usage,
      how groups add tests
- [ ] land identically on both branches (this file's content is itself convergence
      material — same tree both sides)

## Open Questions

- Does crostini's environment differ enough from GitHub's ubuntu runner that startup
  tests need a container image, or is plain ubuntu-latest close enough? (Start plain;
  containerize only when a real discrepancy bites.)
- Are there existing tests/CI on either branch to absorb? (Check `.github/`,
  `setup/`, Makefiles on both — survey during the session, don't assume greenfield.)
- ANSWERED (was open in ../2026-07-07-001): the repo has a GitHub remote,
  `github.com/bukzor/dotfiles`, and it is PUBLIC — GitHub Actions is available
  and free. Real CI is on the table, not just local hooks. (Public also means:
  the .ssh/ audit in 003 matters for anything not yet pushed.)

## Success Criteria

- [ ] `dotfiles-test` green on both branches locally and in CI
- [ ] a group agent can add a test by dropping a file in `tests/` with zero harness work
- [ ] main's tree is testable from the clone without touching live `~`

## Notes

Numbering: this file is 2026-07-07-000, which sorts after the 2026-07-06-* group
files by name; execution order is defined by `.claude/todo.md`, where this is first.
