#!/usr/bin/env -S uv run
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
import json
from pathlib import Path
import argparse


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
                expected_type = prop_schema['type']
                actual_type = type(value).__name__

                type_map = {
                    'string': 'str',
                    'array': 'list',
                    'object': 'dict',
                    'number': ['int', 'float'],
                    'boolean': 'bool'
                }

                expected = type_map.get(expected_type, expected_type)
                if isinstance(expected, list):
                    if actual_type not in expected:
                        errors.append(f"Field '{key}': expected {expected}, got {actual_type}")
                elif actual_type != expected:
                    errors.append(f"Field '{key}': expected {expected}, got {actual_type}")

            # Check enum
            if 'enum' in prop_schema:
                if value not in prop_schema['enum']:
                    errors.append(f"Field '{key}': '{value}' not in allowed values {prop_schema['enum']}")

    return errors


def main():
    parser = argparse.ArgumentParser(
        description='Validate markdown frontmatter against JSON schema'
    )
    parser.add_argument('files', nargs='+', help='Markdown files to validate')
    parser.add_argument('--schema', help='Schema file (auto-detected if not provided)')

    args = parser.parse_args()

    all_valid = True

    for file_path in args.files:
        md_file = Path(file_path)

        if not md_file.exists():
            print(f"❌ {file_path}: File not found", file=sys.stderr)
            all_valid = False
            continue

        # Extract frontmatter
        frontmatter_yaml = extract_frontmatter(md_file)
        if frontmatter_yaml is None:
            print(f"✅ {file_path}: No frontmatter (pure prose)")
            continue

        try:
            data = yaml.safe_load(frontmatter_yaml)
        except yaml.YAMLError as e:
            print(f"❌ {file_path}: Invalid YAML in frontmatter: {e}", file=sys.stderr)
            all_valid = False
            continue

        # Auto-detect schema if not provided
        schema_file = args.schema
        if not schema_file:
            # Look for x.jsonschema.yaml based on parent directory
            parent = md_file.parent.name
            if parent.endswith('.d'):
                category = parent[:-2]  # Remove .d
                schema_file = md_file.parent.parent / f"{category}.jsonschema.yaml"
            else:
                print(f"⚠️  {file_path}: Cannot auto-detect schema (not in .d/ directory)")
                continue

        schema_path = Path(schema_file)
        if not schema_path.exists():
            print(f"❌ {file_path}: Has frontmatter but no schema found: {schema_file}", file=sys.stderr)
            print(f"   Frontmatter requires schema to prevent drift", file=sys.stderr)
            all_valid = False
            continue

        # Load and validate
        schema = load_schema(schema_path)
        if schema is None:
            all_valid = False
            continue

        errors = validate_against_schema(data, schema)

        if errors:
            print(f"❌ {file_path}:", file=sys.stderr)
            for error in errors:
                print(f"   - {error}", file=sys.stderr)
            all_valid = False
        else:
            print(f"✅ {file_path}: Valid")

    sys.exit(0 if all_valid else 1)


if __name__ == '__main__':
    main()
