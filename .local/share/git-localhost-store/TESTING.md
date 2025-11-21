# Testing git-localhost-store

Manual testing guide for the git-localhost-store system.

## Prerequisites

```bash
# Ensure system is configured
git config --global init.templateDir "$HOME/.local/share/git-localhost-store/template-repo"

# Verify claude-path is in PATH
which claude-path
```

## Test 1: Fresh Repository Setup

Creates a new repo and verifies object store is created.

```bash
# Setup
TEST_DIR=~/tmp/test-fresh
rm -rf "$TEST_DIR" ~/.local/state/git-localhost-store/repos/*-tmp-test--fresh
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"

# Test
git init
echo "test content" > file.txt
git add file.txt

# Verify
# - Should see "✓ Creating object store" message
# - Should see trace output with colored $ prompt
ls -la .git  # Should be a file, not directory
cat .git     # Should contain gitdir: pointing to object store
git status   # Should work normally
```

**Expected:**
- `.git` is a file pointing to worktree in object store
- Object store created at `~/.local/state/git-localhost-store/repos/-<encoded-path>/`
- `git status` shows file.txt staged

## Test 2: Commit and Verify Storage

Verifies commits are stored in object store.

```bash
# Continuing from Test 1
git commit -m "First commit"
echo "second line" >> file.txt
git commit -am "Second commit"

# Verify object store has commits
ENCODED=$(claude-path "$PWD")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"
ls -la "$STORE"
ls -la "$STORE/objects/"  # Should have pack or loose objects
ls -la "$STORE/refs/heads/"  # Should have main branch
git --git-dir="$STORE" log --oneline  # Should show commits
```

**Expected:**
- Two commits exist
- Objects stored in `$STORE/objects/`
- Refs in `$STORE/refs/heads/main`
- Commits visible via git --git-dir

## Test 3: Recovery After Deletion

The critical test: verify recovery after `rm -rf`.

```bash
# Continuing from Test 2
# Record current state
git log --oneline > /tmp/before.log
ls -la > /tmp/files-before.txt

# Destroy working directory
cd ~/tmp
rm -rf test-fresh

# Verify object store survived
STORE="$HOME/.local/state/git-localhost-store/repos/-home-$(whoami)-tmp-test--fresh"
git --git-dir="$STORE" log --oneline  # Should still show commits

# Recovery
mkdir test-fresh && cd test-fresh
git init
touch dummy  # Create untracked file
git add dummy

# Verify recovery
git log --oneline > /tmp/after.log
diff /tmp/before.log /tmp/after.log  # Should be identical
ls -la  # Should have file.txt restored, dummy present
cat file.txt  # Should have content from both commits
```

**Expected:**
- Message: "✓ Found existing object store - recovering..."
- Trace shows: `$ rm -rf .git`, `$ mkdir -p ...`, `$ git restore file.txt`
- `file.txt` restored with full content
- `dummy` file preserved (not deleted)
- All commits present in `git log`

## Test 4: Multiple Worktrees

Verify multiple worktrees can be added to the same object store.

```bash
# Continuing from Test 3
STORE="$HOME/.local/state/git-localhost-store/repos/-home-$(whoami)-tmp-test--fresh"

# Add second worktree
git --git-dir="$STORE" worktree add ~/tmp/test-fresh-wt2

# Test both worktrees
cd ~/tmp/test-fresh-wt2
echo "worktree 2" > wt2.txt
git add wt2.txt
git commit -m "From worktree 2"

cd ~/tmp/test-fresh
git fetch --all  # Not needed with worktrees, but verify
git log --oneline  # Should show commit from wt2

# Verify worktree listing
git --git-dir="$STORE" worktree list
```

**Expected:**
- Both worktrees listed
- Commits from wt2 visible in original worktree
- Both worktrees share same object store

## Test 5: Existing Repo Conversion

Apply git-localhost-store to an existing repo with history.

```bash
# Create repo WITHOUT our template
TEST_DIR=~/tmp/test-existing
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template=""  # Skip our template

# Create some history
echo "existing" > existing.txt
git add existing.txt
git commit -m "Existing commit"

# Now apply git-localhost-store
git add .  # Trigger our hook

# Verify
ls -la .git  # Should now be a file
cat .git     # Should point to object store
git log --oneline  # Should show existing commit
ls -la  # Should still have existing.txt
```

**Expected:**
- Existing commits preserved
- `.git` converted to worktree file
- All files present and unchanged
- Git operations work normally

## Test 6: Edge Cases

### Empty recovery (no commits yet)

```bash
TEST_DIR=~/tmp/test-empty
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init

# Trigger setup without any commits
touch dummy
git add dummy

# Delete and recover
cd ~/tmp && rm -rf test-empty
mkdir test-empty && cd test-empty
git init
touch another
git add another

# Verify: should work but have no history
git log  # Should fail (no commits)
```

### Conflicting state (local commits + object store exists)

```bash
# This should ERROR and refuse to proceed
TEST_DIR=~/tmp/test-conflict
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"

# Create object store manually
mkdir -p "$STORE"
git init --bare "$STORE"

# Create conflicting local repo
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template=""
echo "local" > local.txt
git add local.txt
git commit -m "Local commit"

# Try to trigger our hook
touch trigger
git add trigger  # Should ERROR with "Cannot safely merge"
```

**Expected:**
- Error message: "❌ .git has existing commits but object store exists"
- Hook fails
- Local .git unchanged

## Test 7: Path Encoding

Verify path encoding works correctly for various paths.

```bash
# Test various path types
claude-path "/home/user/projects/repo"
claude-path "/home/user/my-repo"
claude-path "/home/user/my--special--repo"

# Create repos with special characters
mkdir -p ~/tmp/test-with-hyphens && cd ~/tmp/test-with-hyphens
git init && touch f && git add f
ls ~/.local/state/git-localhost-store/repos/  # Verify encoding

# Verify recovery works with encoded paths
cd ~/tmp && rm -rf test-with-hyphens
mkdir test-with-hyphens && cd test-with-hyphens
git init && touch t && git add t
git log  # Should work if recovery successful
```

## Cleanup

```bash
# Remove test repositories
rm -rf ~/tmp/test-*

# Optional: Remove all test object stores
rm -rf ~/.local/state/git-localhost-store/repos/-*-tmp-test--*

# Keep the system configured for real use
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
- Check state directory exists: `ls -la ~/.local/state/git-localhost-store/`

### Recovery doesn't work
- Verify object store exists: `ls ~/.local/state/git-localhost-store/repos/`
- Check encoding matches: `claude-path ~/tmp/test-repo`
- Look for corresponding directory in repos/
