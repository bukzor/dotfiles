---
cost-benefit-sweh:
  timebox:
    '@value': 1
    confidence: tentative
    rationale: |
      Four investigative questions (image base64 path, pdftotext coverage, MCP substitutes, usage ratio). Read tool source/behavior + documentation + writeup. ~1 SWEh research.
  benefit-2w:
    '@value': 0.3
    confidence: tentative
    rationale: |
      Tool-value scoring system input; informs future Read tool scope (keep / trim / split). Modest signal value.
---
<anthropic-skill-ownership subtask />

# Investigate Non-Substitutability of Read's PDF/Image Capabilities

**Priority:** Medium
**Complexity:** Low
**Context:** tool-value scoring system, Read tool evaluation

## Problem Statement

The Read tool scores poorly (value=0.0477) due to high cost (7.31kB), but its PDF/image handling may be non-substitutable. Need to verify whether these capabilities have alternate code paths before considering removal/trimming.

## Current Situation

- Read.md is 1.7kB definition + ~5.6kB average call return
- Text file reading is ~60% substitutable via `sed -n` / `cat` in Bash
- PDF/image handling routes through Claude's multimodal capabilities
- No known alternate path for multimodal file analysis in Claude Code

## Questions to Investigate

- [ ] Can images be passed to Claude via base64 in Bash? (likely no visual processing)
- [ ] Does `pdftotext` via Bash cover PDF use cases adequately?
- [ ] Are there MCP tools that could substitute for multimodal file reading?
- [ ] What % of Read usage is text vs PDF/image in practice?

## Success Criteria

- [ ] Document which Read capabilities are truly non-substitutable
- [ ] Quantify substitutability more accurately (current estimate: 0.6)
- [ ] Decide: keep Read as-is, trim Read.md, or split into Read + ReadImage tools

## Notes

From conversation: "Read is the gateway to Claude's multimodal capabilities in Claude Code. Without it, images have no path (Bash base64 doesn't enable vision), PDFs lose visual layout analysis."

**Key investigation:** Dig into how `Read(foo.png)` actually works. If it's just antml image blocks, that's substitutable - could potentially craft equivalent antml via a lighter-weight tool or MCP.
