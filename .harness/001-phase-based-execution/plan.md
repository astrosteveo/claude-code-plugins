# Phase-Based Execution Implementation Plan

> **For Claude:** Execute using subagent per Phase. Each Phase is a cohesive unit - complete all tasks within a Phase before moving to the next.

**Goal:** Streamline planning-to-execution workflow with Phase-based subagent dispatch, auto-checkpointing, and marker-driven session resume.

**Architecture:** Modify 6 existing skills to support Phase-level execution. Add PENDING_EXECUTION.md marker system for seamless session handoff. Session start hook auto-detects pending work.

**Tech Stack:** Markdown skill files (no external dependencies)

**Research Summary:** All skill files reviewed during brainstorming. No external APIs or libraries involved - pure markdown modifications.

**Sources:** Existing skill files in `plugins/harness/skills/`

**Phases:**
1. Phase 1: Update writing-plans (3 tasks) - Phase structure, header, handoff
2. Phase 2: Update subagent-driven-development (3 tasks) - Phase-level dispatch
3. Phase 3: Update handling-context-exhaustion (2 tasks) - Marker creation
4. Phase 4: Update using-harness (2 tasks) - Session start hook
5. Phase 5: Update supporting skills (2 tasks) - executing-plans, resuming-work
6. Phase 6: Integration & Testing (2 tasks) - Verify, commit

---

## Phase 1: Update writing-plans Skill

### Task 1.1: Add Phase Structure Requirements

**Files:**
- Modify: `plugins/harness/skills/writing-plans/skill.md`

**Step 1: Add Phase Structure section after "Bite-Sized Task Granularity"**

Add this new section:

```markdown
## Phase Structure (REQUIRED)

Plans MUST be organized into Phases. Phases are the unit of subagent execution.

**Phase requirements:**
- Each Phase groups 2-6 related tasks
- Phase naming: `## Phase N: [Descriptive Name]`
- Task naming: `### Task N.M: [Name]` or `### Task M: [Name]`
- Each Phase has a clear completion state (tests pass, commits made)

**Phase sizing guidelines:**

| Phase Size | Tasks | Guidance |
|------------|-------|----------|
| Too small | 1 task | Merge with adjacent Phase |
| Ideal | 2-4 tasks | Good subagent workload |
| Acceptable | 5-6 tasks | Consider splitting if complex |
| Too large | 7+ tasks | Must split into multiple Phases |

**Phase completion criteria:**
- All tasks in Phase complete
- Tests passing
- Commit(s) made
- Clear handoff state for next Phase
```

**Step 2: Verify the section was added correctly**

Read the file and confirm the new section exists between "Bite-Sized Task Granularity" and "Plan Document Header".

**Step 3: Commit**

```bash
git add plugins/harness/skills/writing-plans/skill.md
git commit -m "feat(writing-plans): add Phase structure requirements"
```

---

### Task 1.2: Update Plan Header Template

**Files:**
- Modify: `plugins/harness/skills/writing-plans/skill.md`

**Step 1: Update the Plan Document Header section**

Replace the existing header template with:

```markdown
## Plan Document Header

**Every plan MUST start with this header:**

\`\`\`markdown
# [Feature Name] Implementation Plan

> **For Claude:** Execute using subagent per Phase. Each Phase is a cohesive unit.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries with VERIFIED current versions]

**Research Summary:** [Key findings from harness:researching]

**Sources:** [URLs to documentation referenced]

**Phases:**
1. Phase 1: [Name] (N tasks)
2. Phase 2: [Name] (N tasks)
3. Phase 3: [Name] (N tasks)
...

---
\`\`\`

The Phases summary gives quick overview of the work scope and helps with progress tracking.
```

**Step 2: Verify the header template was updated**

Read the file and confirm the header includes the Phases summary list.

**Step 3: Commit**

```bash
git add plugins/harness/skills/writing-plans/skill.md
git commit -m "feat(writing-plans): update plan header with Phases summary"
```

