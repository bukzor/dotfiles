# Splitting Large Documents into .d/ Structure

**Read when:** You have a large document that needs to be split into homogeneous `.d/` categories.

## Successive Subtraction Technique

A practical method for factoring large documents into focused `.d/` categories:

1. **Pick one obvious/helpful category** - Choose the most clear-cut homogeneous type
2. **Extract it** - Either actually create the files, or think through what would be extracted
3. **Examine the remainder** - Look at what's left
4. **Repeat** - Pick the next most obvious category from what remains
5. **Continue until complete** - Keep subtracting categories until the entire doc is factored

## Why This Works

**Avoids premature categorization:** Don't try to define all categories upfront. Let them emerge from the content.

**Reduces cognitive load:** Focus on one homogeneous type at a time, not the entire taxonomy.

**Validates homogeneity:** If something doesn't fit the current category, it stays in the remainder for later categorization.

**Surfaces edge cases:** The remainder gets smaller and clearer, making unusual items more visible.

## Example

780-line creating-documentation.md:

**Round 1:** Extract file-types.d/ (README, HACKING, CLAUDE, design-rationale, etc.)
- Each describes a doc file type with: audience, must/should/shouldn't contain, template
- Clearly homogeneous

**Round 2:** (TBD) Look at remainder, identify next obvious category
- Guidelines? Consumption patterns? Anti-patterns?
- Emerges from what's left after Round 1

**Round N:** Continue until remainder is empty

## Tips

**Thought experiment acceptable:** Don't have to actually create files in each round - can think through "what would be extracted" before committing.

**Templates go to skeleton/:** If extracted content includes templates, move them to appropriate `skeleton/` paths, not into `.d/` documentation.

**Document as you go:** Update task tracking with progress through rounds.

**Don't force it:** If remainder doesn't naturally factor into more categories, reconsider if `.d/` structure is needed for what's left.
