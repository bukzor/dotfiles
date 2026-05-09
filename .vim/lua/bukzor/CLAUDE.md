# lua/bukzor module conventions

Each module is a table `M` returned at the bottom. Modules follow a small,
shared lifecycle vocabulary.

## Functions

| Function | Purpose | Idempotent? |
|---|---|---|
| `M.init()` | Install baseline state: augroups, defaults, highlights, autocmds whose group is owned here. | Yes — pair-symmetric with `M.unload()`. |
| `M.unload()` | Tear down what `M.init()` installed. Clear augroups (which clears their autocmds), reset module-level caches. | Yes — safe before any other call. |
| `M.setup()` | Orchestrator: typically `unload(); init(); plus any further wiring`. Treat as the "do the works" entry point. | Yes — sets up via the unload/init pair. |
| `M.config()` | The *content* (lazy plugin specs, keymaps). Distinct from `setup`: `config` is data, `setup` is action. | N/A |
| `M.reset()` | Wipe upstream-package state via `plenary.reload` before reinstalling. Used when reloading a third-party plugin's module is required. | N/A |

Not every module has every function. Pick the smallest set that matches the
module's responsibility.

## Pairing rule

If `M.init()` creates an augroup, the autocmds whose group is that augroup
must also be created in `M.init()`. The augroup and its handlers are one
unit; splitting them across functions breaks the unload/init reset cycle
silently (group recreated empty, handler never reinstalled).

When a per-plugin setup function (e.g. `setup_mason_lspconfig`) needs an
autocmd, decide first whether the augroup belongs to `init` (long-lived
baseline) or to the plugin (plugin-specific wiring). Don't straddle.

## Reload idiom

Two patterns coexist:

1. **Self-applying** (`which-key.lua`): the file's last line is
   `return M.init()`. `:luafile %` re-applies the entire module without
   restart. Suitable when the module owns no plugin-manager-driven config.

2. **Library-style** (`lsp.lua`, `aerial.lua`, `tree-sitter.lua`): the file
   ends with `return M`. The plugin manager (lazy.nvim) drives orchestration
   by calling individual `M.setup_*` functions as plugin `config = ...`
   callbacks. `:luafile %` only redefines functions; reapply by hand:
   `:lua require('bukzor.lsp').init()` (or `.setup()` for full reset).

`init-nvim.lua` is the entry point: it calls `unload.unload_all()` first for
a clean slate, then sources the viml init, then `require("bukzor.plugins").setup()`
which drives the rest.

## When adding new behavior

- State that survives across `:luafile` reloads → `M.init()`.
- One-shot wiring driven by lazy plugin config → `M.setup_<plugin>()`.
- Anything that creates an augroup → put both group and its autocmds in
  the same function (almost always `M.init`).
- Don't add to `M.setup()` and assume it runs — for library-style modules
  it isn't on the live path; verify with `grep -n 'lsp\.setup\|require.*setup'`.
