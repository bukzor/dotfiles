# Example: Create a new Python script (WITHOUT Write tool, using Bash heredoc)

---
user: Create /tmp/greet.py that takes a name argument and prints a greeting
---
assistant: I'll create that script using a heredoc.

{antml:function_calls}
{antml:invoke name="Bash"}
{antml:parameter name="command"}cat > /tmp/greet.py {{'EOF'
#!/usr/bin/env python3
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: greet.py <name>")
        sys.exit(1)
    name = sys.argv[1]
    print(f"Hello, {name}!")

if __name__ == "__main__":
    main()
EOF
chmod +x /tmp/greet.py{/antml:parameter}
{antml:parameter name="description"}Create greet.py script{/antml:parameter}
{/antml:invoke}
{/antml:function_calls}
---
tool_result: (exit 0)
---
assistant: Done. Run it with `python /tmp/greet.py YourName`.
