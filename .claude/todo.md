---
managed-by: Skill(llm-subtask)
cost-benefit-sweh:
  timebox:
    "@value": 1.5
    rationale: |
      File-level estimate for a 9-item rollup, but mostly the versioned
      ~/.terminfo build dominates. Other items are pointers to issues
      handled elsewhere.
  benefit-2w:
    "@value": 0.5
    rationale: |
      Personal infra; terminfo doesn't change often. Modest payoff
      mostly preventing future-me from re-deriving the build.
---

Scope: `~` generally. For `~/.claude` scope, see `~/.claude/.claude/todo.md`.

- [ ] `bukzor.claude.session.Session.tips()` counts attachment records as
      tips (671 of them on one real session file, vs ~7 real conversation
      branches) — should filter to user/assistant, matching `tip_of()`'s
      approach; also `claude-branch-list --branches-only` doesn't print
      each branch's tip uuid, which is exactly what `claude-branch-extract`
      needs as input — found while rebuilding branch_extract.py 2026-07-24
- [ ] Verify (or drop) the belief that an older Claude Code version had a
      rewind/resume picker capable of switching among sibling branches of
      a branched chat — user recalls this from ~a year ago; 2.1.219's
      picker cannot (confirmed via binary inspection, `MessageSelector` in
      `docs/dev/devlog/2026-07-24-000-Claude-Code-branch-recovery--extract-by-leaf--not-by-carve.md`)
      but older builds weren't inspected — would need an old release
      tarball/changelog to check
- [ ] Add a `/must-read` command for llm-kb's `SKILL.kb/must-read/` (must-read-kb-skill.md's other follow-up; the `SKILL.kb/must-read/` dir itself already exists) — deferred
- [ ] Finish yaml-date-jsonschema's remaining follow-ups in `bukzor-agent-skills/llm-kb`: `finish-debolding-cleanup` (still ~40 bold instances across 8 files beyond `references/pattern-guide.md`, which is now fixed — not actually done despite earlier belief), `auto-migrate-scripts-for-kb-dirs`, `schema-migrate-string-pattern-to-date`
- [ ] Resolve `todo.kb/2026-06-03-001-commit-accumulated-dotfiles-changes.md`'s D6 held-review items: `bin/CLAUDE.md` (deleted uncommitted by another session — restore or finish rename?), `claudesh`/`finder.sh`/`scratch/python/`/`empty/` triage, `.envrc`/`profile.env` review, `.claude/claude-alignment-2026-04-29.{jsonschema.yaml,kb/}` commit-or-trash — NOTE: `bin/colortest17x17*` and `.zsh_profile` (formerly listed here too) are resolved: colortest17x17 merged clean in reunify task 004 (2026-07-13, no stray variant found), `.zsh_profile` deleted on both branches by reunify task 005 (2026-07-12, dead debug artifact)
- [ ] [todo.kb/2026-07-08-000-Reunify-dotfiles.md](todo.kb/2026-07-08-000-Reunify-dotfiles.md) — converge svelte-crostini ↔ main to identical content, merge, live on main
- [ ] `~/.config/sh/env.d/300-homebrew.sh:11` sets `export HOMEBREW_EVAL_ALL=1`, which brew now warns is deprecated ("Use HOMEBREW_REQUIRE_TAP_TRUST or HOMEBREW_NO_REQUIRE_TAP_TRUST instead") — found incidentally while merging `bin/brew-desc` (reunify task 004); needs investigating whether those are actually equivalent replacements (they sound like a different concern: eval-all vs. tap-trust) before changing anything
- [ ] [todo.kb/2026-06-03-001-commit-accumulated-dotfiles-changes.md](todo.kb/2026-06-03-001-commit-accumulated-dotfiles-changes.md) — overlaps reunify 006's "commit/park uncommitted state" step; fold in or close when 006 runs
- [ ] Build versioned `~/.terminfo` into the dotfiles repo
  - [ ] Decide repo layout (track `.tinfo` source vs. compiled `~/.terminfo/t/*` blob; symlink vs. deploy step)
  - [ ] Pin `tmux.tinfo` from upstream `tmux/tmux` at the tag matching brewed tmux (currently 3.5a)
  - [ ] `tic -xs tmux.tinfo` → `~/.terminfo/`
  - [ ] Wire deploy for new machines (Brewfile postinstall, `bin/` install script, or similar)
  - [ ] Document the upgrade flow: bump brew tmux → bump tag → re-fetch + re-`tic`
  - [ ] Verify: `infocmp tmux-256color` resolves to the `~/.terminfo` copy
  - Goal: pin terminfo to the tmux binary version so brewed-tmux + distro-ncurses can't drift.

## Later

We haven't (yet) decided where to place these in the task queue.
Please read and consider slotting them.

- [ ] [todo.kb/2026-06-27-000-hoist-polyglot-monorepo-architecture-convention--values-to-personal-global-scope.md](todo.kb/2026-06-27-000-hoist-polyglot-monorepo-architecture-convention--values-to-personal-global-scope.md) — may belong under `private.bukzor-llc`
