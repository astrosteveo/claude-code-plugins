---
description: "Create structured handoff document for intentional context compaction and session continuation"
argument-hint: "<optional ticket number or description>"
---

# Create Handoff

You are tasked with creating a handoff document for intentional context compaction. This is a core ACE-FCA principle - distilling current progress into a structured artifact that enables fresh context continuation.

## Purpose

Handoffs enable:
- **Intentional Compaction**: Distill accumulated context into essential information
- **Clean Continuation**: Enable new sessions to resume work efficiently
- **Knowledge Preservation**: Capture learnings and gotchas that would otherwise be lost
- **Progress Tracking**: Document what was accomplished and what remains

## Process

### Step 1: Gather Context

Before writing, gather information about current state:

1. **Review current work**:
   - What task(s) were you working on?
   - What phase of implementation are you in?
   - Which plan or research document are you following?

2. **Identify recent changes**:
   - Run `git status` to see uncommitted changes
   - Run `git log --oneline -10` to see recent commits
   - Note specific files modified and why

3. **Collect learnings**:
   - What patterns did you discover?
   - What gotchas or edge cases did you encounter?
   - What debugging insights were gained?

4. **List artifacts created**:
   - Documents written or updated
   - Code files created or modified
   - Test files added

### Step 2: Determine Filename

**Filename format:** `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS_description.md`
- YYYY-MM-DD is today's date
- HH-MM-SS is the current time in 24-hour format
- description is a brief kebab-case description

**Examples:**
- `thoughts/shared/handoffs/2025-01-15_14-30-22_implement-auth-phase-2.md`
- `thoughts/shared/handoffs/2025-01-15_09-15-00_debug-api-timeout.md`

**If no thoughts directory exists:**
- Use `handoffs/YYYY-MM-DD_HH-MM-SS_description.md`
- Or an appropriate location for the project

### Step 3: Write the Handoff

Use this template:

```markdown
---
date: [ISO timestamp with timezone]
researcher: Claude
topic: "[Brief description of work]"
tags: [handoff, relevant-tags]
status: complete
---

# Handoff: [Concise Description]

## Task(s)

[Description of task(s) you were working on, with status of each:]
- **Completed**: [Tasks finished]
- **In Progress**: [Tasks partially done - be specific about what's done and what remains]
- **Planned**: [Tasks discussed but not started]

[If working from an implementation plan, specify which phase you're on]

## Critical References

[Only 2-3 most important documents that must be read to continue:]
- `path/to/plan.md` - The implementation plan being executed
- `path/to/research.md` - Key research informing the work

## Recent Changes

[Describe changes made to the codebase in file:line syntax:]
- `src/auth/handler.ts:45-67` - Added JWT validation logic
- `tests/auth.test.ts:12-34` - Added unit tests for token refresh
- `config/settings.json` - Updated timeout configuration

## Learnings

[Important discoveries that the next session should know:]
- Pattern: [Describe pattern discovered, with file reference]
- Gotcha: [Edge case or bug cause to be aware of]
- Decision: [Important decision made and why]

## Artifacts

[Exhaustive list of files produced or updated:]
- `path/to/file.ext` - Description
- `path/to/another.ext:line-range` - Description

## Action Items & Next Steps

[Prioritized list of what to do next:]
1. **Immediate**: [Most important next action]
2. **Next**: [Second priority]
3. **Later**: [Lower priority items]

## Other Notes

[Any additional context that doesn't fit above:]
- Relevant code locations: `path/to/relevant/code.ts`
- Related documentation: `path/to/docs.md`
- External resources: [URLs if relevant]
- Blockers or dependencies: [If any]
```

### Step 4: Write and Present

1. **Create the handoff file** using the Write tool

2. **Present completion**:

```
Handoff created! You can resume from this handoff in a new session with:

/ace-workflows:resume-handoff thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS_description.md
```

## Guidelines

### More Information, Not Less

This template defines the minimum. Include additional information if:
- Complex debugging context needs to be preserved
- Multiple interrelated tasks are in progress
- Important decisions were made that need justification

### Be Thorough and Precise

- Include both top-level objectives and necessary lower-level details
- Use specific file:line references that an agent can follow
- Don't assume the next session will have any of your current context

### Avoid Excessive Code Snippets

- Prefer file:line references over large code blocks
- Only include code if it's essential (e.g., an error being debugged)
- The next session can read the files directly

### Capture the "Why"

- Don't just list what was done - explain why
- Document decisions and trade-offs
- Note anything that was tried and didn't work

## When to Create a Handoff

- Before ending a work session
- When context is getting too large
- When switching to a different task temporarily
- When multiple agents need to coordinate on work
- When debugging a complex issue over multiple sessions

## Cross-References

- To resume work: `/ace-workflows:resume-handoff`
- For planning: `/ace-workflows:create-plan`
- For research: `/ace-workflows:research-codebase`
