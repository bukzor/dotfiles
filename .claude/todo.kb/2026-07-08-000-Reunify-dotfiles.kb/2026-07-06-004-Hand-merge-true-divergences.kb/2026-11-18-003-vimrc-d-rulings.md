---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "vim": the 2026-11-18 rulings
  - ./2026-11-11-004-vimrc-into-vimrc-d.md  # Open Questions 1-6 and Final report
---

# `.vimrc.d/`: apply the rulings on unit 004's open questions

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 3, "vim")

## Problem Statement

`.vimrc` and `.vimrc.d/` already match on both branches. Apply the
tentative rulings to unit 004/vimrc's Open Questions, authoring once and
committing byte-identical on both branches:

- OQ1: port folding as a new `.vimrc.d/` file.
- OQ2: port `winwidth=86` into `multiple-files.vim`.
- OQ3: drop `isfname+=:`. Nothing to land.
- OQ4: leave the plugins alone. Undotree and surround go into
  `plugins.lua`, which is sibling unit 2026-11-18-002's file. Drop the
  others.
- OQ5: port the `.bq.sql` → `sql_bigquery` filetype. Unit 003 kept that
  parser in `tree-sitter.lua`.
- OQ6: port case-sensitive `*`/`#`, `j`/`k` ↔ `gj`/`gk`, and `<C-s>`.
  Drop the rest.
- In 0010, the `helptags` autocommand does nothing (it lacks `ALL`). Make
  it work, or delete it if nothing needs it.
- Main's `.vim/autoload/bukzor/plug.vim` is dead and exists only on main.
  Delete it on main.

Check with vim 9 using `HOME=<workspace>`, the way unit 004 did: no startup
messages, and each ported setting probes as set.

**Scope (only these files):** `.vimrc.d/*` in both workspaces;
`.vim/autoload/bukzor/plug.vim` on main; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
