---
last-tested: "2026-08-29"
result: pass
scope: nvim-treesitter
---

# nvim-treesitter parsers install and highlight

Verifies the `nvim-treesitter` `main`-branch setup
(`lua/bukzor/tree-sitter.lua`, `docs/dev/adr/2026-08-29-000-Migrate-nvim-treesitter-to-main-branch.md`):
`ensure_installed` parsers compile cleanly (including `latex`, which needs
`tree-sitter generate` and is what broke on the old `master` branch), and the
`FileType` autocmd both auto-installs a missing parser and starts
highlighting.

## Procedure

```bash
# 1. checkhealth: requirements + every installed parser green
nvim --headless -c 'redir! > /tmp/ts-health.txt' -c 'silent checkhealth nvim-treesitter' -c 'redir END' -c 'qa'
nvim --headless -c 'checkhealth nvim-treesitter' -c 'w! /tmp/ts-health2.txt | %print' +qa 2>&1 | tail -40

# 2. ensure_installed list present (latex included)
nvim --headless -c 'lua vim.wait(60000, function() return vim.tbl_contains(require("nvim-treesitter").get_installed("parsers"), "latex") end, 1000)' \
  -c 'lua print("latex installed: " .. tostring(vim.tbl_contains(require("nvim-treesitter").get_installed("parsers"), "latex")))' \
  -c 'qa'

# 3. highlighting activates on a known filetype
nvim --headless -c 'e /tmp/test.tex' -c 'set ft=tex' -c 'lua vim.wait(2000)' \
  -c 'lua print("active: " .. tostring(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil))' \
  -c 'qa'

# 4. auto-install-on-open for a parser NOT in ensure_installed
nvim --headless -c 'e /tmp/test.go' -c 'set ft=go' \
  -c 'lua vim.wait(15000, function() return vim.tbl_contains(require("nvim-treesitter").get_installed("parsers"), "go") end, 500)' \
  -c 'lua print("go installed: " .. tostring(vim.tbl_contains(require("nvim-treesitter").get_installed("parsers"), "go")))' \
  -c 'lua print("active: " .. tostring(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil))' \
  -c 'qa'
```

## Expected

- Step 1: `checkhealth` shows `✅ OK` for the tree-sitter CLI/tar/curl
  requirements, and every `ensure_installed` language row has a `✓` under `H`
  (highlights).
- Step 2: `latex installed: true`.
- Step 3: `active: true`.
- Step 4: `go installed: true` and `active: true`.

No `--no-bindings` / `unexpected argument` errors anywhere in the output.

## Last result (2026-08-29)

Pass on all four steps, immediately after the `master`→`main` branch
migration (fresh reinstall into `~/.local/share/nvim/tree-sitters`, prior
contents moved to `~/trash/`). `checkhealth` showed all requirements green
(tree-sitter-cli 0.26.13) and all eleven `ensure_installed` + transitively
pulled (`hcl`) parsers with `H` checked. User separately confirmed a real
interactive launch's `:messages` was clean (no treesitter errors, just
routine mason-lspconfig/tfsec installs).
