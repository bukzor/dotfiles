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

- [ ] [todo.kb/2026-07-08-000-Reunify-dotfiles.md](todo.kb/2026-07-08-000-Reunify-dotfiles.md) — converge svelte-crostini ↔ main to identical content, merge, live on main
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
- [ ] [todo.kb/2026-05-15-000-rename-outmoded-d-dirs-to-kb-case-by-case-eval.md](todo.kb/2026-05-15-000-rename-outmoded-d-dirs-to-kb-case-by-case-eval.md)
- [x] [todo.kb/2026-05-16-001-claude-jsonl-display-handle-remaining-attachment-subtypes.md](todo.kb/2026-05-16-001-claude-jsonl-display-handle-remaining-attachment-subtypes.md)
