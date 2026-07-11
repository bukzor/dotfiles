# Test: Reclone After Workdir Deletion

What it tests: the realistic trigger for the "store already exists"
refusal — `rm -r` a workdir (store survives, that's the whole point),
then `git clone` the same URL back to the same path. Plain `git clone`
still hits the refusal (expected — see rationale below); the
`git-localhost-clone` wrapper avoids it by attaching to the surviving
store *before* fetching, so there's only ever one set of refs.

Unlike `edge-cases.md`'s "Conflicting state" test (a hand-planted fake
ref), the conflicting ref here comes from an ordinary `git clone` — the
actual incident this guards against (2026-07-09: an agent hit this
refusal on a real re-clone and resolved it by deleting the stale store
solo, without asking).

```bash
ORIGIN=~/tmp/test-reclone-origin
TEST_DIR=~/tmp/test-reclone-conflict
STORE="$HOME/.local/state/git-localhost-store/repos/$(claude-path "$TEST_DIR")"
rm -rf "$ORIGIN" "$TEST_DIR" "$STORE"

# Seed an origin and do a normal first clone (store gets created).
mkdir -p "$ORIGIN" && cd "$ORIGIN"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
git clone -q "$ORIGIN" "$TEST_DIR"

# Delete the workdir (store survives — that's the product's whole point),
# then move origin forward.
rm -r "$TEST_DIR"
cd "$ORIGIN" && git commit -q --allow-empty -m v2

# Plain `git clone` at the same path: refuses.
git clone -q "$ORIGIN" "$TEST_DIR"

# git-localhost-clone at the same path: doesn't.
rm -r "$TEST_DIR"
~/.local/share/git-localhost-store/bin/git-localhost-clone "$ORIGIN" "$TEST_DIR"
```

## Expected

Plain `git clone`:
- Exits 0 (git itself doesn't fail — only the hook does), but stderr shows
  `git-localhost-store: ❌ .git has refs but store already exists: ...` /
  `Needs a human decision.`
- `$TEST_DIR/.git` is a real directory (not a symlink) — unrelocated.
- `$STORE` is untouched (still holds the v1-only history).

`git-localhost-clone`:
- No refusal. Stderr shows `✓ Recovered: .git -> $STORE` from the
  existing recovery path, firing on the ref-less `.git` produced by a
  bare `git init` — *before* `git fetch` ever runs.
- `$TEST_DIR/.git` is a symlink to `$STORE`.
- `git fetch` output shows only the v1..v2 delta, not a full object
  transfer — the store's existing objects were reused.
- Local branch stays on the old (v1) commit — `git-localhost-clone`
  never auto-resets local refs onto origin, even on a clean fast-forward.
  Stderr names both SHAs so a human/agent can reconcile explicitly
  (typically `git -C "$TEST_DIR" reset --hard origin/main` once reviewed).
- `git -C "$TEST_DIR" status -s .` is clean; working tree matches
  whatever HEAD actually points at.

## Why plain `git clone` still refuses (and should)

Not for lack of an early-enough hook — `reference-transaction` does fire
before clone's first ref lands. Confirmed (2026-07-11 devlog) that using
it to swap `.git` for the store mid-transaction crashes `git clone`
itself (`BUG: refs/files-backend.c:3072: initial ref transaction called
with existing refs`, aborts) — its internal state machine assumes
uninterrupted ownership of the gitdir from `init` through fetch. Clone
can't safely be interposed on at all, hook or no hook. Use the wrapper
for re-clones, or resolve the refusal with the user when it happens.
