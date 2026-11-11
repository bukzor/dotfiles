---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "vim"; Notes on lazy-lock.json
  - ~/repo/github.com/bukzor/dotfiles--svelte-crostini/.vim/CLAUDE.md
---

# Vim: lua modules, plugin set, lazy-lock, diffmode

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 1, "vim")

## Problem Statement

Merge `.vim/lua/bukzor/{lsp,plugins,tree-sitter,which-key}.lua` and
`.vim/pack/invented-here/start/diffmode/plugin/diffmode.vim`, then
`.vim/lazy-lock.json`. Svelte's set is the one in use (nvim 0.11
modernization, 2026-05); port what main has that svelte lacks, drop what
svelte deliberately replaced. Plugin additions or removals are judgment
calls (Open Questions) unless svelte's history shows the replacement.

`lazy-lock.json`: the parent says regenerate rather than hand-merge, but
nvim isn't installed here. Take svelte's lock, adding entries only for
plugins your merged `plugins.lua` adds, and flag that it needs a
regenerate on penguin.

No nvim here: check with `luac -p` or `lua` syntax checks if available,
and say what you could not check.

**Scope (only these files):** the six paths above, in both workspaces;
this handoff file. (`.vimrc` and `.vimrc.d/` are unit 004's.)

## Steps

## Decisions

## Open Questions

## Final report
