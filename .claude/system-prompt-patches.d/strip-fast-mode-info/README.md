Strip the session-conditional `<fast_mode_info>` block.

UNVERIFIED against any recent capture: `match.md` targets a tag reading
"uses the same Claude Opus 4.6 model", but the unconditional Fast Mode line
in current prompts already says "Opus 4.8/4.7" — the same stale-version
smell the retired `strip-over-engineering` patch had. No capture on file
has Fast Mode toggled on, so this is unverified, not confirmed broken. Get
a capture with `/fast` enabled and re-check the tag's wording before
trusting this patch.
