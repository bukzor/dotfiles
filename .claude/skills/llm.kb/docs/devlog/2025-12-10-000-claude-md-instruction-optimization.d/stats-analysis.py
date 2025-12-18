#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["scipy"]
# ///
"""
Statistical analysis of 5/5 -> 2/10 swing in test results.
Question: Could this happen by chance from a stable underlying rate?
"""

from scipy import stats
from scipy.special import beta as beta_func, comb
import numpy as np

print("=" * 60)
print("Observed: Round 2 = 5/5, Round 3 = 2/10")
print("Question: Same underlying success rate?")
print("=" * 60)

print("\n### Bayesian Posterior Predictive ###")
print("After 5/5 with Beta(1,1) prior -> posterior Beta(6,1)")
print("What's P(X ≤ 2) for next 10 trials?")

def beta_binom_pmf(k, n, alpha, beta):
    """Beta-binomial PMF"""
    return comb(n, k, exact=True) * beta_func(alpha + k, beta + n - k) / beta_func(alpha, beta)

alpha, beta_param = 6, 1  # posterior after 5/5
n = 10
probs = [beta_binom_pmf(k, n, alpha, beta_param) for k in range(n + 1)]
p_le_2 = sum(probs[:3])
print(f"P(X ≤ 2 | Beta-Binomial(10, 6, 1)) = {p_le_2:.4f} ({p_le_2*100:.2f}%)")

print("\n### Fisher's Exact Test ###")
print("Comparing proportions: 5/5 vs 2/10")
table = [[5, 0], [2, 8]]
odds_ratio, p_value = stats.fisher_exact(table)
print(f"Contingency table: {table}")
print(f"Odds ratio: {odds_ratio}")
print(f"P-value (two-sided): {p_value:.4f} ({p_value*100:.2f}%)")

print("\n### Wilson Score 95% Confidence Intervals ###")
def wilson_ci(successes, trials, confidence=0.95):
    """Wilson score interval for binomial proportion"""
    from scipy.stats import norm
    z = norm.ppf(1 - (1 - confidence) / 2)
    n, p = trials, successes / trials
    denom = 1 + z**2 / n
    center = (p + z**2 / (2 * n)) / denom
    spread = z * np.sqrt(p * (1 - p) / n + z**2 / (4 * n**2)) / denom
    return max(0, center - spread), min(1, center + spread)

ci_r2 = wilson_ci(5, 5)
ci_r3 = wilson_ci(2, 10)
print(f"5/5:  [{ci_r2[0]:.1%}, {ci_r2[1]:.1%}]")
print(f"2/10: [{ci_r3[0]:.1%}, {ci_r3[1]:.1%}]")
overlap = ci_r2[0] < ci_r3[1] and ci_r3[0] < ci_r2[1]
print(f"Intervals overlap: {overlap}")

print("\n### Interpretation ###")
if p_value < 0.05:
    print(f"Fisher p-value {p_value:.3f} < 0.05: REJECT null hypothesis")
    print("The two samples likely come from DIFFERENT underlying rates.")
else:
    print(f"Fisher p-value {p_value:.3f} >= 0.05: Cannot reject null")
    print("Insufficient evidence that rates differ.")

print(f"\nPosterior predictive {p_le_2:.3f}: ", end="")
if p_le_2 < 0.01:
    print("< 1% chance of seeing 2/10 after 5/5 from same rate")
    print("Strong evidence of non-stationarity.")
elif p_le_2 < 0.05:
    print("< 5% chance - suggestive of non-stationarity")
else:
    print("Plausible under same rate")
