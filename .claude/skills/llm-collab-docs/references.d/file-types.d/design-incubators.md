---
filename: design-incubators/
audience: Developers
purpose: Isolated spaces for unsolved design problems
---

# Design Incubators

**Purpose:** Isolated spaces for unsolved design problems

**When to create:**
- Problem affects multiple components
- Multiple viable approaches need exploration
- Solution isn't obvious
- Prototyping will take multiple sessions

**Structure:**
```
design-incubators/
└── problem-name/
    ├── CLAUDE.md              # Problem framing, constraints, candidates
    ├── README.md              # Investigation plan, status
    ├── investigate-X.py       # Exploration scripts
    ├── prototype-A/           # Approach A implementation
    ├── prototype-B/           # Approach B implementation
    └── DECISION.md            # Final choice (when resolved)
```

**Lifecycle:**
1. Create incubator when problem identified
2. Explore approaches, document findings
3. Make decision (write DECISION.md)
4. Merge lessons into main docs
5. Archive or delete incubator