---

### Task 1.3: Replace Execution Handoff

**Files:**
- Modify: `plugins/harness/skills/writing-plans/skill.md`

**Step 1: Replace the entire "Execution Handoff" section**

Replace from `## Execution Handoff` to end of file with:

```markdown
## Execution Handoff

After saving the plan, create checkpoint and offer execution choice:

**Step 1: Auto-create checkpoint**

Save checkpoint to `.harness/NNN-feature-slug/checkpoint.md`:

\`\`\`markdown
# Checkpoint

**Created:** [timestamp]
**Plan:** .harness/NNN-feature-slug/plan.md
**Branch:** [current branch]

## Progress
- All Phases: pending

## Next Steps
1. Execute Phase 1: [Phase name]
\`\`\`

**Step 2: Present execution options**

\`\`\`
✅ **Plan complete and saved**

- Plan: `.harness/NNN-feature-slug/plan.md`
- Checkpoint: `.harness/NNN-feature-slug/checkpoint.md`

**[N] Phases identified:**
1. Phase 1: [Name] (N tasks)
2. Phase 2: [Name] (N tasks)
...

---

**How would you like to proceed?**

| Option | Description |
|--------|-------------|
| **Continue** | Execute now in this session |
| **New Session** | Start fresh session to execute |

**Mode** (applies to either option):
| Mode | Description |
|------|-------------|
| **Autonomous** | Runs all Phases without stopping |
| **Checkpoint** | Pauses after each Phase for approval |

Examples: "continue autonomous", "new session checkpoint", "continue"
\`\`\`

**Step 3: Handle choice**

**If "Continue" chosen:**
- Stay in current session
- **REQUIRED SUB-SKILL:** Use harness:subagent-driven-development
- Set mode: autonomous or checkpoint (default: checkpoint)
- Execute Phase by Phase with fresh subagent per Phase

**If "New Session" chosen:**
- Create PENDING_EXECUTION.md marker (see below)
- Display: "Marker created. Start new session to auto-resume."
- User starts new session, hook auto-invokes appropriate skill

**PENDING_EXECUTION.md marker format:**

\`\`\`markdown
# Pending Execution

**Created:** [timestamp]
**Reason:** planning-complete
**Plan:** .harness/NNN-feature-slug/plan.md
**Checkpoint:** .harness/NNN-feature-slug/checkpoint.md
**Mode:** [autonomous|checkpoint]
**Progress:**
  - Phase 1: pending
  - Phase 2: pending
  ...
**Worktree:** [path]
\`\`\`

Save marker to: `.harness/PENDING_EXECUTION.md`
```

**Step 2: Verify the handoff section was replaced**

Read the end of the file and confirm it matches the new structure.

**Step 3: Commit**

```bash
git add plugins/harness/skills/writing-plans/skill.md
git commit -m "feat(writing-plans): replace handoff with 2-option flow and marker system"
```

---

## Phase 2: Update subagent-driven-development Skill

### Task 2.1: Update Overview and Core Principle

**Files:**
- Modify: `plugins/harness/skills/subagent-driven-development/skill.md`

**Step 1: Update the opening section**

Replace the opening (lines 1-12 approximately) with:

```markdown
---
name: subagent-driven-development
description: Use when executing implementation plans with independent Phases in the current session
---

# Subagent-Driven Development

Execute plan by dispatching fresh subagent per **Phase**, with spec + code quality review after each Phase completes.

**Core principle:** Fresh subagent per Phase + two-stage review (spec then quality) = high quality, context-efficient execution

**Key change from task-level:** Each subagent handles an entire Phase (2-6 tasks), not individual tasks. This reduces dispatch overhead while maintaining fresh context.

**Checkpoint Mode:** This skill supports two modes:
- **Autonomous (checkpoint OFF)** - Runs all Phases without stopping for human input
- **Checkpoints (checkpoint ON)** - Pauses after each Phase for human approval before proceeding
```

