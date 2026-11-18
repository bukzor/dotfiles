---
managed-by: Skill(llm-subtask)
status: done
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

- [x] author `.vimrc.d/` edits in svelte (OQ1, 2, 5, 6; 0010 helptags)
- [x] load-test with vim 9 `HOME=<workspace>`, both workspaces
- [x] land on svelte, then main (+ delete main's `bukzor/plug.vim`); push
- [x] prove `git diff origin/main origin/svelte-crostini -- .vimrc.d` empty

## Decisions

- Homes: folding → new `folding.vim`; `winwidth` → `multiple-files.vim`;
  `.bq.sql` → `filetypes.vim`; `*`/`#` → `search.vim`; `j`/`k` →
  `scrolling.vim` (next to `whichwrap`); `<C-s>` → `finger-savers.vim`.
- Dropped main's `foldlevel=3`: `foldlevelstart=2` resets it on every
  buffer load (probe read 2), so the line did nothing.
- `<C-s>` is `<Cmd>update<CR>` in n/x/i, not main's `map … :update`: in
  visual mode, `:` would prefix the range `'<,'>` and `:update` would then
  try to write only the selected lines. Insert mode shadows nvim 0.11's
  default `i_CTRL-S` signature help. Normal-mode signature help is
  `<C-K>` (which-key.lua).
- helptags: deleted outright. No tracked package has a `doc/`
  (`.vim/pack/**`), lazy.nvim builds its own plugins' tags, and
  `$VIMRUNTIME` ships them. So nothing needed it.

## Open Questions

1. Main's other `.vim/autoload/` files have no callers on main either:
   `plug.vim` (vim-plug itself, which only `bukzor#plug#bootstrap` loaded)
   and `bukzor/mason.vim`. Both are out of scope here. Recommend deleting
   both on main, as was done for `bukzor/plug.vim`.
2. Seen in passing: which-key.lua binds `<C-K>` (n, v) to signature help,
   which overrides `multiple-files.vim`'s `nnoremap <C-K> <C-W>k` under
   nvim. That belongs to unit 2026-11-18-002's area. Recommend moving
   signature help to another key.

## Final report

- svelte `ea415ba`, main `0a7c6f6` (also deletes
  `.vim/autoload/bukzor/plug.vim`). Both are pushed, and `git diff
  origin/main origin/svelte-crostini -- .vimrc .vimrc.d` is empty.
- vim 9.2, `HOME=<workspace>`, both workspaces, identical output:
  `:messages` holds only the header line, both at startup and after
  re-sourcing `~/.vimrc`. `x.bq.sql` gets ft `sql_bigquery`. Probes:
  foldmethod=indent, foldminlines=8, foldlevelstart=2, winwidth=86, and the
  maps for `*` `#` `j` `k` `gj` `gk` and n/x/i `<C-S>`; no helptags
  VimEnter autocmd. In a functional test, `*` on `foo` skipped `Foo` and
  landed on the next `foo`. Probe scripts: `~/trash/vimrc-d-rulings/`.
- OQ3 (`isfname`) and OQ4's dropped plugins: nothing to land. Undotree and
  surround go to unit 002. No nvim on this host: nvim-only behavior
  (sql_bigquery highlighting, the shadowed `i_CTRL-S`) is unchecked.
