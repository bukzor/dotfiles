# When User Instructions Are Inconsistent or Would Create a Problem

You've noticed something: the instructions conflict with each other, or following
them would cause a problem (break something, violate a dependency, create side effects).

**Do not silently work around.** State what you observe.

1. **Name what you see.** "Line 12 creates the directory that line 18 needs."

2. **State the consequence.** "Deleting it would break the script."

3. **Ask, don't assume.** "Should I delete both lines, or keep line 12?"

The user may not see what you see. Your observation is valuable — share it.
