# Complete Example

A working example lives at `complete-example/` in this skill directory.

## Scenario

Planning an 8-year-old's birthday party. The domain requires no technical
knowledge yet admits substantial decomposition: guests, food, games,
decorations, timeline.

## What to Notice

**Nested decomposition**: `food.d/cake.d/` demonstrates when a subcategory
warrants its own directory. Cake decisions (flavor, frosting, decorations) are
independent concerns that would clutter the parent directory.

**Summary sibling for nested directories**: `food.d/cake.md` summarizes
`food.d/cake.d/` in a form suitable as a `food.d/` member. It uses the same
frontmatter schema as `main-dishes.md` and `snacks.md`, so someone reading
`food.d/` sees cake at the appropriate level without diving into `cake.d/`.

**Cross-cutting constraints**: Emma's peanut allergy appears in `guests.d/`
but affects decisions throughout `food.d/`. The root CLAUDE.md flags this.

**CLAUDE.md at each level**: Each directory has guidance for what belongs
there and what doesn't. An agent can read `food.d/CLAUDE.md` and know
immediately whether "paper plates" belongs here (no - that's `decorations.d/`).

**Schemas document frontmatter**: Each `.jsonschema.yaml` file includes
`description:` entries that explain what each field means. Agents read the
schema to understand the data model, not redundant documentation in CLAUDE.md.

**Summary files for overview**: `decorations.md` summarizes theme and budget
without diving into individual items. Unlike `cake.md` (which is also a
`food.d/` member), `decorations.md` sits at the root as a pure overview.

## Exploring

```bash
# See the structure
find complete-example -type f -name '*.md' | head -20

# Read all CLAUDE.md files to understand organization
cat complete-example/**/CLAUDE.md

# See how constraints propagate
grep -r "peanut" complete-example/
```
