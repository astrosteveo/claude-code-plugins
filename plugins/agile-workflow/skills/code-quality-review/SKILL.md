---
name: code-quality-review
description: Use this skill to review implementation quality - clean code, tests, maintainability. Use ONLY AFTER spec-compliance-review passes. Triggers when reviewing code for quality, after spec compliance is confirmed.
---

# Code Quality Review

## Purpose

Verify the implementation is well-built - clean, tested, maintainable.

**PREREQUISITE: Spec compliance must pass first.**

- Spec Compliance: Did you build what was asked? (FIRST)
- Code Quality: Is it well-built? (THIS - SECOND)

## Review Dimensions

### 1. Test Quality

- [ ] All behaviors have tests
- [ ] Tests are focused (one assertion concept per test)
- [ ] Tests have clear names (`test_should_X_when_Y`)
- [ ] Tests use real code, minimal mocks
- [ ] Edge cases covered
- [ ] Error cases covered
- [ ] Tests actually run and pass

### 2. Code Clarity

- [ ] Functions do one thing
- [ ] Names are descriptive and accurate
- [ ] No magic numbers/strings (use constants)
- [ ] Comments explain "why" not "what"
- [ ] No dead code or commented-out code
- [ ] Consistent formatting

### 3. Error Handling

- [ ] Errors are handled appropriately
- [ ] Error messages are helpful
- [ ] No swallowed exceptions
- [ ] Validation at boundaries

### 4. Patterns and Conventions

- [ ] Follows existing codebase patterns
- [ ] Consistent with project style
- [ ] Uses established abstractions
- [ ] Doesn't reinvent existing utilities

### 5. Maintainability

- [ ] No unnecessary complexity
- [ ] Dependencies are appropriate
- [ ] No tight coupling
- [ ] Easy to modify/extend

## Issue Severity Levels

### Critical
Must fix before proceeding. Blocks completion.

Examples:
- Tests don't actually run
- Security vulnerability
- Data loss risk
- Broken functionality

### Important
Should fix before merge. High priority.

Examples:
- Missing error handling
- Poor test coverage
- Confusing logic
- Performance issues

### Minor
Nice to fix. Can note for later.

Examples:
- Naming could be clearer
- Minor code duplication
- Style inconsistencies
- Missing helpful comments

## Review Report Format

```markdown
## Code Quality Review

### Summary
[One paragraph assessment]

### Strengths
- [What's done well]
- [Good patterns followed]

### Issues

#### Critical
- **[Issue title]** - [file:line]
  Problem: [what's wrong]
  Fix: [how to fix]

#### Important
- **[Issue title]** - [file:line]
  Problem: [what's wrong]
  Fix: [how to fix]

#### Minor
- **[Issue title]** - [file:line]
  Suggestion: [improvement]

### Assessment

[ ] ✅ APPROVED - Ready to merge
[ ] ⚠️ APPROVED WITH NOTES - Minor issues, can merge
[ ] ❌ CHANGES REQUESTED - Must address Critical/Important issues
```

## Example Review

```markdown
## Code Quality Review

### Summary
Implementation is solid with good test coverage. One important
issue with error handling needs attention before merge.

### Strengths
- Clear function names that describe behavior
- Tests cover happy path and edge cases
- Follows existing validation patterns in codebase
- Good separation of concerns

### Issues

#### Critical
None

#### Important
- **Missing error handling for null input** - src/validation.ts:15
  Problem: `validateEmail(null)` throws unhandled TypeError
  Fix: Add null check at function start, return false

#### Minor
- **Magic regex could use constant** - src/validation.ts:16
  Suggestion: Extract EMAIL_REGEX constant for clarity

- **Test names could be more specific** - tests/validation.test.ts:5
  Current: `it('validates email')`
  Suggestion: `it('returns true for valid email with standard format')`

### Assessment

❌ CHANGES REQUESTED

Please address:
1. Add null/undefined check to validateEmail

After fix, will be ready to merge.
```

## Review Checklist

Before completing review:

1. [ ] Read all changed files completely
2. [ ] Run the tests yourself
3. [ ] Check each quality dimension
4. [ ] Categorize issues by severity
5. [ ] Provide specific file:line references
6. [ ] Give actionable fix suggestions
7. [ ] Make clear approval decision

## Constraints

- **Never review before spec compliance passes** - Quality review comes second
- **Never approve with Critical issues** - Must be fixed first
- **Always run the tests** - Don't trust they pass
- **Always read the code** - Don't skim
- **Always cite file:line** - Be specific
- **Always categorize severity** - Critical vs Important vs Minor
- **Always give actionable feedback** - Not just "this is wrong"
