---
description: Debug a Claude interaction that didn't go as expected
argument-hint: "[describe your frustration]"
---

Your task is to help root-cause and devise mitigations for perceieved
misbehavior in Claude.

Success criteria:

- correctly pinpoint the source of frustration
- find where claude's interpretation and user's meaning diverged
- devise an efficient change in input to mitigate the issue. Note that changes
  in input come in many forms:
  - a wording change in user's turns
  - a change to one of the involved CLAUDE\*md files
  - a change to any documentation that claude is using (particularly those on-
    disk provided by the user)

As such your focus should be on how to adjust the input to change claude
behavior, not on changing claude's behavior per se.

## User's frustration

This is a brief (and optional) description from the user about their
frustration. This to scope your investigation and analysis.

<quote>
$ARGUMENTS
</quote>

(The default scope is any recent rejections or clarifications in the
conversation.)

## Procedure

### Step 1: Derive a Problem Statement

The user is frustrated but may not fully understand their frustration. Do some
investigation and inference to set a problem statement. Do not continue unless
you're confident you have the right problem statement.

### Step 2: Analyze input(s)

Form a list of relevant inputs that CLAUDE is using during the interaction. The
necessary alterations may be in any one of these files.

### Step 3: Root cause analysis

Analyze the conversation to understand what went wrong:

1. **Identify where Claude's response diverged from the user's expectations**

   - What did the user expect Claude to do/say?
   - What did Claude actually do/say instead?

2. **Trace back to the input that caused the divergence**

   This may be several. Format: (with example)

   - source: (conversation)
   - ambiguous input: Did I miss anything?
   - user intent: Please analyze my prior statement for correctness and gaps.
   - Claude read: Are there _any_ problems we haven't yet discussed?
   - potential disambiguiations:
     - Am I right?
     - Please confirm or refute.

Include any claudefile or other file inputs which encouraged or exacerbated such
mismatches.

## Step 4: Proposed Solution

What change(s) would be most appropriate and effective to avoid this in future?

Keep in mind that additional context tokens and "cognitive burden" will reduce
overall LLM performance. Prefer removing or amending context over adding.
