---
label: BLOCK_FANOUT
standing: bare
verify: "claude-tokens | wc -l, against the raw assistant-record count; or the per-requestId histogram in the body"
---

# One response is written as many records

Claude Code writes one transcript record per *content block* of a
response, and each record repeats that response's entire `usage` block.
Summing `usage` across records therefore multiplies every multi-block
turn by its block count.

This is the common case, not an edge: across a 40-file sample, **76% of
responses were written as more than one record**, up to 16 records for a
single response. A naive sum overstates spend roughly threefold.

The fix is to deduplicate on `(requestId, message.id)` before summing,
which is what `claude-tokens` does and why its output is safe to add up.
Attributing a response's cost *back* to its records — as the abandoned
branch scan must, since only records carry parentage — requires the
inverse: divide the cost by the block count and give each record a share.

```sh
python3 -c "
import json,glob,collections
c=collections.Counter()
for f in glob.glob('$HOME/.claude/projects/*/*.jsonl')[:40]:
    for line in open(f,errors='replace'):
        try: r=json.loads(line)
        except Exception: continue
        if r.get('type')=='assistant' and r.get('requestId'): c[r['requestId']]+=1
multi=sum(1 for v in c.values() if v>1)
print(f'{len(c)} responses, {multi} multi-record ({multi/len(c)*100:.0f}%), max {max(c.values())}')
"
```