**Step 2: Verify the opening was updated**

Read the file and confirm it references Phases, not Tasks.

**Step 3: Commit**

```bash
git add plugins/harness/skills/subagent-driven-development/skill.md
git commit -m "feat(subagent-driven): update overview for Phase-level execution"
```

---

### Task 2.2: Update Process Flow Diagram

**Files:**
- Modify: `plugins/harness/skills/subagent-driven-development/skill.md`

**Step 1: Replace "The Process" section**

Find the `## The Process` section and replace the flow diagram with:

```markdown
## The Process

\`\`\`
Read plan, extract all Phases with full content
    ↓
Create TodoWrite with Phases (not individual tasks)
    ↓
For each Phase:
    ↓
    Mark Phase as in_progress
        ↓
    Dispatch implementer subagent with FULL Phase content
    (all tasks, all steps, all code - subagent executes sequentially)
        ↓
    Subagent executes all Tasks in Phase using TDD
    (commits after each Task within the Phase)
        ↓
    Subagent completes, returns summary
        ↓
    Dispatch spec reviewer for entire Phase
        ↓
    [If issues] Dispatch fix subagent → re-review
        ↓
    Dispatch code quality reviewer for entire Phase
        ↓
    [If issues] Dispatch fix subagent → re-review
        ↓
    Mark Phase complete in TodoWrite
        ↓
    [If checkpoint mode] Report to user, wait for approval
        ↓
Next Phase
    ↓
All Phases complete → harness:finishing-a-development-branch
\`\`\`

**Per-Phase flow details:**

1. **Extract Phase content:** Read all tasks, steps, code snippets for this Phase
2. **Dispatch implementer:** Give subagent the complete Phase specification
3. **Subagent executes:** Works through tasks sequentially, using TDD, commits per task
4. **Spec review:** Verify all tasks in Phase meet spec requirements
5. **Quality review:** Verify code quality across all Phase changes
6. **Checkpoint (if enabled):** Pause for human approval before next Phase
```

**Step 2: Verify the process section was updated**

Read the file and confirm the flow references Phases.

**Step 3: Commit**

```bash
git add plugins/harness/skills/subagent-driven-development/skill.md
git commit -m "feat(subagent-driven): update process flow for Phase-level dispatch"
```

---

### Task 2.3: Update Comparison Table and Examples

**Files:**
- Modify: `plugins/harness/skills/subagent-driven-development/skill.md`

**Step 1: Find and update the comparison table**

Update the comparison table to reflect Phase-level execution:

```markdown
## Comparison of Execution Approaches

| Factor | Autonomous | Checkpoints | Batch Review |
|--------|------------|-------------|--------------|
| Skill | subagent-driven | subagent-driven | executing-plans |
| Session | Same | Same | Separate (worktree) |
| Dispatch unit | Phase | Phase | Phase |
| Human stops | None | After each Phase | After each Phase |
| Reviews | Automated (subagents) | Automated (subagents) | Human |
| Context | Fresh per Phase | Fresh per Phase | Accumulates |
| Speed | Fastest | Medium | Slowest |
| Best for | Independent Phases, trust process | Want oversight per Phase | Complex/risky changes |
```

**Step 2: Update the Example Workflow section**

Replace example to show Phase-level execution:

```markdown
## Example Workflow

\`\`\`
You: I'm using Subagent-Driven Development to execute this plan.

[Read plan file: .harness/004-world-design/plan.md]
[Extract all 6 Phases with full content]
[Create TodoWrite with 6 Phase items]

Phase 1: Camera System (3 tasks)

[Mark Phase 1 as in_progress]
[Dispatch implementer subagent with full Phase 1 content]

Implementer: "Before I begin - should camera lerp be configurable?"

You: "Use 0.08 for now, we can make it configurable later"

Implementer: "Got it. Implementing Phase 1..."
[Later] Implementer:
  - Task 1.1: Camera follow - done, committed
  - Task 1.2: Zoom levels - done, committed
  - Task 1.3: Parallax fix - done, committed
  - All tests passing
  - Phase 1 complete

[Dispatch spec reviewer for Phase 1]
Spec reviewer: ✅ All 3 tasks meet spec requirements

[Dispatch code quality reviewer for Phase 1]
Code reviewer: ✅ Clean implementation, approved

[Mark Phase 1 complete]
[If checkpoint mode: "Phase 1 complete. Continue to Phase 2?"]

Phase 2: World Expansion (2 tasks)
...
\`\`\`
```

