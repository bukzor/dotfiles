#!/usr/bin/env -S PYTHONPATH=/home/bukzor/lib/pythonpath python3 -m bukzor.claude.branch_extract
"""Extract the lineage of a chosen tip into a new session JSONL.

The Claude Code rewind bug (anthropics/claude-code#55347) leaves orphaned
branches reachable only via `parentUuid` chains. This walks the ancestors
of a chosen tip and writes them as a new linear session, with `sessionId`
rewritten so `/resume` will pick it up.

Usage:
    python3 -m bukzor.claude.branch_extract <session.jsonl> <tip>
                                             [--out PATH] [--session-id ID]

`<tip>` can be a full uuid or an integer line number from `branch_list`.
"""
from __future__ import annotations

import argparse
import json
import sys
import uuid as uuidlib
from collections.abc import Iterator
from pathlib import Path

from . import session as session_mod
from .session import Node, Record, Session


def resolve_tip(sess: Session, tip: str) -> Node:
    if tip in sess.by_uuid:
        return sess.by_uuid[tip]
    try:
        line = int(tip)
    except ValueError:
        raise SystemExit(f"tip {tip!r} is neither a uuid in this file nor an int line number")
    for n in sess.nodes:
        if n.line == line:
            return n
    raise SystemExit(f"line {line} not found in {sess.path}")


def default_out_path(sess: Session, new_session_id: str) -> Path:
    return session_mod.project_dir_for(sess.path) / f"{new_session_id}.jsonl"


def linearize_branch(sess: Session, tip: Node, new_session_id: str) -> Iterator[Record]:
    """Pure: yield rewritten records for the ancestor chain of `tip`.

    Records preserve their original uuid/parentUuid (so cross-references
    survive); only sessionId is rewritten.

    >>> from pathlib import Path
    >>> from .session import build_session
    >>> sess = build_session(Path("x"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None,
    ...              "sessionId": "old", "type": "user"}),
    ...     Node(1, {"uuid": "b", "parentUuid": "a",
    ...              "sessionId": "old", "type": "assistant"}),
    ...     Node(2, {"uuid": "c", "parentUuid": "a",
    ...              "sessionId": "old", "type": "user"}),
    ... ]))
    >>> recs = list(linearize_branch(sess, sess.by_uuid["b"], "new"))
    >>> [r["uuid"] for r in recs]
    ['a', 'b']
    >>> {r["sessionId"] for r in recs}
    {'new'}
    """
    assert tip.uuid, tip
    chain = sess.ancestors_of(tip.uuid)
    assert chain, (sess.path, tip.line)
    for node in chain:
        rec = dict(node.record)
        if "sessionId" in rec:
            rec["sessionId"] = new_session_id
        yield rec


def write_jsonl(records: Iterator[Record], out_path: Path) -> int:
    """Impure: write records as JSONL. Returns count written."""
    written = 0
    with out_path.open("w") as f:
        for rec in records:
            f.write(json.dumps(rec) + "\n")
            written += 1
    return written


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("path", type=Path, help="source session JSONL")
    p.add_argument("tip", help="uuid or line number of the chosen tip")
    p.add_argument("--out", type=Path, default=None, help="output path (default: <slug>/<new-uuid>.jsonl)")
    p.add_argument("--session-id", default=None, help="session id for the new file (default: random uuid4)")
    return p.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    sess = session_mod.load(args.path)
    if not sess.nodes:
        print(f"empty or unparseable: {args.path}", file=sys.stderr)
        return 1

    tip = resolve_tip(sess, args.tip)
    new_sid = args.session_id or str(uuidlib.uuid4())
    out = args.out or default_out_path(sess, new_sid)
    if out.exists():
        print(f"refusing to overwrite existing: {out}", file=sys.stderr)
        return 2

    count = write_jsonl(linearize_branch(sess, tip, new_sid), out)
    print(f"wrote {count} records to {out}", file=sys.stderr)
    print(f"new session id: {new_sid}", file=sys.stderr)
    print(out)
    return 0


def _invoked_via_shebang() -> bool:
    """Detect bare `./branch_extract.py` invocation: argv[1] is our own path."""
    if len(sys.argv) != 2:
        return False
    return Path(sys.argv[1]).resolve() == Path(__file__).resolve()


if __name__ == "__main__":
    if len(sys.argv) > 1 and not _invoked_via_shebang():
        raise SystemExit(main())
    import doctest

    raise SystemExit(1 if doctest.testmod(verbose=True).failed else 0)
