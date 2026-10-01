---
source: mutual
status: firm
see-also:
  - failure-modes.kb/shallow-causal-analysis.md
  - case-study.kb/unauthorized-pyrightconfig.md
---

# Dismissing diagnostics as noise

The prior Claude treated a pyright IDE diagnostic as "a known artifact"
and proposed moving on without investigating, on the basis that the
CLI invocation of pyright was clean. The user objected directly: "no,
that it's incorrect does not imply you can ignore it. Noise in
diagnostics is a bug. We need diagnostics to *be* diagnostic."

The failure mode is the categorical move from "I have a hypothesis
about why this might be a false positive" to "therefore I can ignore
it." Hypotheses about source are valuable; conclusions reached without
reproduction are not. A diagnostic-channel signal disagreeing with a
manual-channel signal is itself a finding worth investigating, not a
licensing condition for dismissal.

The recovery move is to reproduce before categorizing. If the
diagnostic fires under conditions Claude can construct, the diagnostic
is a real signal regardless of how Claude labels its origin. In this
session, reproducing the diagnostic via `cd /tmp && pyright /abs/path`
showed the IDE/LSP issue was cwd-dependent project discovery — a real
bug worth surfacing, not noise.