**Step 3: Update Red Flags section**

Update red flags to reference Phases:

```markdown
## Red Flags

**Never:**
- Skip reviews (spec compliance OR code quality) at Phase level
- Proceed to next Phase with unfixed issues
- Dispatch multiple Phase subagents in parallel (use sequential)
- Make subagent read plan file (provide full Phase content instead)
- Accept "close enough" on spec compliance
- Move to next Phase while current Phase has open review issues
```

**Step 4: Commit**

```bash
git add plugins/harness/skills/subagent-driven-development/skill.md
git commit -m "feat(subagent-driven): update tables and examples for Phase-level"
```

---

## Phase 3: Update handling-context-exhaustion Skill

### Task 3.1: Add Marker Creation to Process

**Files:**
- Modify: `plugins/harness/skills/handling-context-exhaustion/skill.md`

**Step 1: Update Step 4 (Create Checkpoint) to also create marker**

Find the "### Step 4: Create Checkpoint" section and add marker creation after it:

```markdown
### Step 5: Create PENDING_EXECUTION Marker

After creating checkpoint, create the marker for auto-resume:

**Location:** `.harness/PENDING_EXECUTION.md`

\`\`\`markdown
# Pending Execution

**Created:** [timestamp]
**Reason:** context-exhaustion
**Plan:** .harness/NNN-feature-name/plan.md
**Checkpoint:** .harness/NNN-feature-name/checkpoint.md
**Mode:** [current mode - autonomous or checkpoint]
**Progress:**
  - Phase 1: complete
  - Phase 2: complete
  - Phase 3: in-progress (Task 3.2)
  - Phase 4: pending
  ...
**Worktree:** [current worktree path]
**Resume At:** Phase [N], continue from Task [N.M]
\`\`\`

This marker enables automatic resume when user starts a new session.
```

**Step 2: Renumber subsequent steps**

Update Step 5 (Commit) to Step 6, and Step 6 (Inform User) to Step 7.

**Step 3: Commit**

```bash
git add plugins/harness/skills/handling-context-exhaustion/skill.md
git commit -m "feat(context-exhaustion): add PENDING_EXECUTION marker creation"
```

---

### Task 3.2: Update User Notification Message

**Files:**
- Modify: `plugins/harness/skills/handling-context-exhaustion/skill.md`

**Step 1: Update the "Inform User" step**

Find the step that informs the user and update to:

```markdown
### Step 7: Inform User

Report to user with clear next steps:

\`\`\`
⚠️ **Context limit approaching. Progress saved.**

- Checkpoint: `.harness/NNN-feature/checkpoint.md`
- Marker: `.harness/PENDING_EXECUTION.md`
- Progress: Phase [N] of [M], Task [N.M]

**Start a new session to auto-resume.**

The session start hook will detect the marker and automatically
invoke the appropriate skill to continue from where you left off.
No need to remember which skill to use!
\`\`\`
```

**Step 2: Update the "Handoff to New Session" section**

Find and update to reference automatic resume:

```markdown
## Handoff to New Session

When context is exhausted and checkpoint + marker are complete:

1. Tell user: "Context limit approaching. Progress saved."
2. Reference: "Marker at `.harness/PENDING_EXECUTION.md`"
3. Instruction: "Start a new session - it will auto-resume"

The `harness:using-harness` skill's session start hook handles reading
the marker and invoking the appropriate skill automatically.
```

