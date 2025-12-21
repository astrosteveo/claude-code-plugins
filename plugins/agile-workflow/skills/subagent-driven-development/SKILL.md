---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks. Dispatches fresh subagent per task with two-stage review (spec compliance then code quality). Triggers when ready to implement a plan with multiple tasks.
---

# Subagent-Driven Development

Execute plans by dispatching fresh subagent per task, with two-stage review after each.

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration.

## When to Use

- Have an implementation plan with tasks
- Tasks are mostly independent
- Want to stay in the current session
- Need quality gates between tasks

## The Process

```
For Each Task:
│
├─ 1. Dispatch Implementer Subagent
│     ├─ Provide FULL task text (don't make them read files)
│     ├─ Include context (where task fits in architecture)
│     ├─ Subagent may ask clarifying questions
│     ├─ Subagent implements with TDD
│     ├─ Subagent self-reviews before reporting
│     └─ Subagent commits work
│
├─ 2. Dispatch Spec Compliance Reviewer
│     ├─ Provide task requirements + implementer report
│     ├─ Reviewer reads actual code (doesn't trust report)
│     ├─ Checks: missing requirements, extra features, misunderstandings
│     ├─ If issues found → Implementer fixes → Re-review
│     └─ Must pass before code quality review
│
├─ 3. Dispatch Code Quality Reviewer
│     ├─ Only after spec compliance passes
│     ├─ Reviews: tests, clarity, error handling, patterns
│     ├─ Reports: Critical, Important, Minor issues
│     ├─ If Critical/Important → Implementer fixes → Re-review
│     └─ Must approve before task is complete
│
└─ 4. Mark Task Complete

After All Tasks:
├─ Run final full-codebase review
└─ Use finishing-branch skill
```

## Controller Responsibilities

The controller (you, orchestrating) must:

1. **Read plan once, extract all tasks with full text**
2. **Create TodoWrite with all tasks**
3. **For each task:**
   - Dispatch implementer with full task text + context
   - Answer any implementer questions
   - Dispatch spec reviewer after implementer reports
   - Handle review loops (implementer fixes, reviewer re-reviews)
   - Dispatch code quality reviewer after spec passes
   - Handle quality review loops
   - Mark task complete
4. **After all tasks:** Final review + finishing-branch

## Dispatching Subagents

Use the Task tool with these agents:

### Implementer

```
Task tool:
  subagent_type: agile-workflow:implementer
  description: "Implement [task-name]"
  prompt: |
    ## Task
    [FULL TEXT of task from plan - paste it, don't reference file]

    ## Context
    [Where this fits: architecture, dependencies, related code]

    ## Working Directory
    [path]

    ## Questions?
    Ask clarifying questions BEFORE starting. It's always OK to pause and ask.
```

### Spec Compliance Reviewer

```
Task tool:
  subagent_type: agile-workflow:spec-reviewer
  description: "Review spec compliance for [task-name]"
  prompt: |
    ## Requirements
    [FULL TEXT of task requirements]

    ## Implementer Report
    [What implementer claimed they built]

    ## Files Changed
    [List of files to review]

    CRITICAL: Do NOT trust the report. Read actual code. Verify independently.
```

### Code Quality Reviewer

```
Task tool:
  subagent_type: agile-workflow:code-quality-reviewer
  description: "Review code quality for [task-name]"
  prompt: |
    ## Requirements
    [Task requirements for context]

    ## Files to Review
    [List of files]

    ## Spec Compliance Status
    ✅ Passed - requirements verified

    Review for quality: tests, clarity, error handling, patterns, maintainability.
```

## Review Loops

**If spec reviewer finds issues:**
```
1. Dispatch implementer with specific fix instructions
2. Implementer fixes and reports
3. Dispatch spec reviewer again
4. Repeat until ✅
```

**If code quality reviewer finds Critical/Important issues:**
```
1. Dispatch implementer with fix instructions
2. Implementer fixes and reports
3. Dispatch code quality reviewer again
4. Repeat until approved
```

## Example Workflow

```
[Read plan.md, extract 3 tasks with full text]
[Create TodoWrite: Task 1, Task 2, Task 3]

=== Task 1: User validation ===

[Mark Task 1 in_progress]
[Dispatch implementer with full task text]

Implementer: "Should validation errors return 400 or 422?"

Controller: "Use 422 for validation errors, 400 for malformed requests."

Implementer:
  - Implemented validateUser function
  - Added 6 tests, all passing
  - Self-review: Caught missing email format check, fixed
  - Committed: feat(user): add validation

[Dispatch spec reviewer]

Spec Reviewer:
  ✅ Spec compliant
  - All requirements implemented
  - No extra features
  - Verified by reading src/user.ts and tests/user.test.ts

[Dispatch code quality reviewer]

Code Quality Reviewer:
  Strengths: Good test coverage, clear naming
  Issues (Important): Magic regex should be constant
  Assessment: Changes requested

[Dispatch implementer with fix instructions]

Implementer:
  - Extracted EMAIL_REGEX constant
  - Tests still passing
  - Committed: refactor(user): extract email regex constant

[Dispatch code quality reviewer again]

Code Quality Reviewer:
  ✅ Approved - no issues

[Mark Task 1 complete]

=== Task 2: ... ===
[Continue pattern]
```

## Red Flags - NEVER

- **Skip reviews** - Both spec compliance AND code quality required
- **Proceed with unfixed issues** - Review loops until approved
- **Dispatch parallel implementers** - Conflicts; one at a time
- **Make subagent read plan file** - Provide full text
- **Skip scene-setting context** - Subagent needs architecture context
- **Ignore subagent questions** - Answer before they proceed
- **Accept "close enough"** - Spec issues = not done
- **Skip re-review after fixes** - Verify fixes actually work
- **Trust implementer self-review alone** - Both self-review AND external review
- **Start quality review before spec passes** - Wrong order
- **Move to next task with open issues** - Current task must fully complete

## Benefits

**Fresh context per task:**
- No confusion from accumulated context
- Each subagent starts clean
- Parallel-safe (subagents don't interfere)

**Two-stage review:**
- Spec compliance catches missing/extra features
- Code quality catches implementation issues
- Different concerns, different reviewers

**Review loops:**
- Issues caught and fixed immediately
- Not discovered later in integration
- Cheaper to fix early

**Controller provides full text:**
- No file reading overhead for subagents
- Exact context curated by controller
- Questions surfaced before work begins
