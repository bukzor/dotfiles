# Test: Migrate from Legacy Layout

What it tests: `migrate-from-gitfile` converts a repo still in the
legacy gitfile-pointer layout (`.git` is a regular file containing
`gitdir: <store>/worktrees/<name>`) into the symlink layout.

```bash
TEST_DIR=~/tmp/test-migrate
LEGACY_STORE=~/tmp/test-migrate.legacy-store
rm -rf "$TEST_DIR" "$LEGACY_STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"

# Build a legacy-layout repo by hand
git init --template=
echo "legacy" > legacy.txt
git add legacy.txt
git -c user.email=t@t -c user.name=t commit -m "legacy commit"

mv .git "$LEGACY_STORE"
git config -f "$LEGACY_STORE/config" core.bare true
mkdir -p "$LEGACY_STORE/worktrees/test-migrate"
echo "$TEST_DIR/.git"             > "$LEGACY_STORE/worktrees/test-migrate/gitdir"
echo "../.."                      > "$LEGACY_STORE/worktrees/test-migrate/commondir"
cp "$LEGACY_STORE/HEAD"             "$LEGACY_STORE/worktrees/test-migrate/HEAD"
mkdir -p                            "$LEGACY_STORE/worktrees/test-migrate/refs"
mv "$LEGACY_STORE/index"            "$LEGACY_STORE/worktrees/test-migrate/index"
echo "gitdir: $LEGACY_STORE/worktrees/test-migrate" > .git

# Confirm the legacy shape produces ENOTDIR on naive readers
ls -la .git
cat .git/HEAD 2>&1 || true   # errors: "Not a directory"

# Migrate
migrate-from-gitfile "$TEST_DIR"
```

## Expected

- Before migration: `cat .git/HEAD` errors with `Not a directory`.
- During migration: `migrate-from-gitfile` prints xtrace-style steps for
  each operation it performs.
- After migration:
  - `.git` is a symlink → `$LEGACY_STORE`.
  - `cat .git/HEAD` reads cleanly via the symlink.
  - `git log --oneline` shows the legacy commit.
  - `$LEGACY_STORE/worktrees/` is gone (single-tier layout).
