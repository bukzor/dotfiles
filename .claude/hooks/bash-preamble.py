#!/usr/bin/env python3
"""PreToolUse hook: wrap every Bash command with safe shell defaults."""

import json
import sys

MARKER = "BASH_7acb2d94_31b3_4e33_86e0_76dc8d8c6577"

input = json.load(sys.stdin)
cmd = input["tool_input"]["command"]

wrapped = f"""\
bash <<'{MARKER}'
export PS4='+$ '
set -euo pipefail
set -x
{cmd}
{{ set +x; }} 2>/dev/null
{MARKER}"""

json.dump(
    {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
            "updatedInput": {"command": wrapped},
        }
    },
    sys.stdout,
)