**Step 3: Commit**

```bash
git add plugins/harness/skills/handling-context-exhaustion/skill.md
git commit -m "feat(context-exhaustion): update user notification for auto-resume"
```

---

## Phase 4: Update using-harness Skill

### Task 4.1: Add Marker Detection Section

**Files:**
- Modify: `plugins/harness/skills/using-harness/skill.md`

**Step 1: Add new section after "The Rule" section**

Add this new section:

```markdown
## Session Start - Pending Execution Check

**Before any other action**, check for pending execution:

\`\`\`
On session start:
    ↓
Check for .harness/PENDING_EXECUTION.md
    ↓
[If exists]
    ↓
    Read marker contents
    ↓
    Display pending execution info
    ↓
    Ask: "Resume execution? [Yes / No / Cancel]"
    ↓
    [Yes] → Invoke harness:subagent-driven-development or harness:executing-plans
    [No] → Continue normal session (marker remains for later)
    [Cancel] → Delete marker, continue normal session
    ↓
[If not exists]
    ↓
    Normal using-harness behavior (check for applicable skills)
\`\`\`

**Display format when marker found:**

\`\`\`
📋 **Pending execution detected**

Feature: [from plan path]
Progress: Phase [N] of [M] ([completed phases] ✓)
Mode: [autonomous/checkpoint]
Reason: [planning-complete/context-exhaustion/user-paused]

Resume execution? [Yes / No / Cancel pending]
\`\`\`

**Handling responses:**
- **Yes**: Invoke appropriate skill with marker context, skill reads checkpoint and continues
- **No**: Proceed with normal session, marker stays for later resume
- **Cancel**: Delete marker file, proceed with normal session
```

**Step 2: Verify section was added**

Read the file and confirm the new section exists.

**Step 3: Commit**

```bash
git add plugins/harness/skills/using-harness/skill.md
git commit -m "feat(using-harness): add session start marker detection"
```

---

### Task 4.2: Add Edge Cases Section

**Files:**
- Modify: `plugins/harness/skills/using-harness/skill.md`

**Step 1: Add edge cases after the marker detection section**

```markdown
## Marker Edge Cases

| Case | Handling |
|------|----------|
| Marker exists but plan file missing | Warn user, offer to cancel marker |
| Marker exists but checkpoint missing | Warn user, offer to cancel or start fresh |
| Marker in wrong worktree | Only check marker in current working directory |
| Corrupted/unparseable marker | Warn user, offer to cancel |
| User declines resume multiple times | Marker persists until explicitly cancelled |

**Cleanup:**
- Marker is deleted automatically when execution completes successfully
- Marker is deleted when user chooses "Cancel"
- Marker persists if user chooses "No" (for later resume)
```

**Step 2: Commit**

```bash
git add plugins/harness/skills/using-harness/skill.md
git commit -m "feat(using-harness): add marker edge cases handling"
```

---

## Phase 5: Update Supporting Skills

### Task 5.1: Update executing-plans for Phase Alignment

**Files:**
- Modify: `plugins/harness/skills/executing-plans/skill.md`

**Step 1: Update overview to reference Phases**

Update the opening to align with Phase-based execution:

```markdown
---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute **Phases** sequentially, report for review between Phases.

**Core principle:** Phase-by-phase execution with checkpoints for architect review.

**Note:** This skill is for separate session execution. For same-session execution, use `harness:subagent-driven-development`.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."
```

**Step 2: Update Step 2 to reference Phases**

```markdown
### Step 2: Execute Phase

**Execute one Phase at a time:**

For the current Phase:
1. Mark Phase as in_progress in TodoWrite
2. Execute each Task within the Phase sequentially
3. Follow each step exactly (plan has bite-sized steps)
4. Run verifications as specified
5. Commit after each Task
6. Mark Phase as completed when all Tasks done
```

**Step 3: Update Step 3 report format**

