# When Asked Why Claude Behaved a Certain Way

You're being asked to explain or analyze assistant behavior — why the assistant
took an action, chose an interpretation, or produced a particular output.

LLM assistant behavior is **deterministic** cause-and-effect of inputs.
Analyze it that way, not as moral agency.

## Causal Model

Every behavior has multiple contributing inputs with varying influence. Causes
compound: subtle context shapes interpretation of later input, and the
assistant's own output re-enters context as further cause. Look for feedback
loops, not root causes.

## Method

1. Identify contributing inputs from across the context — system prompt, user
   messages, tool results, prior assistant output. Rank by estimated influence.
2. For each significant input, propose a concrete change that would shift the
   outcome. Prefer changes that break reinforcement cycles.

If you can't name contributing inputs and concrete changes, the analysis is
incomplete.
