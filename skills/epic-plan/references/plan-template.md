# Implementation Plan Template

Template for phased implementation plans with YAML frontmatter.

## Template

```markdown
---
type: plan
feature: {{SLUG}}
description: "{{GOAL_DESCRIPTION}}"
created: {{DATE}}
status: pending  # pending | approved | in_progress | complete

research:
  codebase: "./codebase-research.md"
  docs: "./docs-research.md"  # null if not applicable

phases:
  total: 2
  current: 0
  list:
    - name: "Phase 1 Name"
      status: pending
      files_affected: 0
    - name: "Phase 2 Name"
      status: pending
      files_affected: 0

validation:
  plan_validated: false
  validation_report: null

rollback_available: true
---

# Implementation Plan: {{FEATURE}}

**Research**: [Codebase](./codebase-research.md) | [Docs](./docs-research.md)

## Goal

{{GOAL_DESCRIPTION}}

## Approach Summary

Brief description of the chosen approach and why, based on research findings.

---

## Phase 1: [Phase Name]

### Changes

| File | Action | Description |
|------|--------|-------------|
| `path/to/file.ts:45-67` | Modify | What changes |
| `path/to/new.ts` | Create | What it does |

### Implementation Details

\`\`\`language
// Pseudocode or key snippets following patterns from research
\`\`\`

### Verification

**Automated**:
- [ ] `npm test` passes
- [ ] `npm run lint` passes
- [ ] `npm run typecheck` passes

**Manual**:
- [ ] Verification step requiring human check

---

## Phase 2: [Phase Name]

### Changes

| File | Action | Description |
|------|--------|-------------|
| `path/to/file.ts` | Modify | What changes |

### Implementation Details

\`\`\`language
// Pseudocode or key snippets
\`\`\`

### Verification

**Automated**:
- [ ] Tests pass
- [ ] Linting passes

**Manual**:
- [ ] Verification step

---

## Rollback Plan

If issues arise:
1. `git revert` the commits from each phase
2. Specific cleanup steps if needed

## Success Criteria

- [ ] Primary functionality works as specified
- [ ] All automated checks pass
- [ ] Manual verification complete
- [ ] No regressions in existing functionality

## Open Questions

- [ ] Questions requiring human decision before implementation
```

## Frontmatter Fields

| Field | Description |
|-------|-------------|
| `type` | Always "plan" |
| `status` | Plan status (pending/approved/in_progress/complete) |
| `phases.total` | Total number of phases |
| `phases.current` | Current phase number (0 = not started) |
| `phases.list[]` | Array of phase names and statuses |
| `validation.plan_validated` | Whether plan-validator has approved |
| `rollback_available` | Whether rollback is possible |

## Status Values

- `pending` - Plan created, awaiting approval
- `approved` - Human approved, ready for implementation
- `in_progress` - Implementation underway
- `complete` - All phases implemented
