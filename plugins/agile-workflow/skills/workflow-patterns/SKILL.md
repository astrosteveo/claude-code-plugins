---
name: workflow-patterns
description: Use when working with agile-workflow artifacts - project.md, research docs, plans. Provides document templates and workflow guidance.
---

# Workflow Patterns

## Overview

The agile-workflow plugin uses a simple Research → Plan → Implement workflow with minimal artifacts.

## Workflow Phases

```
Brainstorm → Research (optional) → Plan → Implement
```

Each phase creates artifacts in `docs/`:
- `docs/project.md` - Project tracking (living document)
- `docs/research/` - Codebase research findings
- `docs/plans/` - Implementation plans

## Artifact Locations

| Artifact | Location | Purpose |
|----------|----------|---------|
| Project tracking | `docs/project.md` | Living project evolution document |
| Research | `docs/research/YYYY-MM-DD-topic.md` | Codebase exploration findings |
| Design | `docs/plans/YYYY-MM-DD-topic-design.md` | Brainstorming output |
| Plan | `docs/plans/YYYY-MM-DD-topic.md` | Implementation tasks |

## Project Tracking Template

```markdown
# Project Name

## Vision
[What this project is and why - 2-3 sentences]

## Tech Stack
- **Language/Framework**: [X]
- **Key Dependencies**: [Y]
- **Deployment**: [Z]

## Decisions Log
| Date | Decision | Rationale |
|------|----------|-----------|
| YYYY-MM-DD | [Decision] | [Why] |

## Completed
- [x] [Feature] (YYYY-MM-DD)

## Current Focus
[What we're actively working on]

## Next Steps
- [ ] [Next item]
- [ ] [After that]

## Notes
[Context for future sessions]
```

## Research Template

```markdown
# Research: [Topic]

## Goal
[What we're trying to understand]

## Summary
[2-3 sentences of key findings]

## Relevant Files
| File | Lines | Purpose |
|------|-------|---------|
| `path/to/file.ts` | 1-145 | [What it does] |

## Patterns Observed
- **[Pattern]**: `file:line` - [Description]

## Integration Points
- [Where new code connects]

## Constraints
- [Things we can't change]

## Open Questions
- [Things still unclear]
```

## Plan Template

```markdown
# [Feature] Implementation Plan

**Goal:** [One sentence]

**Architecture:** [2-3 sentences]

**Tech Stack:** [Key technologies]

---

### Task 1: [Name]

**Files:**
- Create: `path/to/new.ts`
- Modify: `path/to/existing.ts:10-25`

**What to Build:**
[Clear description]

**Implementation:**
[Specific code]

**Tests:**
[What to test]

**Verification:**
Run: `[command]`
Expected: [result]
```

## Git Commit Patterns

| Action | Commit Message |
|--------|----------------|
| New project | `docs: initialize project tracking` |
| Research complete | `docs: add research for [topic]` |
| Plan complete | `docs: add implementation plan for [topic]` |
| Feature complete | `feat: [feature description]` |

## Key Principles

- **YAGNI** - Only build what's needed
- **TDD** - Test-driven development in plans
- **DRY** - Don't repeat yourself
- **Precise references** - Always file:line format
- **Living documents** - Update as work progresses
