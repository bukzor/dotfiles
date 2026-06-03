#!/usr/bin/env -S PYTHONPATH=/home/bukzor/lib/pythonpath python3 -m bukzor.claude.branch_list
"""Print a Claude Code session JSONL as a tree, marking branch points.

Usage:
    python3 -m bukzor.claude.branch_list <session.jsonl> [--branches-only]
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

from . import session as session_mod
from . import tree as tree_mod


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("path", type=Path, help="session JSONL file")
    p.add_argument(
        "--branches-only",
        action="store_true",
        help="show only branch points, their children, and tips",
    )
    return p.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    sess = session_mod.load(args.path)
    if not sess.nodes:
        print(f"empty or unparseable: {args.path}", file=sys.stderr)
        return 1

    bps = sess.branch_points()
    print(f"# session: {sess.session_id or '?'}", file=sys.stderr)
    print(f"# file:    {args.path}", file=sys.stderr)
    print(f"# nodes:   {len(sess.nodes)}", file=sys.stderr)
    print(f"# branches: {len(bps)}  tips: {len(sess.tips())}", file=sys.stderr)
    print(file=sys.stderr)

    tree_mod.render(sess, branches_only=args.branches_only)
    return 0


def _invoked_via_shebang() -> bool:
    """Detect bare `./branch_list.py` invocation: argv[1] is our own path."""
    if len(sys.argv) != 2:
        return False
    return Path(sys.argv[1]).resolve() == Path(__file__).resolve()


if __name__ == "__main__":
    if len(sys.argv) > 1 and not _invoked_via_shebang():
        raise SystemExit(main())
    import doctest

    raise SystemExit(1 if doctest.testmod(verbose=True).failed else 0)
