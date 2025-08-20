---
description: Download webpage optimally for Claude analysis
argument-hint: "<url>"
---

# Optimal Webpage Download for Claude

Download and convert webpages to Claude-friendly format using a two-prong strategy:

## Strategy

**URL to analyze:** $ARGUMENTS

### 1. Source Detection (Preferred)

For open-source documentation, find the raw source files:

**Check for edit links:**
- Use WebFetch to search for "Edit this page", "Edit on GitHub", or "View source" links
- Look in headers, footers, sidebars for these links
- Transform edit URLs to raw source URLs (edit/main/path → raw.githubusercontent.com/.../main/path)

**Common patterns:**
```
hamilton.dagworks.io/concepts/X/ → raw.githubusercontent.com/apache/hamilton/main/docs/concepts/X.rst
docs.python.org/library/X.html → raw.githubusercontent.com/python/cpython/main/Doc/library/X.rst  
*.readthedocs.io/path/ → raw.githubusercontent.com/{org}/{repo}/main/docs/path.{rst,md}
```

**Process:**
1. **Use WebFetch** to find edit/source links:
   ```
   WebFetch(url="$ARGUMENTS", prompt="Search specifically for any \"Edit this page\", \"Edit on GitHub\", \"View source\", or similar links on this webpage. Look in the page footer, header, sidebar, or anywhere else these links might appear. If you find any such links, provide the exact URL. If no edit/source links exist, confirm their absence.")
   ```
2. **Transform to raw URL** if edit link found:
   ```bash
   # From: github.com/apache/hamilton/edit/main/docs/concepts/materialization.rst  
   # To: raw.githubusercontent.com/apache/hamilton/main/docs/concepts/materialization.rst
   Bash(command="curl -O https://raw.githubusercontent.com/apache/hamilton/main/docs/concepts/materialization.rst")
   ```
3. **Try pattern matching** if no edit links:
   ```bash
   # Example: Try common extensions based on URL patterns
   Bash(command="curl -sf -O https://raw.githubusercontent.com/{org}/{repo}/main/docs/{path}.rst")
   Bash(command="curl -sf -O https://raw.githubusercontent.com/{org}/{repo}/main/docs/{path}.md") 
   ```

### 2. HTML Processing Fallback

When source unavailable, use optimized HTML conversion:

```bash
Bash(command="lynx -dump -nolist -nonumbers -dont_wrap_pre -width=100 '$ARGUMENTS' > content.txt")
```

**Why this command:**
- `-nolist -nonumbers`: Remove navigation links/numbering
- `-dont_wrap_pre`: Preserve code block formatting  
- `-width=100`: Optimal line length for readability

## Expected Results

- **Source files**: 10-15KB (90% compression vs HTML)
- **HTML conversion**: 20-30KB (70% compression vs HTML)
- **Clean formatting**: Code blocks preserved, navigation removed

## Workflow

This command guides you through a multi-step process:

1. **Run WebFetch** to detect edit/source links
2. **Use Bash(curl -O)** to download raw source if found
3. **Fallback to Bash(lynx)** for HTML conversion if needed

**Example flow:**
- Input: `https://hamilton.dagworks.io/concepts/materialization/`
- WebFetch finds: `github.com/apache/hamilton/edit/main/docs/concepts/materialization.rst`
- Download: `curl -O https://raw.githubusercontent.com/apache/hamilton/main/docs/concepts/materialization.rst`
- Result: `materialization.rst` (10KB clean source)

## Success Criteria

Output should be:
- Clean, readable text focused on main content
- Properly formatted code blocks
- Minimal navigation/UI artifacts
- Optimal size for Claude token efficiency

Try source detection first, fall back to HTML processing only when necessary.
