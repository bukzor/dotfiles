# Python Code Style Preferences

**Target Version: Python 3.13**

## Function Organization

### Keep Functions Small
- Maximum ~40 lines per function
- Each function should have a single, clear responsibility
- Break complex logic into smaller, composable functions

### Pure vs Impure Functions
- Prefix impure functions (those with side effects) with `proc_`
- Exception: `main()` can be named `main` instead of `proc_main`
- Minimize the number of impure functions
- Strive to keep all logic in pure, testable functions
- Only `main()` should handle I/O operations (stdin/stdout/stderr, sys.exit, etc.)

Examples:
```python
# Pure function - no side effects
def calculate_total(items):
    return sum(item.price for item in items)

# Impure function - has side effects
def proc_save_to_file(data, filename):
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

## Testing

When writing or modifying tests, follow `tdd-workflow.md`. This applies to all
codebases—your own or others'—and is especially valuable in unfamiliar code where
tests verify your understanding before you change behavior.
