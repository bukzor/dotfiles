---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # Final report and Open Questions: the state you start from
---

# Main's live config calls files main doesn't have

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (fallout
from buck-win10's switch to main)

## Problem Statement

The user reports that every Claude Code session on buck-win10 now errors on
`/home/bukzor/.claude/hooks/session-rename.py`.

Cause: main took svelte-crostini's `.claude/settings.json` (unit 004/002).
Its `UserPromptSubmit` hook calls `.claude/hooks/session-rename.py`
(svelte `edc7ee2`), which exists only on svelte. Since 2026-11-18, `~`
runs main.

Fix that first, then sweep for the rest of this class. Main carries
svelte's copy of many config files, but 838 svelte-only paths never came
along (list: `~/trash/svelte-only.paths`). Find every reference from main's
live config to a path that is missing on this host. Check at least these:
- hooks and other paths in `settings.json`;
- `.tmux.conf` (unit 004/000 named `bin/cron-status` and
  `bin/tmux-rename-window`);
- shell startup;
- `.vimrc.d`;
- whatever the scripts you port call in turn.

Then fix each one:

- **Svelte has the file:** add svelte's file to main unchanged, same mode,
  one commit naming svelte-crostini as counterpart. A path only one side
  has merges cleanly in 006, so this decides nothing new.
- **Neither branch tracks it.** For example, the `SessionStart` hook
  `~/claude/mitmproxy/lib/claude_mitmproxy/binpatch.py` belongs to a
  checkout that exists on penguin and not here. Land nothing. Record it
  under Open Questions with your recommendation: a guard in the shared
  config, a host-local install, or something else.

After pushing main, run `git -C ~ pull --ff-only` (the one allowed action
in `~`). Then prove each fix live, for example by piping a sample hook
payload into the hook and getting exit 0.

GitHub over ssh fails on this host: main's `.ssh/config.d/github.sshconfig`
pins a key that is missing here. For your git commands, use
`GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes'`. Don't edit
ssh config; that is the user's call.

**Scope (only these):** the svelte-only paths you port, added on main in
`dotfiles--main`; `git pull` in `~`; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
