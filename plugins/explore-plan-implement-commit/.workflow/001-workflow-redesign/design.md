# Workflow Redesign

## Overview

**Plugin: explore-plan-implement-commit**

A structured workflow for feature development that enforces research before creativity, planning before coding, and commits after every artifact. Follows Anthropic's recommended pattern (Explore → Plan → Code → Commit) with mandatory research integrated into exploration.

### Core Principles

1. **No creative work without research** - Design and planning only happen after the codebase is mapped and best practices are gathered from authoritative sources
2. **No coding without a plan** - Implementation follows a detailed task breakdown, never ad-hoc
3. **Atomic commits as audit trail** - Every artifact and task gets its own commit; git history documents the entire process
4. **Strict phase ordering** - Explore → Plan → Code → Commit. No skipping. No shortcuts.

### Entry Point

One plugin, one flow. User describes what they want. The plugin:
- Infers intent
- Determines if brainstorming is needed (vague request)
- Walks through all phases automatically

---

## Intent Detection & Resume

### The plugin listens for intent, not commands.

| User says | Plugin understands |
|-----------|-------------------|
| "I wanna make a..." | New feature → start at Explore (maybe Brainstorm first) |
| "This script isn't working..." | Bug/fix → start at Explore (skip Brainstorm) |
| "Let's resume 001-marketplace-explorer" | Resume → check artifacts, pick up where left off |
| "Add dark mode to the app" | Clear feature request → start at Explore |

### Resume Logic

The workflow creates artifacts in `.workflow/NNN-feature-slug/`:
- `codebase.md` → Explore (codebase mapping) done
- `research.md` → Explore (research) done
- `design.md` → Plan (design) done
- `plan.md` → Plan (task breakdown) done

When resuming, the plugin checks which artifacts exist and their state:
- Has `plan.md` with unchecked tasks? → Resume at Code
- Has `design.md` but no `plan.md`? → Resume at Plan (task breakdown)
- Has `codebase.md` but no `research.md`? → Resume at Explore (research)

### Plan Progress Tracking

Tasks in `plan.md` use checkboxes:
```markdown
- [x] Task 1: Set up auth routes *(committed: abc1234)*
- [x] Task 2: Add session middleware *(committed: def5678)*
- [ ] Task 3: Create login form
- [ ] Task 4: Add validation
```

Subagents update the plan as tasks complete. The plan becomes the living progress tracker.

---

## The Four Stages

### EXPLORE

| Step | What happens | Artifact | Commit |
|------|--------------|----------|--------|
| Intent | Infer what user wants; brainstorm if vague | — | — |
| Map codebase | Discoverer documents existing code, patterns, architecture with file:line refs | `codebase.md` | ✓ |
| Research | Discoverer fetches best practices from authoritative sources (docs, specs, RFCs). No stale training data. | `research.md` | ✓ |

### PLAN

| Step | What happens | Artifact | Commit |
|------|--------------|----------|--------|
| Design | Architect the solution using codebase context + research findings. Mermaid diagrams where helpful. | `design.md` | ✓ |
| Task breakdown | Decompose design into atomic, ordered tasks with clear deliverables | `plan.md` | ✓ |

### CODE

| Step | What happens | Artifact | Commit |
|------|--------------|----------|--------|
| Per task | Coder implements task, Orchestrator reviews (code quality, test authenticity, plan adherence) | code + tests | ✓ per task |
| Update plan | Mark task complete with commit hash | `plan.md` updated | — |

### COMMIT

| Step | What happens | Artifact | Commit |
|------|--------------|----------|--------|
| Summarize | Document what was built, any deviations from plan | summary in PR or final commit | ✓ |
| Create PR | If on feature branch, open PR with summary | — | — |

---

## Subagent Architecture

Three subagents handle execution. The plugin orchestrates which one works when.

### ORCHESTRATOR
- Coordinates the workflow
- Deploys Discoverer and Coder with structured task templates
- Performs all reviews (code quality, test authenticity, plan adherence)
- Manages issues and tracks progress
- Updates `plan.md` as tasks complete

