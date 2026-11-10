# bukzor Python TDD Conventions

For Python repositories under `github.com/bukzor/`.

## Test Naming

```python
class DescribeCard:
    def it_is_immutable(self): ...
    def it_displays_nicely(self): ...

    class WhenComparing:
        def it_sorts_by_suit_then_rank(self): ...
```

Reads as specification: "Describe Card: it is immutable, it displays nicely. When comparing: it sorts by suit then rank."

## Test Organization

- `{module}_test.py` alongside `{module}.py`
- Property-based tests with hypothesis where valuable

## Test Philosophy

- Show failure first — passing tests prove nothing until you've seen them fail
- Don't run passing tests to demonstrate a change; run the failing case

## pytest Configuration

Requires in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
python_classes = ["Describe*", "When*", "Test*"]
python_functions = ["it_*", "test_*"]
```

## Type Safety Testing (`typesafety/`)

- `typesafety/` directory holds `# E:` type error assertions, checked by pytest-pyright
- Excluded from main pyright config (so `pyright` stays clean at 0 errors)
- Has its own `pyrightconfig.json` extending parent, without the `typesafety` exclusion
- This is the one exception to "no `# E:` directives" — they belong here exclusively
