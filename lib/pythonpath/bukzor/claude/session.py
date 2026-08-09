#!/usr/bin/env -S PYTHONPATH=/home/bukzor/lib/pythonpath python3 -m bukzor.claude.session
"""Load a Claude Code session JSONL as a parent->children tree.

The JSONL stores conversation lines in append order. Each line typically has
its own `uuid` and a `parentUuid` linking to the previous line. When the
user rewinds, new lines are written as siblings of the old continuation —
multiple children share the same parent. `/resume` only walks the most
recently appended chain, leaving alternate branches reachable only via
the file's parent/child structure.

This module exposes the tree so callers can list branches, walk ancestors
of any chosen tip, and extract a linearized history into a new JSONL.
"""
from __future__ import annotations

import json
import sys
from collections import defaultdict
from collections.abc import Iterator, Mapping
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


Record = Mapping[str, Any]


@dataclass(frozen=True)
class Node:
    line: int
    record: Record

    @property
    def uuid(self) -> str | None:
        return self.record.get("uuid")

    @property
    def parent_uuid(self) -> str | None:
        return self.record.get("parentUuid")

    @property
    def type(self) -> str:
        return self.record.get("type", "?")

    @property
    def timestamp(self) -> str | None:
        return self.record.get("timestamp")


@dataclass
class Session:
    path: Path
    nodes: list[Node] = field(default_factory=list)
    by_uuid: dict[str, Node] = field(default_factory=dict)
    children: dict[str, list[str]] = field(default_factory=lambda: defaultdict(list))

    @property
    def session_id(self) -> str | None:
        for n in self.nodes:
            sid = n.record.get("sessionId")
            if sid:
                return sid
        return None

    def root_nodes(self) -> list[Node]:
        """Nodes whose parent is missing (file start, or pointed-outside).

        >>> from pathlib import Path
        >>> sess = build_session(Path("x"), iter([
        ...     Node(0, {"uuid": "a", "parentUuid": None}),
        ...     Node(1, {"uuid": "b", "parentUuid": "a"}),
        ...     Node(2, {"uuid": "c", "parentUuid": "ghost"}),
        ... ]))
        >>> [n.uuid for n in sess.root_nodes()]
        ['a', 'c']
        """
        return [
            n for n in self.nodes
            if n.parent_uuid is None or n.parent_uuid not in self.by_uuid
        ]

    def branch_points(self) -> list[tuple[Node, list[Node]]]:
        """Parents with >1 child. Returns (parent_node, [child_nodes]).

        >>> from pathlib import Path
        >>> sess = build_session(Path("x"), iter([
        ...     Node(0, {"uuid": "a", "parentUuid": None}),
        ...     Node(1, {"uuid": "b", "parentUuid": "a"}),
        ...     Node(2, {"uuid": "c", "parentUuid": "a"}),
        ...     Node(3, {"uuid": "d", "parentUuid": "b"}),
        ... ]))
        >>> [(p.uuid, [c.uuid for c in kids]) for p, kids in sess.branch_points()]
        [('a', ['b', 'c'])]
        """
        out: list[tuple[Node, list[Node]]] = []
        for parent_uuid, child_uuids in self.children.items():
            if len(child_uuids) > 1 and parent_uuid in self.by_uuid:
                parent = self.by_uuid[parent_uuid]
                kids = [self.by_uuid[u] for u in child_uuids if u in self.by_uuid]
                out.append((parent, kids))
        out.sort(key=lambda pair: pair[0].line)
        return out

    def ancestors_of(self, uuid: str) -> list[Node]:
        """Walk parent links from uuid back to a root. Returns root-first order.

        >>> from pathlib import Path
        >>> sess = build_session(Path("x"), iter([
        ...     Node(0, {"uuid": "a", "parentUuid": None}),
        ...     Node(1, {"uuid": "b", "parentUuid": "a"}),
        ...     Node(2, {"uuid": "c", "parentUuid": "b"}),
        ... ]))
        >>> [n.uuid for n in sess.ancestors_of("c")]
        ['a', 'b', 'c']
        >>> [n.uuid for n in sess.ancestors_of("b")]
        ['a', 'b']
        >>> sess.ancestors_of("missing")
        []
        """
        chain: list[Node] = []
        seen: set[str] = set()
        cur: str | None = uuid
        while cur and cur in self.by_uuid and cur not in seen:
            seen.add(cur)
            n = self.by_uuid[cur]
            chain.append(n)
            cur = n.parent_uuid
        chain.reverse()
        return chain

    def tips(self) -> list[Node]:
        """All leaf nodes (no children) sorted by line.

        >>> from pathlib import Path
        >>> sess = build_session(Path("x"), iter([
        ...     Node(0, {"uuid": "a", "parentUuid": None}),
        ...     Node(1, {"uuid": "b", "parentUuid": "a"}),
        ...     Node(2, {"uuid": "c", "parentUuid": "a"}),
        ... ]))
        >>> [n.uuid for n in sess.tips()]
        ['b', 'c']
        """
        return sorted(
            (n for n in self.nodes if not self.children.get(n.uuid or "", [])),
            key=lambda n: n.line,
        )

    def descendants_of(self, uuid: str) -> list[Node]:
        """The subtree rooted at uuid, including uuid itself, sorted by line.

        >>> from pathlib import Path
        >>> sess = build_session(Path("x"), iter([
        ...     Node(0, {"uuid": "a", "parentUuid": None}),
        ...     Node(1, {"uuid": "b", "parentUuid": "a"}),
        ...     Node(2, {"uuid": "c", "parentUuid": "a"}),
        ...     Node(3, {"uuid": "d", "parentUuid": "b"}),
        ... ]))
        >>> [n.uuid for n in sess.descendants_of("b")]
        ['b', 'd']
        """
        out: list[Node] = []
        stack = [uuid]
        seen: set[str] = set()
        while stack:
            cur = stack.pop()
            if cur in seen or cur not in self.by_uuid:
                continue
            seen.add(cur)
            out.append(self.by_uuid[cur])
            stack.extend(self.children.get(cur, []))
        out.sort(key=lambda n: n.line)
        return out

    def tip_of(self, uuid: str) -> Node | None:
        """The record `--resume` would land on if this branch stood alone.

        Claude Code chooses a chain by taking the newest message and walking
        `parentUuid` back, so a branch's identity is its newest descendant --
        not its deepest, and not its last-appended. Attachments carry
        timestamps too, but resume only ever anchors on user/assistant
        records, so those win when present.

        >>> from pathlib import Path
        >>> sess = build_session(Path("x"), iter([
        ...     Node(0, {"uuid": "a", "parentUuid": None,
        ...              "type": "user", "timestamp": "2026-01-01T00:00:00Z"}),
        ...     Node(1, {"uuid": "b", "parentUuid": "a",
        ...              "type": "assistant", "timestamp": "2026-01-01T00:00:02Z"}),
        ...     Node(2, {"uuid": "c", "parentUuid": "a",
        ...              "type": "assistant", "timestamp": "2026-01-01T00:00:09Z"}),
        ...     Node(3, {"uuid": "d", "parentUuid": "b",
        ...              "type": "attachment", "timestamp": "2026-01-01T00:00:99Z"}),
        ... ]))
        >>> sess.tip_of("a").uuid
        'c'
        >>> sess.tip_of("b").uuid
        'b'
        >>> print(sess.tip_of("missing"))
        None
        """
        kin = self.descendants_of(uuid)
        speakers = [n for n in kin if n.type in ("user", "assistant")]
        return max(
            speakers or kin,
            key=lambda n: (n.timestamp or "", n.line),
            default=None,
        )

    def cwd(self, among: list[Node] | None = None) -> str | None:
        """The directory this session ran in -- required to resume it.

        Read from the file, never decoded from the projects/<slug>/ dir name:
        the slug maps both '/' and '.' to '-', so it is not invertible. The
        last value wins, since a resume from elsewhere rewrites it -- which
        is why `among` exists: branches of one file can live in different
        directories, and the whole-file answer is then the live branch's.

        >>> from pathlib import Path
        >>> sess = build_session(Path("x"), iter([
        ...     Node(0, {"uuid": "a", "parentUuid": None, "cwd": "/one"}),
        ...     Node(1, {"uuid": "b", "parentUuid": "a"}),
        ...     Node(2, {"uuid": "c", "parentUuid": "b", "cwd": "/two"}),
        ... ]))
        >>> sess.cwd()
        '/two'
        >>> sess.cwd(among=sess.ancestors_of("b"))
        '/one'
        """
        found = [n.record["cwd"] for n in (among or self.nodes) if n.record.get("cwd")]
        return found[-1] if found else None


