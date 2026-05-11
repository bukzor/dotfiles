---
anthropic-skill-ownership: llm-subtask
---

1. [ ] Verify in interactive nvim: no `vim.tbl_add_reverse_lookup` / `tbl_flatten` / `vim.validate` deprecation warnings in `:checkhealth`. Closes the conform+nvim-lint migration.
2. [ ] Silence node-provider yarn error: `let g:loaded_node_provider = 0` in vim init (pnpm-only setup; prefer disabling over installing yarn).
3. [ ] Pin a single rtp path in lazy `performance` opts so the `~/.config/nvim` → `~/.vim` symlink stops being double-scanned (silences lazy "found existing packages" warnings; cosmetic).
