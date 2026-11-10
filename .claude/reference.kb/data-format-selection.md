# Data format selection

## Pick by the most expensive resource

| Most expensive | Format | Typical locus |
|---|---|---|
| Bytes | Parquet (in Iceberg/DuckLake when mutable) | object storage, WAN, per-TB-scanned billing |
| CPU | Arrow IPC (`.arrow`, = Feather v2), mmap'd | same host, fast LAN, local caches |
| Human attention | TSV (flat), JSONL (nested) | hand-editing, review, git diffs |

Most pipelines touch all three: text in, Parquet at rest, Arrow in compute.
Convert where the expensive resource changes; Parquet ↔ Arrow is cheap.

"Data in motion" is not its own category: local/LAN motion matches in-memory
(Arrow IPC streaming / Flight), WAN motion matches at-rest (Parquet).

## Human-facing text

- Flat → TSV, not CSV: tabs rarely occur in data, so quoting is rare.
- Never space-separated or column-aligned: spaces need pervasive quoting, empty
  fields go invisible, and alignment re-pads whole columns on every edit (noisy
  diffs). Align at view time: `column -t -s $'\t'`, VisiData, csvlens.
- Nested, machine-written → JSONL (universal engine support).
- Nested, hand-authored → YAML as source of truth, compiled to Parquet
  (`duckdb -c "COPY (FROM 'x.jsonl') TO 'x.parquet'"`). JSON5/HJSON/TOON have
  no engine support; TOON is a prompt encoding, not storage.

## Formats you inherit rather than choose

- Avro — Kafka/streaming; Iceberg manifests.
- ORC — Hive-era legacy; DuckDB/Polars don't read it natively.
- SQLite — small *mutable* data; DuckDB can `ATTACH` it.

## Watch, don't adopt (as of 2026)

- Vortex — compressed-in-memory, aims to erase the at-rest/in-memory split.
- Lance — random access + vectors for ML data.
