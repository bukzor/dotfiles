---
label: COMPACT_PARENT
standing: bare
verify: "the compact_boundary scan in the body: 294 of 294 boundaries carry logicalParentUuid"
---

# A compaction root names its predecessor in a second field

A compaction writes a `system`/`compact_boundary` record whose
`parentUuid` is null — but which carries **`logicalParentUuid`** pointing
at the last record of the era it summarised. Every one of the 294
boundaries in this corpus carries it.

Walking `parentUuid` alone therefore reports each pre-compaction era as
unreachable from the newest record, which for cost attribution means counting real
work as thrown away. Doing exactly that inflated the abandoned-branch
figure from 7.3% to 54% — a sevenfold error that looked entirely
plausible until it was checked.

`Skill(claude-code-archeology)` used to state that the boundary record
"has no parent" -- true only of the field it names, and misleading for
anything walking the tree. Corrected in bukzor-agent-skills `66fbf30`,
which now names both fields and says which one the rewind picker
follows.

```sh
python3 -c "
import json,glob
tot=logical=0
for f in glob.glob('$HOME/.claude/projects/*/*.jsonl'):
    for line in open(f,errors='replace'):
        try: r=json.loads(line)
        except Exception: continue
        if r.get('subtype')=='compact_boundary':
            tot+=1; logical+=bool(r.get('logicalParentUuid'))
print(tot,'boundaries,',logical,'carry logicalParentUuid')
"
```
