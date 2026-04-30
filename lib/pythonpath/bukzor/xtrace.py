"""xtrace-style fork/exec helpers.

Usage:
    from bukzor.xtrace import run
    run("mv", "-T", src, dst)

Each `run` call prints the command to stderr with a teal `$` prefix, then
fork/execs via subprocess with check=True. One operation per call.
"""
from __future__ import annotations

import shlex
import subprocess
import sys
from pathlib import Path

PS4 = "\033[36m$\033[0m "  # teal '$' — matches the bash PS4 idiom used elsewhere


def run(*argv: str | Path) -> None:
    """xtrace + fork/exec. One operation per call. Raises on non-zero."""
    cmd = [str(a) for a in argv]
    print(PS4 + shlex.join(cmd), file=sys.stderr)
    subprocess.run(cmd, check=True)


def query(*argv: str | Path) -> str:
    """Read-only subprocess query (no xtrace; doesn't mutate state)."""
    cmd = [str(a) for a in argv]
    return subprocess.run(
        cmd, check=True, capture_output=True, text=True
    ).stdout.strip()
