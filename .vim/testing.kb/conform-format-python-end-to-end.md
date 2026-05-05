---
last-tested: "2026-05-05"
result: pass
scope: conform.nvim
---

# conform formats a Python buffer end-to-end

Verifies the full format chain: open Python buffer → conform invokes isort then
black → buffer is reformatted. This complements `conform-formatters-by-filetype.md`
(which only checks resolution): if wiring passes but this fails, the formatter
binaries themselves are broken — see `mason-python-tools-runnable.md`.

## Procedure

```bash
cat > /tmp/test.py <<'EOF'
import sys
import os
def foo(x,y):
    return x+y
EOF
nvim --headless /tmp/test.py \
  -c 'lua require("conform").format({bufnr=0, async=false, timeout_ms=10000})' \
  -c 'w! /tmp/test.py.out' \
  -c 'qa!'
diff /tmp/test.py /tmp/test.py.out
```

## Expected

Diff shows isort sorting imports (`os` before `sys`), black reformatting
`def foo(x,y):` → `def foo(x, y):`, `x+y` → `x + y`, plus PEP-8 blank lines
after imports and a trailing newline. `diff` exits 1 (differences exist).

## Last result (2026-05-05)

Pass. Output:

```python
import os
import sys


def foo(x, y):
    return x + y
```

isort and black both ran cleanly via `vim.system` with no stderr noise.

