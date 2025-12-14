# Validation Results

**Date**: {{DATE}}
**Feature**: {{FEATURE}}
**Overall**: PASS / FAIL

## Summary

| Check | Status | Details |
|-------|--------|---------|
| Tests | ✓/✗ | X passed, Y failed |
| Lint | ✓/✗ | X errors, Y warnings |
| Types | ✓/✗ | X errors |
| Build | ✓/✗ | Success/Failure (Xs) |

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

## Type Check Results

**Command**: `npx tsc --noEmit`

- Errors: X

### Errors
_(If any)_

- `path/to/file.ts:LINE` - Type error description

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
