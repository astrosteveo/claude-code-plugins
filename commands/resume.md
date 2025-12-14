---
description: Resume work from a handoff document or workflow state
argument-hint: [path/to/handoff.md]
allowed-tools:
  - Read
  - Glob
  - AskUserQuestion
---

# Resume Phase

Resume work from a **handoff document** or active workflow state.

This command efficiently restores context from a previous session without re-reading all artifacts in full.

## Input

**Optional argument**: Path to a specific handoff document.

If not provided, shows a picker of available handoffs and workflows.

## Process

### 1. Parse Argument

Check if a path argument was provided:
- **With path**: Skip to step 3 with that path
- **Without path**: Proceed to step 2 for picker

### 2. Discover Available Options (No Path)

Find all resumable items:

#### Handoffs
```
.claude/handoffs/**/*.md
```

For each handoff, extract from frontmatter:
- `date` - When created
- `feature` - Feature slug
- `topic` - Description

#### Active Workflows
```
.claude/workflows/*/state.md
```

For each workflow state, extract:
- Feature name
- Current phase
- Last updated

#### Present Picker

Use AskUserQuestion to show options:

```
Which session would you like to resume?

**Recent Handoffs:**
1. [2025-01-15 14:30] 003-add-auth - Phase 2 complete
2. [2025-01-14 09:15] 002-caching - Implementation blocked

**Active Workflows:**
3. [Implement] 003-add-auth - Phase 2 of 4
4. [Plan] 004-logging - Ready for implement

Options: [1] / [2] / [3] / [4]
```

### 3. Load Selected Item

Based on selection or argument:

#### If Handoff Document
Read the handoff file and extract:
- Task status from `## Task(s)` section
- Critical references from `## Critical References`
- Action items from `## Action Items & Next Steps`
- Artifact paths from `## Artifacts`

#### If Workflow State
Read `state.md` and extract:
- Current phase
- Phase completion status
- Progress section (if in implement phase)

### 4. Load Referenced Artifacts

Based on current phase and handoff content, selectively load:

| Phase | Load |
|-------|------|
| Explore | Just state.md summary |
| Plan | state.md + research summaries |
| Implement | state.md + plan.md + progress |
| Validate | state.md + plan.md + progress |
| Commit | All artifact summaries |

**Efficiency rule**: Read only what's needed for the current phase. Use summaries and `file:line` references where possible.

### 5. Determine Next Action

Based on loaded context, identify:
- What phase we're in
- What task is in progress
- What the next step should be

### 6. Present Context Summary

Report to user:

```
✓ Context Restored

**Feature**: [feature name]
**Phase**: [current phase]
**Branch**: [git branch from handoff]

## Current State
[Summary of where we are]

## In Progress
- [Current task with status]

## Next Steps
1. [Immediate next action]
2. [Following action]

## Loaded Artifacts
- state.md (full)
- plan.md (summary)
- codebase-research.md (referenced)

Ready to continue. What would you like to do?
```

## Output Format

### Success (from Handoff)
```
✓ Resumed from Handoff

Source: .claude/handoffs/[slug]/[filename].md
Feature: [description]
Phase: [phase]
Git: [branch] @ [commit]

Current Task: [in-progress task]
Next: [immediate next step]

Artifacts loaded: [count] files referenced
```

### Success (from Workflow)
```
✓ Resumed from Workflow

Source: .claude/workflows/[slug]/state.md
Feature: [description]
Phase: [phase]

Current Task: [from progress section]
Next: [next command or action]

Artifacts loaded: [count] files
```

### No Options Found
```
⚠️ Nothing to Resume

No handoffs found in .claude/handoffs/
No active workflows found in .claude/workflows/

Start a new workflow with: /epic:explore [feature]
```

### Path Not Found
```
⚠️ Cannot Resume

Path not found: [provided path]

Available options:
- .claude/handoffs/[list discovered handoffs]
- .claude/workflows/[list discovered workflows]
```

## Context Efficiency

This command is designed for **minimal context loading**:

**DO:**
- Load handoff document in full (it's already compacted)
- Use artifact references rather than full content
- Load only phase-relevant artifacts
- Present summaries, not raw data

**DON'T:**
- Read all research files in full
- Re-read implementation details unless in implement phase
- Load validation results unless in validate/commit phase

**Target**: Resume should use < 20% of context window while providing full situational awareness.

## Picker UX Details

When using AskUserQuestion for the picker:

**Question format:**
```
Select a session to resume:
```

**Options format** (2-4 most recent):
```
Option 1: "[date] [slug] - [description/phase]"
Option 2: "[date] [slug] - [description/phase]"
...
```

**If more than 4 options exist:**
Show the 4 most recent, with note: "Run with explicit path for older handoffs"

## Safety Rules

1. **Verify file exists** before attempting to read
2. **Validate frontmatter** - handoffs should have required fields
3. **Handle missing artifacts gracefully** - don't fail if referenced file doesn't exist
4. **Report what was loaded** - user should know what context is active
