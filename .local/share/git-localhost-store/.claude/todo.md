# TODOs

See `todo.d/` for detailed context. Speculative items live in
`ideas.md` (their triggers may never fire). Abandoned items live under
`todo.d/abandoned/` with closing notes.

## Active

(none)

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
