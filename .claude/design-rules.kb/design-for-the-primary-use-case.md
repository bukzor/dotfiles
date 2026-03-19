# Design for the primary use case

Before designing an API, ask: why does someone reach for this tool at all?
Design the default path for that answer. Everything else is degenerate.

## What "degenerate" means

A degenerate case is one where the user doesn't need the tool's core capability.
If someone uses a FUSE filesystem for static files, they don't need FUSE — ext3
or symlinks would do. The API shouldn't optimize for that case or present it
first.

## How to handle degenerate cases

- Support them, but don't design around them
- Let them work through the primary API with minimal extra syntax
  (e.g., `|| "static"` works fine where closures are the default)
- Don't create separate API paths unless the ergonomic cost is high

## Diagnostic

If your simplest example doesn't demonstrate the tool's reason for existing,
you've designed for the degenerate case.

## Source

chatfs-fuser API design session, 2026-03-19. The initial API had static files
as the simplest example and closures as the "dynamic" variant. Inverted after
asking: "why would someone use a FUSE filesystem for static files?"
