# Replace pyright with basedpyright

**Date:** 2026-05-08
**Status:** Accepted

## Context

After replacing `lvimuser/lsp-inlayhints.nvim` with the built-in `vim.lsp.inlay_hint` (commit 8a99296), inlay hints stopped showing in Python buffers. Diagnostic on `foo.py`:

```
:lua =vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
false
:lua =vim.tbl_map(function(c) return { name = c.name, ihp = c.server_capabilities.inlayHintProvider } end, vim.lsp.get_clients({ bufnr = 0 }))
{ { name = "pyright" } }
```

Root cause: vanilla pyright gates its `inlayHintProvider` capability on the `python.analysis.inlayHints.*` settings, all of which default to `false`. With no settings sent, the capability is never advertised; `client:supports_method("textDocument/inlayHint")` returns false; `vim.lsp.inlay_hint.enable` is correctly skipped.

The previous `lsp-inlayhints.nvim` plugin had the same gate (it only force-attached for `tsserver` and `jdtls`). So pyright was never showing hints there either — the perceived "loss" actually traces to the move from rust/other branches to a Python-heavy branch.

This is not a regression in our code; it's pyright's design conflating capability with configuration. Most peer servers (rust-analyzer, gopls, clangd, lua_ls, ts_ls) advertise unconditionally and gate the *work* via settings.

## Decision

Replace `pyright` with `basedpyright` (DetachHead/basedpyright) in `lua/bukzor/lsp.lua`'s `mason_install.lspconfig`.

## Alternatives Considered

### A. Keep pyright, send `python.analysis.inlayHints.*` settings via `vim.lsp.config("pyright", { settings = ... })`
- **Pros:** Stays on the upstream Microsoft project. Smallest change.
- **Cons:** Doesn't fix pyright's other annoyances (`pythonPath` discovery, conservative `typeCheckingMode = "basic"`, no `reportAny`/`reportImplicitRelativeImport`). Each venv-related friction continues to cost time.

### B. Switch to basedpyright
- **Pros:** Inlay hints on by default. Auto-detects `./.venv` (uv-aligned). `typeCheckingMode = "recommended"` surfaces all rules (warnings, not errors, by default). Adds useful diagnostics: `reportAny`, `reportExplicitAny`, `reportImplicitRelativeImport`, `reportPrivateLocalImportUsage`, `reportIgnoreCommentWithoutRule`. Server protocol is identical; mason has the package; lspconfig has the entry.
- **Cons:** Smaller bus factor (top contributor dwarfs the rest, though there are ~30 contributors and a non-trivial second/third tier). Drift risk: must keep merging from upstream pyright (currently keeping pace, weekly releases). New diagnostic rules diverge from pyright — not a problem here (single-user setup, no shared CI), but worth noting.

### C. Force-attach for pyright in `on_attach_lspconfig`, mirroring lsp-inlayhints.nvim's tsserver/jdtls workaround
- **Pros:** Zero dependency change.
- **Cons:** Even with the gate bypassed, pyright won't actually emit hints unless `python.analysis.inlayHints.*` is configured. So this doesn't fix the symptom on its own — degenerates into option A.

## Consequences

**Positive:**
- Inlay hints work in Python without per-server settings boilerplate.
- `./.venv` auto-detection eliminates the recurring `pythonPath`/`venvPath` confusion.
- Stricter defaults catch more issues at write time.

**Negative:**
- Reliance on a fork with smaller maintainer base than upstream Microsoft pyright.
- Stricter defaults (`typeCheckingMode = "recommended"`) will be louder on existing codebases until tuned via `pyrightconfig.json`/`pyproject.toml` or basedpyright's "baseline" feature. Not relevant for this nvim config repo, but will matter when editing other Python projects.

**Neutral:**
- Mason package name changes (`pyright` → `basedpyright`).
- `vim.lsp.inlay_hint.enable` machinery is unchanged; basedpyright advertises the capability and our `on_attach_lspconfig` enables the renderer per buffer as designed.

## Notes

- `mason-lspconfig` 2.0+'s `automatic_enable = true` is a sharp edge: it enables every *installed* mason package, not just those in `ensure_installed` (see `pack/lazy/opt/mason-lspconfig.nvim/lua/mason-lspconfig/features/automatic_enable.lua:56`). After this swap, the orphaned `pyright` package kept attaching to Python buffers. Mitigated by passing `automatic_enable = M.mason_install.lspconfig` (a whitelist) in `setup_mason_lspconfig`. Orphan packages still need `:MasonUninstall <name>` to free disk.

## Related

- Supersedes: prior implicit choice of upstream pyright in `lsp.lua` (no ADR; predates this directory).
- Related to: 8a99296 (drop lsp-inlayhints.nvim, switch to built-in `vim.lsp.inlay_hint`).
