# Test: Migrate In-Place (Source Store == Target)

What it tests: `migrate-from-gitfile` handles the post-cutover case where
the legacy gitfile already points at the encoded path that the new
symlink layout would use — `relocate_store` is skipped, the swap still
produces a working symlink-layout repo.

```bash
TEST_DIR=~/trash/inplace-migrate-test
FIXTURE_XDG=~/trash/inplace-fixture-xdg
rm -rf "$TEST_DIR" "$FIXTURE_XDG"
mkdir -p "$TEST_DIR" "$FIXTURE_XDG/git-localhost-store/repos"
cd "$TEST_DIR"

git init --template= -q
echo "in-place test" > note.txt
git add note.txt
git -c user.email=t@t -c user.name=t commit -q -m "in-place legacy commit"

ENCODED=$(claude-path "$TEST_DIR")
LEGACY_STORE="$FIXTURE_XDG/git-localhost-store/repos/$ENCODED"

# Stand up the legacy gitfile layout AT the path that
# claude-path encodes for $TEST_DIR — this is the in-place case.
mv .git "$LEGACY_STORE"
git config -f "$LEGACY_STORE/config" core.bare true
mkdir -p "$LEGACY_STORE/worktrees/inplace-migrate-test"
echo "$TEST_DIR/.git"      > "$LEGACY_STORE/worktrees/inplace-migrate-test/gitdir"
echo "../.."               > "$LEGACY_STORE/worktrees/inplace-migrate-test/commondir"
cp "$LEGACY_STORE/HEAD"      "$LEGACY_STORE/worktrees/inplace-migrate-test/HEAD"
mkdir -p                     "$LEGACY_STORE/worktrees/inplace-migrate-test/refs"
mv "$LEGACY_STORE/index"     "$LEGACY_STORE/worktrees/inplace-migrate-test/index"
echo "gitdir: $LEGACY_STORE/worktrees/inplace-migrate-test" > "$TEST_DIR/.git"

# Migrate. Override XDG_STATE_HOME so the encoded target lives next to
# the legacy store.
XDG_STATE_HOME="$FIXTURE_XDG" migrate-from-gitfile "$TEST_DIR"
```

## Expected

- The `mv -T <store> <new_store>` step (relocate) is **absent** from
  the trace — source and target are the same path.
- `.git` is a symlink → `$LEGACY_STORE`.
- `cat .git/HEAD` reads cleanly.
- `git log --oneline` shows the legacy commit.
- `$LEGACY_STORE/worktrees/` is gone.
- `$LEGACY_STORE/HEAD`, `index`, hooks all live at the store root.

## Why this case exists

After the 2026-04-30 cutover, the install dir and state dir were kept
at their original (encoded) paths. Any repo migrated from that point on
already has its store at the path `claude-path` would encode — the
standard "move from old store to encoded target" step would fail the
`target-store-already-exists` precondition. `check_target_store_does_not_exist`
short-circuits when `plan.new_store == plan.layout.store`, and the
`migrate()` composer skips `relocate_store` accordingly.
