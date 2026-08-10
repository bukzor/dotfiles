# TODOs

Suggested order: hook redesign next, then cleanup — one commit each.

- [x] `todo.kb/2026-07-12-001-hook-redesign-quiescent-point-triggers.md`
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
- [ ] Reconcile the documented path encoding with the live one —
      `CLAUDE.md`'s "Path Encoding" and `docs/dev/testing.kb/path-encoding.md`
      still describe `-` → `--`, `/` → `-`, but the deployed `claude-path`
      has delegated to `claude-slug` (every non-alnum → one `-`) since
      ~2026-07-05, which orphans stores created before then. Evidence and
      the encoding decision itself:
      `~/.claude/sessions.kb/penguin/claude-path-encoding-change-orphans-stores.md`
- [ ] Renaming a workdir silently orphans its store name. `bin/git-localhost-store`
      exits at `[ -L .git ]` (line 41) before `$STORE` is ever compared to
      `readlink .git`, so after `mv` the symlink still points at the old
      encoded name and no run ever notices. Functionally harmless -- the
      absolute symlink stays valid -- but the store name becomes a lie, which
      is exactly what a path-encoded store is for. Hit live 2026-08-10
      renaming `~/claude/bukzor-packaging.kb` -> `bukzor-packaging`; fixed by
      hand (`mv` the store, re-`ln -s`). Options: report the mismatch and
      exit non-zero (matches "don't quietly accommodate unknown states"), or
      detect and re-point. Note a rename is indistinguishable from a *copy*
      until you look, so auto-repair could steal a live store.
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
