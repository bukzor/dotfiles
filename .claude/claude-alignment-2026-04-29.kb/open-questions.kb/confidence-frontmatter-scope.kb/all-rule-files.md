---
source: agent
status: exploratory
see-also:
  - all-future-kbs.md
  - rule-architecture.md
---

# Candidate: universal across all rule files

Apply `source`/`status`/`see-also` (or analogues) to all files
Claude reads as instructions: `~/.claude/CLAUDE.md`, project
CLAUDE.md, `must-read.d/` entries, and skill SKILL.md files, in
addition to all kbs. This treats the convention as a Claude-wide
metadata schema for any normative content.

The fit is maximal: every claim or rule the prior Claude reads has
explicit confidence and origin metadata. A future Claude reading
any normative file knows immediately whether they're looking at a
firm rule, a tentative practice, or an exploratory direction; and
whether the source is the user, the model, or shared.

The cost is high. Many existing rule files use a prose voice that
doesn't fit a frontmatter wrapper — CLAUDE.md is written as
imperative posture, not as claims with provenance. Adding
frontmatter would either force a structural rewrite of those files
or create awkward bolt-on metadata. Skill SKILL.md files have a
frontmatter convention already (name/description/depends) that
would need to be reconciled.

Specifically, this candidate touches files outside the alignment
work proper, so it expands the scope of any decision substantially.
The user explicitly invited a rethink of the trigger mechanism for
must-read.d (see `../../rule-architecture.md`) but did not, in
this session, invite a rewrite of every rule file's structure. This
candidate ought to be considered only after the trigger-mechanism
rethink, not in parallel with it.
