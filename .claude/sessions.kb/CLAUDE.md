--- # workaround: anthropics/claude-code#13003
requires:
  - Skill(llm-kb)
---

# Sessions Collection

The user runs many parallel sessions across cwds, repos, and skills;
this collection indexes the ones worth tracking.

## What Belongs

- A planned session that has not been started yet (no `session.uuid`)
- An in-flight session worth referencing across other contexts
- A recently completed session whose follow-ups are still live

## What Does Not Belong

- Per-task todos -- those go in the project's own `.claude/todo.kb/`
- Per-session devlogs -- those belong with the project (Skill(llm-collab))
- Concept definitions, principles, etc. -- those go in their respective
  skill kbs

## When to Add

Add an entry the moment a future line of work is identified -- end of a
session that surfaced follow-ups, mid-conversation when a tangent is
recognized as its own scope, or whenever the user notes "that's another
session." Capture is cheap; the value is in not losing track.

## When to Read

Read at session start to recover the user's open lines of work, or when
deciding whether the current task is already tracked elsewhere.

## Open Work: `- [ ]` Is Load-Bearing

A session entry's open work surfaces in `claude-open-tasks-list` only
when its lines use `- [ ]`. Bare `-` bullets are **invisible** to the
inventory and silently lost — they will not be rated, will not appear in
`task-list.md`, will not compete for prioritization. See
`Skill(llm-subtask)` for the full rule; the short version: any
task-shaped line uses `- [ ]`, anything else is prose.

## File Naming

kebab-case, descriptive enough that the user can guess the session's
purpose from the filename. Do not number -- sessions are not ordered.

## Where Files Live

Session files live directly here, in `~/.claude/sessions.kb/`. This is
the canonical location regardless of which project the session relates
to. A single global index avoids fragmenting sessions across repos and
makes "what am I working on?" a one-directory question.

See the appendix below for an optional in-repo + symlink scheme.

## Lifecycle

When a session is finished and its follow-ups are absorbed elsewhere
(or it is no longer worth tracking), delete the file. The collection
is a working index, not an archive.

## Appendix: in-repo canonical with symlink (optional)

A session may instead be co-located with a project's own source when
that suits the work — e.g., session notes that are usefully versioned
alongside project history, or that track follow-ups tightly coupled to
project-internal artifacts. In that case:

- canonical: `<project>/.claude/sessions.kb/<slug>.md`
- absolute-path symlink: `~/.claude/sessions.kb/<slug>.md` → canonical

This is an optional scheme. The default (direct-in-global) is simpler
and should be preferred unless there's a specific reason to co-locate.
