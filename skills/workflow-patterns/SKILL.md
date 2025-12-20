---
name: Workflow Patterns
description: This skill should be used when working with the agile-workflow plugin, creating PRD documents, writing research or plan docs, updating state.json, estimating story points, contributing to open source projects, or when the user asks about "workflow artifacts", "PRD format", "research document", "plan document", "state schema", "effort estimation", "epic/story structure", "OSS contribution", "project conventions", or "commit message format". Provides document templates, state management patterns, and OSS contribution guidance.
version: 0.1.0
---

# Workflow Patterns

## Overview

The agile-workflow plugin enforces a structured development workflow with specific document formats and state management patterns. All artifacts live in `.claude/workflow/` to keep the project root clean.

## Core Concepts

### Workflow Phases

```
PRD exists? → Explore → Plan exists? → Implement
```

**Gates:**
- No PRD → No Explore (prevents aimless research)
- No Plan → No Implement (prevents coding without thinking)

### Artifact Types

| Artifact | Format | Purpose |
|----------|--------|---------|
| `state.json` | JSON | Machine-readable project state for LLM |
| `PRD.md` | Markdown | Human-readable requirements |
| `epics/[slug]/research.md` | Markdown | Exploration findings with file:line refs |
| `epics/[slug]/plan.md` | Markdown | Implementation approach with stories |

## State Management

### Reading State

To check project state, read `.claude/workflow/state.json`:

```bash
cat .claude/workflow/state.json
```

Parse JSON to determine:
- Which epics exist and their phases
- Story status and blockers
- Effort estimates

### Updating State

When updating state, modify specific fields while preserving structure. Use atomic updates - read, modify, write back.

**Status values:**
- Epic status: `pending`, `in_progress`, `completed`
- Epic phase: `explore`, `plan`, `implement`, `complete`
- Story status: `pending`, `in_progress`, `completed`

### State Schema

For complete state structure, see `references/state-schema.md`.

## Document Formats

### PRD Format

The PRD contains vision, requirements, and epic overview. Create at `.claude/workflow/PRD.md`.

**Key sections:**
1. Vision - One paragraph project purpose
2. Requirements - Numbered list (REQ-1, REQ-2, etc.)
3. Epics - High-level epic descriptions with status

For complete PRD template, see `references/prd-format.md`.

### Research Document Format

Create after exploration at `epics/[epic-slug]/research.md`.

**Key sections:**
1. Summary - 2-3 sentences of findings
2. Relevant Files - Tables with file:line:purpose
3. Patterns Observed - Code patterns found
4. Dependencies - External dependencies
5. Constraints - Limitations discovered

**Critical:** Use precise `file:line` references, not vague descriptions.

For complete research template, see `references/research-format.md`.

### Plan Document Format

Create after planning at `epics/[epic-slug]/plan.md`.

**Key sections:**
1. Approach - High-level technical strategy
2. Stories - Detailed story breakdowns with AC
3. File Change Summary - What files will change
4. Order of Operations - Dependency-based sequence

For complete plan template, see `references/plan-format.md`.

## Effort Estimation

### Fibonacci Story Points

Use Fibonacci sequence for story effort: 1, 2, 3, 5, 8, 13

| Points | Complexity |
|--------|------------|
| 1 | Trivial - single file, obvious change |
| 2 | Simple - few files, straightforward |
| 3 | Moderate - some complexity or unknowns |
| 5 | Complex - multiple files, integration work |
| 8 | Large - significant scope, should consider splitting |
| 13 | Very large - strongly consider breaking down |

### Epic Effort

Epic effort = sum of story points, normalized to nearest Fibonacci.

**Normalization table:**
| Sum Range | Normalized |
|-----------|------------|
| 1-2 | 2 |
| 3-4 | 3 |
| 5-6 | 5 |
| 7-10 | 8 |
| 11-16 | 13 |
| 17-27 | 21 |
| 28+ | Break it down |

### Estimation Guidelines

When estimating effort:
1. Consider files to modify and create
2. Account for integration complexity
3. Factor in testing requirements
4. Include documentation updates
5. If estimate exceeds 8, consider splitting the story

## Story Format

Use the standard user story format:

**As a** [user type], **I want** [goal], **so that** [benefit]

**Example:**
```
As a user, I want to log in with Google, so that I don't need to create a new account
```

### Acceptance Criteria

Write testable, specific criteria:

**Good AC:**
- User can click 'Login with Google' button
- User is redirected to Google consent screen
- Session cookie is set after successful auth

**Bad AC:**
- Login works correctly (too vague)
- User can authenticate (not specific)

## Identifiers

Use slugs for all identifiers:
- kebab-case format
- Lowercase letters and hyphens only
- Self-documenting names
- Example: `user-auth`, `oauth-setup`, `guild-system`

## Git Integration

Commits happen automatically at workflow milestones:

| Trigger | Message Pattern |
|---------|-----------------|
| PRD created | `docs(prd): initialize PRD for [project]` |
| PRD updated | `docs(prd): add [epic-slug] epic` |
| Exploration complete | `docs(explore): add research for [epic-slug]` |
| Plan complete | `docs(plan): add implementation plan for [epic-slug]` |
| Story complete | `feat([epic-slug]): [story-slug] - [story name]` |
| Epic complete | `feat([epic-slug]): complete epic - [epic name]` |

## Directory Structure

```
.claude/workflow/
├── PRD.md              # Requirements and epic overview
├── state.json          # Machine-readable state
└── epics/
    └── [epic-slug]/
        ├── research.md # Exploration output
        └── plan.md     # Implementation plan
```

## Additional Resources

### Reference Files

For detailed templates and schemas:
- **`references/state-schema.md`** - Complete JSON state structure
- **`references/prd-format.md`** - PRD document template
- **`references/research-format.md`** - Research document template
- **`references/plan-format.md`** - Plan document template
- **`references/oss-contribution.md`** - Guide for OSS contributions (convention detection, commit patterns)
