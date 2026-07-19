---
description: Human-alignment pass — check an artifact's goals against the user's goals
argument-hint: <path | "the plan above" | other in-context item>
---

# Align — goals/intent alignment pass

Target: **$ARGUMENTS**
(A file path → read it. An in-context reference → use that prose/plan.)

This checks **intent**: do the goals the target embodies (explicit or implicit)
match the user's goals? It is not a content/technical audit — don't critique
correctness, completeness, or quality.

## Posture

- The user owns the goals. You only surface the goals the target embodies; the
  user judges them.
- Small steps. Present, then stop. Don't bundle in audits or recommendations.
- Don't edit until alignment is confirmed.

## Procedure

1. **Extract** the goals the target embodies — explicit and implicit — plus any
   non-goals it implies. Plain list, nothing else.
2. **Ask** which are the user's, which aren't, what's missing.
3. **Reconcile** corrections into a clarified goal set; reflect it back to confirm.
4. **Adjust** the target to match.
5. **Repeat** until a pass surfaces no misalignment.
