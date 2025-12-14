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

```language
// Pseudocode or key snippets following patterns from research
```

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

```language
// Pseudocode or key snippets
```

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
