#!/usr/bin/env python3
"""PreToolUse hook: wrap every Bash command with safe shell defaults.

Wraps commands in a heredoc to bypass claude-code's shell-quote bugs,
and injects set -euo pipefail and xtrace. Preserves the deny/ask
permission lists from settings.json since updatedInput requires
permissionDecision: "allow".

See bash-preamble.TESTING.md for manual tests and design rationale.
"""

import json
import re
import sys
from pathlib import Path

MARKER = "BASH_7acb2d94_31b3_4e33_86e0_76dc8d8c6577"

SETTINGS_PATHS = (
    Path.home() / ".claude" / "settings.json",
    Path.home() / ".claude" / "settings.local.json",
    Path(".claude") / "settings.json",
    Path(".claude") / "settings.local.json",
)


def parse_bash_prefixes(patterns):
    """Extract command prefixes from Bash permission patterns.

    >>> parse_bash_prefixes(["Bash(rm -rf:*)", "Bash(sudo:*)"])
    ['rm -rf', 'sudo']
    >>> parse_bash_prefixes(["Bash(git add -A:*)"])
    ['git add -A']
    >>> parse_bash_prefixes(["WebSearch", "Glob", "Bash(ls:*)"])
    ['ls']
    >>> parse_bash_prefixes([])
    []
    """
    prefixes = []
    for pattern in patterns:
        m = re.match(r"^Bash\((.+?):\*\)$", pattern)
        if m:
            prefixes.append(m.group(1))
    return prefixes


def check_permission(cmd, deny_prefixes, ask_prefixes):
    """Check command against deny and ask lists.

    Returns "deny", "ask", or "allow".

    >>> check_permission("rm -rf /", ["rm -rf", "sudo"], [])
    'deny'
    >>> check_permission("sudo apt install", ["rm -rf", "sudo"], [])
    'deny'
    >>> check_permission("git push origin main", [], ["git push"])
    'ask'
    >>> check_permission("echo hello", ["rm -rf"], ["git push"])
    'allow'
    >>> check_permission("rm -r foo", ["rm -rf"], [])
    'allow'
    >>> check_permission("rm -rf", ["rm -rf"], [])
    'deny'
    >>> check_permission("sudoku", ["sudo"], [])
    'allow'
    """
    stripped = cmd.lstrip()
    for prefix in deny_prefixes:
        if stripped == prefix or stripped.startswith(prefix + " "):
            return "deny"
    for prefix in ask_prefixes:
        if stripped == prefix or stripped.startswith(prefix + " "):
            return "ask"
    return "allow"


def load_permission_prefixes():
    """Load deny and ask prefixes from all settings files.

    >>> d, a = load_permission_prefixes()
    >>> isinstance(d, list) and isinstance(a, list)
    True
    """
    deny = []
    ask = []
    for path in SETTINGS_PATHS:
        if not path.exists():
            continue
        with path.open() as f:
            settings = json.load(f)
        perms = settings.get("permissions", {})
        deny.extend(parse_bash_prefixes(perms.get("deny", [])))
        ask.extend(parse_bash_prefixes(perms.get("ask", [])))
    return deny, ask


def wrap_command(cmd):
    """Wrap a command in a heredoc with safe shell defaults.

    >>> result = wrap_command("echo hi")
    >>> "set -euo pipefail" in result
    True
    >>> "echo hi" in result
    True
    >>> result.startswith("bash <<")
    True
    >>> result.endswith(MARKER)
    True
    """
    return f"""\
bash <<'{MARKER}'
export PS4='+ $ '
set -euo pipefail
shopt -s failglob
set -x
{cmd}
{{ set +x; }} 2>/dev/null
{MARKER}"""


def main():
    input = json.load(sys.stdin)
    cmd = input["tool_input"]["command"]

    deny_prefixes, ask_prefixes = load_permission_prefixes()
    permission = check_permission(cmd, deny_prefixes, ask_prefixes)

    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": permission,
                "updatedInput": {"command": wrap_command(cmd)},
            }
        },
        sys.stdout,
    )


if __name__ == "__main__":
    main()
