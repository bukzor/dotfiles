# System Prompt Modularization Project

## Overview

This directory contains a modularized version of Claude Code's system prompt, broken down from a single large file into focused, maintainable components.

## Motivation

The original system prompt was a monolithic file that was difficult to:
- Edit specific sections without affecting others
- Navigate and understand the structure
- Optimize for token efficiency 
- Maintain consistent formatting and boundaries

## Structure

The modular system uses numbered prefixes to ensure proper loading order:

- **005-url-and-help-restrictions.md** - URL generation restrictions and help instructions
- **010-identity-and-purpose.md** - Core Claude Code identity and security guidelines
- **010-identity-and-purpose.agent.md** - Agent-specific variant of identity
- **020-antml-function-syntax.md** - Function call syntax and tool definitions
- **025-tool-definitions.d/** - Individual tool descriptions in `.d` directory structure
- **030-tone-and-style.md** - Communication guidelines, conciseness rules, examples
- **040-proactiveness-and-conventions.md** - Behavioral guidelines and code conventions
- **045-hooks-and-feedback.md** - Hook configuration and user feedback processing
- **050-task-workflows.md** - Task execution workflows and commit procedures
- **060-tool-usage-policy.md** - Tool selection guidelines and approval lists
- **070-environment-and-metadata.md** - Model info, environment context, git status
- **080-code-references-and-examples.md** - Code reference patterns and examples

## Benefits Achieved

1. **Token Efficiency**: Can include only relevant sections for different contexts
2. **Maintainability**: Each section can be edited independently
3. **Clear Boundaries**: Explicit section markers prevent content overlap
4. **Consistent Structure**: Numbered prefixes ensure proper loading order
5. **Searchability**: Easy to find and modify specific behavioral rules

## Assembly

Use `assemble-prompt.sh` to combine all sections into a complete system prompt for testing and validation.

## Validation

All tasks from the original TODO were completed:
- ✓ Content filled for all stub files
- ✓ Boundary markers verified
- ✓ Duplicate content removed
- ✓ Assembly script created and tested
- ✓ Token count improved (93 lines → 225+ lines with full content)
