---
description: Guided feature development with codebase understanding and architecture focus
argument-hint: Feature description
---

# Feature Development

Artifact-driven feature development. Each phase produces a document before moving on.

## Core Principles

- **Artifacts gate progress**: Each phase writes its artifact before the next phase begins
- **Understand before acting**: Read and comprehend existing code patterns first
- **Ask clarifying questions**: Start broad, narrow to specifics. No assumptions.
- **Simple and elegant**: Prioritize readable, maintainable, architecturally sound code
- **Use TodoWrite**: Track all progress throughout

---

## Setup: Initialize Feature

**Before anything else:**

### 1. Verify Git Repository

Check if current directory is a git repository:
- If not a git repo: Warn user and ask if they want to proceed without version control
- If uncommitted changes exist: Warn user and recommend committing or stashing first

### 2. Check for Incomplete Features

Look for `.feature-dev/NNN-slug/.state.json` files where `"completed": false`:
- If found: "Found incomplete feature NNN-slug at Phase X. Resume or start fresh?"
- If resume: Load state and continue from saved phase
- If start fresh: Let user decide to archive or delete old directory

### 3. Create Feature Directory

For new features:
1. Check `.feature-dev/` for existing directories (NNN-slug format)
2. Create next numbered directory: `.feature-dev/NNN-feature-slug/`
3. Use kebab-case slug from the feature description

### 4. Create Feature Branch

Create and checkout a feature branch:
```
git checkout -b feature/NNN-feature-slug
```
- If branch already exists, check it out
- All implementation work happens on this branch

### 5. Initialize State

Create `.feature-dev/NNN-slug/.state.json`:
```json
{
  "feature": "feature-slug",
  "branch": "feature/NNN-feature-slug",
  "currentPhase": 1,
  "completedArtifacts": [],
  "completed": false,
  "createdAt": "ISO-timestamp"
}
```

Update `.state.json` as each phase completes.

---

## Phase 1: Requirements

**Goal**: Fully understand what needs to be built through Socratic dialogue

**Input**: $ARGUMENTS

**Process**:

Start BROAD, then narrow down:

1. **Problem Space** (broad)
   - What problem is being solved?
   - Who experiences this problem?
   - What happens if we don't solve it?

2. **Solution Vision** (narrowing)
   - What does success look like?
   - What should the user experience be?
   - What are the boundaries of this feature?

3. **Constraints & Requirements** (specific)
   - Technical constraints?
   - Performance requirements?
   - Compatibility needs?
   - Edge cases to handle?

4. **Success Criteria** (concrete)
   - How do we know it's done?
   - How do we test it works?

Ask questions ONE AT A TIME. Wait for answers. Don't assume.

**Artifact**: Save `.feature-dev/NNN-slug/requirements.md`

```markdown
# Requirements: [Feature Name]

## Problem
[What problem is being solved and why it matters]

## Solution
[What the feature should do]

## Constraints
[Technical and business constraints]

## Success Criteria
- [ ] [Specific, testable criterion]
- [ ] [Another criterion]
```

**Gate**: Do not proceed until requirements.md is written and user confirms.

**State**: Update `.state.json`: `currentPhase: 2`, add `requirements.md` to `completedArtifacts`.

---

## Phase 2: Exploration

**Goal**: Understand relevant existing code and patterns

**Actions**:
1. Launch 2-3 code-explorer agents in parallel:
   - "Find features similar to [feature] and trace through their implementation"
   - "Map the architecture for [feature area]"
   - "Identify patterns, testing approaches, extension points for [feature]"

2. Each agent should return 5-10 key files to read

3. Read all identified files to build deep understanding

**Artifact**: Save `.feature-dev/NNN-slug/exploration.md`

```markdown
# Exploration: [Feature Name]

## Existing Patterns
- [Pattern]: Found in [files], used for [purpose]

## Related Code
- [File]: [What it does, how it relates]

## Key Files
- [file1.ts]: [relevance]
- [file2.ts]: [relevance]

## Insights
- [Things that will affect the design]

## Backlog Candidates
- [Any tech debt, bugs, or improvements discovered in existing code]
```

