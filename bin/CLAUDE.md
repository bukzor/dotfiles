# Markdown frontmatter tools

A get/set pair for reading and writing YAML frontmatter in markdown files.

## `md-frontmatter` (read)

Extracts frontmatter from one or more markdown files. Emits JSONL, one record
per file:

```
{"path": "<file>", "@value": <frontmatter | null>}
```

`@value` is `null` when the file has no frontmatter fence (`---`).

```sh
md-frontmatter notes/*.md                 # one record per file
md-frontmatter foo.md | jq '.["@value"]'  # just the frontmatter object
```

## `md-frontmatter-set` (write)

Reads the same JSONL shape on stdin and writes each `@value` back as the
frontmatter of the corresponding file. Uses recursive leaf-level diff: only
paths whose scalar values actually differ are rewritten, so unchanged subtrees
keep their comments and YAML type fidelity.

```sh
# Round-trip with edits in the middle
md-frontmatter foo.md \
  | jq '.["@value"].title = "New Title"' \
  | md-frontmatter-set

# Bulk update title across many files
md-frontmatter notes/*.md \
  | jq -c '.["@value"].reviewed = "2026-05-17" | .' \
  | md-frontmatter-set
```

### Semantics

- **Unchanged keys**: not rewritten (preserves comments, formatting).
- **Identity round-trip** (`md-frontmatter | md-frontmatter-set` with no edits):
  byte-identical — yq is not invoked at all.
- **Missing key**: deleted from the file.
- **New key**: added.
- **`@value: null` on a file with no frontmatter**: no-op.
- **`@value: null` on a file with frontmatter**: refused (won't strip FM).
- **File with no frontmatter + non-null `@value`**: a fenced block is prepended.

### Known limitation

yq normalizes inline-comment whitespace when it serializes any subtree (e.g.,
`  - a    # foo` becomes `  - a # foo`). Comment text and position survive;
only the extra spacing before `#` collapses. Fixing this would require
switching the serializer to ruamel.yaml.

## Implementation

- `md-frontmatter-diff.jq` — pure jq library used by `md-frontmatter-set` to
  compute the minimal yq expression that transforms current → desired.
- yq does the writing (preserves comments); jq does the diff (yq has no `def`).

## Tests

```sh
~/bin/tests/md-frontmatter        # 5 tests
~/bin/tests/md-frontmatter-set    # 15 tests
```
