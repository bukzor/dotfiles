## TOON Format

Use when writing `.toon` files or outputting structured tabular data.

### Structure

Arrays declare length and fields in header, then 2-space indented rows:

```toon
items[3]{id,name,price}:
  1,Widget,9.99
  2,Gadget,19.99
  3,Thing,4.50
```

### Rules

- `[N]` must match actual row count
- 2-space indent for data rows
- Comma-separated by default (tab also valid)
- Quote values containing delimiter or newline
- `null` for missing values

### Nested Objects

Inline with dot notation in field names:

```toon
users[2]{id,name,address.city,address.zip}:
  1,Alice,Boston,02101
  2,Bob,Denver,80202
```

### Reference

For full LLM usage guide:
```bash
curl -sSL https://raw.githubusercontent.com/toon-format/toon/refs/heads/main/docs/guide/llm-prompts.md
```

https://github.com/toon-format/toon
