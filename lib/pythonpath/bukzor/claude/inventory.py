#!/usr/bin/env -S PYTHONPATH=/home/bukzor/lib/pythonpath python3 -m bukzor.claude.inventory
"""List resumable Claude Code sessions across projects, newest first.

Answers "what was I working on, and how do I pick it back up?" after a
crash, freeze, or reboot: one row per session file with last-activity
time, working directory, and a human label; `--sh` emits paste-ready
resume commands instead.

Usage:
    python3 -m bukzor.claude.inventory [--days N | --all] [--sh]
"""
from __future__ import annotations

import argparse
import sys
import time
from dataclasses import dataclass
from datetime import datetime, tzinfo
from pathlib import Path

from . import session as session_mod
from .format_short import truncate
from .session import Node, Session, is_user_text

PROJECTS_DIR = Path.home() / ".claude" / "projects"

# Harness-injected user-role text; useless as a "what was this session about" label.
BOILERPLATE_PREFIXES = (
    "Base directory for this skill:",
    "This session is being continued",
    "[Request interrupted",
    "Caveat: the messages below",
    "<command-",
    "<local-command",
)


def is_substantive(text: str) -> bool:
    """Whether this user message could serve as the session's label.

    Harness-injected text, slash commands, and my own shorthand ("c",
    "s", "...") all say nothing about the topic, and the shorthand is
    what a session most often ends on -- so an unfiltered "last thing the
    user typed" label is usually the least informative line in the file.

    >>> is_substantive("fix the balloon driver")
    True
    >>> is_substantive("c"), is_substantive("...."), is_substantive("  ")
    (False, False, False)
    >>> is_substantive("/compact"), is_substantive("<command-name>x")
    (False, False)
    >>> is_substantive("This session is being continued from...")
    False
    """
    text = text.strip()
    return (
        len(text) >= 4
        and any(c.isalnum() for c in text)
        and not text.startswith("/")
        and not text.startswith(BOILERPLATE_PREFIXES)
    )


@dataclass(frozen=True)
class Summary:
    mtime: float
    session_id: str
    cwd: str | None
    label: str
    path: Path
    sidechain: bool = False


def summarize(sess: Session, mtime: float, resumable_only: bool = True) -> Summary | None:
    """Distill one session file to an inventory row; None if not resumable.

    Sidechain files (subagent transcripts) and empty files are not
    independently resumable. The label prefers an explicit title record,
    falling back to the last thing the user typed.

    Search wants the sidechains too -- a subagent's transcript is still a
    record of what happened -- so `resumable_only=False` keeps them,
    flagged, rather than dropping them.

    >>> from .session import Node, build_session
    >>> sess = build_session(Path("p/abc.jsonl"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None, "type": "user",
    ...              "sessionId": "sid-1", "cwd": "/w",
    ...              "message": {"content": "fix the bug"}}),
    ...     Node(1, {"type": "ai-title", "title": "Bug fixing"}),
    ... ]))
    >>> s = summarize(sess, mtime=1786216000.0)
    >>> s.session_id, s.cwd, s.label
    ('sid-1', '/w', 'Bug fixing')
    >>> untitled = build_session(Path("p/def.jsonl"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None, "type": "user",
    ...              "message": {"content": "do things"}}),
    ... ]))
    >>> summarize(untitled, 0.0).session_id, summarize(untitled, 0.0).label
    ('def', 'do things')
    >>> noisy = build_session(Path("p/x.jsonl"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None, "type": "user",
    ...              "message": {"content": "real question"}}),
    ...     Node(1, {"uuid": "b", "parentUuid": "a", "type": "user",
    ...              "message": {"content": "Base directory for this skill: /x"}}),
    ... ]))
    >>> summarize(noisy, 0.0).label
    'real question'
    >>> summarize(build_session(Path("x"), iter([])), 0.0) is None
    True
    >>> sidechain = build_session(Path("x"), iter([
    ...     Node(0, {"uuid": "a", "parentUuid": None, "type": "user",
    ...              "isSidechain": True, "message": {"content": "sub"}}),
    ... ]))
    >>> summarize(sidechain, 0.0) is None
    True
    >>> summarize(sidechain, 0.0, resumable_only=False).sidechain
    True
    """
    if not sess.nodes:
        return None
    is_sidechain = bool(sess.nodes[0].record.get("isSidechain"))
    if is_sidechain and resumable_only:
        return None
    titles = [
        n.record["title"]
        for n in sess.nodes
        if n.type in ("custom-title", "ai-title") and n.record.get("title")
    ]
    def text_of(n: Node) -> str:
        msg = n.record["message"]["content"]
        return msg if isinstance(msg, str) else msg[0].get("text", "")

    user_texts = [text_of(n) for n in sess.nodes if is_user_text(n)]
    speech = [t for t in user_texts if is_substantive(t)]
    if titles:
        label = titles[-1]
    elif speech or user_texts:
        label = (speech or user_texts)[-1]
    else:
        label = "(no user messages)"
    return Summary(
        mtime=mtime,
        session_id=sess.session_id or sess.path.stem,
        cwd=sess.cwd(),
        label=truncate(label, 60),
        path=sess.path,
        sidechain=is_sidechain,
    )


