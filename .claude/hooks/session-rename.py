#!/usr/bin/env python3
"""UserPromptSubmit hook: apply a rename queued by `claude-rename`.

A running session keeps its name in process memory; a hook's sessionTitle is
the one path in from outside. Each request applies once.
"""

import json
import sys
from pathlib import Path

REQUESTS = Path.home() / ".claude" / "rename-requests"


def main():
    request = REQUESTS / json.load(sys.stdin)["session_id"]
    if request.exists():
        name = request.read_text().strip()
        request.unlink()
        output = {"hookEventName": "UserPromptSubmit", "sessionTitle": name}
        json.dump({"hookSpecificOutput": output}, sys.stdout)


if __name__ == "__main__":
    main()
