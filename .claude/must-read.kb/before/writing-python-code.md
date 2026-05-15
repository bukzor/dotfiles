# Python Code Style Preferences

**Target Version: Python 3.13**

## Function Organization

### Keep Functions Small
- Maximum ~40 lines per function
- Each function should have a single, clear responsibility
- Break complex logic into smaller, composable functions

### Pure vs Impure Functions
- Name impure functions with verbs that clearly indicate side effects (`write`, `load`, `save`, `send`, `delete`, etc.)
  - Fallback: `proc_` prefix when no verb fits naturally
- Minimize the number of impure functions
- Strive to keep all logic in pure, testable functions
- Only `main()` should handle I/O operations (stdin/stdout/stderr, sys.exit, etc.)

Examples:
```python
# Pure function - no side effects
def calculate_total(items):
    return sum(item.price for item in items)

# Impure function - verb signals side effects
def save_to_file(data, filename):
    with open(filename, 'w') as f:
        f.write(data)

# Main - handles all I/O
def main():
    data = json.load(sys.stdin)
    result = calculate_total(data)
    print(json.dumps(result))
```

## Error Handling

### Assertions
- Assert data invariants rather than handling them conditionally
- Second argument: relevant values, unformatted
  - `assert x, x`
  - `assert x == y, (x, y)`

### Minimize Try Blocks
- A `try` block should ideally encompass exactly one operation
- Avoid wrapping large blocks of code in try/except

### Fail Hard on Unexpected Errors
- Let tracebacks surface for unexpected errors
- No silent fallbacks or fail-soft for bugs
- Tracebacks are optimal for debugging unexpected errors
- Only catch specific, expected exceptions

Bad:
```python
try:
    # 50 lines of code
    ...
except Exception as e:
    # Fail soft
    return default_value
```

Good:
```python
data = json.load(sys.stdin)  # Let it raise if JSON is invalid
result = process_data(data)   # Let it raise if there's a bug
```

## Control Flow

### Exhaustive Case Analysis

When branching on finite value sets (enums, literals), use explicit else that raises:

- `match`/`case` with `case _: raise AssertionError(value)`
- `if`/`elif`/`else` with `else: raise AssertionError(value)`

Never implicit else (early return). The unreachable raise catches bugs when the set grows.

## Code Structure

### Avoid Spaghetti Code
- Break complex functions into small, well-named helper functions
- Each function should be easily understandable in isolation
- Prefer composition over deeply nested logic

## Type Annotations

- Only annotate return types when the return type is nontrivial or non-obvious
  - No `-> None` on test methods — pyright infers them
- No code in `__init__.py`
- Use `types.py` for shared type definitions
- Prefer explicit-relative imports (`from .types import ...`)
- Prefer recursive structural types (`JsonValue`, `JsonObj`) over `Any` for JSON data — enforce narrowing at each access step
- Always prefer immutable covariant types (e.g. `Mapping`, not `dict`) for read-only data
- No `# E:` comments or `# type:` directives in source or test files

## Project Template

Canonical Python project template: https://github.com/bukzor/template.python-project/copier-template/
Local checkout: `~/repo/github.com/bukzor/template.python-project/copier-template/`

New Python projects under `github.com/bukzor/` should be based on or aligned with this template's conventions (pyright strict, pytest, pre-commit, etc.).

## Testing

When writing or modifying tests, follow `writing-tests.md`. This applies to all
codebases—your own or others'—and is especially valuable in unfamiliar code where
tests verify your understanding before you change behavior.
