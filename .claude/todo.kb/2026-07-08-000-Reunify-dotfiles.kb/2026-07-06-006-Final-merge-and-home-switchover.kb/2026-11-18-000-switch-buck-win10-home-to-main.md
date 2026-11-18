---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []  # main's .claude/CLAUDE.md is svelte's since 6bfc6f4
required-reading:
  - ./CLAUDE.md
  - ../CLAUDE.md  # the merged/ branch ruling, topology
  - ../2026-07-06-006-Final-merge-and-home-switchover.md  # per-host steps, smoke test, rollback
---

# buck-win10: switch live `~` to main, retire `wsl-buck-win10`

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (the
buck-win10 rows of its per-host steps, brought ahead of the merge)

## Problem Statement

> [!@bukzor] 2026-11-18: rename `wsl-buck-win10` to `merged/wsl-buck-win10`,
> locally and on origin, and swap `~` to main as soon as possible.

`wsl-buck-win10` is fully contained in main. Its tip `fa3f7c7` is an ancestor
of `origin/main`. Main is not yet merged with svelte-crostini; that doesn't
block this host.

1. **Preflight, before touching `~`:**
   - Record the pre-switch commit.
   - List the paths that `origin/main` tracks and `HEAD` does not, but that
     already exist in `~` (they are ignored under the old branch's
     deny-first scheme). Checkout silently overwrites ignored files. Copy
     every one whose content differs into
     `~/trash/switch-to-main/clobbered/`, and list them.
   - List the paths that checkout will delete: tracked on `HEAD`, absent
     from `origin/main`.
   - Leave `.claude/sessions.kb`'s modified gitlink alone. It is lazily
     bumped.
   - Peer Claude sessions sit idle in `~`. Don't wait for them.
2. **Switch:** create a local `main` tracking `origin/main` and check it
   out in `~`.
3. **Rename:** rename the local `wsl-buck-win10` to `merged/wsl-buck-win10`.
   On origin, create `merged/wsl-buck-win10` at the same commit and delete
   `wsl-buck-win10`. Set the renamed branch's upstream to the renamed
   remote branch. Run `git fetch --prune` in every other clone of this repo
   on this host.
4. **Review:** report `git -C ~ status`. Main uses allow-by-default
   ignores, so expect new untracked files: report them grouped by
   top-level directory, with proposed ignore entries. **Edit no ignore file**.
   Ignore files must land byte-identical on both branches, so that is a
   later unit.
5. **Smoke test** (006's list): new login shell, `bash -i`, `zsh -i`,
   headless vim startup, tmux on a scratch socket (`-L`), `~/bin/has`,
   `~/bin/bootstamp`, `jq` on `~/.claude/settings.json`. Also check that
   `/etc/service` → `~/.config/runit/buck-win10/` still resolves, and that
   `findmnt ~/.config/windows` still shows the mount.

Rollback, if a smoke test breaks something you can't fix inside this scope:
`git -C ~ switch merged/wsl-buck-win10`. Then report.

**Scope (only these):** `~`'s checkout, branch refs locally and on origin,
`~/trash/switch-to-main/`, this handoff file. No edits to tracked content.

## Steps

## Decisions

## Open Questions

## Final report
