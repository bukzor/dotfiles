---
why:
  - ../transport.md
verdict: chosen
---

# Files as messages, pull delivery

Properties that won it:

- Permission scoping via path rules the owner already trusts, with message
  bodies reviewable as file diffs at Ask time.
- Observability: traffic is `ls`-able, watchable in a tmux pane.
- Rewindable receipt: the message enters context through an ordinary Read.
- Mutable-until-read: in-flight mail can be edited or retracted — the
  feature the owner ratified as non-negotiable, structurally impossible
  under push.
- Coalescing: queued messages batch at the next boundary instead of
  interrupting serially in arrival order.
- Zero cost until read: a pointless message dies unread in a directory.
- Transport-agnostic: the address is a path; mounts extend it.
