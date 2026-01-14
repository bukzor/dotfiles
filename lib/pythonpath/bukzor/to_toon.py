#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.13"
# ///
"""Convert arbitrary data to TOON format using Claude."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path
from shlex import quote
from typing import NoReturn

type Several[A] = tuple[A, ...]

TOON_SPEC = Path("~/.claude/must-read.d/before/toon-format.md").expanduser()

INSTRUCTIONS = """\
Convert the data in $INPUT to TOON format.
For any scratch files, use $SCRATCH

Suggestions:
- Run `file` to detect format (may be gzip, etc.)
- Run `wc` to gauge size (lines, words, bytes)
- If HTML: consider `lynx -dump` or `w3m -dump` for text extraction
- If too large or noisy: use `grep -E`, `grep -Ev`, `sed` to extract relevant portions

Then convert to TOON format.
Output ONLY raw .toon content—no markdown fences, no explanation.
Your stdout pipes directly to a .toon file."""

ALLOWED_TOOLS: Several[str] = (
    "zcat",
    "gunzip",
    "gzip",
    "cp",
    "mv",
    "lynx",
    "w3m",
    "file",
    "wc",
    "grep",
    "sed",
)


def format_allowed_tools(tools: Several[str]) -> str:
    return " ".join(f"Bash({tool}:*)" for tool in tools)


def sh_ex(cmd: Several[object]) -> None:
    """Run command with set -ex semantics: echo, exit on error."""
    import os

    cmd_strs: Several[str] = tuple(quote(str(arg)) for arg in cmd)
    if int(os.environ.get("DEBUG", "0")) > 0:
        print(f"+ {' '.join(cmd_strs)}", file=sys.stderr)

    subprocess.run(
        tuple(str(arg) for arg in cmd),
        check=True,  # -e: exit on error
    )


def build_prompt(scratch: Path, path: Path) -> str:
    """Variant-only user prompt (paths change per invocation)."""
    return f"INPUT={path}\nSCRATCH={scratch}"


def build_system_prompt() -> str:
    """Invariant system prompt (cache-friendly)."""
    return f"{TOON_SPEC.read_text()}\n\n{INSTRUCTIONS}"


def proc_write_input(scratch: Path, data: bytes) -> Path:
    """Write input data to scratch file, return input path."""
    path = scratch / "input"
    path.write_bytes(data)
    return path


def usage(exitcode: int) -> NoReturn:
    print("Usage: to-toon SCRATCH_DIR < data", file=sys.stderr)
    raise SystemExit(exitcode)


def main() -> None:
    if len(sys.argv) != 2 or sys.stdin.isatty():
        usage(1)

    scratch = Path(sys.argv[1])
    print(f"scratch: {scratch}", file=sys.stderr)
    path = proc_write_input(scratch, sys.stdin.buffer.read())
    sh_ex((
        "claude", "-p",
        "--verbose",
        "--output-format", "stream-json",
        "--setting-sources", "local",  # suppress user CLAUDE.md (avoids must-read.d overhead)
        "--append-system-prompt", build_system_prompt(),  # invariant (cache-friendly)
        "--allowedTools", format_allowed_tools(ALLOWED_TOOLS),
        "--", build_prompt(scratch, path),
    ))


if __name__ == "__main__":
    main()
