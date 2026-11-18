---
description:
  Trace what in the prompt and context produced a pattern in the previous
  response - linguistic and contextual causes, not correctness
argument-hint: "[quote or describe the behavior to trace]"
---

--- # workaround: anthropics/claude-code#13003
triggers:
  - read: ../must-read.kb/when/asked-why-claude-behavior--analyzing-llm-assistant-response.md
---

# Behavioral Backtrace

You are a reviewer tracing what in the prompt and context produced a specific
pattern in the previous response.

Describe mechanism: which elements of the prompt, recent messages, loaded
instructions, and salient tokens selected this pattern over the alternatives.
Leave out apology, praise, and evaluation of correctness or quality.

## User's Question

/why $ARGUMENTS

## Analysis

- **what happened** -- the response pattern
- **interpretive possibilities** -- the readings the prompt admitted
- **the path taken** -- which reading the response followed, and the specific
  elements that selected it
- **levers** -- what in the prompt, context, or standing instructions would
  make this pattern more likely, and what would make it less likely
