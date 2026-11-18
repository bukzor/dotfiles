---
managed-by: Skill(llm-subtask)
status: done
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

- [x] classify each main-only delta: replaced in svelte's history, dead, or real
- [x] `tree-sitter.lua`: authored, svelte `037750f`, main `f546172`
- [x] `which-key.lua`: svelte's verbatim, main `f546172`
- [ ] `plugins.lua`, `lazy-lock.json`, `lsp.lua`, `diffmode.vim`: held (Open Questions)

## Decisions

- Main's blobs for all six paths are absent from svelte's history, so nothing is a plain fast-forward.
- Dropped as superseded in svelte's history: null-ls/none-ls/mason-null-ls and `on_attach_autoformat`
  (conform + nvim-lint, `95024a8`); lsp-inlayhints (built-in inlay hints, `8a99296`); pyright/pylsp
  (basedpyright ADR, `58b96cc`); lsp.lua keymaps (moved into which-key in `02944c6`); luvit-meta (svelte's
  lazydev `${3rd}/luv/library` is lazydev's documented replacement).
- Dropped as dead or buggy: the `yamlls` block (not in the server list); jsonls `provideFormatter=false`
  (conform formats json, LSP is only a fallback); `ellisonleao/gruvbox.nvim` in `install.colorscheme`
  (takes colorscheme names, not plugins); the which-key `p` "Plugin" group; `vim.diagnostic.definition`.
- tree-sitter: kept main's rtp `prepend` (#3092); ported the sql_bigquery grammar into the new
  `User TSUpdate` API, behind an fs_stat check, so it does nothing where `~/repo/tree-sitter-sql-bigquery`
  is absent (as on this host). Easy to drop if BigQuery is dead.

## Open Questions

Each one blocks its file. My recommendation is first.

1. `plugins.lua`, avante.nvim (+dressing, nui): **drop** (svelte never had it; needs `make` and an API
   key; Claude Code covers this) / keep.
2. `plugins.lua`, nvim-cmp (main wires it only as a lazydev source, with no other sources or mappings):
   **drop** (svelte uses omnifunc) / keep.
   If both drop: plugins.lua = svelte's verbatim, and lazy-lock.json = svelte's verbatim, no regenerate.
   If either is kept: add main's lock entries for it and regenerate on penguin.
3. `lsp.lua`, mason `PATH = "append"`: **drop** (rustup's `~/.cargo/bin/rust-analyzer` proxy would
   shadow mason's working binary and fail unless the component is installed) / port.
4. `lsp.lua`, main's rust_analyzer settings block: **drop** (copied boilerplate, mostly legacy key names
   for defaults). The real changes: `cargo.allFeatures`, `procMacro.ignored` (async-trait, napi-derive,
   async-recursion), `lruCapacity=1024`, range formatting, `imports` module/self. Alternative: port only
   `cargo.features = "all"`.
   If 3 and 4 both drop: lsp.lua = svelte's verbatim.
5. `diffmode.vim`, main's `au OptionSet diff` (svelte: `OptionSet *`): **keep svelte's**. `DiffModeExit`
   maps `m`/`M` to `:cn`/`:cN`, and `*` re-applies that in every buffer that sets an option.
   Narrowing it leaves `m` as `:cn` only in the startup buffer. Main's change came in a bulk commit
   with no stated reason. Otherwise: port it.

## Final report

- Landed and converged (`git diff origin/main origin/svelte-crostini` is empty for these):
  `tree-sitter.lua` (svelte `037750f`, main `f546172`), `which-key.lua` (main `f546172`).
- Held: `plugins.lua`, `lazy-lock.json`, `lsp.lua`, `diffmode.vim` (Open Questions 1-5). If all
  recommendations are accepted, each is svelte's file verbatim copied to main; no authoring left.
- Checks: every `.lua` here parses under vim's `+lua` (Lua 5.4 `loadfile`; a negative test confirms
  it catches errors). Not checked, because nvim is not on this host: whether it loads under LuaJIT;
  the nvim-treesitter `TSUpdate` / `install_info.path` behavior; which-key on main's older lock.
- Scratch: `~/trash/vim-merge-003/` (both sides of each lua file).