def is_user_text(node: Node) -> bool:
    """A genuine user message (not a tool_result wrapped as type=user).

    String content and a text-block list both count; anything starting with
    a tool_result block does not.

    >>> is_user_text(Node(0, {"type": "user", "message": {"content": "hi"}}))
    True
    >>> is_user_text(Node(0, {"type": "user", "message": {"content": [
    ...     {"type": "text", "text": "hi"},
    ... ]}}))
    True
    >>> is_user_text(Node(0, {"type": "user", "message": {"content": [
    ...     {"type": "tool_result", "content": "x"},
    ... ]}}))
    False
    >>> is_user_text(Node(0, {"type": "assistant", "message": {"content": "hi"}}))
    False
    """
    if node.type != "user":
        return False
    msg = node.record.get("message")
    if not isinstance(msg, Mapping):
        return False
    c = msg.get("content")
    if isinstance(c, str):
        return True
    if isinstance(c, list) and c and isinstance(c[0], Mapping):
        return c[0].get("type") == "text"
    return False


def parse_jsonl(text_lines: Iterator[tuple[int, str]]) -> Iterator[Node]:
    """Pure: yield Nodes from (line_no, raw_line) pairs.

    Silently skips blank lines. Malformed JSON is logged to stderr and
    skipped — Claude Code occasionally leaves partial writes after crashes,
    so failing hard would make recovery tools useless. Bugs in this module
    should still surface as tracebacks; only JSONDecodeError is caught.
    """
    for line_no, raw in text_lines:
        raw = raw.strip()
        if not raw:
            continue
        try:
            rec = json.loads(raw)
        except json.JSONDecodeError as e:
            print(f"warn: skipping malformed JSONL at line {line_no}: {e}", file=sys.stderr)
            continue
        yield Node(line=line_no, record=rec)


def build_session(path: Path, nodes: Iterator[Node]) -> Session:
    """Pure-ish: assemble a Session from Nodes. Mutates only the new Session."""
    sess = Session(path=path)
    for node in nodes:
        sess.nodes.append(node)
        if node.uuid:
            sess.by_uuid[node.uuid] = node
        if node.uuid and node.parent_uuid:
            sess.children[node.parent_uuid].append(node.uuid)
    return sess


def load(path: Path | str) -> Session:
    """Read a JSONL session file from disk."""
    path = Path(path)
    with path.open() as f:
        nodes = parse_jsonl(enumerate(f))
        return build_session(path, nodes)


def project_dir_for(path: Path | str) -> Path:
    """Return the projects/<slug>/ dir containing the given session jsonl."""
    return Path(path).resolve().parent


if __name__ == "__main__":
    import doctest

    raise SystemExit(1 if doctest.testmod(verbose=True).failed else 0)
