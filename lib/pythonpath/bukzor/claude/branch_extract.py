#!/usr/bin/env -S PYTHONPATH=/home/bukzor/lib/pythonpath python3 -m bukzor.claude.branch_extract
"""Extract an orphaned branch into a new session JSONL you can resume.

The Claude Code rewind bug (anthropics/claude-code#55347) leaves orphaned
branches unreachable: `/resume` picks one chain at load time -- the newest
message whose uuid is registered as a `leafUuid`, walked back via
`parentUuid` -- and the in-session rewind picker only walks that chain
backward. There is no fast-forward, and no UI reaches a sibling branch.
So we hand-build a file whose newest leaf is the branch you want.

Given any record on a branch, this traces *forward* to that branch's tip
(you can rewind afterward; you cannot fast-forward), collects every record
belonging to it, and writes them out under a fresh `sessionId`.

"Belonging to it" is more than the parent chain -- attachments, file
snapshots and session settings hang off the chain rather than living in
it, and most of them belong to *other* branches. See `belongs_to_branch`.

Usage:
    python3 -m bukzor.claude.branch_extract <session.jsonl> <ref>
                                             [--out PATH] [--session-id ID]

`<ref>` can be a full uuid or an integer line number from `branch_list`;
any record on the branch will do, including the one your grep found.
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

# Session-scoped settings, keyed by sessionId rather than by message: Claude
# Code reads only the final record of each type, so keeping every historical
# one is dead weight -- and keeping any written *after* our tip would import
# a sibling branch's title, mode or leaf pointer.
LAST_WINS = frozenset({
    "last-prompt",
    "custom-title",
    "ai-title",
    "tag",
    "mode",
    "permission-mode",
    "relocated",
    "agent-name",
    "agent-color",
    "agent-setting",
})


def resolve_ref(sess: Session, ref: str) -> Node:
    """Find the record named by a uuid or a branch_list line number."""
    if ref in sess.by_uuid:
        return sess.by_uuid[ref]
    try:
        line = int(ref)
    except ValueError:
        raise SystemExit(f"ref {ref!r} is neither a uuid in this file nor an int line number")
    for n in sess.nodes:
        if n.line == line:
            return n
    raise SystemExit(f"line {line} not found in {sess.path}")


def belongs_to_branch(sess: Session, chain: set[str], node: Node) -> bool:
    """Pure: is `node` structurally part of the branch whose spine is `chain`?

    Three ways to belong, mirroring how Claude Code reassembles a session:

    - the conversation spine itself (`uuid` in the parent chain);
    - decorations hanging off the spine -- attachments and system notices
      name their message as `parentUuid`. Sibling *branch heads* hang off
      the spine too, which is exactly what we are shedding, so user and
      assistant records are excluded here;
    - file-history snapshots and deltas, which reference their message by
      `messageId` (these back `/rewind`'s file restore).

    Session-scoped settings belong to no message at all; `branch_records`
    handles those.
    """
    rec, uuid = node.record, node.uuid
    if uuid and uuid in chain:
        return True
    if node.type in LAST_WINS:
        return False
    if rec.get("messageId"):
        return rec["messageId"] in chain
    if uuid and node.parent_uuid in chain:
        return node.type not in ("user", "assistant")
    return False


def branch_records(sess: Session, tip: Node) -> list[Node]:
    """Pure: every record of tip's branch, in file order, last-wins collapsed.

    Settings are kept up to the branch's last record -- past that point the
    file is describing some other branch -- and then collapsed to the final
    one of each type, since that is all Claude Code will read.

    The off-branch attachment is dropped despite sitting between two kept
    records; `early` is dropped as superseded, `sibling-era` as too late.

    >>> from pathlib import Path
    >>> from .session import build_session
    >>> sess = build_session(Path("x"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None, "type": "user"}),
    ...     Node(1, {"type": "mode", "mode": "early"}),
    ...     Node(2, {"uuid": "keep", "parentUuid": "a", "type": "attachment"}),
    ...     Node(3, {"type": "mode", "mode": "current"}),
    ...     Node(4, {"uuid": "b", "parentUuid": "a", "type": "assistant"}),
    ...     Node(5, {"uuid": "sibling", "parentUuid": "a", "type": "user"}),
    ...     Node(6, {"uuid": "drop", "parentUuid": "sibling", "type": "attachment"}),
    ...     Node(7, {"type": "file-history-snapshot", "messageId": "b"}),
    ...     Node(8, {"type": "file-history-snapshot", "messageId": "sibling"}),
    ...     Node(9, {"type": "mode", "mode": "sibling-era"}),
    ... ]))
    >>> [n.uuid or n.record.get("mode") or n.record["messageId"]
    ...  for n in branch_records(sess, sess.by_uuid["b"])]
    ['a', 'keep', 'current', 'b', 'b']
    """
    assert tip.uuid, tip
    chain = {n.uuid for n in sess.ancestors_of(tip.uuid) if n.uuid}
    assert chain, (sess.path, tip.line)
    kept = [n for n in sess.nodes if belongs_to_branch(sess, chain, n)]
    cutoff = max(n.line for n in kept)
    settings = [n for n in sess.nodes if n.type in LAST_WINS and n.line <= cutoff]
    survivor = {n.type: n.line for n in settings}
    kept += [n for n in settings if survivor[n.type] == n.line]
    kept.sort(key=lambda n: n.line)
    return kept


def rewrite(records: Iterator[Node], tip: Node, new_session_id: str) -> Iterator[Record]:
    """Pure: retarget records at a new session, pinning tip as its leaf.

    uuid/parentUuid are preserved, so cross-references survive; only
    `sessionId` changes. The surviving `last-prompt` record carries the
    `leafUuid` that resume anchors on, so it is repointed at our tip --
    without that, a stale pointer into a branch we just dropped could
    leave the new session unresumable.

    >>> from pathlib import Path
    >>> from .session import build_session
    >>> sess = build_session(Path("x"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None,
    ...              "sessionId": "old", "type": "user"}),
    ...     Node(1, {"type": "last-prompt", "sessionId": "old", "leafUuid": "gone"}),
    ... ]))
    >>> for rec in rewrite(iter(sess.nodes), sess.by_uuid["a"], "new"):
    ...     print(sorted(rec.items()))
    [('parentUuid', None), ('sessionId', 'new'), ('type', 'user'), ('uuid', 'a')]
    [('leafUuid', 'a'), ('sessionId', 'new'), ('type', 'last-prompt')]
    """
    pinned = False
    for node in records:
        rec = dict(node.record)
        if "sessionId" in rec:
            rec["sessionId"] = new_session_id
        if rec.get("type") == "last-prompt":
            rec["leafUuid"], pinned = tip.uuid, True
        yield rec
    if not pinned:
        yield {"type": "last-prompt", "sessionId": new_session_id, "leafUuid": tip.uuid}


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
    p.add_argument("ref", help="uuid or line number of any record on the branch")
    p.add_argument("--out", type=Path, default=None, help="output path (default: <slug>/<new-uuid>.jsonl)")
    p.add_argument("--session-id", default=None, help="session id for the new file (default: random uuid4)")
    return p.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    sess = session_mod.load(args.path)
    if not sess.nodes:
        print(f"empty or unparseable: {args.path}", file=sys.stderr)
        return 1

    ref = resolve_ref(sess, args.ref)
    assert ref.uuid, (args.path, args.ref)
    tip = sess.tip_of(ref.uuid)
    assert tip, (args.path, args.ref)
    new_sid = args.session_id or str(uuidlib.uuid4())
    out = args.out or session_mod.project_dir_for(sess.path) / f"{new_sid}.jsonl"
    if out.exists():
        print(f"refusing to overwrite existing: {out}", file=sys.stderr)
        return 2

    kept = branch_records(sess, tip)
    count = write_jsonl(rewrite(iter(kept), tip, new_sid), out)
    print(f"wrote {count} of {len(sess.nodes)} records to {out}", file=sys.stderr)
    if tip.line != ref.line:
        print(f"branch tip: line {tip.line} {tip.uuid} ({tip.timestamp})", file=sys.stderr)
    print(f"resume it:  cd {sess.cwd(among=kept)} && claude --resume {new_sid}", file=sys.stderr)
    print(out)
    return 0


def _invoked_via_shebang() -> bool:
    """Detect bare `./branch_extract.py` invocation: argv[1] is our own path."""
    if len(sys.argv) != 2:
        return False
    return Path(sys.argv[1]).resolve() == Path(__file__).resolve()


if __name__ == "__main__":
    # `--doctest` runs the tests in every module of this package, even the
    # ones whose bare invocation already means that.
    if len(sys.argv) > 1 and "--doctest" not in sys.argv and not _invoked_via_shebang():
        raise SystemExit(main())
    import doctest

    raise SystemExit(1 if doctest.testmod(verbose=True).failed else 0)
