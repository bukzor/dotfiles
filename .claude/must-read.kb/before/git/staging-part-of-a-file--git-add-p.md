---
triggers:
  - read: ./running-ANY-git-command.md
---

# Before staging part of a file

> [!DRAFT] agent-authored 2026-09-10, vetoable — revised 2026-09-16 from five
> uses and one failure.

The occasion: one file's working-tree changes belong to more than one commit, or
to more than one agent, and only some of them should be staged. Reach here
wherever a human would reach for `git add -p` / `git add --patch`, and whenever
a pre-commit review finds another agent's edits in a file you must commit.

`git apply --cached` is that command without the terminal. It writes the index
and leaves the working tree alone, so the hunks you skip stay live as unstaged
changes — the whole `add -p` contract.

## Stage the hunks you want

`cd` into the repo first, so the patch lands in that repo's `trash/`:

```bash
cd <dir>
git diff -U3 -- <path> > trash/staging.patch
grep -c '^@@' trash/staging.patch                              # how many hunks?
awk '/^@@/{h++} h!=2' trash/staging.patch > trash/mine.patch   # drop hunk 2
git apply --cached --recount --check trash/mine.patch
git apply --cached --recount trash/mine.patch
git diff --cached -- <path>                                    # read this back
git commit-staged <path> -- -m '...'
```

`h!=N` drops hunk N; `h<N`, `h==N` select other subsets. Edit the hunk bodies
freely as well — `--recount` recomputes each `@@` header's line counts from its
body, so a hand-split hunk still applies; without it, `error: corrupt patch`.
`--check` applies nothing and reports whether the real run would succeed.

Read the staged diff back every time. It is the only proof you left the other
agent's work unstaged.

Capture context lines with `git diff`, never from memory — such a patch is
refused, and `--3way` does not rescue it: it recovers moved offsets, not
invented lines.

## When your hunk and theirs are the same hunk

Edits a few lines apart fuse into one `@@`, and then no choice of hunks can
separate them. Shrink the context until they split:

```bash
git diff -U0 -- <path> > trash/staging.patch     # what was 1 hunk becomes 2
awk '/^@@/{h++} h!=2' trash/staging.patch > trash/mine.patch
git apply --cached --recount --unidiff-zero trash/mine.patch
```

`--unidiff-zero` is required. A zero-context patch under `--recount` alone dies
as `patch does not apply`.

## When even that fails

Build the exact bytes you want indexed, write the blob, point the index at it:

```bash
git show ":<path>" > trash/desired.txt    # start from the index, not the worktree
# edit trash/desired.txt
sha=$(git hash-object -w trash/desired.txt)
git update-index --cacheinfo "100644,$sha,<path>"
```

Use this when the other agent has rewritten the whole file, so every line is
contested. `--cacheinfo` reads its path as repo-root-relative, not cwd-relative.
