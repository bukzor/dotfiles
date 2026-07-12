# Test: Edge Cases

Two small cases: an empty workdir conversion, and a conflicting state.

## Empty conversion (no commits yet)

What it tests: conversion still works when the workdir has no commits —
just a fresh `.git/` directory and a single index entry.

```bash
TEST_DIR=~/tmp/test-empty
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"

rm -rf "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init
touch dummy
git add dummy
```

### Expected

- `.git` is a symlink → `$STORE` (post-index-change fired on `git add`).
- `git log` reports `does not have any commits yet`.

## Conflicting state (refs in fresh `.git` AND existing store)

What it tests: when both a populated store *and* refs in the workdir's
fresh `.git` exist, `git-localhost-store` refuses rather than silently
merging.

```bash
TEST_DIR=~/tmp/test-conflict
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"
rm -rf "$TEST_DIR" "$STORE"

# Seed the store
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init -q && echo seed > seed.txt
git add seed.txt
git -c user.email=t@t -c user.name=t commit -q -m seed

# Wipe the workdir, init bypassing our hooks, plant a competing ref
cd ~/tmp && rm -rf "$TEST_DIR"
git -c init.templateDir= init -q "$TEST_DIR" --template=
echo "0000000000000000000000000000000000000001" \
    > "$TEST_DIR/.git/refs/heads/somebranch"

cd "$TEST_DIR" && git-localhost-store
```

### Expected

- `git-localhost-store` exits 1.
- Stderr: `❌ .git has unexpected local branches (not produced by a real
  clone): $STORE`, listing `refs/heads/somebranch`.
- `.git` unchanged (still a real directory, not a symlink).
- `$STORE` unchanged (pre-existing seed commit still there).

See `reclone-after-workdir-deletion.md` for why this refuses: a real
`git clone` only ever writes `refs/remotes/*` and one local branch
(whatever `HEAD` points at). `somebranch` isn't that branch, so it's a
shape `git-localhost-store` doesn't recognize — it refuses rather than
silently ignoring it.
