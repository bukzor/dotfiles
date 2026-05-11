# TODOs

See `todo.d/` for detailed context. Abandoned items live under
`todo.d/abandoned/` with closing notes.

## Active

(none — see Latent below)

## Latent — act on first symptom

Items with a known *trigger condition*. Don't pre-do them; pay the
cost when (and only when) the trigger fires. Each has a documented
recipe so the on-pain response is quick.

- **TRIGGER:** next `migrate-from-gitfile` run on a submodule-bearing
  legacy repo (post-migration `git status` will fail with
  `cannot chdir to '../../../...'` at every submodule).
  **RECIPE:** devlog `2026-05-08-000` — survey `<store>/modules/`,
  rewrite each submodule's `core.worktree` to an absolute path via
  `realpath --no-symlinks <logical-gitdir>/<relative-worktree>`.
  **CODIFY:** fold the rewrite into `migrate.py` after the *next*
  occurrence — second-time pain justifies generalization.

- **TRIGGER:** any future case of "workdir loses `.git` while its
  store remains" (symptom: `git status` reports "not a git
  repository" in a directory you know was tracked).
  **RECIPE:** devlog `2026-05-11-000` addendum — recreate the
  gitfile (`printf 'gitdir: %s\n' "$WT_DIR" > "$WD/.git"`), resolve
  any promote-collisions in `<store>/`, run `migrate-from-gitfile`.
  **CODIFY:** extend `bin/audit-gitfiles` to walk `<repos>/`, decode
  each store's encoded name, flag those whose decoded workdir-path
  exists but lacks `.git`. Reference script:
  `trash/2026-05-11-migration/audit-classify.sh` (gitignored).

- **TRIGGER:** moving home directory, changing username, or copying
  the dotfiles to a different user/host (symptom: every home
  submodule breaks at once with `cannot chdir` errors).
  **RECIPE:** re-run the absolute-path rewrite from devlog
  `2026-05-08-000` with the new prefix. Scriptable.

## Completed

- [x] Migrate `~/` to symlink layout (devlogs 2026-04-30-000,
  2026-05-08-000) — `~/.git` is a symlink → `<store>`; submodules
  resolve correctly.
- [x] Improve `migrate-from-gitfile` to handle in-place migration
  and ephemeral worktree state (devlog 2026-05-08-001).
- [x] Drain Stage-3 legacy-gitfile candidates (devlog
  2026-05-11-000): all migrated, including the hidden
  `claude-plugins-official` case discovered post-audit.
- [x] Wider audit + cleanup (devlog 2026-05-11-000 addendum):
  removed bogus mason/uv `.git` stubs; trashed 2 redundant orphan
  stores.

## Abandoned

- `todo.d/abandoned/2026-05-05-000-audit-and-sweep-stale-hooks.md` —
  stale `git-restore-repo` hook references in 955 stores. Audit
  proved zero live-exposure; pure hygiene.
- `todo.d/abandoned/2025-11-21-001-guardrails-ambiguous-references.md`
  — communication-pattern guardrails. 6 months of non-recurrence;
  in-session correction loop sufficient.
