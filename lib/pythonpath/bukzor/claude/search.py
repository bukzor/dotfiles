#!/usr/bin/env -S PYTHONPATH=/home/bukzor/lib/pythonpath python3 -m bukzor.claude.search
"""Find which past session discussed a half-remembered thing.

The transcripts under ~/.claude/projects are the only record of most
work: what was tried, what was decided, what a command actually printed.
`grep` over the raw JSONL is nearly useless there -- it matches
JSON-escaped text, misses anything split across blocks, and prints a
4000-column line when it hits. This searches the *decoded* text of every
record and reports hits grouped by session, so one match tells you which
conversation to reopen and from where.

Usage:
    python3 -m bukzor.claude.search PATTERN [--days N | --all]
                                    [--role any|user|assistant]
                                    [--matches N] [--sh]
"""
from __future__ import annotations

import argparse
import json
import re
import sys
import time
from dataclasses import dataclass
from datetime import datetime, tzinfo
from pathlib import Path
from typing import NamedTuple

from . import session as session_mod
from .format_short import content_blocks, result_text, truncate
from .inventory import PROJECTS_DIR, Summary, format_row, format_sh, summarize
from .session import Node, Session, is_user_text


class Match(NamedTuple):
    line: int
    role: str
    text: str


@dataclass(frozen=True)
class Hit:
    summary: Summary
    matches: list[Match]


def searchable_text(node: Node) -> str:
    """Everything in one record a human might remember, decoded and joined.

    Archeology starts from a phrase, rarely from knowledge of who said it
    or whether it was prose, a command, or command output -- so thinking,
    tool inputs and tool results are all in scope.

    >>> searchable_text(Node(0, {"type": "user", "message": {"content": "hi"}}))
    'hi'
    >>> searchable_text(Node(0, {"type": "assistant", "message": {"content": [
    ...     {"type": "thinking", "thinking": "hmm"},
    ...     {"type": "text", "text": "answer"},
    ...     {"type": "tool_use", "name": "Bash", "input": {"command": "ls -la"}},
    ... ]}}))
    'hmm\\nanswer\\n{"command": "ls -la"}'
    >>> searchable_text(Node(0, {"type": "user", "message": {"content": [
    ...     {"type": "tool_result", "content": "out"},
    ... ]}}))
    'out'
    >>> searchable_text(Node(0, {"type": "summary", "summary": "what happened"}))
    'what happened'
    >>> searchable_text(Node(0, {"type": "file-history-snapshot"}))
    ''
    """
    parts = [
        value
        for key in ("summary", "title")
        if isinstance(value := node.record.get(key), str)
    ]
    for block in content_blocks(node.record):
        match block.get("type"):
            case "text":
                parts.append(block.get("text") or "")
            case "thinking":
                parts.append(block.get("thinking") or "")
            case "tool_use":
                parts.append(json.dumps(block.get("input") or {}))
            case "tool_result":
                parts.append(result_text(block))
            case _:
                pass
    return "\n".join(p for p in parts if p)


