---
managed-by: Skill(llm-subtask)
status: open
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

- [x] unit tests first: shell-startup invariants runnable as one command — the
      login/interactive matrix (bash -l, bash -i, bash -lc) asserting COLUMNS, PATH
      correctness, PATH idempotent on re-source, prompt present when interactive,
      and zero references to dead paths; keep it cheap enough to run per commit
      (harness live, see ../2026-07-07-000: -l/-lc fit the hermetic-HOME
      `X_test.sh` pattern as-is; -i cells need the pty allowance; the
      dead-path grep is a run-once `X_check.sh`): extended `.profile_test.sh`
      (COLUMNS, idempotent re-source), added `.bashrc_test.sh` (guard
      regression + interactive smoke via `with_pty`), added
      `.config/sh/no-dead-paths_check.sh`. All 8 shell-matrix cells green.
- [x] svelte-crostini (work in live `~`, smoke-test each commit): commit
      `979953d`, prepared fully (env.d move, new env.d files, dead-shim
      deletion, tests all written and green against hermetic HOME) before
      ever touching the live `.profile`/`.bashrc`, so the actual cutover was
      two `Write` calls immediately followed by verification (git-revertable
      if either had failed) — minimum live-downtime window.
    - [x] commit the two in-flight fixes (symlink repair + columns.sh): the
          symlink repair had already landed in an earlier session; columns.sh
          landed in `979953d` along with everything else below
    - [x] move env.d under sh/ as real dir; delete `~/.config/env/`
    - [x] delete dead shims (env.sh, bashrc.sh, rc.sh, interactive_only.sh)
    - [x] rewrite .bashrc with real guard
    - [x] rewrite .profile; migrate inline exports to env.d/; wire profile.d
      (found and fixed a latent bug while wiring profile.d in:
      `00-basics.sh` unconditionally recomputed HOME/USER, clobbering an
      already-correct `$HOME` — caught by the hermetic-HOME test)
    - [x] verify: `bash -lc 'echo $COLUMNS'` = 132; `bash -i` prompt/aliases
          intact — both confirmed live, post-commit
- [ ] main (mirror in the clone: ~/repo/github.com/bukzor/dotfiles--main-reunify)
    - [x] apply identical `~/.config/sh` tree + `.profile`/`.bashrc`: commit
          `d7dac7a` (counterpart: svelte-crostini `979953d`). Byte-identical
          copy, all 20 shell-matrix cells + no-dead-paths check green via
          the vendored zero-dependency `./.local/share/redo/do -c test`.
          Found and fixed two narrow harness gaps while at it: main's
          `test.do` predated `.bashrc_test.sh` (silently skipped its whole
          matrix — one-line fix); `.config/.gitignore`'s and
          `lib/.gitignore`'s un-ignore-everything-non-dotfile rules also
          swept up generated `*.tested`/`*.checked` stamp certificates —
          added re-ignores to both (narrow/additive, not the full
          ignore-scheme reconciliation, which stays a separate later
          effort).
    - [x] homebrew PATH prepend-vs-append (flagged below): user decided
          2026-07-09 — keep svelte's current unconditional prepend, no
          OSTYPE branch. Applies once the homebrew env.d file itself is
          touched (not yet — svelte's `300-homebrew.sh` already prepends
          and was copied as-is by the mirror above).
    - [ ] fold in main-only `.sh_env` content not yet captured — analysis
          done 2026-07-09, not yet implemented. Plan for next session:
        - port, with OSTYPE/existence guards (new env.d files, applied
          identically to both branches once authored — these become new
          convergence content, not main-only): `CPUTYPE`/`OSTYPE` exports;
          macOS `/usr/libexec/path_helper` invocation; TMPDIR selection
          (candidate-list + mkdir/chmod/writable-check loop, easily
          testable); private-dotfiles hook (`has private-dotfiles-check &&
          ...`, `trysource .../.sh_env` — safe no-op today: confirmed
          neither the commands nor `~/private-dotfiles` exist on this
          machine yet, so this ports as inert/future-proofing); TERM-fixing
          (psget/process-tree TERM detection) -- valuable per this task's
          own "Adopt from main's .sh_env" bullet but the most complex/
          fragile piece, test carefully or scope down
        - **deliberately skip** `__orig_PATH` save/restore: redundant with
          svelte's `path` function (functions.d/path.sh), which is already
          idempotent via remove-then-reinsert on every `prepend`/`append`
          call -- svelte doesn't have the "PATH grows on re-source" problem
          `__orig_PATH` exists to solve. Porting both mechanisms together
          would just be two competing idempotency strategies.
        - cross-shell PS1, `precmd_functions`/`preexec_functions`/
          `chpwd_functions` (main vendors `rcaloras/bash-preexec`): already
          correctly out of scope here, tracked in ../2026-07-06-005 instead.
        - travis completions, VCS-prompt detection (disabled by its own
          author, `return 0 # too slow!`): dead weight, skip, not worth a
          question.
    - [ ] delete superseded `.sh_env`/`.sh_rc`/`.sh_advanced_rc`/`.sh_lib`/`.sh_plugins.d`
          only after zsh port (todo 005) consumes them

## Open Questions

- ~~Does main's `.sh_advanced_rc` contain anything not already re-invented on
  svelte?~~ **Answered 2026-07-09:** yes, one real thing, but it's out of
  scope for 000. Travis completions (dead tool) and VCS-prompt detection
  (disabled by its own author, `return 0 # too slow!`) are dead weight, skip.
  The direnv hook and private-dotfiles hook are already reinvented/tracked.
  The one substantive gap: main's `precmd_functions`/`preexec_functions`/
  `chpwd_functions` are backed by `.sh_lib/bash-precmd.sh` (the third-party
  `rcaloras/bash-preexec`, a real DEBUG-trap-based implementation) +
  `bash-chpwd.sh`, vs. svelte's home-grown 6-line `PROMPT_COMMAND` shim in
  `050-precmd-functions.sh` (precmd only, no preexec, no chpwd). This is
  more capable and its whole purpose is zsh-compatible hook naming — that's
  005's (zsh port) job, not 000's; noted there instead of pulled in here.

## Success Criteria

- [ ] `.profile`, `.bashrc`, `~/.config/sh/**` byte-identical on both branches
      (svelte side done; blocked on the main-mirror bullet above)
- [x] fresh login shell on this machine: COLUMNS, PATH, prompt all correct
      (live-verified post-commit `979953d`)
- [x] zero references to nonexistent paths (`grep -r '\.sh/' ~/.config/sh`
      clean) — now also a standing `no-dead-paths_check.sh`, not just a
      one-time grep

## Notes

Sequencing: this group owns `.profile` and `.bashrc` — todo 004 (hand-merges) must
not touch them. zsh port (005) builds on the structure this creates.
