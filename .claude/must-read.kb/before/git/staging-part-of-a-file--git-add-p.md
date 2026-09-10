---
triggers:
  - read: ./running-ANY-git-command.md
---

# Before staging part of a file

> [!DRAFT] agent-authored 2026-09-10, vetoable — from a session asking whether
> `git add --patch` has a headless equivalent. It does; this is it.

The occasion: one file's working-tree changes belong to more than one commit, or
to more than one agent, and only some of them should be staged. Reach here
wherever a human would reach for `git add -p` / `git add --patch`.

`git apply --cached` is that command without the terminal. It writes the index
and leaves the working tree alone, so the hunks you skip stay live as unstaged
changes — the whole `add -p` contract.

## Stage the hunks you want

```bash
git -C <dir> diff -U3 <path> > trash/staging.patch
# edit trash/staging.patch — delete unwanted hunks, split kept ones freely
git -C <dir> apply --cached --recount --check trash/staging.patch
git -C <dir> apply --cached --recount trash/staging.patch
git -C <dir> commit-staged <path> -- -m '...'
```

`--recount` is what lets you edit the patch as prose: git recomputes each `@@`
header's line counts from the hunk body. Without it, a hand-split hunk dies as
`error: corrupt patch`. `--check` applies nothing and reports whether the real
run would succeed.

Capture the context lines with `git diff` every time. A patch whose context you
typed from memory is refused, and `--3way` does not rescue it — it recovers
moved offsets, not invented lines.

## Stage content that no choice of hunks expresses

Build the exact bytes you want indexed, write the blob, point the index at it:

```bash
sha=$(git -C <dir> hash-object -w trash/desired.txt)
git -C <dir> update-index --cacheinfo "100644,$sha,<path>"
```

This is strictly more general than hunk selection, and equivalent where they
overlap — both routes produce the same blob. `--cacheinfo` reads its path as
repo-root-relative, not relative to cwd.
