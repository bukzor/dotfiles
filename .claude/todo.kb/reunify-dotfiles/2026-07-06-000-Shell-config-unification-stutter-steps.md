---
managed-by: Skill(llm-subtask)
status: active
---

# Shell config unification stutter-steps

**Priority:** High (unblocks hand-merge of the hardest diverged files)
**Complexity:** Medium
**Branch:** svelte-crostini first (live in `~`), then mirror to main
**Context:** 2026-07-06 session archaeology; parent goal in `.claude/todo.md`

## Problem Statement

Shell config on svelte-crostini accreted across eras (`~/.sh_*` → `~/.config/env/` →
`~/.config/sh/` → `profile.d`), leaving dead shims and a broken guard. main holds the
most-evolved ancestor content (`.sh_env`, `.sh_rc`). Unifying **is** the convergence
step for `.profile`/`.bashrc`: do it once, commit identical results to both branches.

## Current Situation

- Live `~` (svelte-crostini checkout) already has two uncommitted fixes: `sh/env.d`
  symlink repaired (`../env/env.d`), new `env/env.d/columns.sh` (COLUMNS=132).
- Dead on svelte: `~/.config/env/env.sh`, `sh/bashrc.sh`, `sh/rc.sh` (all point at
  extinct `~/.sh/`), `sh/profile.d/` (never sourced), `interactive_only.sh` (its
  `return` only exits itself — guard never worked; this accident is what lets
  login shells get env.d).
- main's `.sh_env` states the target taxonomy: noninteractive basics →
  once-per-terminal env → per-shell rc. Also has solved problems to adopt:
  `__orig_PATH` idempotent re-sourcing, cross-shell PS1, TERM fixing, TMPDIR selection.

## Proposed Solution

Single tree `~/.config/sh/{functions.d,profile.d,env.d,rc.d,bashrc.d}`:

- `.profile`: functions.sh → source_dir profile.d env.d → bash handoff to `.bashrc`.
  Inline exports migrate to env.d files; HOME/USER stanza → profile.d/00-basics.sh.
- `.bashrc`: real inline interactive guard, then functions.d → env.d → bashrc.d → rc.d.
- Delete dead shims: `env/env.sh`, `sh/bashrc.sh`, `sh/rc.sh`, `sh/interactive_only.sh`,
  emptied `~/.config/env/` (env.d becomes a real dir under sh/).
- Adopt from main's `.sh_env`: idempotent PATH save/restore, OSTYPE guards.

## Implementation Steps

- [ ] unit tests first: shell-startup invariants runnable as one command — the
      login/interactive matrix (bash -l, bash -i, bash -lc) asserting COLUMNS, PATH
      correctness, PATH idempotent on re-source, prompt present when interactive,
      and zero references to dead paths; keep it cheap enough to run per commit
      (harness live, see ../2026-07-07-000: -l/-lc fit the hermetic-HOME
      `X_test.sh` pattern as-is; -i cells need the pty allowance; the
      dead-path grep is a run-once `X_check.sh`)
- [ ] svelte-crostini (work in live `~`, smoke-test each commit)
    - [ ] commit the two in-flight fixes (symlink repair + columns.sh)
    - [ ] move env.d under sh/ as real dir; delete `~/.config/env/`
    - [ ] delete dead shims (env.sh, bashrc.sh, rc.sh, interactive_only.sh)
    - [ ] rewrite .bashrc with real guard
    - [ ] rewrite .profile; migrate inline exports to env.d/; wire profile.d
    - [ ] verify: `bash -lc 'echo $COLUMNS'` = 132; `bash -i` prompt/aliases intact
- [ ] main (mirror in the clone: ~/repo/github.com/bukzor/dotfiles)
    - [ ] apply identical `~/.config/sh` tree + `.profile`/`.bashrc`
    - [ ] fold in main-only `.sh_env` content not yet captured (TERM fix, TMPDIR,
          `__orig_PATH`, private-dotfiles hooks) — with OSTYPE guards
    - [ ] delete superseded `.sh_env`/`.sh_rc`/`.sh_advanced_rc`/`.sh_lib`/`.sh_plugins.d`
          only after zsh port (todo 005) consumes them

## Open Questions

- Does main's `.sh_advanced_rc` contain anything not already re-invented on svelte?

## Success Criteria

- [ ] `.profile`, `.bashrc`, `~/.config/sh/**` byte-identical on both branches
- [ ] fresh login shell on this machine: COLUMNS, PATH, prompt all correct
- [ ] zero references to nonexistent paths (`grep -r '\.sh/' ~/.config/sh` clean)

## Notes

Sequencing: this group owns `.profile` and `.bashrc` — todo 004 (hand-merges) must
not touch them. zsh port (005) builds on the structure this creates.
