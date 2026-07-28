---
cwd: /home/bukzor/claude/deadlock
session:
  uuid: 89844a8c-1ff6-4add-8454-63c7409e0486
  started: 2026-07-27T23:28:00+00:00
  ended: 2026-07-27T23:59:00+00:00
---
# Recover Deadlock Builds + Validate-Gated Snapshotter

Third loss of Deadlock hero builds: a game crash truncates the Steam-Cloud-synced
`cached_hero_builds.kv3` (1087 bytes, 0/0), and Steam Cloud then uploads the
gutted file. Recovered the builds (73 Unpublished / 88 Favorites) from user-pulled
Volume Shadow Copies, restored them live, and built a permanent, validate-gated
backup so future truncations are non-destructive.

## Outcome (all done, verified in production)

- **Builds recovered + live**: richest copy (73/88) restored; game re-saved it
  (106112 bytes) and Steam Cloud uploaded the good version — `remotecache.vdf`
  sha now matches live. The cloud clobber loop is broken; builds confirmed
  loading in-game.
- **New data repo** `github.com/bukzor/bukzor.deadlock-data` (cloned at
  `~/repo/github.com/bukzor/bukzor.deadlock-data`):
  - 3 recovered snapshots committed in succession (58/68 → 72/86 → 73/88).
  - `validate.py` — the gate: parses KV3, requires Unpublished+Favorites > 0.
  - `snapshot.sh` — validate → if changed, cp+commit+push. Skips truncated files.
  - `restore.sh` — safe one-shot restore to live (refuses while Steam runs,
    validates source, stamps mtime; `FORCE=1` overrides).
  - `etc/service/deadlock-builds/run` — runit loop (120s), symlinked into
    `/etc/service/`. Runs as bukzor via chpst. **Currently live and supervised**;
    it auto-captured two changes unforced this session.
- **Host bug fixed**: `runsvdir` (WSL boot) had an empty `PATH`, so it could
  never `exec runsv` — nothing was supervised (sshd was down too). Patched
  `/etc/wsl.conf` (backup: `/etc/wsl.conf.bak`) to set PATH, and restarted
  runsvdir live. sshd came back as a side effect.

## Key facts for future claude

- Live save: `/mnt/c/Program Files (x86)/Steam/userdata/37093539/1422450/remote/cfg/cached_hero_builds.kv3`
- Restore = `~/repo/github.com/bukzor/bukzor.deadlock-data/restore.sh` (Steam closed).
- Recovery backups + snapshotter log: `~/deadlock-builds-recovery/`.
- Snapshotter validation reuses the **deadlock project venv**
  (`/home/bukzor/claude/deadlock/.venv/bin/python`) for `keyvalues3`. If that
  venv is deleted, the gate fails and snapshots stop *safely* (skips, never
  commits garbage).
- KV3→JSONL is lossless; JSONL→KV3 re-encoding is NOT byte-faithful (game-load
  fidelity unproven) — that's why the repo stores raw `.kv3`, not JSONL.

## Open follow-ups

- [ ] Confirm `/etc/wsl.conf` fix survives a real `wsl --shutdown` + reboot
      (services auto-start with a working PATH). Live session already fixed.
- [ ] Root-cause the recurring Deadlock crashes (separate problem; snapshotter
      only makes them non-destructive, doesn't prevent them).
- [ ] Optional: give the data repo its own venv (`uv`) with `keyvalues3` so the
      snapshotter is self-contained and independent of the deadlock project.
- [ ] Optional (deferred by user): JSONL diffable view + git history of builds;
      user trusts the raw binaries and declined for now.
