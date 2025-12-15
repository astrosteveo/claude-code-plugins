---
type: validation
feature: {{SLUG}}
created: {{DATE}}
phase: validate  # validate | phase-N-validation

overall_status: pending  # pass | fail | pending

checks:
  tests:
    status: pending  # pass | fail | pending | skipped
    passed: 0
    failed: 0
    skipped: 0
    duration_ms: 0
    command: "{{TEST_COMMAND}}"
  lint:
    status: pending
    errors: 0
    warnings: 0
    command: "{{LINT_COMMAND}}"
  types:
    status: pending
    errors: 0
    command: "{{TYPE_COMMAND}}"
  build:
    status: pending
    duration_ms: 0
    command: "{{BUILD_COMMAND}}"

issues: []
  # - type: test_failure
  #   file: "path/to/file.ts"
  #   line: 45
  #   message: "Error message"

recommendations: []
---

# Validation Results: {{FEATURE}}

## Summary

| Check | Status | Details |
|-------|--------|---------|
| Tests | PASS/FAIL | X passed, Y failed |
| Lint | PASS/FAIL | X warnings, Y errors |
| Types | PASS/FAIL | X errors |
| Build | PASS/FAIL | Details |

## Overall: {{OVERALL_STATUS}}

---

## Test Results

**Command**: `{{TEST_COMMAND}}`
**Duration**: Xs

### Summary
- Total: X
- Passed: X
- Failed: X
- Skipped: X

### Failed Tests

None / List of failed tests with error messages

---

## Lint Results

**Command**: `{{LINT_COMMAND}}`

### Errors
None / List

### Warnings
None / List

---

## Type Check Results

**Command**: `{{TYPE_COMMAND}}`

### Errors
None / List with file:line references

---

## Build Results

**Command**: `{{BUILD_COMMAND}}`
**Duration**: Xs

### Output
Success / Error details

---

## Recommendations

1. Action item if any failures
2. Action item if any warnings to address
