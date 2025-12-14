# Workflow State

**Feature**: {{FEATURE}}
**Slug**: {{SLUG}}
**Directory**: .claude/workflows/{{SLUG}}
**Current Phase**: {{PHASE}}
**Research Scope**: {{SCOPE}}  <!-- full (codebase + docs) | codebase only -->
**Last Updated**: {{DATE}}
**Context Estimate**: ~[X]K / 200K tokens ([Y]%)

## Background Agents

| Agent | Task ID | Status |
|-------|---------|--------|
| codebase-explorer | {{TASK_ID}} | running/completed |
| docs-researcher | {{TASK_ID}} | running/completed |  <!-- omit row if codebase only -->

## Phase Status

| Phase | Status | Artifact |
|-------|--------|----------|
| Explore | pending/complete | research/*.md |
| Plan | pending/complete | plans/implementation-plan.md |
| Implement | pending/in_progress/complete | implementation/progress.md |
| Validate | pending/complete | validation/results.md |
| Commit | pending/complete | (git commit) |
