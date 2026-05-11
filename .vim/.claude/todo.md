---
anthropic-skill-ownership: llm-subtask
---

- [x] Replace null-ls.nvim (archived) with conform.nvim + nvim-lint
  - [x] Add `stevearc/conform.nvim` (formatters: black, isort, prettierd, gofmt)
  - [x] Add `mfussenegger/nvim-lint` (linters: shellcheck, dotenv-linter, gitlint, tfsec, fish, zsh)
  - [x] Add `WhoIsSethDaniel/mason-tool-installer.nvim`
  - [x] Move autoformat onto conform's `format_on_save` with `lsp_format = "fallback"`
  - [x] Drop null-ls.nvim, mason-null-ls.nvim, `M.null_ls_handler`, `M.setup_mason_null_ls`, `M.on_attach_autoformat`
  - [x] glslc shader-linter migration — wired via nvim-lint; shaderc from brew. See `lua/bukzor/lsp.lua` `lint_linters_by_ft` for the stage-inference caveat.
  - [ ] Verify in interactive nvim: no `vim.tbl_add_reverse_lookup`/`tbl_flatten`/`vim.validate` deprecation warnings in `:checkhealth`
- [x] Stale mason venvs: `black`, `isort`, `gitlint` had shebangs pointing at non-existent Pythons. Fixed 2026-05-05 by `rm -r packages/<tool>` + `rm bin/<tool>`; `mason-tool-installer`'s `run_on_start = true` recreated the venvs against `python3.13`. See `testing.kb/mason-python-tools-runnable.md`.
- [x] Replace lsp-inlayhints.nvim with built-in `vim.lsp.inlay_hint`
  - [x] In `M.on_attach_lspconfig`, swap `require("lsp-inlayhints").on_attach(client, bufnr)` for `vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })`
  - [x] Remove `lvimuser/lsp-inlayhints.nvim` from plugins.lua
  - [x] Remove the `require("lsp-inlayhints").reset()` call in `M.unload`
- [ ] Fix tmux $TERM: in `~/.tmux.conf` set `set-option -g default-terminal "tmux-256color"`
- [x] Fix `[e` mapping in which-key.lua — currently calls `vim.diagnostic.goto_next` but desc says "Prev Error"; should be `goto_prev`
- [ ] Silence node provider yarn error: `let g:loaded_node_provider = 0` in vim init (or install yarn — pnpm-only setup, prefer disabling)

## Later

We haven't (yet) decided where to place these in the task queue.
Please read and consider slotting them.

- Cosmetic: lazy "found existing packages" warnings come from the `~/.config/nvim` → `~/.vim` symlink; both paths get scanned. Could pin a single rtp path in lazy `performance` opts.
- Informational only (no action): which-key `<Q>`/`<gc>` overlap warnings, neoconf jsonls/lua_ls "not installed?" false alarm.
