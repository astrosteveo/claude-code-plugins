# Handoff Template

Template for session handoff documents with YAML frontmatter.

## Template

```markdown
---
type: handoff
feature: {{FEATURE_SLUG}}
description: "{{FEATURE_DESCRIPTION}}"
created: {{ISO_DATE}}

git:
  branch: {{BRANCH}}
  commit: {{COMMIT_HASH}}
  clean: true  # false if uncommitted changes

workflow:
  phase: {{PHASE}}
  plan_path: "{{WORKFLOW_DIR}}/plan.md"
  workflow_dir: "{{WORKFLOW_DIR}}"

tasks:
  - name: "Task description"
    status: completed  # completed | wip | planned
    notes: "Additional context"

context_usage: 60  # percentage estimate

tags: [handoff, {{PHASE}}]
---

# Handoff: {{FEATURE_SLUG}}

## Task Summary

| Task | Status | Notes |
|------|--------|-------|
| [Task description] | completed/WIP/planned | [Additional context] |

**Current Phase**: {{PHASE}}
**Plan Reference**: {{WORKFLOW_DIR}}/plan.md

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
```

## Frontmatter Fields

| Field | Description |
|-------|-------------|
| `type` | Always "handoff" |
| `git.branch` | Current git branch |
| `git.commit` | Current commit hash |
| `git.clean` | Whether working directory is clean |
| `workflow.phase` | Current workflow phase |
| `workflow.workflow_dir` | Path to workflow artifacts |
| `tasks[]` | Array of tasks with status |
| `context_usage` | Estimated context window usage % |
| `tags[]` | Searchable tags |

## Task Status Values

- `completed` - Task finished
- `wip` - Work in progress
- `planned` - Not yet started

## Guidelines

**Target length**: Under 200 lines total
**Focus on**: What's needed to resume, not full history
**Include**: Critical file:line references, not exhaustive lists
