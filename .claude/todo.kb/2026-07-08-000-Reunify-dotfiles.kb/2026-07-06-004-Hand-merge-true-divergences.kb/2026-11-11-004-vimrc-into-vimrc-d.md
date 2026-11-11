---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # ".vimrc"
  - ../2026-07-06-002-Stale-seed-adjudication.md  # its .vimrc findings
  - ~/repo/github.com/bukzor/dotfiles--svelte-crostini/.vim/CLAUDE.md
---

# `.vimrc`: port main's monolith into svelte's `.vimrc.d/`

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 1, ".vimrc")

## Problem Statement

Main's `.vimrc` is a 526-line monolith; svelte's is a loader for 19
`.vimrc.d/*.vim` files. The result is svelte's loader on both branches,
plus whatever main's file has that the modular set lacks, ported into the
fitting `.vimrc.d/` file (or a new one). Do not take main's file: it would
disable all 19 modular files.

Work section by section through main's file and classify each: already in
`.vimrc.d/` (same or superseded), obsolete (dead plugin, old-vim
workaround, a setting nvim defaults to), or missing. Port the missing;
list a judgment call (a key mapping or behavior change) as an Open
Question. Record the classification compactly in Decisions, by line range.

No vim/nvim here; check with `vim -u NONE -es` only if vim is present, and
say what you could not check.

**Scope (only these files):** `.vimrc` and `.vimrc.d/`, in both
workspaces; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
