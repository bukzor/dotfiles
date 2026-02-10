# Documentation Conventions

Meta-decisions about how llm.kb documentation is written.

## Placeholders

Use all-caps, dollar-signed metavariables for placeholders:

```
$CATEGORY.d/
$CATEGORY.md
$CATEGORY.jsonschema.yaml
$ITEM.md
$PROJECT/
```

This clearly distinguishes placeholders from literal filenames like `CLAUDE.md`
or `README.md`.

## Dashes

Use double-dash (`--`) over emdash (`—`). Easier to type, renders consistently.

## Bold

Reserve bold for emphasis ("raising your voice"), not structure.

### Examples Needing Correction

This attempts to use bolding to create list items. This one is particularly
noxious as a markdown formatter will reflow this as a single paragraph.

```
**Root CLAUDE.md**: Common principles
**Per-directory CLAUDE.md**: Category-specific guidance
```

Corrected:

```markdown
- Root CLAUDE.md -- common principles
- Per-directory CLAUDE.md -- category guidance
```

This simply doesn't need bolding.

```markdown
**Purpose**: Catch schema violations.
```

Right:
```markdown
Purpose: catch schema violations.
```

This attempts to use bolding as a section header.

```
**Good fit**:

Lorem ipsum ...
```

Corrected:

```markdown
#### Good fit:

Lorem ipsum ...
```
