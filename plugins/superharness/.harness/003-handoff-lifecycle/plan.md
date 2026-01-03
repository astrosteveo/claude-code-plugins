# Handoff Lifecycle Management Implementation Plan

## Overview

Implement full handoff lifecycle management where `/superharness:resume` is the primary command for all handoff operations - picker dialog for selection, auto-resolution on completion, and checkpoint management.

## Architecture Choice

**Option B: Full Lifecycle** with enhanced `/resume` as the single entry point.

Key design decisions:
- Handoffs are checkpoints - multiple can exist during a task
- `/resume` with no args shows picker dialog (AskUserQuestion)
- Resolution happens automatically when work completes
- New handoffs supersede old ones for the same feature
- Archive mechanism for cleanup without losing history

## Current State Analysis

**What exists:**
- `commands/handoff.md` - Creates handoffs
- `commands/resume.md` - Resumes from handoff (requires path arg)
- `hooks/session-start.sh` - Detects pending handoffs < 7 days old
- No resolution mechanism

**What's missing:**
- Resolved handoff detection in session hook
- Picker dialog when no path provided
- Auto-resolution on completion
- Archive mechanism
- Supersede logic for multiple handoffs

## Desired End State

```
User runs: /superharness:resume
  ↓
No args? → Picker dialog: "Which handoff?"
  ↓
Work continues from selected handoff
  ↓
Work complete? → "Mark resolved?" → Yes → Git trailer + optional archive
  ↓
Work incomplete? → "Create checkpoint?" → Yes → New handoff supersedes old
```

### Key Discoveries:
- `session-start.sh:99-101` - Current 7-day age check
- `session-start.sh:31-35` - Plan abandonment pattern to follow
- Handoffs in two locations: `.harness/*/handoff.md` and `.harness/handoffs/*.md`

## What We're NOT Doing

- Changing handoff creation (`/superharness:handoff`)
- Modifying plan lifecycle
- Auto-deleting old handoffs (archive only)
- Changing the 7-day detection window

## Implementation Approach

1. Hook changes first (detection infrastructure)
2. Resolve command (can be used standalone or by resume)
3. Resume enhancements (picker + completion flow)
4. Documentation updates

---

## Phase 1: Update Session Hook

### Overview
Add resolved handoff detection via git trailers and skip archived handoffs.

### Changes Required:

#### 1. Session Hook Updates
**File**: `plugins/superharness/hooks/session-start.sh`

**Changes**:
- Add function to check if handoff is resolved via git trailers
- Skip handoffs in `archive/` subdirectory
- Check for `handoff: <path>` trailers indicating resolution

### Tasks (TDD Required):

- [x] Task 1: Create test script for hook behavior
  - Test: Resolved handoff (has git trailer) should not appear in PENDING_HANDOFFS
  - Test: Archived handoff should not appear
  - Test: Active handoff should still appear

- [x] Task 2: Add `is_handoff_resolved()` function to check git trailers
  - Pattern: `handoff: <path>` in git log
  - Return true if trailer exists for given path

- [x] Task 3: Add archive directory skip logic
  - Skip files matching `.harness/handoffs/archive/*`
  - Skip files matching `.harness/*/archive/*` (future-proofing)

- [x] Task 4: Integrate resolution check into `check_handoff()` function
  - Call `is_handoff_resolved()` before adding to PENDING_HANDOFFS
  - Skip if resolved

### Success Criteria:

#### Automated Verification:
- [x] `./hooks/session-start.sh` runs without error
- [x] Hook outputs valid JSON
- [x] Test script passes all cases

#### Manual Verification:
- [ ] Create handoff, verify it appears in session start
- [ ] Resolve handoff via git trailer, verify it no longer appears
- [ ] Move handoff to archive, verify it no longer appears

**Human Gate**: Verify hook changes work correctly before proceeding.

---

## Phase 2: Create Resolve Command

### Overview
Create `/superharness:resolve` command for explicit handoff resolution with git trailer and optional archive.

### Changes Required:

#### 1. New Resolve Command
**File**: `plugins/superharness/commands/resolve.md` (new)

**Changes**:
- Create new command with frontmatter
- Accept handoff path as argument
- Create git trailer for resolution
- Optionally move to archive directory

### Tasks (TDD Required):

- [x] Task 1: Create command file with frontmatter
  - Description: "Resolve a handoff (mark complete or abandon)"
  - Argument hint: "<handoff path> [--archive] [--abandon]"

- [x] Task 2: Implement resolution flow
  - Read handoff to verify it exists
  - Confirm resolution with user
  - Create git commit with trailer

- [x] Task 3: Implement archive mechanism
  - If --archive flag or user confirms
  - Move to `.harness/handoffs/archive/` (cross-feature) or `.harness/NNN-slug/archive/` (feature-specific)
  - Create archive directory if needed

- [x] Task 4: Implement abandon variant
  - If --abandon flag
  - Use different trailer: `handoff-abandoned: <path>`
  - Different commit message

### Success Criteria:

#### Automated Verification:
- [x] Command file exists with valid frontmatter
- [ ] Git trailer created after resolution (tested in Phase 5)

#### Manual Verification:
- [ ] Run `/superharness:resolve .harness/test/handoff.md`
- [ ] Verify git log shows trailer
- [ ] Verify archived file moved correctly

**Human Gate**: Verify resolve command works before enhancing resume.

---

## Phase 3: Enhance Resume Command

### Overview
Add picker dialog, completion prompts, and supersede logic to `/superharness:resume`.