def snippet(text: str, at: re.Match[str], width: int = 100) -> str:
    """The matched line, trimmed around the match so the hit stays visible.

    >>> text = "alpha\\nthe needle here\\nomega"
    >>> snippet(text, re.search("needle", text))
    'the needle here'
    >>> padded = "x" * 200 + "needle"
    >>> snippet(padded, re.search("needle", padded), width=20)
    '…xxxxxxxxxxneedle'
    """
    line_start = text.rfind("\n", 0, at.start()) + 1
    line_end = text.find("\n", at.end())
    line = text[line_start : line_end if line_end != -1 else len(text)]
    offset = at.start() - line_start
    if offset > width // 2:
        line = "…" + line[offset - width // 2 :]
    return truncate(line, width)


def role_of(node: Node) -> str:
    """Who is speaking, as a searcher thinks of it rather than as stored.

    Tool results are stored as `type: user` records, so the raw type
    can't answer "what did I actually ask for" -- the single most useful
    filter in this tool.

    >>> role_of(Node(0, {"type": "user", "message": {"content": "do it"}}))
    'user'
    >>> role_of(Node(0, {"type": "user", "message": {"content": [
    ...     {"type": "tool_result", "content": "output"},
    ... ]}}))
    'tool'
    >>> role_of(Node(0, {"type": "assistant", "message": {"content": "sure"}}))
    'assistant'
    """
    if node.type == "user":
        return "user" if is_user_text(node) else "tool"
    else:
        return node.type


def find(sess: Session, pattern: re.Pattern[str], roles: frozenset[str]) -> list[Match]:
    """Every record whose decoded text matches, in file order.

    >>> from pathlib import Path
    >>> from .session import build_session
    >>> sess = build_session(Path("x"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None, "type": "user",
    ...              "message": {"content": "where is the balloon"}}),
    ...     Node(1, {"uuid": "b", "parentUuid": "a", "type": "assistant",
    ...              "message": {"content": "the balloon deflated"}}),
    ... ]))
    >>> find(sess, re.compile("balloon"), frozenset({"user", "assistant"}))
    [Match(line=0, role='user', text='where is the balloon'), Match(line=1, role='assistant', text='the balloon deflated')]
    >>> find(sess, re.compile("balloon"), frozenset({"user"}))
    [Match(line=0, role='user', text='where is the balloon')]
    >>> find(sess, re.compile("zeppelin"), frozenset({"user"}))
    []
    """
    out: list[Match] = []
    for node in sess.nodes:
        role = role_of(node)
        if roles and role not in roles:
            continue
        text = searchable_text(node)
        found = pattern.search(text)
        if found:
            out.append(Match(node.line, role, snippet(text, found)))
    return out


def scan(
    projects_dir: Path,
    cutoff: float | None,
    pattern: re.Pattern[str],
    roles: frozenset[str],
) -> list[Hit]:
    """Search every recent-enough session file. Newest first."""
    out: list[Hit] = []
    for path in projects_dir.glob("*/*.jsonl"):
        mtime = path.stat().st_mtime
        if cutoff is not None and mtime < cutoff:
            continue
        sess = session_mod.load(path)
        matches = find(sess, pattern, roles)
        if not matches:
            continue
        summary = summarize(sess, mtime, resumable_only=False)
        if summary:
            out.append(Hit(summary, matches))
    return sorted(out, key=lambda h: h.summary.mtime, reverse=True)


def format_hit(hit: Hit, tz: tzinfo, home: str, limit: int) -> str:
    """The session's inventory row, then its matches indented beneath it."""
    lines = [format_row(hit.summary, tz, home)]
    for match in hit.matches[:limit]:
        lines.append(f"    {match.line:>6}  {match.role:<9}  {match.text}")
    if len(hit.matches) > limit:
        lines.append(f"    {'':>6}  ... {len(hit.matches) - limit} more")
    return "\n".join(lines)


ROLES = {
    "any": frozenset[str](),
    "user": frozenset({"user"}),
    "assistant": frozenset({"assistant"}),
    "tool": frozenset({"tool"}),
    "talk": frozenset({"user", "assistant"}),
}


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    p.add_argument("pattern", help="python regex, searched case-insensitively")
    p.add_argument("--days", type=float, default=30.0, help="how far back (default 30)")
    p.add_argument("--all", action="store_true", help="no time limit")
    p.add_argument("--role", choices=sorted(ROLES), default="any")
    p.add_argument("--matches", type=int, default=3, help="max hits shown per session")
    p.add_argument("--sh", action="store_true", help="emit resume commands instead")
    p.add_argument("--projects-dir", type=Path, default=PROJECTS_DIR)
    return p.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    cutoff = None if args.all else time.time() - args.days * 86400
    pattern = re.compile(args.pattern, re.IGNORECASE)
    hits = scan(args.projects_dir, cutoff, pattern, ROLES[args.role])
    tz = datetime.now().astimezone().tzinfo
    assert tz, tz
    home = str(Path.home())
    for hit in hits:
        if args.sh:
            print(format_sh(hit.summary, tz, home))
        else:
            print(format_hit(hit, tz, home, args.matches))
    total = sum(len(h.matches) for h in hits)
    print(f"# {total} matches in {len(hits)} sessions", file=sys.stderr)
    return 0 if hits else 1


def _invoked_via_shebang() -> bool:
    """Detect bare `./search.py` invocation: argv[1] is our own path."""
    if len(sys.argv) != 2:
        return False
    return Path(sys.argv[1]).resolve() == Path(__file__).resolve()


if __name__ == "__main__":
    if "--doctest" in sys.argv:
        import doctest

        raise SystemExit(1 if doctest.testmod(verbose=True).failed else 0)
    if _invoked_via_shebang():
        sys.argv = sys.argv[:1]
    raise SystemExit(main(sys.argv[1:]))
