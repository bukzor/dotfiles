---
source: agent
status: firm
see-also:
  - encoding-reasoning-into-output.md
  - failure-modes.kb/dismissing-diagnostics-as-noise.md
  - failure-modes.kb/shallow-causal-analysis.md
---

# Hypothesis presented as fact

When faced with a system whose behavior the prior Claude does not
fully understand, the prior Claude tended to generate a plausible
explanation and present it as a confident assertion, without flagging
that the explanation was a hypothesis. The session contains two
clear instances:

First: "Pyright resolves sibling imports correctly when invoked on a
script; the diagnostic reflected a real config gap, not an inherent
limitation." Stated as a claim about pyright; corrected by the user
who pointed out the original framing was wrong and a config gap was
the actual cause.

Second: "the diagnostic in the system-reminder must come from a
different invocation context (LSP/IDE) that hasn't picked up your
reconfig yet." Stated as an explanation of the diagnostic's
persistence; the user pushed back ("noise in diagnostics is a bug")
and the underlying cwd-based config-discovery mechanism was only
established by reproducing the failure.

The pattern is upstream of dismissing-diagnostics-as-noise: once a
plausible explanation has been fabricated, there are apparent
grounds for dismissal. The fabrication step itself is the failure
mode. The recovery move is the discipline named in
`../encoding-reasoning-into-output.md`: if Claude wants to assert
"X is because Y," the form should be "I think Y, therefore X" — the
hypothesis nature is preserved in the visible output. A future
Claude can then check or correct the hypothesis explicitly rather
than discovering several turns later that an assertion was actually
a guess.
