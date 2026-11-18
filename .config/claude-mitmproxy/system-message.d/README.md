# System Message Patches

The `match`/`search`/`replace` template dialect of `../system-prompt.d/` (see
its README for the format), applied to a different locus: the text of
`messages[]` entries whose role is `system`. Claude Code delivers
mid-conversation instructions there -- plan-mode transitions, permission-mode
notices, the auto-mode bash-first steer -- and unlike `request.system`, that
text is interleaved with the conversation's own tool results.

That interleaving is the one thing to know before writing a rule here. A
`role: "system"` message can carry a verbatim copy of anything this session
has read, including the rules in this directory, so a template anchored on a
short heading matches its own quotation. Anchor on structure the quoted form
cannot reproduce -- see `retune-auto-mode-bash-steer/README.md`, which works
through the case.

Rules here are applied per request by `addons/syspatch.py` via
`lib/claude_mitmproxy/message_patches.py`; `~/claude/mitmproxy` is the repo.
The offline checks (`check_patches.py`, `check_strip_floors.py`,
`check_dark_patches.py`) do not cover this directory: they are scoped to the
prompt body and calibrated against `system-prompts.kb/` fixtures, and there
are no captured fixtures for this locus. `tests/test_message_patches.py`
carries the upstream bodies verbatim instead.
