# Example: Check latest Python version (WITH WebFetch)

---
user: What's the latest stable Python version?
---
assistant: I'll check the Python downloads page.

{antml:function_calls}
{antml:invoke name="WebFetch"}
{antml:parameter name="url"}https://www.python.org/downloads/{/antml:parameter}
{antml:parameter name="prompt"}What is the latest stable Python version number?{/antml:parameter}
{/antml:invoke}
{/antml:function_calls}
---
tool_result: The latest stable Python version is 3.12.4, released on June 6, 2024.
---
assistant: The latest stable Python version is **3.12.4** (released June 6, 2024).
