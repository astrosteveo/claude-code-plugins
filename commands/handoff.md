---
description: Create handoff document for transferring work to another session
argument-hint: [description]
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash(git:status, git:log, git:rev-parse, git:branch)
  - AskUserQuestion
---

# Handoff Phase

Create a **handoff document** for transferring work to another session.

A handoff captures your current context in a structured, concise format that enables efficient session resumption without context bloat.

## Input

**Optional argument**: Brief description for the handoff filename (kebab-case).

If not provided, derive from feature name or prompt user.

## Process

### 1. Locate Active Feature

Find the current workflow state:
```
.claude/workflows/*/state.md
```

Read `state.md` to get:
- Feature name and slug
- Current phase
- Directory path

**If no workflow found:**
Create a general handoff without workflow context. Ask user for a description.

### 2. Gather Context

#### Git Information
```bash
git rev-parse HEAD          # Current commit hash
git branch --show-current   # Current branch
git status --short          # Working tree status
```

#### Workflow Artifacts (if workflow exists)
From the feature directory, read available artifacts:
- `state.md` - Current phase and progress
- `plan.md` - Implementation plan (if exists)
- `*-research.md` - Research findings (if exist)
- `validation.md` - Validation results (if exists)

Extract:
- Current task status from state.md
- Which phase we're in
- What's been completed vs remaining
- Any blockers or issues

### 3. Generate Timestamp and Path

Generate handoff file path:
```
.claude/handoffs/[feature-slug]/YYYY-MM-DD_HH-MM-SS_[description].md
```

Where:
- `YYYY-MM-DD` is today's date
- `HH-MM-SS` is current time in 24-hour format
- `[feature-slug]` is from state.md or "general" if no workflow
- `[description]` is from argument or derived from feature

Example: `.claude/handoffs/003-add-auth/2025-01-15_14-30-22_phase2-complete.md`

### 4. Create Handoff Directory

```bash
mkdir -p .claude/handoffs/[feature-slug]/
```

### 5. Write Handoff Document

Use template from `/home/astrosteveo/workspace/epic/templates/handoff.md`

Fill in:

**Frontmatter:**
```yaml
---
date: [ISO 8601 timestamp with timezone]
git_commit: [commit hash from step 2]
branch: [branch name from step 2]
feature: [feature slug]
topic: "[Feature description]"
tags: [handoff, current-phase]
status: complete
---
```

**Task(s)**:
- List current tasks with status (completed/WIP/planned)
- Note current implementation phase if applicable
- Reference plan document path

**Critical References**:
- List 2-3 most important documents (plan, key research findings)
- Include file paths

**Recent Changes**:
- List files changed in `file:line` format
- Focus on changes made in this session

**Learnings**:
- Document important patterns discovered
- Note any root causes identified
- Include gotchas or constraints found

**Artifacts**:
- Exhaustive list of all workflow artifacts with paths
- Include status of each (complete, in_progress, pending)

**Action Items & Next Steps**:
- Clear list of what the next session should do
- Prioritize by importance

**Other Notes**:
- Any additional context that doesn't fit above
- Links to relevant documentation or issues

### 6. Confirm with User

Present handoff summary using AskUserQuestion:

**Show:**
- Handoff file path
- Task summary (what's done, what's remaining)
- Next steps

**Ask:** "Create this handoff?"
- Options: "Yes, create handoff" / "Edit description" / "Cancel"

### 7. Write and Report

After confirmation, write the handoff file.

Report to user:
```
✓ Handoff Created

Path: .claude/handoffs/[slug]/[filename].md

Summary:
- Feature: [feature name]
- Phase: [current phase]
- Tasks: [X complete, Y remaining]

Resume with:
/epic:resume .claude/handoffs/[slug]/[filename].md

Or start fresh session and run:
/epic:resume
```

## Output Format

### Success
```
✓ Handoff Created

Path: .claude/handoffs/[slug]/[filename].md
Feature: [description]
Phase: [current phase]

Next session can resume with:
  /epic:resume .claude/handoffs/[slug]/[filename].md
```

### Blocked
```
⚠️ Cannot Create Handoff

Reason: [specific issue]
Resolution: [specific action]
```

## Context Efficiency

This command compacts current session context into a structured document that:
- Captures essential state without raw artifacts
- Uses `file:line` references instead of full content
- Enables efficient resume without re-reading everything

**Target**: Handoff document should be < 200 lines while capturing all essential context.

## Safety Rules

1. **Never omit critical state** - All task status must be captured
2. **Use references, not content** - Point to files, don't copy them
3. **Be thorough but concise** - More information, not more words
4. **Include git state** - Branch and commit enable environment recreation
