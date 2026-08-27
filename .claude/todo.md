---
managed-by: Skill(llm-subtask)
cost-benefit-sweh:
  timebox:
    "@value": 1.5
    rationale: |
      File-level estimate for a 9-item rollup, but mostly the versioned
      ~/.terminfo build dominates. Other items are pointers to issues
      handled elsewhere.
  benefit-2w:
    "@value": 0.5
    rationale: |
      Personal infra; terminfo doesn't change often. Modest payoff
      mostly preventing future-me from re-deriving the build.
---

Scope: `~` generally. For `~/.claude` scope, see `~/.claude/.claude/todo.md`.

- [ ] `claude_code_archeology.session.Session.tips()` counts attachment
      records as tips (671 of them on one real session file, vs ~7 real
      conversation branches) — should filter to user/assistant, matching
      `tip_of()`'s approach; also `claude-branch-list --branches-only`
      doesn't print each branch's tip uuid, which is exactly what
      `claude-branch-extract` needs as input — found while rebuilding
      branch_extract.py 2026-07-24
- [ ] `claude-search` reports a JSONL line number but nothing in
      `claude-code-archeology` renders the records *around* one — reading a
      hit's context means writing a throwaway parser every time (did it again
      2026-08-21; that copy is `~/.claude/trash/peek.py`). Add a range view:
      `claude-jsonl-peek FILE --range LO HI`, or `--around N` on
      `claude-jsonl-display`.
- [ ] Verify (or drop) the belief that an older Claude Code version had a
      rewind/resume picker capable of switching among sibling branches of
      a branched chat — user recalls this from ~a year ago; 2.1.219's
      picker cannot (confirmed via binary inspection, `MessageSelector` in
      `docs/dev/devlog/2026-07-24-000-Claude-Code-branch-recovery--extract-by-leaf--not-by-carve.md`)
      but older builds weren't inspected — would need an old release
      tarball/changelog to check
- [ ] Add a `/must-read` command for llm-kb's `skill.kb/must-read.kb/` (must-read-kb-skill.md's other follow-up; the `skill.kb/must-read.kb/` dir itself already exists) — deferred
- [ ] Finish yaml-date-jsonschema's remaining follow-ups in `bukzor-agent-skills/llm-kb`: `finish-debolding-cleanup` (still ~40 bold instances across 8 files beyond `references/pattern-guide.md`, which is now fixed — not actually done despite earlier belief), `auto-migrate-scripts-for-kb-dirs`, `schema-migrate-string-pattern-to-date`
- [ ] Resolve `todo.kb/2026-06-03-001-commit-accumulated-dotfiles-changes.md`'s D6 held-review items: `bin/CLAUDE.md` (deleted uncommitted by another session — restore or finish rename?), `claudesh`/`finder.sh`/`scratch/python/`/`empty/` triage, `.envrc`/`profile.env` review, `.claude/claude-alignment-2026-04-29.{jsonschema.yaml,kb/}` commit-or-trash — NOTE: `bin/colortest17x17*` and `.zsh_profile` (formerly listed here too) are resolved: colortest17x17 merged clean in reunify task 004 (2026-07-13, no stray variant found), `.zsh_profile` deleted on both branches by reunify task 005 (2026-07-12, dead debug artifact)
- [ ] [todo.kb/2026-07-08-000-Reunify-dotfiles.md](todo.kb/2026-07-08-000-Reunify-dotfiles.md) — converge svelte-crostini ↔ main to identical content, merge, live on main
- [ ] [todo.kb/2026-06-03-001-commit-accumulated-dotfiles-changes.md](todo.kb/2026-06-03-001-commit-accumulated-dotfiles-changes.md) — overlaps reunify 006's "commit/park uncommitted state" step; fold in or close when 006 runs
- [ ] Build versioned `~/.terminfo` into the dotfiles repo
  - [ ] Decide repo layout (track `.tinfo` source vs. compiled `~/.terminfo/t/*` blob; symlink vs. deploy step)
  - [ ] Pin `tmux.tinfo` from upstream `tmux/tmux` at the tag matching brewed tmux (currently 3.5a)
  - [ ] `tic -xs tmux.tinfo` → `~/.terminfo/`
  - [ ] Wire deploy for new machines (Brewfile postinstall, `bin/` install script, or similar)
  - [ ] Document the upgrade flow: bump brew tmux → bump tag → re-fetch + re-`tic`
  - [ ] Verify: `infocmp tmux-256color` resolves to the `~/.terminfo` copy
  - Goal: pin terminfo to the tmux binary version so brewed-tmux + distro-ncurses can't drift.
- [ ] [todo.kb/2026-07-26-000-Evaluate-sub--patch-upstream--hard-fork--or-write-my-own.md](todo.kb/2026-07-26-000-Evaluate-sub--patch-upstream--hard-fork--or-write-my-own.md) — dogfood via chatfs, file the `--help` wart upstream, decide from the patch queue
- [ ] Restore `.sh_lib/functions-cli.sh` — tracked on `main` and
      `origin/main`, absent on `svelte-crostini`, which leaves `~/bin/has`
      and `~/bin/bootstamp` dangling (found 2026-08-10). Belongs to
      [todo.kb/2026-07-08-000-Reunify-dotfiles.md](todo.kb/2026-07-08-000-Reunify-dotfiles.md).
- [ ] Delete `~/trash/git-localhost-store-dotfiles-copy/` (6.7M) once the
      packaged `git-localhost-store` has run a while without regret. It is
      the retired dotfiles copy of the tool plus untracked May-2026 migration
      artifacts, kept only for recovery; the installed system was verified
      before it was moved aside (2026-08-10).
- [ ] Remove `HOMEBREW_EVAL_ALL=1` from shell config — new brew treats it as a fatal
      deprecation in `brew tap`; per-tap `brew trust` replaces it (found 2026-07-26
      while fixing the sub install)

- [ ] Delete `~/trash/pnpm-global-5-retired/` (820M) and `~/trash/pnpm-stubs/`
      once corepack-provided pnpm has run a few days without regret. The dir
      is pnpm 10's global root; the stubs are the four bin shims that pointed
      into it. Both were verified replaced before being moved aside
      (2026-08-27).
- [ ] Remove `~/prefix/npm/` — an empty scaffold (`lib/.gitkeep`) for a prefix
      nothing reads: `.npmrc` was deleted 2026-08-27 (pnpm 11 reads `.npmrc`
      for auth/registry only) and `npm` here is a shim to pnpm.
- [ ] `.config/sh/functions.sh` still sources `functions.d/*.sh` with a bare
      loop that reports nothing when a file fails. `source_dir` got that
      treatment 2026-08-27; this loop can't use `warn` because `warn.sh`
      loads last. Rename it `00-warn.sh`, or inline an `echo >&2`.
- [ ] corepack's `pnpm`/`pnpx` shims are symlinks into
      `~/.volta/tools/image/node/<version>/`, so a `volta install node` strands
      them and only `cron-health_check.sh` would notice, a day later. Consider
      re-running `corepack enable pnpm --install-directory ~/prefix/pnpm/bin`
      from `bin/pnpm-upgrade-g` when the shim is broken.

## Later

We haven't (yet) decided where to place these in the task queue.
Please read and consider slotting them.

- [ ] [todo.kb/2026-06-27-000-hoist-polyglot-monorepo-architecture-convention--values-to-personal-global-scope.md](todo.kb/2026-06-27-000-hoist-polyglot-monorepo-architecture-convention--values-to-personal-global-scope.md) — may belong under `private.bukzor-llc`
