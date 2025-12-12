#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "pyyaml",
# ]
# ///
"""
Validate frontmatter in markdown files against JSON schemas.

Prevents errors by catching schema violations early.
"""

import sys
import yaml
from pathlib import Path
from dataclasses import dataclass
import argparse


@dataclass(frozen=True)
class ValidationResult:
    """One validation result."""
    depth: int
    kind: str  # 'dir', 'file'
    text: str
    errors: tuple[str, ...] = ()

    def __bool__(self):
        return not self.errors

    def __str__(self):
        indent = "    " * self.depth
        match self.kind:
            case 'dir':
                return f"  {indent}{self.text}/"
            case 'file':
                icon = "✅" if self else "❌"
                lines = [f"{icon}{indent}{self.text}"]
                for error in self.errors:
                    lines.append(f"    {indent}{error}")
                return "\n".join(lines)


def validate_one_file(md_file, schema_override, depth):
    """Validate one file, yielding output. Skips non-data files."""
    if md_file.name == 'CLAUDE.md':
        return
    errors = validate_file(md_file, schema_override)
    yield ValidationResult(depth, 'file', md_file.name, errors=tuple(errors))


def without_children(paths):
    """Yield paths, skipping any that are children of already-yielded paths."""
    seen = set()
    for p in sorted(paths):
        if any(parent in seen for parent in p.parents):
            continue
        else:
            yield p
            seen.add(p)


def validate_paths(paths, schema_override=None, depth=0):
    """Recursively validate paths, yielding ValidationResult objects."""
    for path in paths:
        p = Path(path)

        if p.is_dir() and p.name.endswith('.d'):
            yield ValidationResult(depth, 'dir', p.name)

            for md_file in sorted(p.glob('*.md')):
                yield from validate_one_file(md_file, schema_override, depth + 1)

            yield from validate_paths(sorted(p.glob('*.d')), schema_override, depth + 1)

        elif p.is_dir():
            yield from validate_paths(without_children(p.glob('**/*.d')), schema_override, depth)

        elif p.is_file():
            yield from validate_one_file(p, schema_override, depth)


def extract_frontmatter(md_file):
    """Extract YAML frontmatter from markdown file."""
    content = md_file.read_text()

    if not content.startswith('---\n'):
        return None

    # Find closing ---
    parts = content.split('---\n', 2)
    if len(parts) < 3:
        return None

    return parts[1]


def load_schema(schema_file):
    """Load JSON schema from YAML file."""
    try:
        with open(schema_file) as f:
            return yaml.safe_load(f)
    except Exception as e:
        print(f"Error loading schema: {e}", file=sys.stderr)
        return None


def validate_against_schema(data, schema):
    """Simple validation against schema (basic checks)."""
    errors = []

    # Check required fields
    required = schema.get('required', [])
    for field in required:
        if field not in data:
            errors.append(f"Missing required field: {field}")

    # Check property types if specified
    properties = schema.get('properties', {})
    for key, value in data.items():
        if key in properties:
            prop_schema = properties[key]

            # Check type
            if 'type' in prop_schema:
                schema_type = prop_schema['type']
                actual_type = type(value).__name__

                # JSON Schema type -> Python type name(s)
                type_map = {
                    'string': ('str',),
                    'array': ('list',),
                    'object': ('dict',),
                    'number': ('int', 'float'),
                    'integer': ('int',),
                    'boolean': ('bool',),
                    'date': ('date',),
                    'null': ('NoneType',),
                }

                # Normalize schema_type to tuple (handles type: [string, null])
                if not isinstance(schema_type, list):
                    schema_type = [schema_type]

                # Build set of acceptable Python type names
                expected = set()
                for t in schema_type:
                    expected.update(type_map.get(t, (t,)))

                if actual_type not in expected:
                    errors.append(f"Field '{key}': expected {sorted(expected)}, got {actual_type}")

            # Check enum
            if 'enum' in prop_schema:
                if value not in prop_schema['enum']:
                    errors.append(f"Field '{key}': '{value}' not in allowed values {prop_schema['enum']}")

    return errors


def validate_file(md_file, schema_override=None):
    """Validate a single markdown file. Returns list of errors."""
    if not md_file.exists():
        return ["File not found"]

    frontmatter_yaml = extract_frontmatter(md_file)
    if frontmatter_yaml is None:
        return []

    try:
        data = yaml.safe_load(frontmatter_yaml)
    except yaml.YAMLError as e:
        return [f"Invalid YAML: {e}"]

    # Auto-detect schema if not provided
    schema_file = schema_override
    if not schema_file:
        parent = md_file.parent.name
        if parent.endswith('.d'):
            category = parent[:-2]
            schema_file = md_file.parent.parent / f"{category}.jsonschema.yaml"
        else:
            return []  # Can't validate without schema

    schema_path = Path(schema_file)
    if not schema_path.exists():
        return [f"No schema found: {schema_file}"]

    schema = load_schema(schema_path)
    if schema is None:
        return ["Failed to load schema"]

    return validate_against_schema(data, schema)


def main():
    parser = argparse.ArgumentParser(
        description='Validate markdown frontmatter against JSON schema'
    )
    parser.add_argument('paths', nargs='*', default=['.'], help='Markdown files, .d/ directories, or directories containing .d/ subdirectories (default: .)')
    parser.add_argument('--schema', help='Schema file (auto-detected if not provided)')

    args = parser.parse_args()

    file_count = 0
    error_count = 0
    for result in validate_paths(args.paths, args.schema):
        print(result)
        if result.kind == 'file':
            file_count += 1
            if not result:
                error_count += 1

    icon = "✅" if error_count == 0 else "❌"
    print(f"{icon} {file_count} files, {error_count} errors")

    sys.exit(0 if error_count == 0 else 2)


if __name__ == '__main__':
    main()
