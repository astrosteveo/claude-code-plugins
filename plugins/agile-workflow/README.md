# Agile Workflow Plugin for Claude Code

A Claude Code plugin for high-quality autonomous coding sessions using the Research → Plan → Implement workflow.

## Philosophy

Based on research from [Advanced Context Engineering for Coding Agents](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents):

> "A bad line of code is a bad line. But a bad line of a plan could lead to hundreds of bad lines."

Human effort should focus on **reviewing plans**, not code. This plugin enforces:
- Thorough planning before coding
- Fresh subagents per task (clean context)
- Two-stage review (spec compliance, then quality)
- Project tracking that evolves with the work

## Quick Start

```bash
# Start something new
/agile-workflow:workflow I want to build a CLI tool for...

# Research existing codebase
/agile-workflow:workflow research authentication system

# Create implementation plan
/agile-workflow:workflow plan

# Execute plan with subagents
/agile-workflow:workflow implement
```

## Workflow

```
Brainstorm → Research (optional) → Plan → Implement
    ↓              ↓                  ↓         ↓
 Socratic      Explore           Detailed   Subagent
 dialogue      codebase           tasks      per task
    ↓              ↓                  ↓         ↓
 Design doc   Research doc    Implementation  Two-stage
    +              +               plan        review
 project.md   file:line refs
```

## Artifacts

All artifacts live in `docs/`:

```
docs/
├── project.md                    # Living project tracking
├── research/
│   └── YYYY-MM-DD-topic.md       # Codebase exploration
└── plans/
    ├── YYYY-MM-DD-topic-design.md  # Brainstorming output
    └── YYYY-MM-DD-topic.md         # Implementation plan
```

### Project Tracking (docs/project.md)

A living document that evolves with the project:

```markdown
# Project Name

## Vision
[What and why]

## Tech Stack
- Language: [X]

## Decisions Log
| Date | Decision | Rationale |

## Completed
- [x] Feature (date)

## Current Focus
[Active work]

## Next Steps
- [ ] Next item

## Notes
[Context for future sessions]
```

## Skills

| Skill | Purpose |
|-------|---------|
| **brainstorming** | Socratic dialogue to understand what to build |
| **research** | Survey codebase, document with file:line refs |
| **writing-plans** | Create detailed implementation plans |
| **subagent-driven-development** | Execute plans with fresh subagent per task |
| **project-tracking** | Maintain docs/project.md across sessions |

## Implementation Pattern

Plans are executed using subagent-driven development:

```
For Each Task:
├── Dispatch Implementer (fresh context)
│   └── TDD, self-review, commit
├── Dispatch Spec Reviewer
│   └── Verify requirements met (nothing missing/extra)
│   └── If issues → Implementer fixes → Re-review
├── Dispatch Code Quality Reviewer
│   └── Verify quality (only after spec passes)
│   └── If issues → Implementer fixes → Re-review
└── Mark complete, next task
```

Benefits:
- Fresh context per task (no pollution)
- Two-stage review catches different issues
- 30-minute autonomous sessions without deviation

## Key Principles

- **YAGNI** - Only build what's needed
- **TDD** - Test-driven development
- **DRY** - Don't repeat yourself
- **Precise references** - Always file:line format
- **Plan review > Code review** - Human effort on plans

## Other Skills

| Skill | Purpose |
|-------|---------|
| **systematic-debugging** | Four-phase root cause investigation |
| **verification-before-completion** | Evidence-first verification |
| **git-worktrees** | Isolated development environments |
| **finishing-branch** | Structured branch completion |

## License

MIT
