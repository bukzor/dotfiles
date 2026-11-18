---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-001-config-references-missing-on-main.md  # Open Question 1
---

# `settings.json`: skip the mitmproxy hook where it's absent, and warn visibly

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

> [!@bukzor] 2026-11-18: skip it *and visibly warn*.

The `SessionStart` hook in `.claude/settings.json` runs
`"$HOME"/claude/mitmproxy/lib/claude_mitmproxy/binpatch.py`. That is a
checkout that exists on penguin and not here, so the hook exits 127.
Where the script exists, run it as now. Where it doesn't, exit 0 and show
the user a one-line warning naming the missing path. Use Claude Code's
hook output contract for a user-visible message (look it up; don't guess),
not just stderr.

Land the change byte-identical on both branches. Then `git -C ~ pull
--ff-only`, and prove both cases by running the hook command by hand: once
with the path absent (exit 0, warning JSON) and once with a stub script on
a temporary `HOME` (the stub runs). Check `jq . settings.json`.

Same ssh workaround as unit 001.

**Scope (only these files):** `.claude/settings.json` in both workspaces;
`git pull` in `~`; this handoff file.

## Steps

- [x] look up the hook output contract
- [x] guard the hook in `settings.json`; commit and push on main and svelte
- [x] `git -C ~ pull --ff-only`; prove absent and present cases; `jq .`

## Decisions

- Warning channel: top-level `systemMessage` ("Warning message shown to the
  user"; SessionStart does not discard it), per
  <https://code.claude.com/docs/en/hooks.md> § JSON output, fetched
  2026-11-18. Not stderr, not `additionalContext` (that goes to Claude).
- `exec` the script when present, so its stdin, stdout and exit code pass
  through unchanged.
- Test `-e`, not `-x`: a present but non-executable script still fails
  loudly (126) instead of being skipped as if absent.
- The path is interpolated into the JSON unescaped; a `"` or `\` in `$HOME`
  would break it. Not worth the extra code.

## Open Questions

## Final report

- main `4df8d7d`, svelte-crostini `cff69b9`: the guarded hook command.
  `git diff origin/main origin/svelte-crostini -- .claude/settings.json`
  is empty; `jq .` parses both.
- `~` fast-forwarded `b422b1b..4df8d7d`.
- Live proofs, command extracted with `jq` from `~/.claude/settings.json`:
  - absent (real `HOME`): exit 0, stdout
    `{"systemMessage": "mitmproxy binpatch skipped: /home/bukzor/claude/mitmproxy/lib/claude_mitmproxy/binpatch.py not found"}`,
    which `jq` parses.
  - present (stub on `HOME=~/trash/003/stubhome`): the stub ran, got the
    hook payload on stdin, exit 0.
- Not checked: a real Claude Code session start rendering the warning.
