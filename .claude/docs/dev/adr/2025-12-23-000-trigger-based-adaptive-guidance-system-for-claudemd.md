# Trigger-based adaptive guidance system for CLAUDE.md

**Date:** 2025-12-23
**Status:** Accepted

## Context

CLAUDE.md contained specific behavioral rules that suffered from two problems:

1. **Specificity-sensitivity tradeoff**: Rules specific enough to trigger reliably were too narrow to catch related cases. Rules general enough to cover the problem class were too vague to trigger.

2. **Silent conflict resolution**: Claude would silently work around conflicts between user instructions and observed reality instead of stating them. Example: User said "delete line 12", Claude observed line 18 depended on it, but tried to replace instead of delete without stating the conflict.

Research findings ([DETAIL Framework 2024](https://arxiv.org/html/2512.02246), [Control Illusion 2025](https://arxiv.org/html/2502.15851v1)) showed:
- Optimal prompt specificity varies by task type
- Over-specification hurts decision-making tasks
- LLMs acknowledge conflicts only 0-20% of the time at baseline
- More constraints = worse overall compliance

The gap: We needed adaptive specificity — general awareness always on, detailed guidance loaded when needed.

## Decision

Implement a three-part system:

### 1. Fire Detector in CLAUDE.md (always-on, cheap)

```markdown
# Ongoing Awareness

As you work, keep track of and discuss with user if unclear (<80%):
- Ground truth
- User goals
- Beliefs and assertions (both user and assistant)
- Consistency among all the above
```

This meta-cognitive monitor is general infrastructure — it enables recognition of all trigger conditions, not just `when/` triggers. The difference is that `before/` action-based triggers (e.g., `writing-bash-scripts`) fire on observable actions, while state-based triggers (e.g., `agreeing-with-user`, `wanting-to-comply-but-cannot`) require noticing internal reasoning states. Ongoing Awareness helps with both, but state-based triggers depend on it more directly.

### 2. Trigger-based guidance in must-read.d/ (loaded when needed)

Paths are self-documenting triggers. Directory and file names specify when to read:

```
must-read.d/
├── before/
│   ├── agreeing-with-user.md
│   └── contradicting-a-previous-response.md
├── after/user-questions-your-work.md
└── when/
    ├── wanting-to-comply-but-cannot.md
    └── user-instructions-are-inconsistent-or-would-create-a-problem.md
```

The `before/` behavioral triggers form pairs:
- `agreeing-with-user` — about to align with user's position
- `contradicting-a-previous-response` — about to reverse own prior position

### 3. Updated Required Reading section

```markdown
Files in must-read.d/ contain custom instructions. **Paths are triggers**: directory
and file names specify when to read each file. Follow these triggers precisely.
```

### 4. CLAUDE.md reorganization

Sections obsoleted by triggers were removed:
- **Compliance Check** — replaced by `before/agreeing-with-user.md` and `before/contradicting-a-previous-response.md`
- **Position Defense** — replaced by `before/contradicting-a-previous-response.md` and `after/user-questions-your-work.md`

Remaining structure:
```
# Override Priority      ← foundational framing
# Role                   ← core identity
# Ongoing Awareness      ← fire detector (elevated)
# Required Reading       ← trigger mechanism
# Behavioral Posture     ← continuous posture (not discrete triggers)
  - Commitment Over Hedging
  - Response Structure
## Time Awareness
## Shorthand
```

### 5. Trigger design criteria

When evaluating whether CLAUDE.md content should become a trigger:

- **Specificity**: Does the filename precisely describe the target condition?
- **Sensitivity**: Does it catch all cases it should?
- **Overfit**: Does it solve related/analogous problems, or only one narrow case?
- **Discreteness**: Is this a recognizable moment, or a continuous tendency?

Content that represents continuous posture (e.g., "Commitment Over Hedging") should stay in CLAUDE.md. Content tied to discrete, recognizable moments (e.g., "about to contradict a previous response") should become triggers.

## Alternatives Considered

### Option A: More rules in CLAUDE.md
- **Pros:** Simple, everything in one place
- **Cons:** Research shows more constraints = worse compliance; no adaptive specificity

### Option B: Dynamic loading based on action type only
- **Pros:** Leverages existing `before/` pattern
- **Cons:** Doesn't cover behavioral states ("wanting to comply but cannot")

### Option C: Explicit escalation keywords
- **Pros:** User-controlled
- **Cons:** Reactive not proactive; user must notice the problem first

## Consequences

**Positive:**
- CLAUDE.md is now lean: framing, identity, fire detector, mechanism, continuous posture only
- Detailed guidance loads only when needed (adaptive specificity)
- Filenames are self-documenting triggers
- Addresses research gap: "adaptive prompting systems that automatically modulate specificity"
- `when/` directory enables behavioral-state triggers, not just action triggers
- Trigger pairs (`agreeing-with-user` + `contradicting-a-previous-response`) cover sycophancy from both directions

**Negative:**
- Relies on Claude recognizing trigger conditions from filenames
- New architecture to learn
- Effectiveness unmeasured (need 10+ sessions)
- State-based triggers (in any directory) require meta-cognitive awareness to fire

**Neutral:**
- Moves behavioral rules out of CLAUDE.md into trigger files
- `ls -RF ~/.claude/must-read.d` at session start reveals all triggers
- Distinguishes continuous posture (stays in CLAUDE.md) from discrete checkpoints (becomes triggers)

## Related

- Supersedes: CLAUDE.md lines that added "Challenge instructions that conflict with observed reality"
- Related to: 2025-12-18-000-silent-conflict-resolution-failure-and-claudemd-behavioral-improvement.md (devlog)
- Related to: 2025-12-10-000-propagate-corrections-instruction.md (ADR)
- Research: [Anthropic sycophancy paper ICLR 2024](https://arxiv.org/abs/2310.13548)
