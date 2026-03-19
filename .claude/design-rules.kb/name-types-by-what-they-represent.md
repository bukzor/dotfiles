# Name types by what they represent

Name types for what they represent in the domain, not what they "are" in the
implementation. Only disambiguate to the extent it's actually ambiguous.

A struct holding file data + metadata is a `File`, not a `FileContent` or
`ContentSource`. The module path provides disambiguation (`chatfs_fuser::File`
vs `std::fs::File`).

## Corollary

Don't preemptively avoid common names. `File`, `Error`, `Result` are fine —
the package/module is part of the name. `beauty_salon::File` is unambiguous.

## Source

chatfs-fuser API design session, 2026-03-19.
