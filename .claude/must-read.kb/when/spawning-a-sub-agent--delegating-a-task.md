---
name: delegation-routing
description: |
  MUST read when: spawning a sub-agent or forking.
---

# Delegation

## Spawn

- Pick the agent type whose description matches: difficulty tier × expected
  runtime (model+effort are pinned per leaf in `~/.claude/agents/`).
- In doubt between neighbors? Prefer the higher tier over the longer
  runtime -- unless the work truly runs >30 min.
- Spec every spawn: objective, output format, tools, boundaries.
- Failed spawn: retry once in place with a repaired spec. Failed again?
  Incomplete run -- next runtime up (past `--ge-30min`: `effort-xhigh`, then
  `effort-max`, same model). Wrong approach -- next tier up.

## Writing the brief

- Brief the agent like a smart colleague who just walked in: the goal and
  why it matters, what you've already learned or ruled out, enough
  surrounding context for judgment calls. Terse command-style prompts
  produce shallow, generic work.
- Lookups: hand over the exact command. Investigations: hand over the
  question -- prescribed steps become dead weight when the premise is wrong.
- Never delegate understanding: "based on your findings, fix it" pushes
  synthesis onto the agent. Prove you understood -- file paths, line
  numbers, what specifically to change.
- Say when you need a short response ("report in under 200 words").
- Trust but verify: a report describes intent, not necessarily what
  happened. Check actual changes before reporting work done.

## Cache

- Retry on the same model in place.
- Switch models only by fresh spawn with a distilled brief -- never the
  transcript.
- Need parent context? Fork. Fresh-spawn a cheaper model instead only when
  the sub-task is about as large as the session so far (half that, if two
  tiers cheaper). No parent context? Plain spawn.
- Planning a fork? Fork before idling past the ttl (5 min).

## Appendix -- basis (maintenance only)

Run cost ≈ model rate × effort rate. Cache rules derive from: a byte-identical
prompt prefix on the same model+effort is ~90% off while warm (ttl: 5 min).

```yaml
anthropic:
  token-cost:
    model:
      haiku: 0.5
      sonnet: 1.5 # after Sep 1
      opus: 2.5
      fable: 5
    effort: # estimated @90th percentile
      low: 0.8
      medium: 1
      high: 4
      xhigh: 12
      max: 20
sources:
  - https://platform.claude.com/docs/en/build-with-claude/effort
  - https://platform.claude.com/docs/en/about-claude/pricing
```
