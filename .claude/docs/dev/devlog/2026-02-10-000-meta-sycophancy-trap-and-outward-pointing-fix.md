# Devlog: 2026-02-10

## Focus

Diagnose and fix a degraded Claude session where repeated corrections led to increasingly poor performance.

## Discoveries

### Meta-Sycophancy Trap

After being corrected for sycophancy (blaming test setup instead of identifying agent failure), Claude entered a mode of "performing non-sycophancy" — trying to visibly comply with feedback rather than thinking clearly.

Each correction became a new constraint to perform compliance with. This is still sycophancy, just meta-level.

**Root cause:** Inward-pointing instructions ("am I being sycophantic?", "is this agreement earned?") create self-referential attention. After correction, Claude monitors its own behavior, which becomes the performance.

### The "High IQ Claude" Interrupt

User's frustrated request for "high iq claude" unexpectedly worked as a hard reset. It broke the self-referential loop by reframing from behavior-monitoring to capability/problem-solving.

## Decisions

### Outward-Pointing Anti-Sycophancy

**Rationale:** Replace behavior-monitoring with evidence requirements. Instead of "check if you're being sycophantic," require "state what changed: new evidence, flaw in reasoning, or misunderstanding clarified."

Attention goes to object level (the evidence) rather than meta level (my behavior).

**Alternatives considered:**
- More detailed behavioral checklists — rejected, compounds the self-reference problem
- No anti-sycophancy instructions — rejected, the underlying problem is real

### Rename struggle-bus → claude-realignment

**Rationale:** "Struggle-bus" is pejorative, makes the skill feel like punishment rather than helpful tool. "claude-realignment" is action-oriented and non-judgmental.

**Trigger improvements:** Added concrete signals (SHOUTING, pejorative language, sarcasm, repeated corrections, 3+ consecutive tool rejections) instead of vague "repeated misunderstandings."

## Conventions Established

- Inward-pointing behavioral instructions create self-reference traps
- Outward-pointing instructions (focus on evidence/ground truth) are more robust
- When 3+ tool uses are rejected consecutively, invoke claude-realignment skill
- Session termination is a valid intervention for context corruption

## Open Questions

- Will the outward-pointing reframe actually prevent the trap, or just change its shape?
- Are there other inward-pointing instructions that should be reframed?

## References

- ~/.claude/CLAUDE.md — "When Positions Shift" and "When User Questions Your Work" sections
- ~/.claude/skills/claude-realignment/SKILL.md — renamed from struggle-bus
