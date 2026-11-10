# ~/.config

## Per-host trees

> [!@bukzor] 2026-11-10: per-host runit services live in `runit/<hostname>/`;
> `/etc/service` is a symlink to this host's tree (made by `runit/install`).

> [!DRAFT] 2026-11-10 — trigger: before adding per-host config for a second
> tool, or versioning a host's `/etc` files (e.g. `wsl.conf`), ask the user
> whether to pivot to a host-first layout — `hosts/<hostname>/<tool>/`, or
> mirroring real paths as `hosts/<hostname>/etc/…` — instead of a second
> `<tool>/<hostname>/`. Tool-first holds only while runit is the sole
> per-host tool.
