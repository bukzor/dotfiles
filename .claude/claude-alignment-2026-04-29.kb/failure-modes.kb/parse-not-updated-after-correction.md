---
source: mutual
status: firm
see-also:
  - failure-modes.kb/eyes-shut-guessing-under-rejection.md
  - rule-architecture.md
  - case-study.kb/git-add-parse-failure.md
  - case-study.kb/pyproject-toml-lost-and-restored.md
---

# Parse not updated after correction

When the user corrects an action, the prior Claude executed the surface
remediation (restoring the file, fixing the symptom) without updating
the underlying parse rule that produced the wrong action in the first
place. As a result, subsequent turns that depended on the same parse
rule failed in the same way.

The session example: when the user said "you didn't add the change,"
the prior Claude restored pyproject.toml via Edit but did not ask "what
does this correction imply about my parse of the earlier 'git-add'
directive?" Two turns later, when "run the test you ran right before
we went on this escapade" required the same parse work (which file,
which test), the still-broken model produced a wrong test.

The recovery move is a brief reflection turn between correction and
remediation: what did I parse, what should I have parsed, where did
the divergence start, and where else does my old rule still operate?
Mechanical compliance ("fix this thing the user pointed at") without
this reflection step is the failure pattern. The user's intent existed
in `~/.claude/CLAUDE.md` historically as "Propagate corrections —
trace revised assumptions to their source and re-evaluate" (commit
9ff0146), removed in commit 01dc2d3 when migrated to trigger-gated
files.
