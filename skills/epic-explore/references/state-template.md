# State Template

Template for workflow state tracking with YAML frontmatter.

## Template

```markdown
---
feature: {{SLUG}}
description: "{{FEATURE_DESCRIPTION}}"
created: {{DATE}}
last_updated: {{DATE}}

workflow:
  current_phase: explore
  phases:
    explore:
      status: in_progress
      artifacts: []
    plan:
      status: pending
      artifacts: []
    implement:
      status: pending
      current_phase_num: 0
      total_phases: 0
      artifacts: []
    validate:
      status: pending
      artifacts: []
    commit:
      status: pending
      commit_hash: null

agents:
  codebase_explorer:
    task_id: {{TASK_ID}}
    status: running
  docs_researcher:
    task_id: null
    status: pending
    enabled: false

verification:
  tests: pending
  lint: pending
  types: pending
  build: pending

blockers: []
---

# Workflow State: {{FEATURE}}

## Phase Status

| Phase | Status | Artifact |
|-------|--------|----------|
| Explore | in_progress | *-research.md |
| Plan | pending | plan.md |
| Implement | pending | (tracked above) |
| Validate | pending | validation.md |
| Commit | pending | git commit |

## Current Progress

_Updated during implementation phase._

### Implementation Phases
| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1 | pending | |
| Phase 2 | pending | |

### Active Work
- [ ] Current task in progress

## Deviations from Plan

| Deviation | Reason | Impact |
|-----------|--------|--------|
| None | - | - |

## Next Steps

1. Run next phase command
```

## Frontmatter Fields

| Field | Description |
|-------|-------------|
| `workflow.current_phase` | Current active phase (explore/plan/implement/validate/commit) |
| `workflow.phases.[phase].status` | Phase status (pending/in_progress/complete) |
| `agents.*` | Background agent task IDs and status |
| `verification.*` | Verification check statuses |
| `blockers[]` | List of current blockers |

## Status Values

- `pending` - Not started
- `in_progress` - Currently active
- `complete` - Finished successfully
- `blocked` - Cannot proceed
