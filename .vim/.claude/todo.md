---
anthropic-skill-ownership: llm-subtask
---

- [ ] Replace null-ls.nvim (archived) with conform.nvim + nvim-lint
  - Interim (2026-05-05): swapped `jose-elias-alvarez/null-ls.nvim` → `nvimtools/none-ls.nvim` fork to unblock nvim 0.11 (`_request_name_to_capability` removed). Lua module name unchanged, mason-null-ls still works. Proper migration below still wanted.
  - [ ] Add `stevearc/conform.nvim` to plugins.lua, port formatter list (black, isort, prettierd, shellcheck-as-formatter? no — formatters only: black, isort, prettierd, gofmt)
  - [ ] Add `mfussenegger/nvim-lint` for linters/diagnostics (shellcheck, dotenv_linter, gitlint, tfsec, glslc, fish, zsh)
  - [ ] Add `WhoIsSethDaniel/mason-tool-installer.nvim` for mason-side install of the binaries (replaces mason-null-ls.nvim)
  - [ ] Move `M.on_attach_autoformat` BufWritePre logic onto conform's `format_on_save`
  - [ ] Drop null-ls.nvim, mason-null-ls.nvim, and the `M.null_ls_handler` / `M.setup_mason_null_ls` from lsp.lua
  - [ ] Verify: no more `vim.tbl_add_reverse_lookup`/`tbl_flatten`/`vim.validate` deprecation warnings in `:checkhealth`
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
