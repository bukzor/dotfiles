---
managed-by: Skill(llm-subtask)
status: done
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

- [x] classify main's `.vimrc` by line range (Decisions)
- [x] port the missing into svelte's `.vimrc.d/`; load-test with vim 9.2
- [x] land `.vimrc` + `.vimrc.d/` byte-identical on svelte, then main; push
- [x] prove `git diff origin/main origin/svelte-crostini -- .vimrc .vimrc.d` empty

## Decisions

Svelte's `.vimrc.d` was carved from main's 2023-05 `.vimrc`, so main's later
edits (`545daae`, `94a6f86`) port; svelte's later edits beat main's 2023 lines.

- **Already/superseded:** 131-159 (display, wild*: svelte's newer
  wildmode/pum), 178-183, 269-304, 311-337, 339-345, 354-370 + 372-379 (svelte
  `.sls` newer), 398-410 (svelte `<Cmd>`-modernized), 412-418 (0005 keeps
  python3 on purpose), 420-431, 448-470 (svelte's 2026-05 diagnostics UX
  replaced the hi links; LspReference* unused), 473-481 (HiFile, nvim `:Inspect`).
- **Obsolete:** 6-11 `LogPluginPaths` (unused); 25-27 + 91-129 vim-plug
  (none on svelte; gruvbox/sensible are submodules; bracketed-paste native;
  editorconfig built into nvim; syntax plugins → treesitter/runtime); 36-87
  kitty `t_*` (vim 9 reads kitty's terminfo, `:h kitty-terminal`; nvim ignores
  `t_*`); 132-135 synmaxcol/termguicolors (defaults/autodetect); 226-232
  visualbell/modeline; 346-351 smarttab/autoindent/filetype (nvim + sensible).
- **Ported:** 160 updatetime → timings; 161 netrw sort → builtin-plugins;
  162-168 checktime → multiple-files (skips cmdwin); 519 qf height →
  multiple-files (in an augroup); 150 colorcolumn `+0`, 522 `fo-=t`, 175
  undofile (nvim only: vim's undodir=. litters) → 0020-basics; 29-34 opam
  merlin + vim's `editorconfig` package → 0010-plugins; 371 `.hcl` (main
  un-mapped it; native hcl), 377 `.sshconfig`, 383-395 `.do` (main's passed a
  nested list to `contents`; fixed) → filetypes; 434-445 `:LspDetach`
  (`get_clients`, no global fn) → lsp; 13-22 `:VimReset`, 493-516
  `:LogAllEvents` → new debug-helpers; 484-491 local-extras hook → new
  `zz-local.vim` (sorts last).

## Open Questions

1. Folding, 1-4 (2025): indent folds, `foldlevelstart=2` closes deep folds on
   open. Recommend port as `folding.vim`: main's latest intent, none on svelte.
2. Window sizing, 306-309 (2025): `winwidth=86` grows the focused split.
   Recommend port to multiple-files.vim; same reasoning, but it reflows splits.
3. `isfname+=:`, 523 (2025): tested, breaks `gF` on `file:12`. Recommend drop.
4. Plugins, 95-126: undotree (+`<Leader>u`) and surround → recommend add to
   plugins.lua; unimpaired → drop (nvim 0.11 ships `[q ]q [b ]b`); zoomwintab,
   dirdiff, claude.vim, vim-reason-plus → drop unless still used on main's host.
5. `.bq.sql` → `sql_bigquery`, 378: highlights only with main's parser in
   tree-sitter.lua (003). Port only if 003 keeps that parser.
6. Keys and UI the 2023 carve-out left out: statusline 189-203, `mouse=nvrh`
   209, `j/k`↔`gj/gk` 213-222, whichwrap `~[]` 216, `jj` 235, visual `p`/`P`
   238-239 (native `v_P` covers it), ctrl-S/A/C/Y/Z/V/R 246-267, case-sensitive
   `*`/`#` 185-186. Recommend: `*`/`#`, `j/k`, `<C-s>`; drop the rest
   (`imap <c-r>` breaks register insert, `<c-a>` hides increment).

## Final report

- svelte `6d1e067`, main `b1876c4`, both pushed; `git diff origin/main
  origin/svelte-crostini -- .vimrc .vimrc.d` is empty.
- vim 9.2 with `HOME=<workspace>`: both load with no messages; probes passed
  (new options, augroups, commands, ft, qf height, extras hook, re-source).
  No nvim/lua here: the `.do` and `:LspDetach` lua are checked by eye only.
- Main's host loses its vim-plug plugins (OQ 4); main's
  `.vim/autoload/bukzor/plug.vim` is now dead (outside this scope).
- Not fixed: 0010's `au VimEnter * silent! helptags` lacks `ALL` (silenced
  E471), so it does nothing. Add `ALL` back or delete it.
