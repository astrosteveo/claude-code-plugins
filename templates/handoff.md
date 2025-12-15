---
type: handoff
feature: {{FEATURE_SLUG}}
description: "{{FEATURE_DESCRIPTION}}"
created: {{ISO_DATE}}

git:
  branch: {{BRANCH}}
  commit: {{COMMIT_HASH}}
  clean: true

workflow:
  phase: {{PHASE}}
  plan_path: "{{PLAN_PATH}}"
  workflow_dir: "{{WORKFLOW_DIR}}"

tasks:
  - name: "{{TASK_NAME}}"
    status: completed  # completed | wip | planned
    notes: ""

context_usage: 60  # percentage estimate

tags: [handoff, {{PHASE}}]
---

# Handoff: {{FEATURE_SLUG}}

## Task Summary

| Task | Status | Notes |
|------|--------|-------|
| [Task description] | completed/WIP/planned | [Additional context] |

**Current Phase**: {{PHASE}}
**Plan Reference**: {{PLAN_PATH}}

## Critical References

_Documents that must be followed:_

- `{{WORKFLOW_DIR}}/plan.md` - Implementation plan
- `{{WORKFLOW_DIR}}/state.md` - Current workflow state

## Recent Changes

_Changes made in `file:line` format:_

- `path/to/file.ts:45-67` - [What was changed]

## Learnings

_Patterns or information the next session should know:_

- [Pattern/learning discovered]

## Artifacts

| Artifact | Path | Status |
|----------|------|--------|
| Research | `{{WORKFLOW_DIR}}/codebase-research.md` | [status] |
| Plan | `{{WORKFLOW_DIR}}/plan.md` | [status] |
| State | `{{WORKFLOW_DIR}}/state.md` | [status] |
| Validation | `{{WORKFLOW_DIR}}/validation.md` | [status] |

## Next Steps

1. [ ] [Next action item]
2. [ ] [Following action item]

## Notes

_Additional context:_

- [Note]
