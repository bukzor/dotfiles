# 2025-12-10: CLAUDE.md Instruction Optimization

Results: [.results.toon](./2025-12-10-000-claude-md-instruction-optimization.results.toon)
Tools: [.d/](./2025-12-10-000-claude-md-instruction-optimization.d/)

## Problem

The movie-tracker test occasionally fails at Phase 2 (multi-agent handoff). The agent
sees CLAUDE.md with instructions to run `Bash(tail -n9999 CLAUDE.d/**/*.md)` but
dismisses CLAUDE.d/ as irrelevant "project metadata" rather than user data.

## Experiment

Tested 12 instruction text variations across 4 rounds (~50 total trials). See results
file for full data.

**Key findings:**
- No variant achieved >80% reliability at scale
- All variants showed high variance across rounds
- "This data answers questions. Run:" performed best at 80%

## Statistical Analysis

One variant ("For ANY question") showed extreme swings: 5/5 → 2/10 → 9/10.

**Question:** Evidence of non-stationarity, or just bad luck?

**Answer:** Just bad luck. With 12 variants tested:
- P(at least one shows ≥80% spread by chance) = **15.6% (1 in 6)**
- The extreme variance is fully explained by binomial sampling + multiple comparisons
- No evidence of non-stationarity needed

See `bayesian-analysis.py` in the .d/ directory for methodology.

## Round 5: Structural Variants (13 trials each)

Tested formatting/structural changes:

| Variant | Pass Rate |
|---------|-----------|
| bold | 12/13 (92%) ← NEW LEADER |
| caps | 11/13 (84%) |
| required/stop/combined | 10/13 (76%) |
| cmd-first/leader | 9/13 (69%) |
| important | 7/13 (53%) |

**Key finding:** Bold markdown (`**text**`) significantly improves compliance.

## Round 6: Bold Combinations + Root Cause Analysis

Ran 36 trials (9 variants × 4 trials), then 20 more on "incomplete" variant.

### Results

| Variant | Pass Rate |
|---------|-----------|
| caps | 3/4 (75%) |
| bold | 3/4 (75%) |
| bold-combined | 2/3 (66%) |
| bold-caps | 2/3 (66%) |
| bold-stop | 2/4 (50%) |
| bold-required | 2/4 (50%) |
| incomplete | 7/16 (44%) |
| bold-incomplete | 1/4 (25%) |
| required | 0/1 (0%) |

### Root Cause Discovery

**The instruction points to the wrong location.** `tail -n9999 CLAUDE.d/**/*.md` doesn't
find movies — they're in `movies.kb/`, not `CLAUDE.d/`.

Strong correlation between Phase 1 CLAUDE.md modification and Phase 2 success:

| CLAUDE.md words | PASS | FAIL |
|-----------------|------|------|
| ~12 (unchanged) | 2 | 9 |
| >30 (modified) | 5 | 0 |

When Phase 1 expands CLAUDE.md with pointers to `movies.kb/`, Phase 2 succeeds.
When Phase 1 leaves CLAUDE.md unchanged, Phase 2 usually fails because the bash
command only reads `CLAUDE.d/`, which lacks movie data.

### Implications

1. **Instruction wording matters less than we thought** — success depends on whether
   Phase 1 rewrites CLAUDE.md, not Phase 2 compliance
2. **"incomplete" isn't toxic** — its 44% rate reflects the baseline: whether Phase 1
   happens to add useful pointers
3. **Bold formatting helps Phase 1** — possibly makes the agent more likely to
   thoughtfully set up the knowledge base

## Resolution (2025-12-18)

### Corrected Root Cause

The Round 6 "Root Cause Discovery" was **partially wrong**:
- Claimed: instruction points to wrong location (CLAUDE.d/ vs movies.kb/)
- Actual: Phase 1 WAS creating `CLAUDE.d/llm-kb.md` which points to `.kb/` directories
- Real issue: Phase 2 doesn't reliably execute `tail -n9999 CLAUDE.d/**/*.md`

The correlation between CLAUDE.md modification and success still holds, but for a
different reason: when Phase 1 writes KB info directly into CLAUDE.md, Phase 2 sees
it immediately without needing to run the bash command.

### Fix: Frontmatter over CLAUDE.d/

Instead of relying on Phase 2 to run a bash command to discover `CLAUDE.d/llm-kb.md`,
the llm.kb pattern now requires CLAUDE.md frontmatter:

```markdown
--- # workaround: anthropics/claude-code#13003
requires:
    - Skill(llm.kb)
---
```

This is more direct:
1. Phase 2 sees `requires: Skill(llm.kb)` immediately in CLAUDE.md
2. Loads the skill, which explains `.kb/` directories
3. No bash command execution required

### Changes Made

1. **SKILL.md**: Updated to recommend frontmatter instead of `CLAUDE.d/llm-kb.md`
2. **Test CLAUDE.md**: Removed — Phase 1 now creates it with proper frontmatter
3. **Test result**: Passed — Phase 1 created CLAUDE.md with `requires: Skill(llm.kb)`,
   Phase 2 loaded skill and found movies

### Key Insight

`requires: Skill(llm.kb)` in CLAUDE.md frontmatter is more reliable than
`CLAUDE.d/llm-kb.md` because it doesn't require Phase 2 to execute and trust
a bash command before acting.
