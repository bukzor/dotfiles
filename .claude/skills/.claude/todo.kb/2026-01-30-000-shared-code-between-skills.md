---
status: in-progress
---

# Shared Code Between Skills

## Problem

Multiple skills need to share Python code. No official convention exists.

## Current Solution (Accepted)

Inline `[tool.uv.sources]` in script metadata:

```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["shared"]
#
# [tool.uv.sources]
# shared = { path = "../../lib/shared", editable = true }
# ///
```

Path is relative to script location, not CWD.

**Downsides:**
- Verbose boilerplate in every script
- Path must be repeated in each script
- No centralized dependency management

## Alternatives to Investigate

### Per-skill venvs

Each skill directory has its own `.venv` and `pyproject.toml`:

```
llm-collab/
├── pyproject.toml      # defines deps + sources
├── .venv/              # skill-specific venv
└── bin/
    └── llm-collab-adr  # uses project mode, not --script
```

Scripts use `uv run` (project mode) instead of `uv run --script`.

**Questions:**
- How do bin/ scripts invoke uv in project mode?
- Does the shebang work?
- How is the shared lib referenced?

### Per-skill pyproject.toml with sources redirect

Similar to above but scripts remain `--script` mode, with the pyproject.toml
only providing the sources redirect.

**Questions:**
- Does `uv run --script` respect a nearby pyproject.toml's `[tool.uv.sources]`?
- Or does --script mode ignore project context entirely?

## Next Steps

1. Test per-skill venv approach
2. Test if --script respects project sources
3. Compare ergonomics
