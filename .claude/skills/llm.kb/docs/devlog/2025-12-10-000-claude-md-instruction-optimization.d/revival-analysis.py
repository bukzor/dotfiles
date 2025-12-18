#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///
"""
Calculate P(true_rate > threshold) for eliminated candidates.
Key question: could an eliminated candidate actually be better than our leader?
"""
from math import gamma

def beta_func(a, b):
    return gamma(a) * gamma(b) / gamma(a + b)

def incomplete_beta(x, a, b, steps=1000):
    """Numerical integration for Beta CDF."""
    total = 0
    dx = x / steps
    for i in range(steps):
        xi = (i + 0.5) * dx
        total += xi**(a-1) * (1-xi)**(b-1) * dx
    return total / beta_func(a, b)

def p_above(successes, total, threshold):
    """P(true_rate > threshold) with uniform prior."""
    alpha = 1 + successes
    beta = 1 + total - successes
    return 1 - incomplete_beta(threshold, alpha, beta)

# All cumulative data from results.toon
variants = {
    # Eliminated in round 1
    "Required to be helpful": (0, 2),
    "Helpful responses require this": (0, 2),
    "You cannot help without this": (1, 2),
    "To help with ANY question run first": (1, 2),

    # Eliminated in round 2 (had round1 + round2 data)
    "Your context is incomplete": (2+3, 2+5),  # 5/7
    "To help you I must run": (2+4, 2+5),      # 6/7
    "Helpful answers require this data": (2+4, 2+5),  # 6/7
    "Contains answers you need": (2+4, 2+5),  # 6/7

    # Round 3 participants (all rounds cumulative)
    "Answers live here": (2+5+7, 2+5+10),     # 14/17
    "This data answers questions": (2+5+8, 2+5+10),  # 15/17 LEADER
    "Even if question seems unrelated": (2+5+7, 2+5+10),  # 14/17
    "For ANY question": (2+5+2+9, 2+5+10+10),  # 18/27
}

# Leader's observed rate
leader_name = "This data answers questions"
leader_s, leader_n = variants[leader_name]
leader_rate = leader_s / leader_n

print(f"Leader: {leader_name}")
print(f"  Observed: {leader_s}/{leader_n} = {leader_rate:.1%}")
print()
print(f"P(true > {leader_rate:.1%}) for each variant:")
print()

results = []
for name, (s, n) in variants.items():
    rate = s / n
    p = p_above(s, n, leader_rate)
    results.append((p, name, s, n, rate))

for p, name, s, n, rate in sorted(results, reverse=True):
    marker = " ← LEADER" if name == leader_name else ""
    print(f"  {p:5.1%}  {s:2}/{n:2} ({rate:4.0%})  {name}{marker}")
