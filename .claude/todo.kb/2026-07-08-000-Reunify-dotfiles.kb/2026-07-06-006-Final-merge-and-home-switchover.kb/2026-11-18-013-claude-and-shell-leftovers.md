---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-011-claude-on-path-ci-and-defects.md  # Decisions (.claude/local), Open Question 2
  - ./2026-11-18-010-buck-win10-post-merge-cleanup.md  # Open Question 4 (Windows prefs)
  - ../2026-07-06-005-Port-zsh-config-into-config-sh-structure.md  # Follow-up: bin/gcpenv
---

# Leftovers: `.claude/local`, the npm-global `claude`, Windows prefs, `gcpenv`

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

User, 2026-11-18: "please do known improvements, followup (the ones you can)
now". Commit on **main** in `dotfiles--main` and push; this handoff file
lives on svelte-crostini.

1. **`.claude/local`** is a tracked dangling link from the 2025 npm "local
   install" (`0acda47`). The native installer treats it as an old install
   and deletes it. Remove it from main. Grep the repo for anything else from
   that era (`.local/share/claude-code`) and remove that too if dead.
2. **`~/prefix/npm-global/bin/claude`:** no session runs it (live sessions
   run `~/.local/share/pnpm/claude`; check with `ps`/`/proc/*/exe`
   first). Move it, and its package, to `~/trash/merge-013/`. Leave the
   pnpm copy alone: running sessions use it.
3. **Windows prefs:** `/mnt/c/Users/worki/.claude/settings.json` carries
   `theme` and `tui: fullscreen` as uncommitted edits to a tracked file.
   Find, in Claude Code's docs, a host-local place for them that the repo
   doesn't track (for example `~/.claude.json` via `/config`, or a
   local settings file). Cite the docs. Move them there, so `git status`
   on the Windows home no longer shows `settings.json`. If no host-local
   home exists, record that under Open Questions and leave the file as is.
4. **`bin/gcpenv`:** check whether it works on main now that `.sh_lib/`
   came back with the merge. Fix it only if it is broken and the fix is
   small. Retiring `.sh_lib/` is out of scope.

Afterwards: `git -C ~ pull --ff-only` and `git -C /mnt/c/Users/worki pull
--ff-only` (WSL git, as unit 010 did).

**Scope (only these):** `.claude/local` and dead claude-code-era paths on
main; `~/prefix/npm-global/`; the Windows home's `.claude/settings.json`
and the host-local file the prefs move to; `bin/gcpenv`; the two pulls;
this handoff file. Not the root `.gitignore` (unit 015 owns it).

## Steps

- [x] 1 `.claude/local` removed on main (`7479348` local, pushed as `c8b3fa7`); no other `.local/share/claude-code` reference (grep). `.local/share/claude-bin` is the osx sed/pgrep shim dir, not that era: kept.
- [x] 2 npm-global `claude` + `@anthropic-ai` moved to `~/trash/merge-013/` (no live process ran it; 5 ran the pnpm 2.1.316 copy)
- [x] 3 Windows prefs moved to `.claude/settings.local.json`; `settings.json` restored
- [x] 4 `bin/gcpenv` checked
- [x] 5 pulls: `~` and `/mnt/c/Users/worki` fast-forwarded to `c8b3fa7`

## Decisions

- 3: docs (code.claude.com/docs/en/settings-reference.md, `theme` and `tui`
  entries) give both keys scope `Any file`; `~/.claude.json` is read for
  `theme` only as an old-version fallback and not for `tui`. So the host-local
  home is `.claude/settings.local.json` (settings.md, "Settings files": Project
  local; already gitignored by `**/.claude/settings.local.json`). In the
  Windows home the project root is `~`, so it applies to sessions started in
  the home repo, not elsewhere. Backups in `~/trash/merge-013/`.
- 4: `bin/gcpenv` works on main (`--help` ok; no-arg path reaches `gcloud`,
  absent here). No fix.
- Push: dotfiles--main had a sibling's unstaged edit, so `pull --rebase`
  refused; cherry-picked my commit onto `origin/main` in a temp worktree and
  pushed. Local `main` in `dotfiles--main` still holds `7479348` (same
  patch); its next rebase drops it.

## Open Questions

1. `.claude/local` on the pnpm install: running sessions (2.1.316) stay on
   pnpm; retiring it (Unit 011 OQ 2) waits until those end.

## Final report

Done as above. Commits on main: `c8b3fa7`. No tracked file changed in the
Windows home (settings.json clean; local file is ignored). `gcpenv`
unchanged. Not checked: gcpenv against a real gcloud.
