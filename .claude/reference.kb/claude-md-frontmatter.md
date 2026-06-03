# CLAUDE.md frontmatter stripping (anthropics/claude-code#13003)

YAML frontmatter in CLAUDE.md files is parsed and stripped before the content
reaches the model. Only `paths:` is consumed (for the unreleased
`.claude/rules/` feature); every other field is discarded.

**Workaround:** open with a commented fence. The comment after `---` stops the
parser from treating the block as frontmatter, so the content passes through as
regular markdown:

    --- # workaround: anthropics/claude-code#13003
    requires:
        - Skill(llm-subtask)
    ---
