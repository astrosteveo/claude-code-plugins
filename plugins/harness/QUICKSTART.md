# Harness Quick Start

> Tame your AI with structured workflows. Get from idea to working code without losing your way.

## What is Harness?

A 5-phase workflow that makes AI-assisted coding predictable:

**Define → Research → Plan → Execute → Verify**

## Why Use It?

- **Prevents scope creep** - Requirements are captured before coding starts
- **Creates an audit trail** - Every decision is documented in artifacts
- **Ensures nothing gets missed** - Verification checks requirements AND user satisfaction

## The 5 Phases

| Phase | What Happens | Output |
|-------|--------------|--------|
| **Define** | Clarify what you're building through Q&A | `requirements.md` |
| **Research** | Explore codebase and best practices | `codebase.md`, `research.md` |
| **Plan** | Design architecture and implementation steps | `design.md`, `plan.md` |
| **Execute** | Build with TDD, commit incrementally | Working code + tests |
| **Verify** | Validate against requirements, ensure satisfaction | Passing tests + approval |

## Get Started

1. **Describe what you want** - Just say what you're trying to build or fix
2. **Answer questions** - The AI guides you through requirements with Socratic dialogue
3. **Approve the plan** - Review the implementation approach before any code is written
4. **Watch it build** - TDD-first implementation following the approved plan
5. **Verify together** - Tests pass AND you're satisfied = done

## Commands

| Command | What It Does |
|---------|--------------|
| `/define` | Start or return to requirements phase |
| `/research` | Explore codebase and options |
| `/plan` | Design the implementation |
| `/execute` | Build following the plan |
| `/verify` | Validate everything works |

## Intent Detection

The workflow automatically detects what you need:

- **"Add a feature"** → Starts the workflow (write-intent)
- **"How does this work?"** → Direct answer (read-intent)
- **"Review this code"** → Asks for clarification (ambiguous)

## Artifacts

All work is tracked in `.harness/` directories:

```
.harness/
├── 001-feature-name/
│   ├── requirements.md
│   ├── codebase.md
│   ├── research.md
│   ├── design.md
│   └── plan.md
└── backlog.md
```

## Lightweight Mode

For trivial tasks (typos, config tweaks), the workflow suggests skipping the ceremony:
> "This seems straightforward. Want to just do it?"

## Learn More

See [WORKFLOW.md](./WORKFLOW.md) for the complete reference.
