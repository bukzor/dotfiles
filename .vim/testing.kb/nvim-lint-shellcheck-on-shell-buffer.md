---
last-tested: "2026-05-05"
result: pass
scope: nvim-lint
---

# nvim-lint runs shellcheck on a shell buffer

Verifies the nvim-lint autocmd is wired (BufReadPost / BufWritePost / InsertLeave),
that `linters_by_ft.bash = { "shellcheck" }` resolves, and that the resulting
diagnostics surface via `vim.diagnostic.get(0)`. A failure here means either
mason-installed shellcheck is broken, the autocmd group `BukzorLint` isn't
registering, or the filetype mapping has regressed.

## Procedure

```bash
cat > /tmp/test.sh <<'EOF'
#!/bin/bash
echo "hello $unset_variable"
EOF
nvim --headless /tmp/test.sh \
  -c 'doautocmd BufReadPost' \
  -c 'sleep 1' \
  -c 'lua local d = vim.diagnostic.get(0); print(#d, vim.inspect(vim.tbl_map(function(x) return x.message end, d)))' \
  -c 'qa!'
```

## Expected

`1 { "unset_variable is referenced but not assigned." }`

(Exact wording is shellcheck's; if shellcheck is upgraded the phrasing may
shift, but the count must remain ≥ 1.)

## Last result (2026-05-05)

Exactly the expected output. Confirms `M.setup_nvim_lint` correctly wires the
autocmd and that `linters_by_ft` resolves `bash` → shellcheck.

## Troubleshooting

If diagnostics is `0`:

- `~/.local/share/nvim/mason/bin/shellcheck --version` — must run.
- `:lua print(vim.inspect(require("lint")._resolve_linter_by_ft("bash")))` —
  must return `{ "shellcheck" }`.
- `:autocmd BukzorLint` — must show callbacks for BufReadPost / BufWritePost.
