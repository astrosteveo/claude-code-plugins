---
name: research
description: Use when you need to understand an existing codebase before planning. Surveys code, documents patterns, and identifies integration points. Essential for working in unfamiliar codebases.
---

# Codebase Research

Systematically explore a codebase to understand what exists before planning changes.

**Announce at start:** "I'm researching the codebase to understand [topic]."

## When to Use

- Working in an unfamiliar codebase
- Adding features that integrate with existing code
- Need to understand patterns before planning
- ACE-FCA "Research Phase" before planning

## The Process

1. **Understand the goal** - What are we trying to learn?
2. **Survey the structure** - Directory layout, key files
3. **Find relevant code** - Files that matter for this work
4. **Document patterns** - How does this codebase do things?
5. **Identify integration points** - Where will new code connect?
6. **Write research artifact** - Capture findings

## Research Techniques

**File discovery:**
```
Glob: **/*.ts, **/auth/**, etc.
```

**Pattern search:**
```
Grep: function names, imports, patterns
```

**Deep reading:**
- Read key files completely
- Note specific line ranges
- Understand dependencies

## What to Document

**Always use precise references:** `src/auth/middleware.ts:45-67`

| Category | What to Capture |
|----------|-----------------|
| Structure | Directory layout, entry points |
| Patterns | How errors are handled, how data flows |
| Integration | Where new code will connect |
| Conventions | Naming, formatting, testing patterns |
| Constraints | What can't be changed, external deps |

## Research Artifact

Write findings to: `docs/research/YYYY-MM-DD-<topic>.md`

```markdown
# Research: [Topic]

## Goal
[What we're trying to understand]

## Summary
[2-3 sentences of key findings]

## Relevant Files

### [Category]
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

## After Research

1. Update docs/project.md Notes if relevant context discovered
2. Proceed to planning: "Ready to create an implementation plan?"

## Key Rules

- **Precise references** - Always file:line, never vague descriptions
- **Organize by category** - Group related files together
- **Note constraints** - What can't be changed is as important as what can
- **Surface questions** - Don't hide uncertainty
