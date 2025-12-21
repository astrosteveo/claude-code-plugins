---
description: Start or continue work - routes to brainstorm, research, plan, or implement based on context
argument-hint: "[new idea] | research [topic] | plan | implement"
---

# Workflow Command

Routes to the appropriate skill based on what you need.

## Quick Reference

| Command | What it does |
|---------|--------------|
| `/workflow [idea]` | Brainstorm new work |
| `/workflow research [topic]` | Research existing codebase |
| `/workflow plan` | Create implementation plan |
| `/workflow implement` | Execute plan with subagents |

## Routing Logic

### New Work: `/workflow [idea description]`

Use the **brainstorming** skill to:
1. Understand what user wants to build
2. Ask clarifying questions (one at a time)
3. Present design in digestible chunks
4. Create or update docs/project.md
5. Offer next steps (research or plan)

### Research: `/workflow research [topic]`

Use the **research** skill to:
1. Survey codebase structure
2. Find relevant files
3. Document patterns and integration points
4. Write findings to docs/research/YYYY-MM-DD-topic.md
5. Offer to proceed to planning

### Planning: `/workflow plan`

Use the **writing-plans** skill to:
1. Review design/research artifacts
2. Create detailed implementation plan
3. Break into bite-sized tasks with exact file paths
4. Write to docs/plans/YYYY-MM-DD-feature.md
5. Offer execution options

### Implementation: `/workflow implement`

Use the **subagent-driven-development** skill to:
1. Read the plan
2. Create TodoWrite with all tasks
3. Dispatch fresh subagent per task
4. Two-stage review (spec compliance, then quality)
5. Update docs/project.md when complete

## Auto-Detection (No Arguments)

If user just runs `/workflow` with no arguments:

1. Check for docs/project.md
2. If exists, read Current Focus and Next Steps
3. Suggest logical next action based on context

Example:
```
Project: Corporate Casualties
Current Focus: [empty]
Next Steps:
- [ ] Add worker needs system
- [ ] Implement pathfinding

Suggestion: "Looks like 'Add worker needs system' is next.
Want to research the codebase first, or jump into planning?"
```

## Project Tracking

Throughout the workflow, keep docs/project.md updated:
- After brainstorming: Add Vision, Tech Stack, Next Steps
- After completing work: Move items Completed, update Current Focus
- When decisions are made: Log in Decisions table

## Session Start

When starting a new session on an existing project:
1. Read docs/project.md
2. Summarize current state
3. Ask: "What would you like to work on?" or suggest from Next Steps
