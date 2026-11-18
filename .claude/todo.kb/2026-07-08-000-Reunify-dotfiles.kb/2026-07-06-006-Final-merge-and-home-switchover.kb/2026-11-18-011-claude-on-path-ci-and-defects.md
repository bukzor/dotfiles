---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-010-buck-win10-post-merge-cleanup.md  # Open Questions 1-3
---

# `claude` on fresh shells' PATH; CI hang; small main defects

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments").
The branches have been merged since `ff853dc`. Commit on **main** in
`dotfiles--main` and push. The plan's kb on svelte-crostini is the one
exception: your handoff file still lives there.

1. **Urgent: `claude` is not found in a fresh login shell** (verified:
   `env -i HOME=$HOME bash -lc 'command -v claude'` fails). Running
   sessions use `~/.local/share/pnpm/claude`.
   - Find the mechanism penguin uses to get `claude`: read
     `.config/sh/env.d/claude.sh`, `900-path.sh`, the pnpm global manifest
     `.config/pnpm/global/package.json`, and `d1b633a`'s "route claude
     through the proxy".
   - Make this host match it. If that mechanism means a manifest entry,
     add it. If it means a host install, do it. If nothing on main covers
     it, use Anthropic's native installer into `~/.local/bin`.
   - Don't disturb the running sessions' binary.
   - Prove it: `env -i HOME=$HOME bash -lc 'claude --version'` works, and
     the same under `zsh -l`.
2. **CI starvation.** Every Check sh run since 11-11 hangs until the
   6-hour default timeout.
   - Add `timeout-minutes` (5) to the Check workflows' jobs.
   - Find the hanging test: run the matrix locally under `timeout`, or
     read a run's last log lines. Fix it if the cause is clear; otherwise
     record it.
   - Then cancel the stale queued and in-progress Check runs with
     `gh run cancel` (they are rerunnable).
   - Report the first full run after the fix.
3. **`.config/sh/rc.d/upstream-replies.sh`** prints "command not found"
   when its tool is absent, contrary to its own comment. Make it silent in
   that case.
4. **`docs/ideas/never?`:** that name can't exist on NTFS, so the Windows
   checkout shows it as deleted. Rename it to a portable name and update
   any links to it.
5. **`init.templateDir`** names a directory that this host's
   git-localhost-store install provides, but the Windows home lacks it.
   Fix it the cheapest correct way: a guard, a conditional include, or
   installing it there too. Explain why.

Afterwards: `git -C ~ pull --ff-only` and `git -C /mnt/c/Users/worki pull
--ff-only` (WSL git for the latter, as unit 010 did).

**Scope (only these):** the files each item names, on main; host
installs for item 1; `gh run cancel`; the two pulls; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
