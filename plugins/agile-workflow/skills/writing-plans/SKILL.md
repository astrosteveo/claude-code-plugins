---
name: writing-plans
description: Use when you have a spec or research and need to create an implementation plan. Creates detailed, bite-sized tasks that enable autonomous execution.
---

# Writing Implementation Plans

Create comprehensive plans assuming the implementer has zero project context. This enables long autonomous coding sessions.

**Announce at start:** "I'm creating an implementation plan for [feature]."

## Why Plans Matter

> "A bad line of code is a bad line. But a bad line of a plan could lead to hundreds of bad lines."

Human effort concentrates on plan review, not code review. Reading a 200-line plan beats reviewing 2,000 lines of code.

## Plan Location

Save plans to: `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Plan Header (Required)

Every plan MUST start with:

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Granularity

**Each task is one focused unit of work (15-30 minutes):**

Tasks should be small enough that:
- A fresh subagent can complete it without confusion
- Tests can verify it independently
- It can be reviewed in isolation

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.ts`
- Modify: `exact/path/to/existing.ts:123-145`
- Test: `tests/exact/path/to/test.ts`

**What to Build:**
[Clear description of what this task produces]

**Implementation:**
[Specific code or pseudocode - be precise]

**Tests:**
[What tests to write, what they verify]

**Verification:**
Run: `[test command]`
Expected: [what success looks like]
```

## Key Principles

- **Exact file paths** - Never "somewhere in src/"
- **Complete code in plan** - Not "add validation" but actual code
- **Exact test commands** - With expected output
- **TDD emphasized** - Test → Implement → Verify
- **YAGNI enforced** - Only what's needed, nothing extra
- **DRY considered** - Note shared code opportunities

## After Writing Plan

Offer execution options:

```
Plan saved to docs/plans/YYYY-MM-DD-feature.md

Two execution options:

1. **Subagent-Driven (this session)** - I dispatch fresh subagent per task,
   review between tasks, fast iteration

2. **New Session** - Open fresh session, work through plan with checkpoints

Which approach?
```

**If Subagent-Driven:** Use subagent-driven-development skill

## Example Task

```markdown
### Task 3: Add User Validation

**Files:**
- Create: `src/validation/user.ts`
- Test: `tests/validation/user.test.ts`

**What to Build:**
Validation function for user input with email format and password strength checks.

**Implementation:**
```typescript
export function validateUser(input: UserInput): ValidationResult {
  const errors: string[] = [];

  if (!EMAIL_REGEX.test(input.email)) {
    errors.push('Invalid email format');
  }

  if (input.password.length < 8) {
    errors.push('Password must be at least 8 characters');
  }

  return { valid: errors.length === 0, errors };
}
```

**Tests:**
- Valid user passes validation
- Invalid email fails with specific error
- Short password fails with specific error
- Multiple errors returned together

**Verification:**
Run: `npm test -- --grep "user validation"`
Expected: All 4 tests pass
```

## Plan Review

Before finalizing, verify:
- [ ] Every task has exact file paths
- [ ] Implementation is specific, not vague
- [ ] Tests are defined for each task
- [ ] Tasks are ordered by dependency
- [ ] No YAGNI violations (unnecessary features)
