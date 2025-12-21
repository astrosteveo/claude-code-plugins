# Agile Workflow Plugin for Claude Code

A Claude Code plugin that enforces AGILE-style project management with TDD, Socratic discovery, and systematic debugging.

## Philosophy

AGILE methodology and LLM context limitations share the same solution: **break work into small, focused chunks**.

- LLM performance degrades at ~40% context, seriously at ~60%, breaks at ~80%
- AGILE breaks work into epics → stories for the same reason humans can't hold large projects in their heads
- This plugin enforces a workflow that keeps context minimal and work well-scoped

## Features

- **Single command**: `/agile-workflow:workflow` handles everything
- **Socratic discovery**: Presents alternatives, asks about tech stack, validates incrementally
- **TDD enforcement**: Red-green-refactor for every behavior
- **Bite-sized tasks**: Each step takes 2-5 minutes with complete code snippets
- **Two-stage review**: Spec compliance first, code quality second
- **Git worktrees**: Isolated development environments
- **Systematic debugging**: Four-phase root cause investigation

## Usage

```bash
# Start a new project or continue existing workflow
/agile-workflow:workflow

# Add a new feature idea
/agile-workflow:workflow I want to add user authentication

# Explicitly run a phase
/agile-workflow:workflow explore user-auth
/agile-workflow:workflow plan user-auth
/agile-workflow:workflow implement user-auth
```

## Workflow

```
PRD exists? → Explore → Plan exists? → Implement (Orchestrator)
     ↓            ↓           ↓                  ↓
   Gate        Research     Gate          ┌─────────────┐
   + Tech      doc with   + Stories       │ Per Task:   │
   Stack       file:line   + Tasks        │ Implementer │
                                          │ Spec Review │
                                          │ Quality Rev │
                                          └─────────────┘
                                                 ↓
                                          Finish Branch
                                          (merge/PR/keep/discard)
```

### Gates

| Gate | Prevents |
|------|----------|
| No PRD → No Explore | Aimless research without direction |
| No Plan → No Implement | Coding without thinking |
| No Spec Compliance → No Quality Review | Reviewing style before requirements |

## Artifacts

All workflow artifacts live in `.claude/workflow/`:

```
.claude/workflow/
├── PRD.md              # Requirements, tech stack, epic overview
├── state.json          # Machine-readable project state
└── epics/
    └── [epic-slug]/
        ├── research.md # Exploration findings
        └── plan.md     # Implementation plan with TDD tasks
```

## Agents

### Workflow Agents

| Agent | Phase | Purpose |
|-------|-------|---------|
| Discovery | PRD creation | Socratic dialogue, tech stack clarification, validate incrementally |
| Explore | Research | Survey codebase, document with file:line refs |
| Plan | Design | Bite-sized TDD tasks with complete code snippets |
| Implement | Execution | **Orchestrator** - dispatches subagents per task |

### Subagents (dispatched by Implement)

| Agent | Role | Purpose |
|-------|------|---------|
| Implementer | Execute | Fresh per task, TDD, self-review, commit |
| Spec-Reviewer | Review | Verify code matches requirements (nothing missing/extra) |
| Code-Quality-Reviewer | Review | Verify quality (only after spec passes) |

## Skills

| Skill | Purpose |
|-------|---------|
| **workflow-patterns** | Document templates, state schema, effort estimation |
| **subagent-driven-development** | Orchestration pattern: fresh subagent per task + two-stage review |
| **systematic-debugging** | Four-phase debugging: investigate → analyze → hypothesize → implement |
| **verification-before-completion** | Evidence-first: run verification before claiming done |
| **spec-compliance-review** | Verify code matches requirements exactly |
| **code-quality-review** | Review implementation quality (after spec passes) |
| **git-worktrees** | Isolated development environments per feature |
| **finishing-branch** | Structured completion: merge/PR/keep/discard |

## Subagent-Driven Development

Implementation uses fresh subagents per task with two-stage review:

```
For Each Task:
├── Implementer subagent (TDD, self-review, commit)
├── Spec Reviewer subagent (verify requirements)
│   └── If issues → Implementer fixes → Re-review
├── Code Quality Reviewer subagent (verify quality)
│   └── If issues → Implementer fixes → Re-review
└── Mark complete

Benefits:
- Fresh context per task (no pollution)
- Two-stage review catches different issues
- Review loops ensure fixes work
- Controller provides full context to subagents
```

## TDD Enforcement

Every implementation task follows red-green-refactor:

1. **RED**: Write failing test, run it, verify it fails
2. **GREEN**: Write minimal code, run test, verify it passes
3. **REFACTOR**: Clean up while keeping tests green
4. **COMMIT**: Atomic commit for each behavior

**The Iron Law**: No production code without a failing test first.

## Discovery Process

The discovery agent uses Socratic dialogue:

1. **One question at a time** - Never overwhelms
2. **Presents alternatives** - "Here are 3 approaches, I'd recommend A because..."
3. **Asks about tech stack** - Never assumes Godot, React, etc.
4. **Validates incrementally** - "Does this capture what you're thinking?"
5. **Pushes back on scope creep** - "Do you need this for v1?"

## Two-Stage Review

After implementation:

1. **Spec Compliance** - Does it match requirements? Nothing missing? Nothing extra?
2. **Code Quality** - Is it well-built? Only runs after spec passes.

## Effort Points

Stories use Fibonacci points: 1, 2, 3, 5, 8, 13

- 1-5 points: Normal story
- 8+ points: Must split

Epic effort = sum of story points, normalized to nearest Fibonacci.

## License

MIT
