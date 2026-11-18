---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "vim": the 2026-11-18 rulings
  - ./2026-11-11-003-vim-lua-and-plugins.md  # Open Questions 1-5
  - ./2026-11-18-000-mason-and-rust-analyzer-history.md  # Open Questions 1-2, Final report
  - ./2026-11-11-004-vimrc-into-vimrc-d.md  # Open Question 4: undotree and surround
---

# Vim lua: apply the rulings, converge the last four conflicts

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 3, "vim")

## Problem Statement

These are the last four main ↔ svelte conflicts. Apply the rulings recorded
in the parent's "vim" item, and land each file byte-identical on both
branches:

- `.vim/lua/bukzor/lsp.lua`: svelte's file plus `PATH = "append",` in
  `setup_mason`, on both branches.
- `.vim/lua/bukzor/plugins.lua`: svelte's file plus undotree (with its
  `<Leader>u` mapping) and vim-surround, both from main's 2023 `.vimrc`, on
  both branches. Check that `<Leader>u` isn't already taken, including in
  which-key.
- `.vim/lazy-lock.json`: svelte's file on main. Lazy adds the two new
  plugins' entries on penguin's next run, so don't add them by hand.
- `.vim/pack/invented-here/start/diffmode/plugin/diffmode.vim`: svelte's
  file on main.

Host step: run `rustup component add rust-analyzer` here, then show that
`~/.cargo/bin/rust-analyzer --version` works.

When you finish, `git merge-tree --allow-unrelated-histories origin/main
origin/svelte-crostini` should report zero conflicts. Report the count.

**Scope (only these files):** the four paths above, in both workspaces;
this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