def _shorten(path: str, home: str) -> str:
    """
    >>> _shorten("/home/u/proj", "/home/u")
    '~/proj'
    >>> _shorten("/home/u", "/home/u")
    '~'
    >>> _shorten("/home/unrelated", "/home/u")
    '/home/unrelated'
    >>> _shorten("/etc", "/home/u")
    '/etc'
    """
    if path == home or path.startswith(home + "/"):
        return "~" + path.removeprefix(home)
    else:
        return path


def _stamp(mtime: float, tz: tzinfo) -> str:
    return datetime.fromtimestamp(mtime, tz).strftime("%Y-%m-%d %H:%M")


def format_row(s: Summary, tz: tzinfo, home: str) -> str:
    """One aligned human-readable line per session.

    >>> from datetime import timezone
    >>> s = Summary(mtime=1786216000.0, session_id="0e9272f7-aaaa-bbbb",
    ...             cwd="/home/u/proj", label="Bug fixing", path=Path("x"))
    >>> format_row(s, tz=timezone.utc, home="/home/u")
    '2026-08-08 19:06  0e9272f7  ~/proj  Bug fixing'

    A subagent transcript is marked, because `--resume` cannot open one.

    >>> import dataclasses
    >>> format_row(dataclasses.replace(s, sidechain=True), timezone.utc, "/home/u")
    '2026-08-08 19:06  0e9272f7  ~/proj  [subagent] Bug fixing'
    """
    cwd = _shorten(s.cwd, home) if s.cwd else "(cwd unknown)"
    mark = "[subagent] " if s.sidechain else ""
    return f"{_stamp(s.mtime, tz)}  {s.session_id[:8]}  {cwd}  {mark}{s.label}"


def format_sh(s: Summary, tz: tzinfo, home: str) -> str:
    """A paste-ready resume command, labeled by a comment line.

    >>> from datetime import timezone
    >>> s = Summary(mtime=1786216000.0, session_id="0e9272f7-aaaa-bbbb",
    ...             cwd="/home/u/proj", label="Bug fixing", path=Path("x"))
    >>> print(format_sh(s, tz=timezone.utc, home="/home/u"))
    # 2026-08-08 19:06  Bug fixing
    (cd ~/proj && claude --resume 0e9272f7-aaaa-bbbb)
    """
    comment = f"# {_stamp(s.mtime, tz)}  {s.label}"
    if not s.cwd:
        return f"{comment}\n# no cwd recorded; resume from its original directory: {s.path}"
    return f"{comment}\n(cd {_shorten(s.cwd, home)} && claude --resume {s.session_id})"


def scan(projects_dir: Path, cutoff: float | None) -> list[Summary]:
    """Load every recent-enough session file. Newest first."""
    out: list[Summary] = []
    for path in projects_dir.glob("*/*.jsonl"):
        mtime = path.stat().st_mtime
        if cutoff is not None and mtime < cutoff:
            continue
        summary = summarize(session_mod.load(path), mtime)
        if summary:
            out.append(summary)
    return sorted(out, key=lambda s: s.mtime, reverse=True)


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--days", type=float, default=7.0, help="how far back to look (default 7)")
    p.add_argument("--all", action="store_true", help="no time limit")
    p.add_argument("--sh", action="store_true", help="emit resume commands instead of a table")
    p.add_argument("--projects-dir", type=Path, default=PROJECTS_DIR)
    return p.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    cutoff = None if args.all else time.time() - args.days * 86400
    summaries = scan(args.projects_dir, cutoff)
    tz = datetime.now().astimezone().tzinfo
    assert tz, tz
    home = str(Path.home())
    fmt = format_sh if args.sh else format_row
    for s in summaries:
        print(fmt(s, tz, home))
    print(f"# {len(summaries)} sessions", file=sys.stderr)
    return 0


def _invoked_via_shebang() -> bool:
    """Detect bare `./inventory.py` invocation: argv[1] is our own path."""
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
