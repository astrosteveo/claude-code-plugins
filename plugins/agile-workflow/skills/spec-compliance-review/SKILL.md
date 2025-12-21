---
name: spec-compliance-review
description: Use this skill to verify implementation matches requirements exactly - nothing missing, nothing extra. Use BEFORE code quality review. Triggers after implementation, before marking complete, or when reviewing changes against a plan.
---

# Spec Compliance Review

## Purpose

Verify the implementation matches what was requested - **nothing missing, nothing extra**.

This is distinct from code quality review:
- **Spec Compliance**: Did you build what was asked? (FIRST)
- **Code Quality**: Is it well-built? (SECOND, only after spec passes)

## The Rule

**Do NOT trust the implementer's report. Read the actual code.**

Compare the implementation line-by-line against requirements.

## Review Process

### Step 1: Load Requirements

Read the requirements from:
- Story acceptance criteria
- Plan.md task description
- PRD requirements (if referenced)

List each requirement explicitly.

### Step 2: Read Actual Code

For each file mentioned:
1. Read the file completely
2. Note what was actually implemented
3. Don't assume - verify

### Step 3: Compare Line-by-Line

For each requirement:

```
Requirement: [REQ-1 description]
Evidence: [file:line - what code implements this]
Status: ✅ Met | ❌ Missing | ⚠️ Partial
```

### Step 4: Check for Extras

Look for code that wasn't requested:
- Features not in requirements
- Edge cases not specified
- "Improvements" not asked for
- Over-engineering

```
Extra: [description of extra code]
Location: [file:line]
Issue: Not in requirements - should remove (YAGNI)
```

### Step 5: Report

**If Compliant:**
```
## Spec Compliance: ✅ PASS

All requirements verified:
- [REQ-1]: ✅ [file:line]
- [REQ-2]: ✅ [file:line]

No extra features found.
```

**If Issues Found:**
```
## Spec Compliance: ❌ ISSUES FOUND

### Missing Requirements
- [REQ-1]: ❌ Not implemented
  Expected: [what should exist]
  Found: [what actually exists or "nothing"]

### Partial Implementations
- [REQ-2]: ⚠️ Incomplete
  Expected: [full requirement]
  Found: [what's there]
  Missing: [what's not]

### Extra Code (YAGNI Violations)
- [file:line]: [description]
  Issue: Not in requirements

### Required Actions
1. [Specific action to fix]
2. [Another action]
```

## Common Issues to Check

### Missing Requirements
- Feature described but not implemented
- Acceptance criterion not met
- Edge case in spec not handled

### Partial Implementations
- Function exists but doesn't do everything specified
- Only happy path implemented when errors specified
- Part of a multi-step requirement missing

### Extra Code (YAGNI)
- Error handling not in requirements
- Configuration options not requested
- "Future-proofing" not asked for
- Abstractions for single use case

### Misunderstandings
- Implemented something different than requested
- Misread the requirement
- Made assumptions not in spec

## Example Review

**Requirements:**
1. Add `validateEmail(email: string): boolean`
2. Return true for valid emails, false for invalid
3. Add tests for valid and invalid cases

**Review:**
```
## Spec Compliance Review

### Requirements Check

1. validateEmail function
   Evidence: src/validation.ts:15 - `export function validateEmail(email: string): boolean`
   Status: ✅ Met

2. Returns true/false correctly
   Evidence: src/validation.ts:16-18 - Returns boolean based on regex match
   Status: ✅ Met

3. Tests for valid/invalid
   Evidence: tests/validation.test.ts:5-20 - Two test cases
   Status: ✅ Met

### Extra Code Check

- src/validation.ts:20-25: `validatePhone` function
  Issue: ❌ Not in requirements - YAGNI violation

- src/validation.ts:27-30: `ValidationError` class
  Issue: ❌ Not in requirements - YAGNI violation

## Result: ❌ ISSUES FOUND

### Required Actions
1. Remove `validatePhone` function (not requested)
2. Remove `ValidationError` class (not requested)
3. Re-review after changes
```

## Constraints

- **Never trust implementer reports** - Read actual code
- **Never skip the extras check** - YAGNI is a spec issue
- **Never combine with code quality** - Spec compliance comes FIRST
- **Always cite file:line** - Be specific about evidence
- **Always list every requirement** - Check each one explicitly
- **Pass spec compliance before code quality review begins**
