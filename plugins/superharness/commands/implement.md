---
description: "Execute approved implementation plans phase by phase with TDD and verification gates"
argument-hint: "<path to plan file>"
load-skills:
  - tdd
  - verification
---

# Implement Plan

You are tasked with implementing an approved technical plan from `.harness/`. These plans contain phases with specific changes and success criteria.

## CRITICAL: TDD Is Mandatory

For EVERY task in EVERY phase:
1. **Write failing test FIRST** - Before ANY production code
2. **Run test, verify RED** - Must see it fail
3. **Write minimal code** - Only enough to pass
4. **Run test, verify GREEN** - Must see it pass
5. **Refactor if needed** - Clean up while green

**No production code without a failing test first. This is non-negotiable.**

## CRITICAL: Sequential Phases with Human Gates

- Execute phases sequentially - do NOT skip ahead
- Run automated verification after each phase
- PAUSE for manual verification after each phase (human gate)
- Update plan checkboxes as work completes
- Commit with phase trailer after each phase

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
- **Write tests FIRST for every change** (TDD)
- Verify your work makes sense in the broader codebase context
- Update checkboxes in the plan as you complete sections

When things don't match exactly, think about why and communicate clearly. The plan is your guide, but your judgment matters too.

## Phase Execution Process

### For Each Phase:

#### 1. Read and Understand

- Read the phase's overview and changes required
- Identify all files that need modification
- Understand the success criteria
- Review the TDD tasks

#### 2. Implement Changes (TDD Required)

For EACH task in the phase:

```
RED Phase:
1. Write a failing test for the functionality
2. Run the test
3. VERIFY it fails (if it passes, your test is wrong)
4. Commit: "test: add failing test for [feature]"

GREEN Phase:
1. Write the MINIMAL code to make the test pass
2. Run the test
3. VERIFY it passes
4. Commit: "feat: implement [feature]"

REFACTOR Phase (if needed):
1. Clean up code while keeping tests green
2. Run tests after each change
3. Commit: "refactor: clean up [feature]"
```

**DO NOT skip the RED phase. DO NOT write production code before the test.**

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

#### 5. Commit Phase Completion

Create a commit with the phase trailer:

```bash
git add -A
git commit -m "feat: complete Phase N - [Phase Name]

[Brief description of what was implemented]

phase(N): complete"
```

**This trailer is how the session hook detects incomplete work.**

#### 6. Human Gate - Pause for Manual Verification

After automated verification passes:

```
Phase [N] Complete - Ready for Manual Verification

Automated verification passed:
- [x] Tests pass (X tests)
- [x] Type checking passes
- [x] Linting passes

Please perform the manual verification steps:
- [ ] [Manual step 1 from plan]
- [ ] [Manual step 2 from plan]

Let me know when manual testing is complete so I can proceed to Phase [N+1].
```

Wait for user confirmation before proceeding.

**Exception:** If instructed to execute multiple phases consecutively, skip the pause until the last phase.

## TDD Red Flags

These thoughts mean STOP - you're rationalizing skipping TDD:

| Thought | Reality |
|---------|---------|
| "This is too simple to test" | Simple code breaks too. Write the test. |
| "I'll write tests after" | After = never. Write them now. |
| "The test would be trivial" | Trivial tests catch trivial bugs. Write it. |
| "I know this works" | Prove it with a test. |
| "Testing this is hard" | Hard to test = bad design. Fix the design. |
| "Just this once" | No exceptions. TDD always. |

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
4. Check git log for phase completion trailers

## Progress Tracking

Maintain a todo list with:

```
Phase 1: [Name] - in_progress/completed
  - Task 1.1 (TDD) - completed
  - Task 1.2 (TDD) - in_progress
Phase 2: [Name] - pending
...
```

Update todos as you complete work.

## Verification Checklist

Before marking a phase complete:

- [ ] All TDD tasks completed (RED-GREEN-REFACTOR)
- [ ] All code changes implemented
- [ ] All automated verification passes
- [ ] Plan checkboxes updated
- [ ] Phase commit created with `phase(N): complete` trailer
- [ ] Human notified for manual verification

## Example Workflow

```
User: /superharness:implement .harness/003-auth/plan.md

Agent: [Reads plan, identifies 3 phases]

Starting Phase 1: Database Schema Changes

Task 1.1: Add user table migration
- RED: Writing failing test for migration...
  [Creates test, runs it, verifies failure]
  Committed: "test: add failing test for user migration"

- GREEN: Implementing migration...
  [Creates migration, runs test, verifies pass]
  Committed: "feat: add user table migration"

Task 1.2: Add user model
- RED: Writing failing test for user model...
  [Creates test, runs it, verifies failure]

- GREEN: Implementing user model...
  [Creates model, runs test, verifies pass]

Running automated verification...
- Tests: PASS (12 tests)
- Type check: PASS
- Lint: PASS

Committing phase completion...
"feat: complete Phase 1 - Database Schema

Added user table migration and model with full test coverage.

phase(1): complete"

Phase 1 Complete - Ready for Manual Verification

Automated verification passed:
- [x] Migration applies cleanly
- [x] Unit tests pass (12 tests)
- [x] Type checking passes

Please perform the manual verification:
- [ ] Verify table appears in database
- [ ] Check foreign key constraints

Let me know when manual testing is complete.

User: Manual testing complete, looks good!

Agent: Proceeding to Phase 2...
```

## Cross-References

- To validate after implementation: `/superharness:validate`
- To create a handoff document: `/superharness:handoff`
- If plan needs updates: `/superharness:iterate`
