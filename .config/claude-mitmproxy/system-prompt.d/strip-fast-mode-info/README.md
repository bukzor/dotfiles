Strip the Fast Mode advertisement.

Advertises a toggle, not information the session needs. Since v2.1.221 it
is an unconditional `# Environment` bullet; every captured body with that
heading carries it, so `match.md` anchors on the heading and the bullet
going missing is loud by design. The bullet's version-list tail ("Opus
5/4.8") churns with releases, so `search.d/v2.1.221.md` takes it as
`$REST`; `search.d/v2.1.76.md` covers the session-conditional
`<fast_mode_info>` tag this patch originally targeted.

`search.d/v2.1.323.md`: the bullet was reworded again (it now explains the
model switch rather than denying one); its stable head is "gives faster
output".
