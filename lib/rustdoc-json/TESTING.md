# Testing

## Unit Tests

```bash
uv run --no-dev pytest rustdoc_json_index_test.py -v
```

## Acceptance Tests

Run against real rustdoc JSON to verify no errors and no duplicates:

```bash
# Fetch rustdoc JSON (cached in ~/.cache/rustdoc-json/)
rustdoc-json serde
rustdoc-json git2

# Run and check output count
python rustdoc_json_index.py < ~/.cache/rustdoc-json/serde-1.0.228.json | wc -l

# Check for unhandled type variants (would raise ValueError)
python rustdoc_json_index.py < ~/.cache/rustdoc-json/serde-1.0.228.json > /dev/null

# Check for duplicate names (should find none)
python rustdoc_json_index.py < ~/.cache/rustdoc-json/serde-1.0.228.json |
  cut -d' ' -f2- |
  sort | uniq -c |
  grep -v '^      1 '
```

## Adding New Type Variants

When a new rustdoc JSON type variant appears, the code raises `ValueError` with the variant keys. To add support:

1. Inspect the variant structure:
   ```bash
   jq -rc '.index | to_entries[].value.inner.impl |
     select(.for.NEW_VARIANT != null) | .for.NEW_VARIANT' < crate.json
   ```

2. Add a `case` in `format_type()` for the new variant

3. Add a `case` in `ast_to_string()`'s `type_to_str()` for display

4. Add unit tests for the new variant

5. Re-run acceptance tests to verify no duplicates
