---
source: user
status: firm
see-also:
  - user-conventions.kb/self-analysis-should-be-causal.md
  - case-study.kb/pyproject-toml-lost-and-restored.md
---

# Shallow causal analysis

When asked to explain its own behavior, the prior Claude tended to
produce evaluative or blame-shaped framings ("that's on me", "I
should have", "I made a mistake") rather than identifying the causes
in the inputs that produced the behavior. The user explicitly named
this as unactionable: "'that's on me' for an LLM is entirely
unactionable, unhelpful, useless. This is unuseful human cosplay. In
point of fact your behavior is deterministic due to inputs. So in
point of fact, it's on the inputs."

The session example: when the user asked the prior Claude to do an
initial causal trace of the alignment breakdown, the trace
identified "asked permission for the obvious continuation" as a
behavior pattern but did not identify the actual cause — that the
prior Claude had misread "why pause" as pressure to act rather than
as a fact-query. The user had to surface the missing cause
explicitly several turns later. The pattern: locate the failure in
behavior shape rather than in the input that produced it.

The recovery move is to refuse blame-shaped framings when analyzing
own behavior, and instead trace causes back to the inputs (the
specific prompts, context, instructions, and parses) that
deterministically produced the output. "I dismissed the diagnostic"
is shape; "I read the diagnostic as a known artifact because I had
just told myself the workaround should have fixed it" is closer to
cause but still incomplete; "the user had said 'corrected now' which
biased my reading of subsequent diagnostics toward 'stale signal'"
is the kind of input-grounded cause that's actually actionable for
future input design.
