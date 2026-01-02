---
date: YYYY-MM-DDTHH:MM:SSZ
researcher: Claude
topic: "[Brief Topic Description]"
tags: [handoff, feature-name, relevant-tags]
status: in_progress
---

# Handoff: [Feature/Task Name]

## Overview

[2-3 sentence summary of what was being worked on and current state]

## Task Status

- **Completed:** [What's done]
- **In Progress:** [What's partially done]
- **Blocked:** [Any blockers]
- **Remaining:** [What's left to do]

---

## What Was Completed

### [Completed Item 1]

- [Specific accomplishment]
- [File changed: `path/to/file.ts`]
- [Verification: tests pass / manually verified]

### [Completed Item 2]

- [Specific accomplishment]
- [File changed: `path/to/file.ts`]

---

## Current State

### Files Modified

| File | Changes | Status |
|------|---------|--------|
| `path/to/file.ts` | [What changed] | Complete |
| `path/to/other.ts` | [What changed] | In Progress |

### Tests

- **Passing:** X tests
- **Failing:** Y tests (if any, explain why)
- **New Tests Added:** [List new tests]

### Git State

```bash
# Current branch
git branch --show-current

# Uncommitted changes (if any)
git status --short
```

---

## What Remains

### Immediate Next Steps

1. [ ] [Next task 1 - be specific]
2. [ ] [Next task 2 - be specific]
3. [ ] [Next task 3 - be specific]

### Known Issues

- [Issue 1: description and potential fix]
- [Issue 2: description and potential fix]

### Decisions Needed

- [Decision 1: options and recommendation]
- [Decision 2: options and recommendation]

---

## Context for Resuming

### Key Files to Read

1. `path/to/main/file.ts` - [Why important]
2. `path/to/test/file.test.ts` - [Why important]
3. `.harness/NNN-feature/plan.md` - [Current plan]

### Important Implementation Details

- [Detail 1 that's easy to forget]
- [Detail 2 that's easy to forget]
- [Detail 3 that's easy to forget]

### Edge Cases Discovered

- [Edge case 1: how it's handled]
- [Edge case 2: still needs handling]

---

## References

- **Plan:** `.harness/NNN-feature/plan.md`
- **Research:** `.harness/NNN-feature/research.md`
- **Related Docs:** [links]

---

## Resume Command

```
/superharness:resume .harness/NNN-feature/handoff.md
```

Or if this is a cross-feature handoff:

```
/superharness:resume .harness/handoffs/YYYY-MM-DD_HH-MM-SS_description.md
```
