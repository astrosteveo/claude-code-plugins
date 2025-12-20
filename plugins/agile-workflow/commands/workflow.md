---
description: AGILE workflow orchestrator - manages PRD, explore, plan, and implement phases
argument-hint: [explore|plan|implement <epic-slug>] or [new idea description]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion
---

# Workflow Command

Orchestrate the AGILE workflow for this project. This command routes to the appropriate phase based on current state and arguments.

## Initial Checks

First, verify git repository exists:

```bash
git rev-parse --is-inside-work-tree 2>/dev/null || echo "NO_GIT"
```

If NO_GIT, initialize git repository before proceeding:
```bash
git init
```

## State Detection

Check for workflow artifacts:

1. **Check PRD exists**: Look for `.claude/workflow/PRD.md`
2. **Check state exists**: Look for `.claude/workflow/state.json`
3. **Parse arguments**: Determine if explicit phase or new idea

## Routing Logic

### No PRD Exists

If `.claude/workflow/PRD.md` does not exist:
- Launch the **discovery** agent to create initial PRD
- Pass any provided arguments as the initial idea/vision

### PRD Exists + New Idea Provided

If PRD exists and arguments look like a feature description (not a phase keyword):
- Launch the **discovery** agent in update mode
- Pass arguments as the new feature idea to add to PRD

### Explicit Phase Command

If first argument is `explore`, `plan`, or `implement`:
- `explore <epic-slug>`: Launch **explore** agent for that epic
- `plan <epic-slug>`: Launch **plan** agent for that epic
- `implement <epic-slug>`: Launch **implement** agent for that epic

Validate the epic exists in state.json before launching.

### Auto-Detection (No Arguments)

If no arguments provided and PRD exists:

1. Read `.claude/workflow/state.json`
2. Find epics that need work:
   - Epic with `phase: "explore"` and no `research.md` → run explore
   - Epic with `phase: "plan"` and no `plan.md` → run plan
   - Epic with `phase: "implement"` and incomplete stories → run implement
3. If multiple epics need work, show status and ask user which to continue
4. If no epics need work, show completion status

## Status Display

When showing status, display:

```
Workflow Status
===============

PRD: ✓ exists
Git: ✓ initialized

Epics:
  [epic-slug-1] phase: implement | effort: 13 | stories: 2/3 complete
  [epic-slug-2] phase: plan      | effort: TBD
  [epic-slug-3] phase: pending   | effort: TBD

Next suggested action: /agile-workflow:workflow implement epic-slug-1
```

## Agent Invocation

When launching agents, use the Task tool with these agent types:

- **discovery**: `subagent_type: "agile-workflow:discovery"`
- **explore**: `subagent_type: "agile-workflow:explore"`
- **plan**: `subagent_type: "agile-workflow:plan"`
- **implement**: `subagent_type: "agile-workflow:implement"`

Pass relevant context to each agent:
- Current state from state.json
- Epic slug being worked on
- Any user-provided context

## Argument Parsing

Arguments: $ARGUMENTS

Parse to determine intent:
- Empty → auto-detect next action
- Starts with `explore`/`plan`/`implement` → explicit phase, second word is epic slug
- Otherwise → treat as new idea for discovery

## Error Handling

- If epic slug doesn't exist in state, list available epics
- If phase is invalid for epic's current state, explain the workflow gates
- If PRD exists but state.json is missing, regenerate state from PRD

## Workflow Gates

Enforce these rules:
- **No PRD → No Explore**: Cannot explore without requirements
- **No Plan → No Implement**: Cannot implement without a plan

If user tries to skip a gate, explain why and suggest the correct action.
