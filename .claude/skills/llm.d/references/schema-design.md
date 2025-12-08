# Schema Design

JSON Schema Draft 07 in YAML for frontmatter validation.

## Multiple Patterns in One Directory

Use `oneOf` when files can have different valid frontmatter structures:

```yaml
oneOf:
  - required: [provider, models]      # Pattern 1: Cloud providers
    properties:
      provider: {type: string}
      models: {type: array}

  - required: [category, privacy]     # Pattern 2: Local models
    properties:
      category: {const: "Local Model Support"}
      privacy: {type: string}
```

## Useful Constraints

```yaml
license:
  enum: [MIT, Apache-2.0, Proprietary]  # Prevent typos

repository:
  format: uri  # Validate URLs

date:
  type: date  # YAML parses ISO dates (2024-03-10) as date objects

additionalProperties: false  # Strict validation recommended
```

## Evolution

- **Add optional fields**: Safe
- **Add required fields**: Must update all existing files
- **Change enums**: May break files

Start minimal, expand as useful fields emerge.
