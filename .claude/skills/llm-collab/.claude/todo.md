- [x] todo.kb/2025-11-26-000 (destructure docs into references.kb/)
  - [x] Fix errors in must-read.d/before/creating-documentation.md
  - [x] Extract all content to references.kb/ (file-types, guidelines, workflows)
  - [x] Remaining: schemas, update references
- [x] todo.kb/2025-12-02-001 (create category overview files) — Low
- [x] todo.kb/2025-12-02-000 (factor SKILL.md above the fold) — Medium
- [x] Decide fate of creating-documentation.md (delete vs replace with index)
- [x] Consider must-read-before trigger for llm-collab-docs skill
- [~] todo.kb/2025-12-03-000 (pivot from .d to .kb naming) — references.kb/ done, triggers/validation remain
- [ ] todo.kb/2025-11-29-001 (document blocking pattern in subtask skill) — High/Low
- [x] todo.kb/2025-11-26-002 (devlog template redundancy fix) — Medium/Low
- [ ] todo.kb/2025-11-26-001 (ideas.kb/ pattern) — Medium/Low
- [x] Replace heredocs in bin/ scripts with skeleton/ copies
  - [x] llm-collab-init: all 6 heredocs → cp from skeleton/
  - [x] llm-collab-devlog: heredoc → sed from skeleton template
  - [x] llm-collab-adr: heredoc → sed from skeleton template
  - [x] llm-collab-idea: heredoc → sed from skeleton template
  - [x] Created missing skeleton/docs/adr/README.md
- [~] Check other scripts for docs/ → docs/dev/ migration needed (scan llm-collab and other skills)
  - [x] All bin/ scripts: rename -n|--name-only → -n|--dry-run (adr, devlog, idea, subtask-todo)
  - [x] skeleton/docs/dev/devlog/: old dir deleted, new dir exists with content
  - [ ] Verify llm-collab-devlog script still works
  - [ ] Run TESTING.md to verify bin/ scripts work with new paths
  - [ ] Check other skill scripts for similar migration needs

## Later

- [ ] todo.kb/2026-02-09-000 (design.kb pattern for living design docs)
- [ ] todo.kb/2025-11-29-000 (devlog reevaluation - strategic) — Medium/High
- [ ] todo.kb/2025-11-26-003 (clarify todo.md/todo.kb relationship in subtask skill docs)
