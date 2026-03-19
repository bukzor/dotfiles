# Use stdlib patterns as tiebreakers

When choosing between equivalent API shapes, look at how the language's standard
library handles the same situation. Follow that pattern unless you have a strong
reason to diverge.

## Example

Should a FUSE file API accept both values and callbacks in one parameter, or
always take a callback? The stdlib has `unwrap_or(value)` vs
`unwrap_or_else(|| value)` — two methods. But when one case is dominant and
the other degenerate, the stdlib often just takes the general form. Always
taking a callback with `|| value` for the static case is two characters and
idiomatic.

## Why

- Reduces learning curve — users already know the pattern
- Avoids inventing novel API shapes when a proven one exists
- Settles "taste" debates with evidence instead of opinion

## Source

chatfs-fuser API design session, 2026-03-19.
