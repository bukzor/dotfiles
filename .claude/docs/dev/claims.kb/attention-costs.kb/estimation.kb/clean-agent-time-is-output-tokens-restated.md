---
label: CLEAN_TIME_IS_OUTPUT
standing: bare
why:
  - ./output-size-does-not-follow-from-input-size.md
verify: "per-call durations from timestamp_start/timestamp_end in the mitmproxy capture, against output tokens per session"
---

# True generation time is output volume restated, not a second input

Measuring generation time properly — summing per-call durations from the
wire capture rather than inter-request gaps — gives 22.9% oracle accuracy,
better than turn count's 27.2%. That improvement is real and it is
useless.

**Correlation between log output tokens and log generation time is
+0.997**, at a throughput of 82 tokens/sec (p10–p90: 73–115). Generation
time is output volume divided by a near-constant. It is not an
independent predictor; it is the same quantity with a clock on it.

Which places it exactly where output tokens sit: the best thing to know
and the hardest thing to guess. An agent can no more estimate its
generation-seconds than its output tokens, because they are one estimate.

The general shape, which `PREDICTABLE_ISNT_USEFUL` states directly: an
input's value is its oracle accuracy *and* its guessability, and quoting
either alone oversells it.
