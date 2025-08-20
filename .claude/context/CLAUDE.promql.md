# Core Concepts

## Time Series & Vector Types

INSTANT VECTOR:

- One sample per series at timestamp
- Structure: {metric_name, {labels}, value, timestamp}
- Each unique label combination = distinct series
- Label sets must remain identical over time

RANGE VECTOR:

- Multiple samples over time range
- Syntax: metric[time_range]
- Requires ≥2 points for rate/delta calculations
- Range calculations fragment at stale gaps
- Time range is exclusive start, inclusive end

## Labels & Selectors

Basic syntax: `metric_name{label="value", label2=~"pattern"}`

Matchers:

- `=` exact match
- `!=` exclude match
- `=~` regex match (always anchored as ^pattern$)
- `!~` exclude regex match

Key rules:

- Empty matcher (`label=""`) matches both missing label and `label=""`
- Multiple matchers on same label use AND logic
- Must have either metric name OR ≥1 non-empty matcher
- `__name__` label represents metric name
- Invalid in labels/names: dots, invalid UTF-8, null bytes

## Time & Staleness

- Series marked stale after 5m without samples (default)
- Stale series excluded from calculations (not zeroed)
- Custom timestamp exporters: keep last value 5m after stopping
- Used points must be within 5m of request
- Time modifiers:
  - `offset duration`: Shifts evaluation time backward
  - `@ timestamp`: Sets specific evaluation time
  - @ time applies to complete subexpression
  - Offsets evaluated relative to @ time

# Operations

## Vector Matching

ONE-TO-ONE (Default):

- Requires identical non-ignored label sets
- Returns intersection of labels
- Non-matches dropped silently

Example:

```
{job="a",env="prod"} + {job="a",dc="east"}
→ {job="a"}
```

MANY-TO-ONE:

```
vector1 <op> ignoring(...)|on(...) group_left|right(labels) vector2
```

- Requires explicit group_left/right
- Direction points to "many" side
- Returns: "one" side labels + specified "many" labels
- Must produce unique identifiers

Example:

```
{env="prod",job="a"} + group_right(dc) {job="a",dc="east"}
→ {env="prod",job="a",dc="east"}
```

## Operators

Priority (highest to lowest):

1. `^`
2. `* / % atan2`
3. `+ -`
4. `== != <= < >= >`
5. `and unless`
6. `or`

Label behavior:

- Arithmetic (`+-*/`): Keeps matching labels, group\_\* adds specified many-side
  labels
- Comparison: No labels by default; with bool modifier returns 0/1
- Logical (`and/unless/or`): Uses complete label sets, no grouping allowed

## Key Functions

COUNTER FUNCTIONS (counters only):

- `rate()`: Per-second average, handles resets
- `increase()`: Total increase over range
- `irate()`: Per-second rate from last 2 points
- `resets()`: Number of counter resets in range

GAUGE FUNCTIONS (gauges only):

- `delta()`: Absolute difference
- `deriv()`: Per-second regression
- `predict_linear()`: Future prediction

AGGREGATIONS:

```
<agg-op> [without|by (<labels>)] (<vector>)
```

- `without`: Drops specified labels
- `by`: Keeps only specified labels
- Always drops metric name
- Empty result if no matches
- Types: sum, min, max, avg, count, topk, bottomk, quantile

# Critical Rules & Gotchas

OPERATION ORDER:

- Calculate rate() BEFORE aggregation (counter resets)
- Vector matching before processing
- Label matching before filtering

MUST DO:

- Use group modifiers for many-to-one operations
- Verify cardinality before graphing/alerts
- Ensure unique series identifiers in operations

AVOID:

- rate() after aggregation
- Range operations with <2 points
- Many-to-many matches without group
- Counter functions on gauges
- Gauge functions on counters

SILENT FAILURES:

- Missing matches in vector operations
- Stale data exclusion
- Counter reset detection failures
- High cardinality explosions in joins
- Subquery misalignment
- Range calculations break at gaps

HISTOGRAM HANDLING:

- Most functions ignore histogram samples
- Mixed float/histogram results dropped
- sum/avg retain structure
- Bucket operations require matching layouts
