# Devlog: 2026-05-08 — LSP and diagnostics UX recovery on nvim 0.11

## Focus

After the nvim 0.11 modernization (commits 8a99296, 0c932f5, 95024a8 from
2026-05-05), several LSP-adjacent surfaces were quietly broken:

- Inlay hints stopped showing.
- `<leader>q` and the `<leader>l*` Trouble mappings were no-ops.
- `[d`/`]d` did nothing in normal buffers.
- Diagnostic virtual-text was off; the user had been expecting end-of-line
  error annotations all along.

Goal: get LSP/diagnostic UX back and document the pieces that bit us.

## Decisions

### Replace pyright with basedpyright

Full rationale, alternatives, consequences in
`docs/dev/adr/2026-05-08-000-replace-pyright-with-basedpyright.md`.

Short version: pyright gates `inlayHintProvider` on
`python.analysis.inlayHints.*` settings being non-default-off, so the new
built-in `vim.lsp.inlay_hint.enable` had nothing to enable. basedpyright
defaults hints on, auto-detects `./.venv`, and adds useful "recommended"
mode diagnostics. Single-user setup, no shared CI; the fork's smaller bus
factor is acceptable.

### LspAttach autocmd in `M.init()` instead of wildcard `vim.lsp.config("*", { on_attach })`

Discovered that `vim.lsp.config("*", { on_attach = M.on_attach_lspconfig })`
is silently overridden when a server's bundled `lsp/<name>.lua` defines its
own `on_attach`. Audit showed four such servers in our list:
**rust_analyzer, ts_ls, clangd, basedpyright** — exactly the ones we'd want
hints from. So `M.on_attach_lspconfig` was never running for them.

**Rationale:** `LspAttach` autocmds fire for every client regardless of how
its `on_attach` is wired, and they coexist with lspconfig's per-server
`on_attach` (no override). Pairing the autocmd with its augroup (`M.au_attach`)
in `M.init()` keeps unload/init a complete reset cycle.

**Alternatives considered:**
- Per-server `vim.lsp.config(name, { on_attach = chained })` calls — fragile
  and easy to miss when adding new servers.
- Detect and unwrap the bundled `on_attach` — too clever, breaks when
  upstream changes its handler.

### Whitelist `automatic_enable` in `mason-lspconfig.setup`

mason-lspconfig 2.0+'s default `automatic_enable = true` enables every
*installed* mason package, not only those in `ensure_installed`. After the
basedpyright swap, the orphan pyright kept attaching. Pass the same list
both as `ensure_installed` and `automatic_enable` (the latter accepts a
string-array whitelist).

### Diagnostic UX

`vim.diagnostic.config({...})` now lives in `M.init()` (was orphaned in the
dead `M.setup()` orchestrator). Settings:

- `virtual_text` on, with `format` callback truncating multi-line server
  messages (basedpyright/pyright frequently restate the headline as a
  shorter line 2; the float still shows full text).
- `severity_sort = true`, signs + underline as defaults.
- `jump = { float = true, wrap = true }` so every `[d`/`]d`/`[e`/`]e`/`[w`/`]w`
  shows the message after jumping.
- Highlight links: errors → `Comment`, warnings/info/hint → `NonText` for a
  doubly-muted look while keeping the sign-column severity color as the
  primary signal.

Added `[w`/`]w` for warning navigation (filter by `severity = WARN`).

### Diff-mode keybindings scoped to diff buffers

`pack/invented-here/start/diffmode/plugin/diffmode.vim` had buffer-local
`[d`/`]d` mappings registered at top-level (not inside `DiffModeEnter`),
shadowing the global diagnostic-jump mappings on whichever buffer was
current at plugin-load time. The `[c`/`]c` rhs is a no-op outside diff mode,
so it manifested as silent failure. Moved into `DiffModeEnter`/`DiffModeExit`
alongside the existing `m`/`M`/`R` pattern.

## Conventions Established

### `lua/bukzor` module lifecycle

Documented in `lua/bukzor/CLAUDE.md`. Summary:

- `M.init()` installs idempotent baseline state — including any autocmds
  whose group is owned by this module.
- `M.unload()` is the symmetric tear-down.
- `M.setup()` is the orchestrator: unload + init + plugin wiring.
- `M.config()` is *content* (mappings, lazy specs).
- Pairing rule: if `M.init()` creates an augroup, the autocmds writing to
  that augroup must also live in `M.init()`. Splitting them across
  functions silently breaks the unload/init reset cycle.
- Reload idiom: which-key.lua self-applies via `return M.init()`; lsp.lua
  is library-style (driven by lazy plugin configs). For lsp.lua reloads,
  `:lua require('bukzor.lsp').init()` reapplies init-owned state.

### Trouble v3 syntax

`:TroubleToggle <view>` → `:Trouble <mode> [action] [opts]`. Mappings
updated:

- `<leader>q`, `<leader>li` → `:Trouble diagnostics toggle filter.buf=0`
- `<leader>lI` → `:Trouble diagnostics toggle`
- `<leader>lr` → `:Trouble lsp_references toggle`

## Open Questions

- The dead `M.setup()` orchestrator in `lsp.lua`: keep as a manual reset
  entry point, or delete it? Currently kept; `lua/bukzor/CLAUDE.md` notes
  the "library-style" pattern. If kept, may need light maintenance to stay
  in sync with the actual setup_* functions wired by `plugins.lua`.
- Stricter basedpyright defaults (`typeCheckingMode = "recommended"`) will
  be louder when editing other Python projects. Per-project
  `pyrightconfig.json` or basedpyright's "baseline" feature handle it; not
  yet exercised in anger.
- `vim.diagnostic.config` doesn't auto-reapply on `:luafile lua/bukzor/lsp.lua`
  — only `:lua require('bukzor.lsp').init()` does. Acceptable given lsp.lua
  is library-style; documented in `lua/bukzor/CLAUDE.md`.

## References

- ADR: `docs/dev/adr/2026-05-08-000-replace-pyright-with-basedpyright.md`
- Convention: `lua/bukzor/CLAUDE.md`
- Predecessor commits: 8a99296 (drop lsp-inlayhints, switch to built-in
  inlay_hint), 0c932f5 (vim.diagnostic.jump migration), 95024a8 (conform.nvim
  + nvim-lint replacing null-ls).
- mason-lspconfig 2.0+ `automatic_enable` semantics:
  `pack/lazy/opt/mason-lspconfig.nvim/lua/mason-lspconfig/features/automatic_enable.lua:56`.
- lspconfig per-server `on_attach` overrides:
  `pack/lazy/opt/nvim-lspconfig/lsp/{basedpyright,rust_analyzer,ts_ls,clangd}.lua`.
