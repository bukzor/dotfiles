# Subroutine Factoring

Extract complex loops into separate sections with local numbering.

## Pattern

When a procedure has nested loops or multiple "go to step X" jumps, factor the inner loop into its own section:

```
Main procedure:
  4. Pick item
  5. Do thing
  6. Complex process (see below)
  7. Repeat from 4

## Complex Process
  0. First step
  1. Second step
  2. Final step
```

## When to apply

- Multiple "repeat from step N" creating spaghetti
- Inner loop has different concern than outer loop
- Section would benefit from local step numbering

## Example

tdd-posthoc: Main procedure handles mutation selection/iteration. "Harden Tests" handles test strengthening loop. Separating them reduced cross-references from 4+ to 1.

## Benefits

- Local numbering (0, 1, 2) doesn't conflict with main (4, 5, 6, 7)
- Each section has single concern
- Easier to trace execution paths
