---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-002-commands-agents-are-told-to-run.md  # Open Questions 4-5
---

# `claude-tokens-cost` prices for current models; main's stray `breakdown.md`

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. `bin/claude-tokens-cost` (both branches) has no `PRICES` entry for
   `claude-opus-5-5`, so it fails on today's corpus. Add entries for every
   current Claude model, in its existing format. Take the prices from
   Anthropic's published pricing (load `Skill(claude-api)`, or fetch the
   pricing page); never from memory. Cite the source in the commit message.
   If unknown models should warn rather than fail, make that change too.
   Land it byte-identical on both branches. Show the cost of a real
   transcript containing opus-5-5 rows.
2. `.claude/commands/breakdown.md` exists only on main, and its frontmatter
   is invalid YAML. Svelte deleted it. Check svelte's history to see whether
   it was renamed or superseded (for example by a `breakdown` skill). If so,
   delete it on main. If it was dropped with no replacement, record that
   under Open Questions, and fix only its frontmatter.

Then `git -C ~ pull --ff-only`. Use unit 001's ssh workaround if plain ssh
still fails.

**Scope (only these files):** `bin/claude-tokens-cost` in both workspaces;
`.claude/commands/breakdown.md` on main; `git pull` in `~`; this handoff
file.

## Steps

## Decisions

## Open Questions

## Final report
