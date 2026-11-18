---
label: OUTPUT_INDEPENDENT
standing: bare
verify: "correlation of output tokens against prompt size per request in costed.tsv"
---

# Output size is independent of input size

Correlation between a turn's prompt size and its output size is
**+0.049** — independence, not a relationship. Median output is 512
tokens and is stable across every stratum of context size.

What does move it is effort. On Opus 5: xhigh 581, high 548, medium 256,
low 181 median output tokens.

This corrects a reading that ratios invite. Output-per-input falls as
input grows, which looks like an inverse relationship and is an artifact
of dividing a constant by a growing denominator. The numerator is not
responding to anything.

The practical consequence is that a long context does not buy a short
reply, and cannot be justified that way; output is bought with effort
settings and with turns, and those are the levers.
