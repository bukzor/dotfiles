---
cwd: /home/bukzor
session:
  started: null
  ended: null
---
# Extract sessions.kb to private repo (planned)

Move `~/.claude/sessions.kb/` out of the dotfiles repo into a private
GitHub repo (`bukzor/claude-sessions`), cloned directly at the path.
Dotfiles gitignores the path. Isolates the high-churn working journal
from the dotfiles log/blame.

Procedure: `~/.claude/CLAUDE.Task.extract-sessions-kb-to-private-repo.md`.

## Pre-flight decisions for the user

(Captured in the Task.md.)

1. Repo name: `bukzor/claude-sessions` (private)?
2. Preserve history via `git filter-repo`, or fresh start?
3. Per-host subdir layout (`sessions.kb/<hostname>/<entry>.md`)?

## Risks

- Secrets in history; run `gitleaks detect` before pushing.
- Dotfiles history retains the pre-extraction sessions.kb commits
  (not rewriting).

## Delete When

Extraction landed, all hosts wired up, Task.md absorbed into the new
repo's README. Or when the plan is abandoned.
