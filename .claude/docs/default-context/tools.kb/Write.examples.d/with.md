# Example: Create a new Python script (WITH Write tool)

---
user: Create /tmp/greet.py that takes a name argument and prints a greeting
---
assistant: I'll create that script for you.

{antml:function_calls}
{antml:invoke name="Write"}
{antml:parameter name="file_path"}/tmp/greet.py{/antml:parameter}
{antml:parameter name="content"}#!/usr/bin/env python3
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: greet.py <name>")
        sys.exit(1)
    name = sys.argv[1]
    print(f"Hello, {name}!")

if __name__ == "__main__":
    main()
{/antml:parameter}
{/antml:invoke}
{/antml:function_calls}
---
tool_result: File written successfully to /tmp/greet.py
---
assistant: Done. Run it with `python /tmp/greet.py YourName`.
