#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///
"""
Bayesian analysis of experiment results.
Given observed successes/failures, estimate probability of tail events.
"""
from math import comb, gamma

def beta_func(a, b):
    return gamma(a) * gamma(b) / gamma(a + b)

def beta_binom_pmf(k, n, alpha, beta):
    """Beta-binomial PMF: P(X=k) integrating over Beta prior"""
    return comb(n, k) * beta_func(alpha + k, beta + n - k) / beta_func(alpha, beta)

def analyze(successes, failures, round2_n=5, round3_n=10):
    """Analyze probability of observing round 2 and round 3 results."""
    # Posterior with uniform prior Beta(1,1)
    alpha = 1 + successes
    beta = 1 + failures

    mean = alpha / (alpha + beta)
    var = (alpha * beta) / ((alpha + beta)**2 * (alpha + beta + 1))
    std = var ** 0.5

    print(f"Data: {successes} successes, {failures} failures")
    print(f"Posterior: Beta({alpha}, {beta})")
    print(f"  Mean: {mean:.1%} ± {std:.1%}")
    print()

    # P(perfect run in round 2)
    p_perfect = beta_binom_pmf(round2_n, round2_n, alpha, beta)
    print(f"P(≥{round2_n}/{round2_n}) = {p_perfect:.2%}")

    # P(≤2 in round 3)
    p_low = sum(beta_binom_pmf(k, round3_n, alpha, beta) for k in range(3))
    print(f"P(≤2/{round3_n}) = {p_low:.2%}")

    joint = p_perfect * p_low
    print(f"Joint: {joint:.2%} (~1 in {int(1/joint)})")

    return p_perfect, p_low, joint

if __name__ == "__main__":
    import sys
    if len(sys.argv) == 3:
        s, f = int(sys.argv[1]), int(sys.argv[2])
    else:
        # Default: pooled from 5/5 + 2/10
        s, f = 7, 8
    analyze(s, f)
