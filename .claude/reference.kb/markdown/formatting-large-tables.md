# Markdown tables

## Prefer sub-lists over tables for prose cells

GFM table rows are exactly one source line — cells can't wrap across lines
(`<br>` forces a rendered break but doesn't shorten the source line). For
prose-length content, use a bullet list with attributes as sub-bullets
instead; list items soft-wrap across source lines, tables can't:

```markdown
- `key-name:`
  - files: 12
  - Prose explanation goes here, wrapping across as many
    source lines as needed.
```

Reserve pipe tables for short, single-token cells (numbers, short labels)
where column alignment earns its keep.