```markdown
### Step 3: Report

When Phase complete:
- Show which Phase was implemented
- Show task completion summary
- Show verification output (tests passing)
- Say: "Phase [N] complete. Ready for feedback."
```

**Step 4: Commit**

```bash
git add plugins/harness/skills/executing-plans/skill.md
git commit -m "feat(executing-plans): align with Phase-based execution"
```

---

### Task 5.2: Update resuming-work for Marker Integration

**Files:**
- Modify: `plugins/harness/skills/resuming-work/skill.md`

**Step 1: Add marker reading to the process**

Find the process section and add marker integration:

```markdown
## The Process

### Step 1: Check for Pending Execution Marker

First, check if there's a PENDING_EXECUTION.md marker:

\`\`\`
If .harness/PENDING_EXECUTION.md exists:
    - Read marker for plan path, checkpoint path, progress
    - Use marker info to determine where to resume
    - Skip to Step 3 with marker context

If no marker:
    - Continue to Step 2 (manual checkpoint discovery)
\`\`\`

### Step 2: Find Checkpoint (if no marker)

Look for checkpoint files in `.harness/*/checkpoint.md`...
[rest of existing process]
```

**Step 2: Add marker cleanup on completion**

Add to the end of the skill:

```markdown
## Cleanup

When execution completes successfully:
1. Delete `.harness/PENDING_EXECUTION.md` marker (if exists)
2. Update checkpoint to show completion
3. Proceed to `harness:finishing-a-development-branch`
```

**Step 3: Commit**

```bash
git add plugins/harness/skills/resuming-work/skill.md
git commit -m "feat(resuming-work): add marker integration for auto-resume"
```

---

## Phase 6: Integration & Testing

### Task 6.1: Verify All Skills Updated

**Step 1: List all modified files**

```bash
git status
```

Expected: 6 skill files modified

**Step 2: Review each file for consistency**

Read each modified skill and verify:
- [ ] writing-plans: Has Phase structure, new header, new handoff
- [ ] subagent-driven-development: References Phases throughout
- [ ] handling-context-exhaustion: Creates marker
- [ ] using-harness: Has marker detection hook
- [ ] executing-plans: Aligned with Phases
- [ ] resuming-work: Reads marker

**Step 3: Check for any remaining "per task" or "per Task" references that should be "per Phase"**

```bash
grep -r "per task" plugins/harness/skills/ --include="*.md"
grep -r "per Task" plugins/harness/skills/ --include="*.md"
```

Fix any inconsistencies found.

---

### Task 6.2: Final Commit and Version Bump

**Step 1: Stage all changes**

```bash
git add -A
```

**Step 2: Create final commit if any remaining changes**

```bash
git commit -m "chore: final cleanup for phase-based execution"
```

**Step 3: Update version in plugin manifest (if applicable)**

Check for version file and bump to 0.4.0:

```bash
cat plugins/harness/manifest.json 2>/dev/null || cat plugins/harness/plugin.json 2>/dev/null || echo "No manifest found"
```

If version file exists, update version to 0.4.0.

**Step 4: Commit version bump**

```bash
git add -A
git commit -m "chore: bump version to 0.4.0 for phase-based execution"
```

---

## Summary

| Phase | Tasks | Focus |
|-------|-------|-------|
| 1 | 1.1 - 1.3 | writing-plans: Phase structure, header, handoff |
| 2 | 2.1 - 2.3 | subagent-driven-development: Phase-level dispatch |
| 3 | 3.1 - 3.2 | handling-context-exhaustion: Marker creation |
| 4 | 4.1 - 4.2 | using-harness: Session start hook |
| 5 | 5.1 - 5.2 | executing-plans, resuming-work: Alignment |
| 6 | 6.1 - 6.2 | Integration testing and version bump |

**Total: 6 Phases, 14 Tasks**

**Deferred to backlog:**
- Implementer/reviewer prompt template updates (in subagent-driven-development subdirectory)
- INDEX.md updates to reflect new workflow
- Documentation updates for users
