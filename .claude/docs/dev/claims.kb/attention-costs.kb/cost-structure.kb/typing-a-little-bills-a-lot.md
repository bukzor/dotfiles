---
label: TYPED_AMPLIFICATION
standing: bare
why:
  - ./each-turn-rebills-the-whole-prompt.md
  - ../measurement.kb/what-the-corpus-costs.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --typed"
---

# What the operator types is a rounding error in what gets billed

The operator composed **1,241,462 characters across 4,216 messages** — a
mean of 294 each, a few paragraphs at most. That correspondence cost
**$6,243.45**:

| | |
|---|---|
| per 1,000 typed characters | **$5.03** |
| per Mtok of typed text | **~$14,600** |
| per composed message | **$1.48** |

A megatoken of ordinary prose costs $5 to send to this API. A megatoken
of *this operator's typing* costs about **fourteen thousand** — roughly
**11,500x amplification** between composing a token and billing one.

This is the number that breaks intuition, and it is worth understanding
rather than dismissing, because the instinct it provokes — type less — is
the wrong response. The amplification is not a markup on typing. It is
`TRIANGLE` viewed from the other end: a short message admits a long
context, which is then replayed on every turn it survives. The typed text
is the *trigger* for the spend, not the substance of it, so the ratio
between them says nothing about either.

Two consequences, and they point opposite ways from the naive reading:

- **Terseness saves nothing.** Doubling a prompt's length moves a
  rounding error. Clarity that avoids one wasted turn saves 300x what the
  extra sentence costs.
- **The message that opens a long session is the expensive one** — not
  because it is long, but because everything it sets in motion is billed
  against `R` remaining turns (`STRIP_PRICE`).
