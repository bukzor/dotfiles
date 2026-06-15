---
cwd: /home/bukzor
session:
  started: null
  ended: null
---
# Settle sessions.kb conventions (planned)

Several conventions surfaced during the must-read.kb rollout but
weren't decided. They affect how every future session is captured.

## Open questions

### 1. When does `session.ended` transition from null to a timestamp?

- Schema says null means "still in flight or end was not recorded."
- `skeleton-default.md` leaves `ended: null` even after its `/session-end`.
- `rename-must-read-d-to-must-read-kb.md` (this rollout's entry)
  also kept null.
- `/session-end` command doesn't say to set it.
- Options:
  - At /session-end, set to `date -Is`. Honest but locks in the
    end-of-conversation moment, which may not equal end of session.
  - Leave null until manual cleanup. Conservative but the field never
    transitions in practice.
  - Set at /session-end only when the user confirms "really done."

### 2. Task.md untracked-by-convention rule

- Observed at `~/.claude/`:
  `CLAUDE.rename-must-read-d-to-must-read-kb.Task.md`,
  `CLAUDE.Task.restructure-must-read-dirs.md`,
  `CLAUDE.Task.extract-sessions-kb-to-private-repo.md`
  are all untracked.
- No documented rule says they should be untracked. Inferred from
  precedent only.
- Decision: codify (where? sessions.kb/CLAUDE.md? .gitignore?), or
  flip to tracked.

### 3. Task.md vs sessions.kb entry relationship

- session-start.md prefers exact slug-match when a Task.md exists.
- Two of three existing Task.md files use one prefix convention
  (`CLAUDE.Task.<slug>.md`); one uses another (`CLAUDE.<slug>.Task.md`).
- Pick one. Rename the outlier.

### 4. Forward-looking (speculative)

User noted: "in practice, less than half of sessions may have a
taskfile. And it's possible the session files entirely supersede the
taskfile concept in future." If pursued, the Task.md → sessions.kb
relationship inverts.

## Delete When

Each of #1–#3 decided and documented in sessions.kb/CLAUDE.md
(or elsewhere). #4 either pursued or rejected.
