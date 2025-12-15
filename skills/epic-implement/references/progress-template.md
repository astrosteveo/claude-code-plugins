# Progress Template

Template for the Current Progress section in state.md, updated during implementation.

## Template

Add this section to `state.md` during implementation, updating the frontmatter as well:

```markdown
## Current Progress

_Last Updated: [timestamp]_

### Phase Summary
| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1 | ✓ Complete | [brief notes] |
| Phase 2 | → In Progress | [current work] |
| Phase 3 | Pending | |

### Active Work
- [x] Completed change 1
- [x] Completed change 2
- [ ] Current change in progress

### Verification Results
| Check | Status | Notes |
|-------|--------|-------|
| Tests | PASS | 42 passed |
| Lint | PASS | No issues |
| Types | PASS | No errors |

## Deviations from Plan

| Deviation | Reason | Impact |
|-----------|--------|--------|
| [What differed] | [Why] | [Effect on plan] |

## Blockers

_None_ or list current blockers

## Next Steps

1. [Immediate next action]
2. [Following action]
```

## Frontmatter Updates

When updating progress, also update the state.md frontmatter:

```yaml
workflow:
  current_phase: implement
  phases:
    implement:
      status: in_progress
      current_phase_num: 2  # Update as phases complete
      total_phases: 3

verification:
  tests: pass     # Update after each verification
  lint: pass
  types: pass
  build: pending

blockers: []      # Add any blockers here
```

## Status Values

| Symbol | Meaning |
|--------|---------|
| `✓ Complete` | Phase finished, all verification passed |
| `→ In Progress` | Currently being worked on |
| `Pending` | Not yet started |
| `⚠️ Blocked` | Cannot proceed, needs resolution |

## When to Update

Update after:
1. Each file change
2. Each verification run
3. Each phase completion
4. Any deviation from plan
5. New blockers discovered
