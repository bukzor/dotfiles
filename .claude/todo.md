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

- [ ] [todo.kb/2026-05-15-000-rename-outmoded-d-dirs-to-kb-case-by-case-eval.md](todo.kb/2026-05-15-000-rename-outmoded-d-dirs-to-kb-case-by-case-eval.md)
- [x] [todo.kb/2026-06-03-000-migrate-topic-reference-docs-from-must-readkb-to-referencekb.md](todo.kb/2026-06-03-000-migrate-topic-reference-docs-from-must-readkb-to-referencekb.md)
- [x] [todo.kb/2026-05-16-001-claude-jsonl-display-handle-remaining-attachment-subtypes.md](todo.kb/2026-05-16-001-claude-jsonl-display-handle-remaining-attachment-subtypes.md)
