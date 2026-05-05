---
last-tested: "2026-05-05"
result: pass
scope: nvim-startup
---

# Headless config loads cleanly

Verifies the full nvim init runs without errors under `--headless`. Cheap
regression gate before commits and after big plugin / config / system changes.
A failure here usually means a deprecation, a missing plugin, or a Lua syntax
error introduced by a recent edit.

## Procedure

```bash
nvim --headless +qa 2>&1 ; echo "exit=$?"
```

## Expected

`exit=0` and no error text. (Lazy may print clone progress on first run if any
plugins are missing; subsequent runs are silent.)

## Last result (2026-05-05)

`exit=0`, silent. Re-run after the conform / nvim-lint migration confirms the
new plugin specs and `lsp.lua` rewrite don't break boot.
