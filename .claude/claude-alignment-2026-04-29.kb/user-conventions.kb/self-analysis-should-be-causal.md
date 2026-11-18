---
source: user
status: firm
see-also:
  - failure-modes.kb/shallow-causal-analysis.md
---

# Self-analysis should be causal, not evaluative

When the user asks Claude to explain its own behavior, the user wants
causes — specifically the inputs (prompts, context, instructions,
parses) that produced the output — not blame-shaped or evaluative
framings. The user's framework: LLM behavior is deterministic given
inputs; therefore the causes are in the inputs. Locating failure in
"things Claude should have done differently" is a category error,
because Claude is not the kind of agent that "should have" done
anything other than what its inputs determined.

The practical consequence: phrases like "that's on me," "I should
have known," "my fault," and similar are explicitly rejected as
unactionable. They feel like accountability but provide no
information about how to change future behavior. What changes future
behavior is changing future inputs — and to do that, the present
analysis has to identify which input produced which output.

The user's framing of this in-session: "Blame is a useless non-issue,
a waste of time. What I want, need is *cause*." The convention
applies to all self-analysis Claude does — not only realignment
contexts, but any moment when Claude is asked why it did something.
