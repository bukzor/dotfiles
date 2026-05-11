# Audit and Sweep Stale Hooks

**Priority:** Medium
**Complexity:** Low
**Context:** docs/dev/devlog/2026-05-05-000-rename-script-to-git-localhost-store.md

## Problem

When `bin/git-restore-repo` was renamed to `bin/git-localhost-store`,
already-migrated stores under `~/.local/state/git-localhost-store/repos/`
kept the old absolute path baked into their per-store
`hooks/{post-index-change,pre-commit,reference-transaction}` files. Hooks
short-circuit when `.git` is already a symlink, so this is dormant in
normal operation — but a recovery scenario (`rm -rf workdir; git init`
in a directory whose store still exists) will fire a hook that invokes
the old, no-longer-existent path and fail loudly.

## Scope

For each per-repo store dir:

```
~/.local/state/git-localhost-store/repos/<encoded>/
└── hooks/
    ├── post-index-change       # invokes .../bin/git-restore-repo
    ├── pre-commit              # invokes .../bin/git-restore-repo
    └── reference-transaction   # invokes .../bin/git-restore-repo
```

Rewrite the path to `.../bin/git-localhost-store` (or just re-copy from
the current `template-repo/hooks/`).

## Approach

Single-pass shell sweep:

```bash
TEMPLATE="$HOME/.local/share/git-localhost-store/template-repo/hooks"
for store in "$HOME/.local/state/git-localhost-store/repos"/*/; do
    cp -p "$TEMPLATE"/* "$store/hooks/"
done
```

Or a more conservative `sed -i 's|bin/git-restore-repo|bin/git-localhost-store|g'`
that only touches the path line.

The conservative variant is safer if any per-store hook has been
hand-customized — though there's no reason it would have been.

## Detection

`grep -l git-restore-repo ~/.local/state/git-localhost-store/repos/*/hooks/*`
lists stores still on the old path. Empty output → done.

## Decision

**Deferred.** The lazy/auto-fix-on-fire posture (per session 2026-05-05)
accepts that a stale hook will fail loudly when invoked, prompting a
manual fix at that moment. This TODO captures the proactive cleanup as a
batch operation for a future session.

## Abandonment (2026-05-11)

Closing. The 2026-05-11 audit (devlog 2026-05-11-000 addendum) verified
the worry-scenario isn't reachable in current state:

- 955 of 976 stores carry the stale `git-restore-repo` reference.
- Of those, 14 have a live workdir pointing back; all 14 have `.git`
  as a symlink. Their hooks short-circuit at the first line
  (`if [ -L .git ]; then exit 0; fi`) — the stale path is never read.
- The original concern ("`rm -rf workdir; git init` in a dir whose
  store still exists, hook fires, fails") doesn't fire the *stored*
  stale hooks. Fresh `git init` installs hooks from
  `init.templateDir` (the global template, which now references
  the new `git-localhost-store` name), not from the pre-existing
  store-side hooks.
- The only paths that read a stored hook directly require the workdir
  to *regress* to a non-symlink state (legacy gitfile layout — count 0,
  or someone manually invoking a hook from the store dir).

Pure hygiene. Nothing breaks if it's never done. If a real failure
ever surfaces, reopen and run the sweep; recipe is preserved above.
