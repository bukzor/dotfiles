# TODOs

Suggested order: hook redesign next, then cleanup — one commit each.

- [ ] `todo.kb/2026-07-12-001-hook-redesign-quiescent-point-triggers.md`
      — replace mid-operation `reference-transaction` with
      post-commit/post-checkout; env re-entrancy guard replaces the
      hooks-aside dance; hooks become symlinks to one shared body
- [ ] Root-file/doc cleanup (independent of the two above)
  - [ ] Delete `test-reference-transaction` and `test-empty-commit` —
        superseded by `docs/dev/testing.kb/`; `test-empty-commit`'s
        header still claims a "KNOWN FAILURE" fixed 2025-12-18
  - [ ] Fold TESTING.md's residual value (prereqs, troubleshooting,
        cleanup) into README or `testing.kb/CLAUDE.md`; delete TESTING.md
  - [ ] Delete `lib/init` — its mkdir is redundant (the relocator does it
        every run) and it doesn't set `init.templateDir`; install is one
        `git config` line in README
  - [ ] Fix `docs/adr/README.md` stale boilerplate ("None yet. Create
        your first ADR!")
- [ ] Decide the fate of `CLAUDE.md`'s "Related Files" section — it's a
      content enumeration (`**bin/x** — description`, one line per
      file), the exact pattern the project's own "Don't enumerate
      directory contents in docs" rule warns against. Pre-existing, not
      urgent. Keep it as-is, restructure as a rule-shaped section, or
      drop it.
- [ ] Check whether `docs/dev/testing.kb/recovery-after-deletion.md`
      still pulls its weight next to the rewritten
      `reclone-after-workdir-deletion.md` (2026-07-11) — names are close
      enough to invite confusion. (2026-07-12 read-through: they cover
      distinct entry points — explicit adopt of a ref-less `.git` vs.
      clone-with-refs merge — so likely keep both, maybe rename.)

See `ideas.md` for speculative items; `todo.kb/abandoned/` for
closed analyses.
