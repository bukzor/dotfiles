# Development Notes

## Design Principles

- **No failsoft code**: Unknown variants raise `ValueError`, missing keys raise `KeyError`. This ensures we discover new rustdoc format changes immediately rather than silently producing bad output.

- **Full trait paths**: Traits are resolved to full paths via the `paths` table (e.g., `serde::de::Error` not just `Error`) to disambiguate same-named traits.

- **Splatted items**: Each impl produces one output per item (method/const), not one per impl block. This makes the index searchable by method name.

## Code Patterns

### Match statements
All type dispatch uses `match`/`case`. The final `case _` always raises, never returns a default.

### Explicit conditions
Use `x is not None` rather than truthiness tests like `if x`. We test exactly what we mean.

### No redundant guards
Don't write `if not items: return []` when the subsequent loop would naturally return `[]` for empty input.

## Known Type Variants

Types handled in `format_type()`:
- `resolved_path` - named types with optional generic args
- `primitive` - str, u8, etc.
- `generic` - type parameters like T
- `borrowed_ref` - references with lifetime and mutability
- `slice` - [T]
- `array` - [T; N]
- `tuple` - (A, B, ...)
- `qualified_path` - <T as Trait>::Item