### DISCOVERER
- All information gathering
- Codebase mapping (truth-documenting only, no opinions)
- External research (epistemic humility - verify everything, trust nothing from training data)
- Outputs: `codebase.md`, `research.md`

### CODER
- All implementation work
- Receives structured templates from Orchestrator (files to touch, expected outputs, constraints)
- Writes code + tests
- No codebase exploration - that context was already gathered

### Why this split?

| Concern | Owner |
|---------|-------|
| What exists? | Discoverer |
| What's best practice? | Discoverer |
| What should we build? | Orchestrator (via design) |
| How do we build it? | Orchestrator (via plan) |
| Actually building it | Coder |
| Is it good? | Orchestrator (via reviews) |

No role confusion. Clear handoffs. Each subagent stays in its lane.

---

## File Structure & Artifacts

### Workflow Directory

```
.workflow/
├── 001-user-authentication/
│   ├── codebase.md      # What exists (file:line refs)
│   ├── research.md      # Best practices gathered
│   ├── design.md        # Architecture decisions
│   ├── plan.md          # Tasks with checkboxes + commit hashes
│   └── issues.md        # Bugs/blockers discovered during impl
├── 002-dark-mode/
│   └── ...
└── backlog.md           # Deferred items across all features
```

### Numbering

Each feature gets a sequential number prefix (`001-`, `002-`). Makes it easy to:
- Resume by number: "resume 001"
- See order features were worked on
- Keep things tidy

### Artifact Lifecycle

| Artifact | Created during | Updated during | Done when |
|----------|---------------|----------------|-----------|
| `codebase.md` | Explore | — | Committed |
| `research.md` | Explore | — | Committed |
| `design.md` | Plan | — | Committed |
| `plan.md` | Plan | Code (checkboxes + hashes) | All tasks checked |
| `issues.md` | Code (if needed) | Code | Empty or resolved |

---

## Commit Conventions

### Format

```
<stage>: <what was done>
```

### Examples by stage

```
explore: document codebase for user-auth feature
explore: research JWT best practices and session management
plan: design authentication architecture
plan: create implementation task breakdown
code: implement login route and validation
code: add session middleware
code: write auth integration tests
commit: finalize user-auth feature
```

### Why this format?

- `git log --oneline` instantly shows the workflow progression
- Filter by stage: `git log --grep="^explore:"`
- The audit trail reads like a story

### Commit body (optional but encouraged for key artifacts)

```
explore: research JWT best practices

Sources:
- https://jwt.io/introduction
- https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_Cheat_Sheet.html

Key decisions:
- Use short-lived access tokens (15min)
- Refresh tokens stored httpOnly
```

This way the *why* lives in git history too, not just the *what*.

---

## User Experience

### New Feature Flow

```
User: "I want to add user authentication with OAuth"

Plugin: Understood - clear feature request. Starting Explore phase.

        [Maps codebase]
        → Found existing session handling in src/middleware/
        → No current auth implementation
        → Committed: explore: document codebase for oauth feature

        [Researches best practices]
        → Fetched OAuth 2.0 spec, provider docs
        → Committed: explore: research OAuth best practices

        Ready to design. [proceeds to Plan]

        [Creates design]
        → Architecture decisions made
        → Committed: plan: design OAuth architecture

        [Creates task breakdown]
        → 6 tasks identified
        → Committed: plan: create implementation tasks

        Ready to implement. Autonomous or batched?

User: "Batched, 2 at a time"

Plugin: [Implements tasks 1-2]
        → Committed: code: add OAuth provider config
        → Committed: code: implement callback handler
        → plan.md updated with commit hashes

        Review checkpoint. Continue?
```

### Resume Flow

```
User: "Resume 001"

Plugin: Found 001-oauth-feature
        → codebase.md ✓
        → research.md ✓
        → design.md ✓
        → plan.md: 2/6 tasks complete

        Resuming at Code phase, task 3.
```
