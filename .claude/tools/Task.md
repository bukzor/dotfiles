# Task Tool - Buck's Usage Preferences

## Available Agent Types
- **general-purpose**: Research, code search, multi-step tasks (Tools: *)
- **statusline-setup**: Configure Claude Code status line (Tools: Read, Edit)
- **output-style-setup**: Create Claude Code output styles (Tools: Read, Write, Edit, Glob, LS, Grep)

## When to Use Task Tool
- Complex multi-step research requiring multiple rounds of search/analysis
- When you're not confident you'll find the right match in first few tries
- Broad searches across unknown codebases
- Tasks matching specialized agent descriptions

## When NOT to Use Task Tool
- Reading specific file paths → use Read/Glob instead
- Searching for specific class definitions → use Glob instead  
- Searching within 2-3 specific files → use Read instead
- Tasks unrelated to agent descriptions

## Usage Guidelines
- **Launch multiple agents concurrently** when possible (batch tool calls)
- **Provide detailed autonomous task descriptions** - agents are stateless
- **Specify exactly what information to return** in final message
- **Clearly indicate** if you expect code writing vs research only
- Agent outputs should generally be trusted