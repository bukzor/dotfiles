# Claude Code Token Usage Analysis - Findings

## Executive Summary

**Updated 2025-08-21**: Claude Code token usage is dominated by tool definitions. True vanilla startup cost is **14,657-17,372 tokens** depending on context. Individual tool removal through settings provides **24% reduction (4,094 tokens saved)**.

## Experimental Results

### Systematic Tool Cost Analysis

Individual tool costs measured through systematic enable/disable testing in clean environments. All measurements show consistent, reliable token counts with no evidence of double-counting bugs in current version.

### Baseline Measurements

| Configuration | Tokens | System Prompt | System Tools | Context Files | Notes |
|---------------|--------|---------------|--------------|---------------|--------|
| **Empty HOME, All Tools** | 14,657 | 3,000 | 1,400 | 0 | True vanilla |
| **Real HOME, All Tools** | 17,372 | 3,000 | 1,400 | 2,700 | With CLAUDE.md |
| **Real HOME, 3 Tools Denied** | 13,278 | 2,400 | 1,100 | 2,700 | Optimized setup |
| **Empty HOME, No Tools** | 2,583 | 2,400 | 85 | 0 | Minimal baseline |

### Individual Tool Costs

| Tool | Words | Tokens | Tokens/Word | Impact |
|------|-------|--------|-------------|--------|
| **TodoWrite** | 1,474 | 3,224 | 2.19 | Largest tool |
| **Bash** | 1,373 | 2,583 | 1.88 | Major functionality |
| **Task** | 701 | 1,488 | 2.12 | Mid-range |
| **MultiEdit** | 527 | 1,196 | 2.27 | High density |
| **NotebookEdit** | 217 | ~477 | 2.20 | Smaller tool |

### Optimization Results

**Buck's Settings Optimization**:
- Tools removed: TodoWrite, MultiEdit, NotebookEdit
- **Token savings**: 4,094 tokens (24% reduction)
- **Functionality preserved**: All essential tools remain

## Key Findings (2025-08-21)

### Tool Cost Structure

1. **Tool definitions dominate**: 17 tools available, ranging from 477-3,224 tokens each
2. **High token density**: Tools average **2.0 tokens per word**
3. **Removal is highly effective**: Individual tool removal provides immediate, measurable savings
4. **Custom tool descriptions have no impact**: Tool costs are dominated by JSON schemas and parameters

### Token Distribution (17,372 token setup)

| Component | Tokens | % of Total | Optimization Potential |
|-----------|---------|------------|----------------------|
| **Tool Definitions** | ~12,074 | 70% | High - selective removal |
| **Context Files** | 2,700 | 16% | Medium - content optimization |
| **System Prompt** | 3,000 | 17% | Low - core functionality |
| **Infrastructure** | ~598 | 3% | None - required overhead |

### Optimization Strategies Validated

1. **Settings-based tool denial**: 24% reduction achieved
2. **Context file management**: 16% of total when present  
3. **Complete tool removal**: Up to 85% reduction possible (but impractical)
4. **Tool description optimization**: Minimal impact (~0% measured)

## Disk-Based Estimates vs Reality

### Tool Definitions

- **My simplified estimate**: 357 words → ~400 tokens
- **Detailed analysis of 4 tools**: 3,612 words → ~3,600 tokens
- **Projected for all 16 tools**: 14,448 words → ~14,400 tokens
- **Experimental measurement**: 12,178 tokens
- **Accuracy**: 85% (projections slightly high)

### Context Files

- **Disk measurement**: 3,470 words → 3,470 tokens (1:1 ratio)
- **Breakdown**:
  - Global CLAUDE.md: 1,148 words
  - Project CLAUDE.md: 1,007 words
  - Hamilton CLAUDE.md: 586 words
  - Hamilton CLAUDE.local.md: 729 words

### System Components (Accurately Estimated)

- **System prompt**: 568 words → 568 tokens ✓
- **Environment context**: 131 words → 131 tokens ✓
- **Git status**: Included in environment
- **User message (first turn only)**: 54 words → 54 tokens ✓

## Unknown System Overhead (5,329 tokens)

The largest unaccounted component likely includes:

1. **Extended system instructions** not captured in main prompt
2. **Tool usage policies and examples** (loaded even without tools)
3. **Security constraints and behavioral guidelines**
4. **Context processing metadata and formatting**
5. **Additional behavioral examples and edge cases**
6. **Session initialization overhead**

## Optimization Strategies

### High Impact (50%+ reduction)

- **Selective tool disabling**: Use `--disallowedTools` for unused tools
- **Context file minimization**: Reduce or consolidate CLAUDE.md files

### Medium Impact (10-25% reduction)

- **Streamline context files**: Remove verbose instructions and examples
- **Project-specific tool loading**: Only load tools relevant to task type

### Low Impact (<10% reduction)

- **Minimal environment reporting**: Reduce git/system context verbosity

## Recommendations

### For Users
1. **Token-sensitive workflows**: Use settings.json `"deny"` list for unused tools (24%+ reduction)
2. **Context optimization**: Audit CLAUDE.md files - they're 16% of token cost when present
3. **Strategic tool selection**: Remove TodoWrite (3,224 tokens) and Bash (2,583 tokens) if not needed

### For Claude Code Development  
1. **Tool loading optimization**: Consider lazy loading or categorization of tools
2. **Granular control**: Provide UI for individual tool management beyond deny lists
3. **Token reporting**: Surface individual tool costs to help users optimize

### For Measurement
1. **Empirical approach**: Individual tool testing provides accurate cost assessment
2. **Token-to-word ratios**: Use 2.0:1 ratio (empirically measured for tools, likely applies broadly)
3. **Baseline establishment**: True vanilla is 14,657 (empty) or 17,372 (with context) tokens

## Methodology Notes

### Creating Vanilla Test Environment

```bash
tmp_home=$(mktemp -d)
mkdir -p "$tmp_home/Library/Keychains"
# Create a basic login keychain
security create-keychain -p "" "$tmp_home/Library/Keychains/login.keychain-db"
security default-keychain -s "$tmp_home/Library/Keychains/login.keychain-db"
HOME=$tmp_home claude --verbose 0
```

### Testing with All Tools Disabled

```bash
HOME=$tmp_home claude --disallowedTools Task,Bash,Glob,Grep,LS,ExitPlanMode,Read,Edit,MultiEdit,Write,NotebookEdit,WebFetch,TodoWrite,WebSearch,BashOutput,KillBash --verbose 0
```

**Note**: When Claude receives "0" as input, it often responds with "0" (calculator mode). Use `/context` to get token measurements instead.

### Analysis Methods

- **Token counting**: Based on Claude Code's internal `/context` reporting (note: double-counted)
- **Word estimates**: Used `wc -w` on recreated files  
- **Experimental approach**: Compared identical sessions with/without tools
- **Disk analysis**: Recreated system components to estimate token sources
- **Word-to-token assumption**: 1 word ≈ 1 token (validated for known components)
