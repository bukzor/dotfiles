# Claude Code Tool Value Analysis

Cost/benefit scoring for Claude Code tools to guide enablement decisions.

## Tiers

**Tier 1 - Core (value >0.4):** Keep always
| Tool | Value | Cost (kB) |
|------|-------|-----------|
| ReadMcpResourceTool | 1.22 | 0.33 |
| ListMcpResourcesTool | 0.99 | 0.38 |
| WebSearch | 0.66 | 1.71 |
| Bash | 0.63 | 11.4 |
| Edit | 0.42 | 1.38 |

**Tier 2 - Solid (0.1-0.4):** Keep unless context-starved
| Tool | Value | Cost (kB) |
|------|-------|-----------|
| BashOutput | 0.29 | 0.58 |
| Task | 0.14 | 7.22 |
| Write | 0.13 | 0.70 |
| NotebookEdit | 0.13 | 0.53 |

**Tier 3 - Marginal (0.025-0.1):** Situational, disable for lean workflows
| Tool | Value | Cost (kB) |
|------|-------|-----------|
| Glob | 0.094 | 0.92 |
| LSP | 0.065 | 1.60 |
| StructuredOutput | 0.061 | 0.40 |
| Grep | 0.058 | 2.34 |
| Read | 0.048 | 7.31 |
| WebFetch | 0.044 | 2.63 |
| Skill | 0.043 | 3.01 |
| KillShell | 0.041 | 0.26 |
| SlashCommand | 0.031 | 1.46 |
| AskUserQuestion | 0.028 | 0.54 |

**Tier 4 - Disable candidates (value <0.01):** Clear 4x gap from Tier 3
| Tool | Value | Cost (kB) |
|------|-------|-----------|
| ExitPlanMode | 0.007 | 1.89 |
| EnterPlanMode | 0.003 | 3.13 |
| TodoWrite | 0.0008 | 9.53 |

## Formula

```
benefit = enablement × turn_efficiency × accuracy_boost × (1 - penalty)
cost = definition_kb + (call_kb × frequency)
value = benefit / cost
```

Where:
- `enablement = essentiality × frequency`
- `turn_efficiency = turns_without / turns_with`
- `accuracy_boost = (1 - error_with) / (1 - error_without)`
- `penalty = substitutability^0.322`
- `definition_kb` = actual .md file size

## Usage

```bash
bin/tool-scores-show                    # display computed values
bin/tool-scores-update                  # regenerate .score.yaml files
bin/tool-scores-rank                    # display sorted by value (descending)
```

## Notes

- Large definitions hurt disproportionately due to triangular context cost (definition × turns)
- Read scores low despite high usage because Bash+sed substitutes adequately
- MCP tools score high: tiny definitions, no substitutes, high accuracy when needed
- TodoWrite's turn_efficiency=1 (no turn savings) tanks its value
