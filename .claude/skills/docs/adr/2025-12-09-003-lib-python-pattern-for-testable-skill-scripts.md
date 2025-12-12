# lib/python pattern for testable skill scripts

**Date:** 2025-12-09
**Status:** Accepted

## Context

Skill scripts need to be both executable (from `bin/`) and testable (importable as modules). Python scripts that live directly in `bin/` can't be imported due to naming constraints (hyphens, no `__init__.py`).

## Decision

Place Python code in `lib/python/{libname}/` as a proper package:

```
skill/
├── bin/
│   └── skill-name-tool -> ../lib/python/libname/tool.py
├── lib/
│   └── python/
│       └── libname/
│           ├── __init__.py
│           ├── tool.py          # executable script
│           └── tool_test.py     # tests alongside code
```

**Key elements:**

1. **Package structure:** `lib/python/{libname}/` with `__init__.py`
2. **Symlinks:** `bin/{tool}` → `../lib/python/{libname}/{script}.py`
3. **Executable scripts:** Use `uv run --script` shebang for dependency management
4. **Tests:** Live alongside code as `*_test.py`, run with pytest

**Script shebang pattern:**
```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["pyyaml"]
# ///
```

## Alternatives Considered

### bin/ scripts only (no lib/)
- **Pros:** Simpler structure
- **Cons:** Can't import for testing, can't share code between scripts

### lib/ at repo root
- **Pros:** Single location for all library code
- **Cons:** Couples skills together, harder to move skills independently

## Consequences

**Positive:**
- Scripts are importable for unit testing
- Code can be shared between scripts in same skill
- Symlinks preserve `bin/` as the public interface

**Negative:**
- More directories to navigate
- Symlinks can confuse some tools

**Neutral:**
- Tests run via `pytest lib/python/` or specific file

## Related

- Related to: 2025-12-09-001-skill-and-script-naming-conventions.md (bin/ conventions)
