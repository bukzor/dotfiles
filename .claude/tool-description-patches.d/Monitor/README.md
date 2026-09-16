Two live wordings pre-v2.1.221 (pre-`ws` source), one from v2.1.221 through
at least v2.1.267 (adds the `ws` source and PushNotification guidance). The
stub is the one-paragraph mechanics summary; everything else (mechanism
picking, script quality, coverage, output volume, `ws` source, pushing)
moved to must-read.kb/before/using-claude-code-tool/Monitor.md, which the
proxy's stripped-schema note points readers at.

v2.1.273 rewrote the persistent-vs-timeout paragraph: the prose no longer
mentions `persistent: true` at all, reframing everything as "every monitor
expires after `timeout_ms` (default 5min, max 30min); re-arm if you still
need the watch." This is a top-level-description change only -- the
`persistent` parameter's own schema description (a separate field this
patch doesn't touch) still reads "no timeout" in the same request, and a
persistent monitor armed under the old wording kept running (and kept
reporting) days later. Nothing to fold in: our stub never described
`persistent` either, deferring that to the must-read.kb entry, which
remains accurate to the schema even though upstream's own prose no longer
advertises the escape hatch.

Same-day, the haiku wording of that same paragraph (v2.1.273-haiku, build
2.1.273.6b6 vs. the sonnet build 2.1.273.95e above) gives the max as "10
minutes" where sonnet's says "30 minutes" -- one number swapped, nothing
else. Whether that's a genuine per-model schema difference (a cheaper model
gets a shorter leash) or just prose drift, it's still only the top-level
description string; this session's own actual `timeout_ms` schema field
(the part a caller can rely on) says max 3600000ms regardless. Nothing to
fold in: the stub never quoted a number either.
