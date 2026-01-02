---
name: handoff
description: "Create structured handoff document for intentional context compaction and session continuation"
argument-hint: "<optional description>"
load-skills:
  - verification
---

# Create Handoff

You are tasked with creating a handoff document for intentional context compaction. This is a core principle - distilling current progress into a structured artifact that enables fresh context continuation.

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
   - Check for `phase(N): complete` trailers
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

**For feature-specific handoff:**
`.harness/NNN-feature-slug/handoff.md`

**For cross-feature/general handoff:**
`.harness/handoffs/YYYY-MM-DD_HH-MM-SS_description.md`

Examples:
- `.harness/003-auth/handoff.md`
- `.harness/handoffs/2025-01-15_14-30-22_debug-api-timeout.md`

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

## Phase Progress

[If executing a plan, show phase status:]
- Phase 1: [x] Complete (phase(1): complete in git)
- Phase 2: [x] Complete (phase(2): complete in git)
- Phase 3: [ ] In Progress - Task 2 of 4 done

## Critical References

[Only 2-3 most important documents that must be read to continue:]
- `.harness/NNN-slug/plan.md` - The implementation plan being executed
- `.harness/NNN-slug/research.md` - Key research informing the work

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
- Blockers or dependencies: [If any]
```

### Step 4: Write and Present

1. **Create the handoff file** using the Write tool

2. **Present completion**:

```
Handoff created! You can resume from this handoff in a new session with:

/superharness:resume .harness/NNN-slug/handoff.md

Current state:
- Phase X of Y complete
- Next action: [immediate action item]
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
- When debugging a complex issue over multiple sessions
- When the session hook prompts about context limits

## Cross-References

- To resume work: `/superharness:resume`
- For planning: `/superharness:create-plan`
- For research: `/superharness:research`
