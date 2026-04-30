# Testing git-localhost-store

## Quick Test (Automated)

```bash
./test-reference-transaction
```

Runs a full cycle: init → add → commit → verify. Uses `--template=` flag for isolation (doesn't require global config).

## Manual Testing Guide

### Prerequisites

```bash
# Verify claude-path is in PATH
which claude-path

# Option A: Global config (affects all new repos)
git config --global init.templateDir "$HOME/.local/share/git-localhost-store/template-repo"

# Option B: Per-repo (for isolated testing)
git init --template="$HOME/.local/share/git-localhost-store/template-repo"
```

## Test 1: Fresh Repository Setup

Creates a new repo and verifies the store is created and `.git` becomes a symlink.

```bash
# Setup
TEST_DIR=~/tmp/test-fresh
rm -rf "$TEST_DIR" ~/.local/state/git-localhost-store/repos/-home-*-tmp-test--fresh
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"

# Test
git init
echo "test content" > file.txt
git add file.txt

# Verify
ls -la .git           # Should be a symbolic link → ~/.local/state/...
readlink .git         # Should print the store path
cat .git/HEAD         # Should resolve through the symlink and print "ref: refs/heads/main"
git status            # Should work normally
```

**Expected:**
- `.git` is a symlink → `~/.local/state/git-localhost-store/repos/<encoded>/`
- The store directory contains `HEAD`, `objects/`, `refs/`, `config`, `hooks/`
- `cat .git/HEAD` resolves through the symlink and prints the ref
- `git status` shows file.txt staged

## Test 2: Commit and Verify Storage

Verifies commits land in the store.

```bash
# Continuing from Test 1
git commit -m "First commit"
echo "second line" >> file.txt
git commit -am "Second commit"

# Verify the store has commits
ENCODED=$(claude-path "$PWD")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"
ls -la "$STORE"
ls -la "$STORE/objects/"     # Should have pack or loose objects
ls -la "$STORE/refs/heads/"  # Should have main branch
git --git-dir="$STORE" log --oneline  # Should show commits
```

**Expected:**
- Two commits exist
- Objects stored in `$STORE/objects/`
- Refs in `$STORE/refs/heads/main`
- Commits visible via `git --git-dir`

## Test 3: Recovery After Deletion

The critical test: verify recovery after `rm -rf`.

```bash
# Continuing from Test 2
git log --oneline > /tmp/before.log

# Destroy working directory
cd ~/tmp
rm -rf test-fresh

# Verify the store survived
STORE="$HOME/.local/state/git-localhost-store/repos/-home-$(whoami)-tmp-test--fresh"
ls "$STORE/objects/"                    # Still there
git --git-dir="$STORE" log --oneline    # Still shows commits

# Recovery
mkdir test-fresh && cd test-fresh
git init                                # Hook detects existing store; symlink recreated
git checkout -- .                       # Restore tracked files

# Verify recovery
git log --oneline > /tmp/after.log
diff /tmp/before.log /tmp/after.log     # Should be identical
ls -la                                   # file.txt restored
cat file.txt                            # Should have content from both commits
```

**Expected:**
- Pre-existing store is detected; the new `.git` becomes a symlink to it
- `git checkout -- .` restores tracked files
- All commits present in `git log`

## Test 4: Existing Repo Conversion

Apply git-localhost-store to an existing repo with history.

```bash
# Create repo WITHOUT our template
TEST_DIR=~/tmp/test-existing
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template=""

# Create some history
echo "existing" > existing.txt
git add existing.txt
git commit -m "Existing commit"

# Apply git-localhost-store
git-restore-repo

# Verify
ls -la .git                # Symlink
git log --oneline          # Existing commit preserved
ls -la                     # existing.txt still there
```

**Expected:**
- Existing commits preserved
- `.git` converted to symlink → store
- All files present and unchanged
- Git operations work normally

## Test 5: Empty Commit on Fresh Repo

```bash
TEST_DIR=~/tmp/test-empty-commit
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template="$HOME/.local/share/git-localhost-store/template-repo"
git commit --allow-empty -m "test empty commit"
ls -la .git
git log --oneline
```

**Expected:**
- Commit succeeds
- `.git` becomes a symlink (the `reference-transaction` hook fires after the commit's ref txn lands)
- Object store created with the empty commit's tree

## Test 6: Edge Cases

### Empty recovery (no commits yet)

```bash
TEST_DIR=~/tmp/test-empty
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init

# Trigger conversion without commits — happens on first add
touch dummy
git add dummy

ls -la .git           # Should be a symlink
git log               # Should fail with "does not have any commits yet"
```

### Conflicting state (existing local repo + existing store)

```bash
TEST_DIR=~/tmp/test-conflict
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"

# Create a store first
rm -rf "$STORE" "$TEST_DIR"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template="$HOME/.local/share/git-localhost-store/template-repo"
echo "first" > f && git add f && git commit -m "first"

# Tear down only the workdir
cd ~/tmp && rm -rf test-conflict

# Try to create a NEW conflicting repo at the same path
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template=""    # not using our template
echo "different" > different.txt
git add different.txt
git commit -m "Conflicting local commit"

# Now run git-restore-repo manually
git-restore-repo
```

**Expected:**
- `git-restore-repo` refuses with `❌ Store already exists: ...`
- Local `.git` unchanged
- User intervention required (decide which side to keep)

## Test 7: Path Encoding

Verify path encoding works for various inputs.

```bash
claude-path "/home/user/projects/repo"
claude-path "/home/user/my-repo"
claude-path "/home/user/my--special--repo"

# Repos with special characters round-trip through the store
mkdir -p ~/tmp/test-with-hyphens && cd ~/tmp/test-with-hyphens
git init && touch f && git add f
ls ~/.local/state/git-localhost-store/repos/  # The encoded name should appear

# Recovery still works through the encoding
cd ~/tmp && rm -rf test-with-hyphens
mkdir test-with-hyphens && cd test-with-hyphens
git init
git checkout -- .  # If anything was committed; harmless if not
```

## Test 8: Migrate from Legacy Layout

Verify `migrate-from-gitfile` converts a legacy gitfile-style repo.

```bash
TEST_DIR=~/tmp/test-migrate
LEGACY_STORE=~/tmp/test-migrate.legacy-store
rm -rf "$TEST_DIR" "$LEGACY_STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"

# Build a legacy-layout repo by hand:
git init --template=""
echo "legacy" > legacy.txt && git add legacy.txt && git commit -m "legacy commit"

mv .git "$LEGACY_STORE"
git config -f "$LEGACY_STORE/config" core.bare true
mkdir -p "$LEGACY_STORE/worktrees/test-migrate"
echo "$TEST_DIR/.git" > "$LEGACY_STORE/worktrees/test-migrate/gitdir"
echo "../.." > "$LEGACY_STORE/worktrees/test-migrate/commondir"
cp "$LEGACY_STORE/HEAD" "$LEGACY_STORE/worktrees/test-migrate/HEAD"
mkdir -p "$LEGACY_STORE/worktrees/test-migrate/refs"
mv "$LEGACY_STORE/index" "$LEGACY_STORE/worktrees/test-migrate/index"
echo "gitdir: $LEGACY_STORE/worktrees/test-migrate" > .git

# .git is now a regular file (gitfile)
ls -la .git
cat .git/HEAD 2>&1 || true   # Should error: "Not a directory"

# Migrate
migrate-from-gitfile "$TEST_DIR"

# Verify
ls -la .git                  # Symlink now
cat .git/HEAD                # Reads cleanly
git log --oneline            # Commit preserved
```

**Expected:**
- `cat .git/HEAD` errors before migration ("Not a directory")
- Migration prints xtrace-style steps
- `.git` is a symlink afterward
- All commits preserved
- `cat .git/HEAD` reads cleanly via the symlink

## Cleanup

```bash
# Remove test repositories
rm -rf ~/tmp/test-*

# Optional: Remove all test object stores
rm -rf ~/.local/state/git-localhost-store/repos/-home-*-tmp-test--*
```

## Common Issues

### Hook doesn't run
- Check: `git config --global init.templateDir`
- Should point to: `~/.local/share/git-localhost-store/template-repo`

### `claude-path` not found
- Check: `which claude-path`
- Should be in: `~/bin/claude-path`
- Verify `~/bin` is in `$PATH`

### Object store not created
- Check hook is executable: `ls -la ~/.local/share/git-localhost-store/template-repo/hooks/post-index-change`
- Check state directory parent exists: `ls -la ~/.local/state/`

### Recovery doesn't work
- Verify object store exists: `ls ~/.local/state/git-localhost-store/repos/`
- Check encoding matches: `claude-path ~/tmp/test-repo`
- Look for the corresponding directory under `repos/`
