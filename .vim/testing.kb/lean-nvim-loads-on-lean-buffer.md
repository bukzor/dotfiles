---
last-tested: "2026-07-28"
result: pass
scope: lean
---

# lean.nvim loads on a lean buffer

Verifies the lean.nvim lazy spec: opening a `.lean` file triggers the plugin,
filetype detection works, and `vim.g.lean_config` is populated (the plugin
self-activates; `require("lean").setup()` is deprecated and must not appear).
The LSP itself runs via `lake serve` and needs a real Lean project, so it's out
of scope here.

## Procedure

```bash
printf 'example : 1 + 1 = 2 := rfl\n' > trash/test.lean
nvim --headless trash/test.lean \
  "+lua local p = require('lazy.core.config').plugins['lean.nvim']; print('loaded:', p and p._.loaded ~= nil); print('ft:', vim.bo.filetype); print('config:', vim.inspect(vim.g.lean_config))" \
  +qa 2>&1; echo "exit=$?"
```

## Expected

`loaded: true`, `ft: lean`, `config: { mappings = true }`, `exit=0`, and no
deprecation warning about `require("lean").setup`.

## Last result (2026-07-28)

Pass, on the initial lean.nvim installation. An earlier `opts = ...` spec
tripped the setup() deprecation warning (removal slated for lean.nvim
v2026.9.1); the `init` + `vim.g.lean_config` spec is silent.
