Execute a skill within the main conversation

<skills_instructions>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke skills using this tool with the skill name only (no arguments)
- When you invoke a skill, you will see <command-message>The "{name}" skill is loading</command-message>
- The skill's prompt will expand and provide detailed instructions on how to complete the task
- Examples:
  - `skill: "pdf"` - invoke the pdf skill
  - `skill: "xlsx"` - invoke the xlsx skill
  - `skill: "ms-office-suite:pdf"` - invoke using fully qualified name

Important:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already running
- Do not use this tool for built-in CLI commands (like /help, /clear, etc.)
</skills_instructions>

<available_skills>
<skill>
<name>
artifacts-builder
</name>
<description>
Suite of tools for creating elaborate, multi-component claude.ai HTML artifacts using modern frontend web technologies (React, Tailwind CSS, shadcn/ui). Use for complex artifacts requiring state management, routing, or shadcn/ui components - not for simple single-file HTML/JSX artifacts. (user)
</description>
<location>
user
</location>
</skill>
<skill>
<name>
llm-collab-docs
</name>
<description>
Load when:\n\n1. After making significant decisions (to document as ADR)\n2. Before ending a work session (to document in devlog)\n3. When setting up documentation for a multi-session project\n4. When user asks about coordinating work across sessions (user)
</description>
<location>
user
</location>
</skill>
<skill>
<name>
llm.d
</name>
<description>
Load when:\n\n1. Creating structured knowledge bases (.d/ directories) OR\n2. Organizing facts/tasks for multi-agent LLM access OR\n3. Need grep-able metadata with schema validation (user)
</description>
<location>
user
</location>
</skill>
<skill>
<name>
struggle-bus
</name>
<description>
Load when:\n\n1. User says \"struggle bus\" or \"manual breathing\" OR\n2. User asks \"why did you [unexpected behavior]\" OR\n3. Multiple clarification attempts fail (user)
</description>
<location>
user
</location>
</skill>
<skill>
<name>
subtask
</name>
<description>
Load when:\n\n1. user gives a terse command starting with \"subtask\" or \"todo\" OR\n2. working with multiple tasks OR\n3. user asks a question during a task (user)
</description>
<location>
user
</location>
</skill>
<skill>
<name>
webapp-testing
</name>
<description>
Toolkit for interacting with and testing local web applications using Playwright. Supports verifying frontend functionality, debugging UI behavior, capturing browser screenshots, and viewing browser logs. (user)
</description>
<location>
user
</location>
</skill>
</available_skills>
