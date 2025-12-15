# Validation Results Template

Template for validation results with YAML frontmatter.

## Template

```markdown
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
    command: "npm test"
  lint:
    status: pending
    errors: 0
    warnings: 0
    command: "npm run lint"
  types:
    status: pending
    errors: 0
    command: "npx tsc --noEmit"
  build:
    status: pending
    duration_ms: 0
    command: "npm run build"

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
| Tests | ✓/✗ | X passed, Y failed |
| Lint | ✓/✗ | X errors, Y warnings |
| Types | ✓/✗ | X errors |
| Build | ✓/✗ | Success/Failure (Xs) |

## Overall: {{OVERALL_STATUS}}

---

## Test Results

**Command**: `npm test`
**Duration**: X.Xs

- Total: X
- Passed: X
- Failed: X
- Skipped: X

### Failures
_(If any)_

1. `path/to/test.ts` - "test name" - Error message

---

## Lint Results

**Command**: `npm run lint`

- Errors: X
- Warnings: X
- Auto-fixed: X _(if --fix used)_

### Errors
_(If any)_

- `path/to/file.ts:LINE` - Error description

### Warnings
_(If any)_

- `path/to/file.ts:LINE` - Warning description

---

## Type Check Results

**Command**: `npx tsc --noEmit`

- Errors: X

### Errors
_(If any)_

- `path/to/file.ts:LINE` - Type error description

---

## Build Results

**Command**: `npm run build`
**Duration**: X.Xs
**Status**: Success / Failure

### Output
_(If successful)_
- Location: `dist/`

### Errors
_(If failed)_
- Error description
```

## Frontmatter Fields

| Field | Description |
|-------|-------------|
| `type` | Always "validation" |
| `phase` | "validate" for final, "phase-N-validation" for phase validation |
| `overall_status` | Aggregate status (pass/fail/pending) |
| `checks.*` | Individual check results with counts |
| `issues[]` | Array of specific issues found |
| `recommendations[]` | Suggested fixes |

## Status Values

- `pass` - Check passed
- `fail` - Check failed
- `pending` - Not yet run
- `skipped` - Intentionally skipped
