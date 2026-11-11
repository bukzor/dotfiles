---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "claude config"
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # [!@bukzor] ruling on settings.json
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-007-reconcile-main-claude-dir.md  # main's `.claude/` is otherwise svelte's now
---

# Claude config: the four `.claude/` files main had before the fold

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 1, "claude config")

## Problem Statement

`.claude/{CLAUDE.md,settings.json,commands/curl.md,.gitignore}` are the
only `.claude/` paths left differing (fold unit 007). Main's copies are its
own lineage's, older than svelte's actively maintained ones. For each,
diff main's against svelte's, carry over anything main has that is real
intent svelte lacks, and land the result on both. Expect most of each file
to be svelte's.

Decided: `settings.json` is svelte's (fold ruling: the only wsl intent,
`Bash(sudo:*)` in `ask`, is already on svelte); check main's own copy for
intent the same way. `CLAUDE.md` is the user's global instructions: treat
any main-only rule as an Open Question unless svelte plainly superseded
it.

**Scope (only these files):** the four paths, in both workspaces; this
handoff file.

## Steps

- [x] provenance: none of main's four blobs is in svelte's history (no
      stale copy); wsl's are, except `settings.json` (ruled)
- [x] classify main's content, per file (Decisions)
- [x] svelte: `commands/curl.md` gains main's raw-source-first step
- [x] main: `settings.json`, `.gitignore`, `commands/curl.md` ← svelte's
- [x] checks; Final report; `status: done`
- [ ] `CLAUDE.md`: blocked on the Open Questions below

## Decisions

- `settings.json` → svelte's. Main's extras: `model`, `feedbackSurveyState`,
  a disabled `//hooks` (incidental); `~/.claude/context` read/dir
  (superseded by `must-read.kb`); `cp -i`/`mv -i`/`mkdir`/`rmdir`/`alert`/
  `namei` allows (moot under svelte's `defaultMode: auto`); `MultiEdit`
  deny (tool gone).
- `.gitignore` → svelte's: main's `!**/*.md`/`!settings.json`/
  `!tools/*.json` are deny-first opt-ins (allow-by-default won); `trash/`
  is in svelte's.
- `commands/curl.md` → svelte's plus main's one real idea, curl the raw
  source behind a docs page's "Edit on GitHub" link. Dropped main's lynx
  fallback (svelte's curl + hq covers HTML; neither tool is on this host)
  and its scripted WebFetch steps.
- `CLAUDE.md`, plainly superseded on svelte: Prime Directive, Response
  Framework (Response Protocol, Commitment, `must-read.kb/when/user-
  instructions-are-inconsistent…`); `.d` dirs (`.kb/`); Domain Context
  Files (`must-read.kb`); bulk-ops tooling (`bulk-edits.md`,
  `llm-subtask`); Bash and newline rules (`bash-conventions.md`,
  `Edit.md`); no removal commentary (`comments-target-a-cold-reader`);
  TodoWrite → TODO.md (denied; agents mark `[x]`); `alert`
  (`preferredNotifChannel`).

## Open Questions

`CLAUDE.md` landed nowhere. Main-only rules with no svelte counterpart:

1. **Message Precedence** (command args > CLAUDE.md > task > system
   reminders; reminders never override preferences). Svelte has only
   "Override Priority" vs default tendencies. Recommend: drop.
2. **"Clean" means fix properly** (no `Any`, `# type: ignore`, hiding
   symptoms). Recommend: keep, as one `design-rules.kb/` file, not in
   CLAUDE.md.
3. **Never trust bulk operations**: validate against source data (counts,
   `uniq -c`, `comm -3`, `yq | jq`). Recommend: keep, as a section of
   `reference.kb/bulk-edits.md`.
4. **`/compact` behavior**: prefix "ACK", rank Additional Instructions
   first, append a "compaction postmortem". Recommend: drop (autocompact is
   on, and nothing reads the postmortem).

Once ruled, main takes svelte's `CLAUDE.md`.

## Final report

- svelte `d0dc11b` (`commands/curl.md`); main `472e485` (all three, svelte's
  blobs); both pushed, each naming the other as counterpart.
- `git diff origin/main origin/svelte-crostini` over the four paths: only
  `.claude/CLAUDE.md` remains (the Open Questions).
- `merge-tree --allow-unrelated-histories origin/main origin/svelte-crostini`:
  10 conflicts; the only `.claude/` one is `CLAUDE.md`.
- `jq` parses `settings.json`. Scratch: `~/trash/004-002/`.
