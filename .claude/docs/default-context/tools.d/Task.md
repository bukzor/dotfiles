# Task

## Description

Launch a new agent to handle complex, multi-step tasks autonomously.

## Full Instructions

Launch a new agent to handle complex, multi-step tasks autonomously.

The Task tool launches specialized agents (subprocesses) that autonomously handle complex tasks. Each agent type has specific capabilities and tools available to it.

Available agent types and the tools they have access to:
- general-purpose: General-purpose agent for researching complex questions, searching for code, and executing multi-step tasks.
- Explore: Fast agent specialized for exploring codebases. Use this when you need to quickly find files by patterns, search code for keywords, or answer questions about the codebase.
- Plan: Software architect agent for designing implementation plans.
- claude-code-guide: Use this agent when the user asks questions about Claude Code or the Claude Agent SDK.

When using the Task tool, you must specify a subagent_type parameter to select which agent type to use.

When NOT to use the Task tool:
- If you want to read a specific file path, use the Read or Glob tool instead
- If you are searching for a specific class definition like "class Foo", use the Glob tool instead
- If you are searching for code within a specific file or set of 2-3 files, use the Read tool instead

Usage notes:
- Launch multiple agents concurrently whenever possible, to maximize performance
- When the agent is done, it will return a single message back to you. The result returned by the agent is not visible to the user.
- Each agent invocation is stateless. You will not be able to send additional messages to the agent.
- The agent's outputs should generally be trusted
- Clearly tell the agent whether you expect it to write code or just to do research
