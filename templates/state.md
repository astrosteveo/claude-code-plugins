---
feature: {{SLUG}}
description: "{{FEATURE_DESCRIPTION}}"
created: {{DATE}}
last_updated: {{DATE}}

workflow:
  current_phase: explore
  phases:
    explore:
      status: pending
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
    task_id: null
    status: pending
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
| Explore | pending | *-research.md |
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
