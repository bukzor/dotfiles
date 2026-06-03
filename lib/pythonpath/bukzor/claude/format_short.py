#!/usr/bin/env -S PYTHONPATH=/home/bukzor/lib/pythonpath python3 -m bukzor.claude.format_short
"""Terse one-line labels for tree-view rendering of session nodes.

These produce ~80-column summaries suitable for indented tree output.
For full pretty-printing of a node, see `claude-jsonl-display`.
"""
from __future__ import annotations

import json
from collections.abc import Mapping
from typing import Any

from .session import Node


def _truncate(s: str, n: int = 80) -> str:
    """Collapse newlines to ' / ' and ellipsize past n chars.

    >>> _truncate("hello")
    'hello'
    >>> _truncate("hello world", 5)
    'hell…'
    >>> _truncate("line1\\nline2\\nline3", 50)
    'line1 / line2 / line3'
    >>> _truncate("  surrounded by space  ", 50)
    'surrounded by space'
    """
    s = s.replace("\n", " / ").strip()
    return s if len(s) <= n else s[: n - 1] + "…"


def _content_blocks(record: Mapping[str, Any]) -> list[Mapping[str, Any]]:
    """Normalize a record's message content to a list of block dicts.

    A string message.content becomes a synthetic text block — that's the
    shape user-typed prompts take in Claude Code JSONLs.

    >>> _content_blocks({"message": {"content": "hi"}})
    [{'type': 'text', 'text': 'hi'}]
    >>> _content_blocks({"message": {"content": [{"type": "text", "text": "a"}]}})
    [{'type': 'text', 'text': 'a'}]
    >>> _content_blocks({})
    []
    >>> _content_blocks({"message": "not-a-mapping"})
    []
    """
    msg = record.get("message")
    if not isinstance(msg, Mapping):
        return []
    c = msg.get("content")
    if isinstance(c, str):
        return [{"type": "text", "text": c}]
    if isinstance(c, list):
        return [b for b in c if isinstance(b, Mapping)]
    return []


def _label_tool_use(block: Mapping[str, Any]) -> str:
    """One-line label for a tool_use block, specialized per tool name.

    >>> _label_tool_use({"name": "Bash", "input": {"command": "ls -la\\nfoo"}})
    'Bash: ls -la'
    >>> _label_tool_use({"name": "Edit", "input": {"file_path": "/x/y.py"}})
    'Edit: /x/y.py'
    >>> _label_tool_use({"name": "Agent", "input": {"description": "go fish"}})
    'Agent: go fish'
    >>> _label_tool_use({"name": "Bash", "input": {}})
    'Bash: '
    """
    name = block.get("name", "?")
    inp = block.get("input") or {}
    match name:
        case "Bash":
            cmd = (inp.get("command") or "").splitlines()[0] if inp else ""
            return f"Bash: {cmd}"
        case "Edit" | "Read" | "Write" | "NotebookEdit":
            return f"{name}: {inp.get('file_path', '?')}"
        case "Agent":
            return f"Agent: {inp.get('description', '?')}"
        case "Grep" | "Glob":
            return f"{name}: {json.dumps(inp)[:60]}"
        case _:
            return f"{name}({json.dumps(inp)[:60]})"


def _label_user(record: Mapping[str, Any]) -> str:
    """First text block wins; otherwise show a truncated tool_result.

    >>> _label_user({"message": {"content": "hi there"}})
    'hi there'
    >>> _label_user({"message": {"content": [
    ...     {"type": "tool_result", "content": "output text", "is_error": False},
    ... ]}})
    'tool_result: output text'
    >>> _label_user({"message": {"content": [
    ...     {"type": "tool_result", "content": "boom", "is_error": True},
    ... ]}})
    'tool_result ERR: boom'
    >>> _label_user({})
    '(user, empty)'
    """
    for b in _content_blocks(record):
        t = b.get("type")
        if t == "text":
            return _truncate(b.get("text") or "")
        if t == "tool_result":
            tr = b.get("content")
            text = ""
            if isinstance(tr, str):
                text = tr
            elif isinstance(tr, list):
                for x in tr:
                    if isinstance(x, Mapping) and "text" in x:
                        text = x["text"]
                        break
            err = " ERR" if b.get("is_error") else ""
            return _truncate(f"tool_result{err}: {text}")
    return "(user, empty)"


def _label_assistant(record: Mapping[str, Any]) -> str:
    """Join non-empty per-block labels with ' | '. Parallel tool calls show together.

    >>> _label_assistant({"message": {"content": [
    ...     {"type": "text", "text": "answer"},
    ...     {"type": "tool_use", "name": "Bash", "input": {"command": "ls"}},
    ... ]}})
    'answer | Bash: ls'
    >>> _label_assistant({"message": {"content": [
    ...     {"type": "thinking", "thinking": "hmm"},
    ... ]}})
    '[thinking]'
    """
    parts: list[str] = []
    for b in _content_blocks(record):
        match b.get("type"):
            case "text":
                parts.append(b.get("text") or "")
            case "thinking":
                parts.append("[thinking]")
            case "tool_use":
                parts.append(_label_tool_use(b))
            case _:
                pass
    return _truncate(" | ".join(p for p in parts if p))


def label(node: Node) -> str:
    """Return a short label suitable for tree-view of this node."""
    match node.type:
        case "user":
            return _label_user(node.record)
        case "assistant":
            return _label_assistant(node.record)
        case "system":
            sub = node.record.get("subtype", "")
            return f"system/{sub}" if sub else "system"
        case "summary":
            return _truncate(f"summary: {node.record.get('summary', '')}")
        case "file-history-snapshot":
            snap = node.record.get("snapshot", {})
            tracked = snap.get("trackedFileBackups", {})
            return f"snapshot ({len(tracked)} files)"
        case "attachment":
            return "attachment"
        case "permission-mode":
            return f"permission-mode: {node.record.get('permissionMode', '?')}"
        case "last-prompt":
            return "last-prompt"
        case "ai-title":
            return _truncate(f"ai-title: {node.record.get('title', '')}")
        case other:
            return other


if __name__ == "__main__":
    import doctest

    raise SystemExit(1 if doctest.testmod(verbose=True).failed else 0)