### Changes Required:

#### 1. Resume Command Enhancements
**File**: `plugins/superharness/commands/resume.md`

**Changes**:
- Add picker dialog when no path provided
- Add completion prompt at end of work
- Add supersede logic for multiple handoffs
- Integrate with resolve mechanism

### Tasks (TDD Required):

- [ ] Task 1: Add handoff discovery function
  - Scan `.harness/*/handoff.md` and `.harness/handoffs/*.md`
  - Filter out resolved/archived
  - Sort by date (newest first)
  - Extract topic/description for display

- [ ] Task 2: Implement picker dialog (no args case)
  - Use AskUserQuestion tool
  - Present available handoffs as options
  - Include "None - start fresh" option
  - Format: "[Topic] (N days ago) - path"

- [ ] Task 3: Add completion flow
  - At end of resume process, ask: "Work complete?"
  - If yes: Prompt to resolve (calls resolve logic)
  - If no: Prompt to create new checkpoint

- [ ] Task 4: Implement supersede logic
  - When creating new handoff during active resume
  - Add `supersedes: <old-handoff-path>` to new handoff frontmatter
  - Auto-resolve old handoff with reason "superseded"

- [ ] Task 5: Update initial response section
  - If no args: Run picker instead of asking for path
  - If args: Proceed as before

### Success Criteria:

#### Automated Verification:
- [ ] Command file has updated content
- [ ] No syntax errors in markdown

#### Manual Verification:
- [ ] Run `/superharness:resume` with no args → picker appears
- [ ] Select handoff → resumes correctly
- [ ] Complete work → resolution prompt appears
- [ ] Create new checkpoint → old one auto-resolved

**Human Gate**: Verify full resume flow before documentation.

---

## Phase 4: Update Documentation

### Overview
Update all documentation to reflect new handoff lifecycle.

### Changes Required:

#### 1. CLAUDE.md Updates
**File**: `plugins/superharness/CLAUDE.md`

**Changes**:
- Add resolve command to command table
- Document handoff lifecycle
- Update directory structure with archive

#### 2. README.md Updates
**File**: `plugins/superharness/README.md`

**Changes**:
- Add handoff lifecycle section
- Document `/superharness:resolve` command
- Update `/superharness:resume` documentation

#### 3. Foundation Skill Updates
**File**: `plugins/superharness/skills/superharness-core/SKILL.md`

**Changes**:
- Update incomplete work handling to mention resolve
- Add resolve to command table
- Update abandon handling for handoffs

#### 4. Handoff Command Updates
**File**: `plugins/superharness/commands/handoff.md`

**Changes**:
- Add cross-reference to resolve command
- Mention checkpoint/supersede pattern

### Tasks (TDD Required):

- [ ] Task 1: Update CLAUDE.md with new command and lifecycle docs
- [ ] Task 2: Update README.md with user-facing documentation
- [ ] Task 3: Update superharness-core skill with resolve workflow
- [ ] Task 4: Update handoff command with cross-references

### Success Criteria:

#### Automated Verification:
- [ ] All markdown files valid
- [ ] No broken internal links

#### Manual Verification:
- [ ] Documentation accurately reflects implementation
- [ ] Examples are correct and runnable

**Human Gate**: Review documentation for accuracy.

---

## Phase 5: End-to-End Testing

### Overview
Verify complete handoff lifecycle works as expected.

### Test Scenarios:

#### Scenario 1: Happy Path - Single Handoff
1. Create handoff via `/superharness:handoff`
2. New session - verify "INCOMPLETE WORK DETECTED"
3. Run `/superharness:resume` (no args)
4. Verify picker shows handoff
5. Select and resume
6. Mark complete
7. New session - verify clean (no incomplete work)

#### Scenario 2: Checkpoint Chain
1. Create handoff A
2. Resume handoff A, work partially
3. Create handoff B (checkpoint)
4. Verify A is auto-resolved as "superseded"
5. New session - only B shows as pending

#### Scenario 3: Archive Flow
1. Create handoff
2. Resolve with --archive
3. Verify file moved to archive directory
4. Verify no longer detected as pending

#### Scenario 4: Abandon Flow
1. Create handoff
2. Resolve with --abandon
3. Verify git trailer shows abandoned
4. Verify no longer detected as pending

### Tasks:

- [ ] Task 1: Execute Scenario 1 and document results
- [ ] Task 2: Execute Scenario 2 and document results
- [ ] Task 3: Execute Scenario 3 and document results
- [ ] Task 4: Execute Scenario 4 and document results

### Success Criteria:

#### Automated Verification:
- [ ] All scenarios complete without errors

#### Manual Verification:
- [ ] Each scenario behaves as expected
- [ ] No regressions in existing functionality

**Human Gate**: Final approval before marking feature complete.

---

## Testing Strategy

### Unit Tests:
- Hook function tests via test script
- Resolution trailer detection
- Archive path handling

### Integration Tests:
- Full resume flow with picker
- Supersede chain behavior
- Session hook detection after resolution

### Manual Testing Steps:
1. Create test handoff
2. Run session hook, verify detection
3. Run resume with picker
4. Complete and resolve
5. Verify clean session state

## References

- Research: `.harness/003-handoff-lifecycle/research.md`
- Session hook: `plugins/superharness/hooks/session-start.sh`
- Resume command: `plugins/superharness/commands/resume.md`
- Handoff command: `plugins/superharness/commands/handoff.md`