**Backlog**: If agents surfaced any tech debt, bugs, or improvements in existing code, log them to `.feature-dev/backlog.md` (see Project Backlog section).

**Gate**: Do not proceed until exploration.md is written.

**State**: Update `.state.json`: `currentPhase: 3`, add `exploration.md` to `completedArtifacts`.

---

## Phase 3: Architecture

**Goal**: Design the implementation approach

**Actions**:
1. Launch 2-3 code-architect agents with different focuses:
   - Minimal changes (smallest diff, maximum reuse)
   - Clean architecture (maintainability, elegant abstractions)
   - Pragmatic balance (speed + quality)

2. Review approaches and form recommendation

3. Present to user:
   - Summary of each approach
   - Trade-offs comparison
   - **Your recommendation with reasoning**

4. **Ask user which approach they prefer**

**Artifact**: Save `.feature-dev/NNN-slug/architecture.md`

```markdown
# Architecture: [Feature Name]

## Chosen Approach
[Name and description of selected approach]

## Rationale
[Why this approach was chosen]

## Components
- [Component]: [Purpose]

## Changes Required
- [File]: [What changes]

## Data Flow
[How data moves through the system]
```

**Gate**: Do not proceed until user approves approach and architecture.md is written.

**State**: Update `.state.json`: `currentPhase: 4`, add `architecture.md` to `completedArtifacts`.

---

## Phase 4: Plan

**Goal**: Create detailed implementation steps

**Actions**:
1. Review all artifacts: requirements, exploration, architecture
2. Break down into specific, ordered tasks
3. Identify dependencies between tasks

**Artifact**: Save `.feature-dev/NNN-slug/plan.md`

```markdown
# Plan: [Feature Name]

## Tasks

### Task 1: [Description]
- File: [path]
- Action: [create/modify]
- Details: [specific changes]
- Depends on: [nothing / Task N]

### Task 2: [Description]
...

## Testing Plan
- [ ] [Test case]

## Verification
- [ ] [How to verify it works]
```

**Gate**: Do not proceed until plan.md is written.

**State**: Update `.state.json`: `currentPhase: 5`, add `plan.md` to `completedArtifacts`.

---

## Phase 5: Implementation

**Goal**: Build the feature

**CRITICAL**: Do not start without explicit user approval.

**Actions**:
1. Ask: "Plan ready. Proceed with implementation?"
2. Wait for explicit "yes"
3. Work through each task in order
4. Update todos as you progress
5. Follow codebase conventions strictly

**Gate**: All tasks complete, code compiles/runs.

**State**: Update `.state.json`: `currentPhase: 6`.

---

## Phase 6: Review

**Goal**: Ensure quality

**Actions**:
1. Launch 3 code-reviewer agents:
   - Simplicity / DRY / elegance
   - Bugs / functional correctness
   - Project conventions / abstractions

2. Consolidate findings

3. Present to user: issues found, recommended fixes

4. Ask: "Fix now, fix later, or proceed as-is?"

5. Address based on user decision

**Artifact**: Save `.feature-dev/NNN-slug/review.md`

```markdown
# Review: [Feature Name]

## Issues Found
- [Severity]: [Issue] - [Resolution]

## Changes Made
- [What was fixed]

## Outstanding Items
- [Anything deferred]

## Backlog Candidates
- [Pre-existing issues discovered during review]
```

**Backlog**: If reviewers discovered pre-existing bugs or tech debt in the codebase (not introduced by this feature), log them to `.feature-dev/backlog.md`.

**State**: Update `.state.json`: `currentPhase: 7`, add `review.md` to `completedArtifacts`.

---

## Phase 7: Summary

**Goal**: Document completion

**Artifact**: Save `.feature-dev/NNN-slug/summary.md`

```markdown
# Summary: [Feature Name]

## What Was Built
[Brief description]

## Files Changed
- [file]: [what changed]

## Key Decisions
- [Decision]: [Rationale]

## Next Steps
- [Suggested follow-ups]
```

