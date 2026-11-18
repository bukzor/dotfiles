# Shell / CLI Tool Design Rules

Design principles for command-line tools and scripts meant to compose in
shell pipelines.

- Data flow, argument conventions, exit/error discipline
- Bias toward Unix-filter composability
- Applies to any language a pipeline stage is written in (sh, Python, …),
  not just bash
