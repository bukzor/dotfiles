---
triggers:
  - read: ~/.claude/reference.kb/claude-md-frontmatter.md
---

# Developing claude-code extensions (hooks, skills, commands, …)

Claude-Code-related skills are lazy loaded, from `~/.claude/skill-categories/claude-code/`.

See also: lazy-loading/skills.md

## Writing or revising a skill body

Four rules, each with a failure behind it. The derivation, the
alternatives, and the acceptance test are in
`bukzor-agent-skills/docs/dev/adr/2026-08-28-000-A-skill-states-a-stance--not-a-procedure.md`
— read it when one of these is contested, not on every edit.

- **State a stance, not steps.** Establish what the agent is
  accountable for, what it must be able to say before acting, and the
  precedence among those. A step presumes the setting that makes it
  possible; a stance also yields a finding where that setting is absent.
- **Keep situational bindings, below a marked seam.** They are what
  makes a check runnable. Say in the file that a port rewrites that
  section rather than dropping it.
- **Give every detection instruction its null case.** An unstated empty
  result reads as noise to the agent who most needs the check.
- **Cost is what the skill mandates reading, transitively** — not its
  own length. Route derivation to an address marked read-on-contest.

Author-facing conventions live in that repo's `docs/dev/adr/`, never in
a `SKILL.md` body, which is read by invokers (2026-08-09-000). The
load trigger is the `description:`, intent-keyed (2026-08-27-000) — and
it should fire on the episode that created the skill; check that it does.
