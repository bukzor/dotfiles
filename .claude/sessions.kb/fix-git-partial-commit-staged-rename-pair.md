---
cwd: /home/bukzor/repo/github.com/bukzor/git-partial.prototyping
session:
  started: null
  ended: null
---
# Fix git-partial commit-staged path-filter for renames (planned)

`git commit-staged <dest-path>` over a `git mv`-renamed pair commits
only the addition half of the rename. The deletion of the source path
stays in the index because the path filter doesn't match it.

Hit during the must-read.d → must-read.kb rename (commits 21f8179 +
d9d7617). Worked around with a follow-up commit; should be fixed in
the tool so future renames commit atomically.

## Reproduction

```bash
git mv old-dir new-dir
git commit-staged new-dir -- -m "rename"   # commits add-half only
git status                                  # source still staged-D
```

## Expected behavior

When the path filter matches one half of a rename pair, include the
other half. Either:
- Detect rename pairs across the filter boundary and pull both, or
- Document that the user must pass both old and new paths
  (acceptable but error-prone — `git mv` shows `R` in status, the
  user reasonably assumes commit-staged understands renames too).

## Cross-references

- `git-partial.prototyping/.claude/todo.md` has a related mutation-test
  entry "filter-rename-by-destination-only" marked equivalent —
  that's about the diff-tree side, not the path-filter side. Different
  layer.
- Rename context: `~/.claude/sessions.kb/rename-must-read-d-to-must-read-kb.md`

## Delete When

Fixed in git-partial.prototyping and verified against the original
repro.
