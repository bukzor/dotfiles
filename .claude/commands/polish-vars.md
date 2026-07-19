---
description: Variable hygiene pass -- inline single-use vars, rebind in place
disable-model-invocation: true
---

# Polish Variables

Review recent code changes and apply variable hygiene:

## Rules

1. **Inline single-use variables** — if a variable is used exactly once, inline it
   unless the name adds significant clarity

2. **Rebind evolving values in-place** — when a value transforms through stages,
   use the same name:
   ```python
   # Good
   state = replace(state, players=new_players)
   state = check_game_end(state)

   # Avoid
   new_state = replace(state, players=new_players)
   final_state = check_game_end(new_state)
   ```

3. **Exception: keep names that document intent** — `winner`, `shooter`, `direction`
   are worth keeping even if used once

## Workflow

1. Review staged or recent changes
2. For each function, identify:
   - Variables used exactly once (inline candidates)
   - `new_*` / `old_*` pairs (rebind candidates)
3. Apply transformations
4. Run pyright + tests to verify
