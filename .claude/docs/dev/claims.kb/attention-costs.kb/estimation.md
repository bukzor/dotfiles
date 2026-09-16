---
label: ESTIMATION
standing: agent
ontology:
  - prospective input
  - oracle accuracy
  - t-shirt call
why:
  - ./cost-structure.md
  - ./measurement.md
stale-when: an estimator is scored against predictions an agent actually made rather than against outcomes alone
---

# estimation — what can be known before acting

An agent deciding whether to do a task needs its price before doing it.
Everything it could key on divides by a single question: is the quantity
knowable in advance?

A **prospective input** is one the agent can judge before the work — task
size, roughly. Everything else is measurable only afterwards, however well
it predicts. **Oracle accuracy** is how well an input would predict cost
if it were known exactly; it is the ceiling a prospective estimate is
competing for, and quoting it alone is how an estimator gets oversold.

That distinction is what this theory exists to keep straight, because the
two best-correlating inputs — output tokens and generation time — are the
two an agent cannot know, and the accuracy they advertise is unreachable.

Accuracy is reported as median absolute percentage error over sessions,
and as the share of sessions predicted within a factor of two. The second
matters more for decisions: a threshold is rarely close enough for 30% to
change the answer, and a factor of two sometimes is.

The practical form of a prospective estimate is a **t-shirt call** — the
task sorted into one of a few log-spaced size buckets, rather than given a
number. Its bound is `TSHIRT_BOUND`, and the reason nothing finer is worth
building is `CONVERSION_IS_CHEAP`.
