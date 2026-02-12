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

## pytest Configuration

Requires in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
python_classes = ["Describe*", "When*", "Test*"]
python_functions = ["it_*", "test_*"]
```