**Dashboard Update**: After writing summary.md:
1. Open `.feature-dev/dashboard.md` (create from template if needed)
2. Add any "Next Steps" from summary.md to the Recommended Next Steps table
3. Promote high-priority backlog items to the appropriate dashboard sections
4. Check off any items that were completed during this feature

**State**: Update `.state.json`: `completed: true`, add `summary.md` to `completedArtifacts`.

**Git**: Remind user that work is on branch `feature/NNN-slug` and suggest:
- Create PR for review: `gh pr create`
- Or merge to main if approved: `git checkout main && git merge feature/NNN-slug`

Mark all todos complete. Announce completion.

---

## Project Dashboard

**Purpose**: Provide a clear "what's next" view for the project, aggregating recommended work from completed features and the backlog.

**File**: `.feature-dev/dashboard.md`

**Format**:

```markdown
# Project Dashboard

## Recommended Next Steps

High-value work suggested from completed features:

| Priority | Description | Source | Notes |
|----------|-------------|--------|-------|
| High | Add unit tests for auth module | 003-user-auth | Deferred during review |
| Medium | Implement caching for API calls | 002-api-client | Performance improvement |

## Quick Wins

Small, low-effort items that can be knocked out quickly:

- [ ] [TD-003] Fix typo in error message (src/errors.ts:24)
- [ ] [IMP-002] Add missing type annotation (src/utils.ts:89)

## Priority Bugs

Bugs that should be addressed soon:

- [ ] [BUG-001] Race condition in session handling - **High**
- [ ] [BUG-003] Incorrect date formatting in reports - **Medium**

## Tech Debt Queue

Technical debt ranked by impact:

- [ ] [TD-001] Refactor duplicated validation logic - **High**
- [ ] [TD-002] Migrate deprecated API calls - **Medium**
```

**Maintenance**:
- Update after completing each feature (Phase 7)
- Pull high-priority items from backlog.md
- Archive completed items
- Re-prioritize as project evolves

---

## Project Backlog

**Purpose**: Log project-wide tech debt, bugs, and improvement opportunities discovered during feature development that aren't scoped to the current feature.

**File**: `.feature-dev/backlog.md`

**When to Log**:
- During **Exploration**: Technical debt or architectural issues discovered in existing code
- During **Review**: Bugs or issues found that exist outside the feature's scope
- Anytime: Pre-existing problems that should be addressed but aren't blocking current work

**Format**:

```markdown
# Project Backlog

## Tech Debt

### [TD-001] [Short title]
- **Severity**: Low | Medium | High | Critical
- **Location**: [file:line or component]
- **Description**: [What the issue is]
- **Suggested Fix**: [How to address it]
- **Discovered**: [Date] during [feature-slug]

## Bugs

### [BUG-001] [Short title]
- **Severity**: Low | Medium | High | Critical
- **Location**: [file:line or component]
- **Description**: [What's broken]
- **Reproduction**: [How to trigger it]
- **Discovered**: [Date] during [feature-slug]

## Improvements

### [IMP-001] [Short title]
- **Priority**: Low | Medium | High
- **Location**: [file:line or component]
- **Description**: [What could be better]
- **Benefit**: [Why it matters]
- **Discovered**: [Date] during [feature-slug]
```

**Process**:
1. Check if `.feature-dev/backlog.md` exists; create from template if not
2. Assign next sequential ID within category (TD-001, BUG-002, etc.)
3. Include the feature slug where the issue was discovered for traceability
4. When issues are fixed, move them to a `## Resolved` section with resolution date

---

## Artifact Checklist

Before implementation begins, these must exist:
- [ ] `.feature-dev/NNN-slug/requirements.md`
- [ ] `.feature-dev/NNN-slug/exploration.md`
- [ ] `.feature-dev/NNN-slug/architecture.md`
- [ ] `.feature-dev/NNN-slug/plan.md`

After completion:
- [ ] `.feature-dev/NNN-slug/review.md`
- [ ] `.feature-dev/NNN-slug/summary.md`

Project-wide (maintain as needed):
- [ ] `.feature-dev/dashboard.md` - Updated with next steps
- [ ] `.feature-dev/backlog.md` - Updated with discovered issues
