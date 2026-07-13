# Test: Store Recovery Via Commit (Not Clone)

What it tests: `reclone-after-workdir-deletion.md` covers the recovery
merge triggered by `git clone`. This is the same merge triggered by
`git commit` instead -- a fresh `git init` followed by a commit, at a
path whose store already has content (compatible or divergent). This
path is unsafe unless `post-index-change` defers to `post-commit`; see
"Why this needs its own test" below.

## Setup (shared by both cases)

```bash
export XDG_STATE_HOME=~/trash/test-state-home
```

## Case 1: compatible (store's history is an ancestor of/equal to the fresh commit)

```bash
D=~/trash/test-commit-recover
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$(claude-path "$D")"
rm -r "$D" "$STORE"

mkdir -p "$D" && cd "$D"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
rm -r "$D"
mkdir -p "$D" && cd "$D"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
```

### Expected (Case 1)

- `git commit` exits 0.
- `.git` is a symlink to `$STORE`.
- Stderr shows the `post-index-change` deferral note, then
  `git-localhost-store: ✓ Recovered: ...` from `post-commit`.

## Case 2: genuine divergence (must refuse cleanly, not crash)

```bash
D=~/trash/test-commit-diverge
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$(claude-path "$D")"
rm -r "$D" "$STORE"

mkdir -p "$D" && cd "$D"
git init -q --template=
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m storev1
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m storev2
mkdir -p "$STORE"; mv .git/* "$STORE/"; rm -r .git; ln -s "$STORE" .git

rm -r "$D"; mkdir -p "$D" && cd "$D"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m unrelated
```

### Expected (Case 2)

- `git commit` itself still exits 0 (post-commit's own failure doesn't
  affect `git commit`'s exit status -- githooks(5): "cannot affect the
  outcome").
- `.git` is a **real directory**, unchanged, holding the just-made
  `unrelated` commit fully intact and visible in `git log`.
- The store (`$STORE`) is completely untouched -- still just
  storev1/storev2.
- Stderr shows `git-localhost-store: ❌ ... Needs a human decision.`

## Why this needs its own test

`git commit` internally fires `post-index-change` (its index-refresh
step touches the same internal machinery `git add` uses), and it fires
**before** commit's own ref-transaction lands -- unlike `git clone`,
whose refs are already written before checkout/`post-index-change` fire
(see `reclone-after-workdir-deletion.md`'s "Why plain `git clone` can't
be made to never refuse"). Discovered empirically 2026-07-13 while
testing the quiescent-point hook redesign: letting `post-index-change`
run the store-exists recovery branch for a `git commit` produced `fatal:
cannot lock ref 'HEAD': reference already exists` from `git commit`
itself, and -- worse -- silently discarded the user's just-made commit to
a dangling, unreferenced object (recoverable only via `git fsck
--dangling`, not visible in `git log --all`). Confirmed the *identical*
setup invoked directly (no hook) or via `git clone` doesn't have this
problem -- only `git commit`'s in-flight ref-transaction races the swap.

The fix (`bin/git-localhost-store`'s `HOOK_NAME` check, see the
`post-index-change` comment at the top of the `[ -e "$STORE" ]` branch):
`post-index-change` never runs the recovery branch, regardless of
whether the case is compatible or divergent -- it always defers to
`post-commit`/`post-checkout`, which fire at true quiescent points. A
manual invocation (no hook, `HOOK_NAME` empty) proceeds normally, since
there's no enclosing git command to race.
