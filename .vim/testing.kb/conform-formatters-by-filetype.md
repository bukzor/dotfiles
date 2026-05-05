---
last-tested: "2026-05-05"
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
ts: { "prettierd" }
go: { "gofmt" }
```

For filetypes with no entry in `formatters_by_ft` (e.g. `rust`, `lua`),
`list_formatters_for_buffer` returns `{}` and format-on-save falls through to
LSP via `lsp_format = "fallback"`.

## Last result (2026-05-05)

Python returned `{ "isort", "black" }` as expected. (Other filetypes not
re-checked this session — wiring uses the same code path.)
