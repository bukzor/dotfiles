# 2025-12-09: Test Isolation and Multi-Agent Handoff

## Focus

Fix test contamination, establish multi-agent handoff mechanism.

## What Happened

- Fixed test contamination from `work/` directory leaking into test via `--add-dir`
- Evolved fake home approach: copy only SKILL.md + symlink credentials
- Iterated on CLAUDE.md guidance: "append if exists" → literal bash snippet → CLAUDE.d/ pattern
- Introduced `CLAUDE.d/` pattern: idempotent file overwrite for composable extensions
- Added two-phase test: Phase 1 creates knowledge base, Phase 2 tests handoff
- Future-proofed evaluation by deferring detail to SKILL.md

## Decisions

**CLAUDE.d/ pattern for CLAUDE.md extensions:**
- CLAUDE.md contains `## CLAUDE.d/` directive with `tail -n9999 CLAUDE.d/**/*.md`
- Skills create/overwrite `CLAUDE.d/$SKILL.md` (idempotent)
- `CLAUDE.d/llm-d.md` includes `requires: skills/llm.d` for skill discovery

This enables:
- Idempotent updates (file overwrite vs append)
- Composable (multiple skills can coexist)
- Multi-agent discovery (future agents find skill via requires:)

## Next Session

- Run test, evaluate against SKILL.md patterns
- Iterate if haiku doesn't follow the pattern
- Consider: does CLAUDE.d/ pattern deserve promotion to llm-collab-docs?
