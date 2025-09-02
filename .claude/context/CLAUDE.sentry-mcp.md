# Sentry MCP Usage Rules - READ THIS FIRST before using any mcp__sentry__ tools

**Success criteria:** Find events/issues in correct dataset with proper time filtering

**Core syntax:**
- Use raw Sentry query syntax in `naturalLanguageQuery` (not natural language)
- Add `includeExplanation=true` to verify query interpretation

**Time filtering:**
- `statsPeriod=1h` `statsPeriod=24h` (cleanest)
- `timestamp=>2025-08-08T17:00:00` (if you need absolute times)

**Dataset control:**
- `dataset=errors` forces errors dataset (for programmatic events)  
- `level=error` also forces errors dataset
- Default often picks wrong dataset (logs vs errors)

**Common patterns:**
```
level=error message="search term"
level=warning dataset=errors message="search term"  
environment=selftest statsPeriod=24h
id=EVENT_ID dataset=errors
issue=ISSUE-ID dataset=errors
```

**Aggregation queries (tag distributions, counts):**
- Full explicit syntax: `issue=ISSUE-ID dataset=errors field=TAG-NAME field=count() sort=-count() mode=aggregate statsPeriod=14d`
- Minimal syntax: `issue=ISSUE-ID dataset=errors` (MCP auto-detects aggregation)
- Example: `issue=PROJ-THREAD-LEAKS-19 dataset=errors field=pytest.file field=count() sort=-count() mode=aggregate statsPeriod=14d`

**Tool differences:**
- `search_events`: Supports OR/AND, complex queries, aggregations
- `search_issues`: Simpler syntax, no OR/AND support