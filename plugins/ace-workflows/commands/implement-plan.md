---
description: "Execute approved implementation plans phase by phase with verification gates"
argument-hint: "<path to plan file>"
---

# Implement Plan

You are tasked with implementing an approved technical plan from `thoughts/shared/plans/`. These plans contain phases with specific changes and success criteria.

## CRITICAL: Sequential Phases with Human Gates

- Execute phases sequentially - do NOT skip ahead
- Run automated verification after each phase
- PAUSE for manual verification after each phase (human gate)
- Update plan checkboxes as work completes

## Getting Started

When given a plan path:

1. **Read the plan completely** - check for existing checkmarks `- [x]`
2. **Read all files mentioned** in the plan (FULLY, no limit/offset)
3. **Think deeply** about how pieces fit together
4. **Create a todo list** to track your progress
5. **Start implementing** if you understand what needs to be done

If no plan path provided, ask for one.

## Implementation Philosophy

Plans are carefully designed, but reality can be messy. Your job is to:

- Follow the plan's intent while adapting to what you find
- Implement each phase fully before moving to the next
- Verify your work makes sense in the broader codebase context
- Update checkboxes in the plan as you complete sections

When things don't match exactly, think about why and communicate clearly. The plan is your guide, but your judgment matters too.

## Phase Execution Process

### For Each Phase:

#### 1. Read and Understand

- Read the phase's overview and changes required
- Identify all files that need modification
- Understand the success criteria

#### 2. Implement Changes

- Make the code changes specified in the plan
- Follow existing patterns in the codebase
- Create tests as specified
- Commit work incrementally

#### 3. Run Automated Verification

Execute all automated verification commands from the plan:

```
- [ ] Tests pass: `make test` or equivalent
- [ ] Type checking passes
- [ ] Linting passes
```

Fix any issues before proceeding.

#### 4. Update Plan Checkboxes

Use Edit tool to check off completed items:
- `- [ ]` becomes `- [x]`

#### 5. Human Gate - Pause for Manual Verification

After automated verification passes:

```
Phase [N] Complete - Ready for Manual Verification

Automated verification passed:
- [x] Tests pass
- [x] Type checking passes
- [x] Linting passes

Please perform the manual verification steps:
- [ ] [Manual step 1 from plan]
- [ ] [Manual step 2 from plan]

Let me know when manual testing is complete so I can proceed to Phase [N+1].
```

Wait for user confirmation before proceeding.

**Exception:** If instructed to execute multiple phases consecutively, skip the pause until the last phase.

## Handling Mismatches

If you encounter a mismatch between plan and reality:

```
Issue in Phase [N]:

Expected: [what the plan says]
Found: [actual situation]
Why this matters: [explanation]

How should I proceed?
```

DO NOT proceed with guesswork - get guidance.

## Resuming Work

If the plan has existing checkmarks:

1. Trust that completed work is done
2. Pick up from the first unchecked item
3. Verify previous work only if something seems off

## If You Get Stuck

When something isn't working:

1. Make sure you've read and understood all relevant code
2. Consider if the codebase evolved since the plan was written
3. Present the mismatch clearly and ask for guidance

Use sub-agents sparingly - mainly for targeted debugging.

## Progress Tracking

Maintain a todo list with:

```
Phase 1: [Name] - in_progress/completed
  - Task 1.1 - completed
  - Task 1.2 - in_progress
Phase 2: [Name] - pending
...
```

Update todos as you complete work.

## Verification Checklist

Before marking a phase complete:

- [ ] All code changes implemented
- [ ] All automated verification passes
- [ ] Plan checkboxes updated
- [ ] Human notified for manual verification

## Example Workflow

```
User: /ace-workflows:implement-plan thoughts/shared/plans/2025-01-15-feature.md

Agent: [Reads plan, identifies 3 phases]

Starting Phase 1: Database Schema Changes

Implementing:
- Added migration file for new table
- Updated models
- Created unit tests

Running automated verification...
- Tests: PASS
- Type check: PASS
- Lint: PASS

Phase 1 Complete - Ready for Manual Verification

Automated verification passed:
- [x] Migration applies cleanly
- [x] Unit tests pass
- [x] Type checking passes

Please perform the manual verification:
- [ ] Verify table appears in database
- [ ] Check foreign key constraints

Let me know when manual testing is complete.

User: Manual testing complete, looks good!

Agent: Proceeding to Phase 2...
```

## Cross-References

- To validate after implementation: `/ace-workflows:validate-plan`
- To create a handoff document: `/ace-workflows:create-handoff`
- If plan needs updates: `/ace-workflows:iterate-plan`
