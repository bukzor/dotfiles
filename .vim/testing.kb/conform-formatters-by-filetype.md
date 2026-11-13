---
last-tested: "2026-11-13"
result: pass
scope: conform.nvim
---

# conform resolves formatters per filetype

Verifies `formatters_by_ft` (defined in `lsp.lua` as `M.conform_formatters_by_ft`)
is wired so that `:ConformInfo` and the format pipeline pick up the right tool
chain for each filetype. This is the **wiring** test; whether the tools then
actually run is covered by `conform-format-python-end-to-end.md`.

## Procedure

```bash
echo "x" > /tmp/test.py
nvim --headless /tmp/test.py \
  -c 'lua print("py:", vim.inspect(require("conform").list_formatters_for_buffer(0)))' \
  -c 'qa!' 2>&1 | grep '^py:'

echo "x" > /tmp/test.ts
nvim --headless /tmp/test.ts \
  -c 'lua print("ts:", vim.inspect(require("conform").list_formatters_for_buffer(0)))' \
  -c 'qa!' 2>&1 | grep '^ts:'

echo "x" > /tmp/test.go
nvim --headless /tmp/test.go \
  -c 'lua print("go:", vim.inspect(require("conform").list_formatters_for_buffer(0)))' \
  -c 'qa!' 2>&1 | grep '^go:'
```

## Expected

```
py: { "isort", "black" }
ts: { "oxfmt", "prettierd" }
go: { "gofmt" }
```

Prettier-family filetypes list both but run one (`stop_after_first`): oxfmt
only when a parent of the file has `node_modules/.bin/oxfmt`, else prettierd.
`list_formatters_to_run(0)` shows which; for `/tmp/test.ts` it is
`prettierd`, inside a project that installs oxfmt it is `oxfmt`.

For filetypes with no entry in `formatters_by_ft` (e.g. `rust`, `lua`),
`list_formatters_for_buffer` returns `{}` and format-on-save falls through to
LSP via `lsp_format = "fallback"`.

## Last result (2026-11-13)

All three as expected. `list_formatters_to_run` gave `prettierd` for a `.ts`
outside any project and `oxfmt` in `my-own-shadertoy` (which installs it).
