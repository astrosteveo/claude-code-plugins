---
name: exploration
description: Use when entering an unfamiliar codebase, starting new work, or when you need to understand before building. Covers codebase exploration AND external research to avoid stale knowledge.
---

# Exploration

## Overview

Understand before you build. This skill covers two types of research:

1. **Codebase exploration** - What's here? How does it work?
2. **External research** - What are current best practices? What patterns exist?

**Announce at start:** "I'm using the exploration skill to understand the codebase and research current approaches."

## When to Use

- Entering an unfamiliar codebase
- Starting work on a new feature/area
- Before brainstorming (to inform design decisions)
- When asked "explore", "understand", "what's here", "how does this work"
- When you need current best practices (your training data may be stale)

## The Process

### Phase 1: Codebase Understanding

**Goal:** Build a mental model of what exists.

```
1. Project structure
   - What's the overall architecture?
   - Key directories and their purposes
   - Entry points and main flows

2. Patterns in use
   - How are similar things done here?
   - Naming conventions, file organization
   - Testing patterns, error handling

3. Key files
   - Configuration (package.json, tsconfig, etc.)
   - Core modules and their responsibilities
   - Recent changes (git log)
```

**Use subagents for deep dives** - Per Anthropic's recommendation, spawn exploration subagents for complex areas to preserve your context.

### Phase 2: External Research

**Goal:** Ensure you're not building on stale knowledge.

```
1. Current best practices
   - Search for "<technology> best practices 2025"
   - Look for official documentation updates
   - Check for deprecations or new approaches

2. Similar implementations
   - How do others solve this problem?
   - What patterns are emerging?
   - What pitfalls have others hit?

3. Dependencies and tools
   - Are there better libraries now?
   - Version compatibility concerns?
   - Security considerations?
```

**Always search** - Your training data has a cutoff. Web search fills the gap.

### Phase 3: Synthesis & Documentation

**Goal:** Consolidate findings into a persistent artifact.

**Write findings to `docs/research.md`** (or `docs/research/YYYY-MM-DD-<topic>.md` for topic-specific research):

```markdown
# Research: [Topic or "Codebase Exploration"]

**Date:** YYYY-MM-DD
**Purpose:** [Why this exploration was done]

## Codebase Summary

### Architecture
- [Pattern/style used]
- [Key architectural decisions]

### Key Areas
| Directory | Purpose |
|-----------|---------|
| src/      | [description] |
| lib/      | [description] |

### Existing Patterns
- [Pattern 1]: [where used, how it works]
- [Pattern 2]: [where used, how it works]

## External Research

### Current Best Practices
- [Finding 1] - Source: [link]
- [Finding 2] - Source: [link]

### Relevant Patterns
- [Pattern]: [description, when to use]

### Potential Pitfalls
- [Pitfall 1]: [how to avoid]

## Recommendations

### Immediate
- [ ] [Action item 1]
- [ ] [Action item 2]

### Future Considerations
- [Consideration 1]
- [Consideration 2]

## Sources
- [Link 1]
- [Link 2]
```

**Commit the research document** after writing.

## Outputs

**Always produce:** `docs/research.md` (or topic-specific file) committed to git.

Exploration can end in different ways:

| User Intent | Outcome |
|-------------|---------|
| "Just understand this" | research.md committed, no next step |
| "Explore before we build X" | research.md committed → offer to start brainstorming |
| "What should we work on?" | research.md committed → recommended priorities |

**Do NOT automatically transition to brainstorming.** Ask first:
> "I've written my findings to docs/research.md and committed. Would you like to proceed to brainstorming a specific feature, or do you have questions about what I found?"

## Key Principles

- **No code yet** - This is purely research and understanding
- **Search externally** - Don't rely only on training data
- **Use subagents** - For complex codebases, parallelize exploration
- **Always document** - Write findings to `docs/research.md` and commit
- **Stay flexible** - Not every exploration leads to building something

## Red Flags

**Never:**
- Skip external research ("I already know how to do this")
- Jump to implementation ("I see what to do, let me just...")
- Assume training data is current (always verify with search)
- Skip writing research.md ("I'll just tell them verbally")
- Explore indefinitely (set a scope, deliver findings)

**Always:**
- Search for current best practices
- Understand existing patterns before proposing new ones
- Write findings to docs/research.md and commit
- Let the user decide next steps

## Integration

**Leads to (optionally):**
- **brainstorming** - When exploration informs a design decision
- Nothing - When the goal was just understanding

**Can be used by:**
- **brainstorming** - "Let me explore the codebase first" before design
- **debugging** - Understanding system before fixing

## Example Flow

```
User: "I'm new to this codebase. Help me understand it and what we should work on."

You: "I'm using the exploration skill to understand the codebase and research current approaches."

[Phase 1: Explore structure, patterns, key files]
[Phase 2: Search for best practices related to the tech stack]
[Phase 3: Write docs/research.md with findings]

You: "I've written my findings to docs/research.md and committed. Here's the summary:

## Codebase Summary
- React 18 + TypeScript frontend
- Express API with PostgreSQL
- Testing with Jest, ~60% coverage
- Follows feature-folder structure

## External Research
- React 19 is now stable - migration guide available
- Express 5.0 released with async error handling
- Current best practice: use React Server Components for data fetching

## Recommendations
1. Update to Express 5.0 (security patches)
2. Consider React 19 migration (new features align with your patterns)
3. Increase test coverage in /api/auth (critical path, only 40% covered)

The full details with sources are in docs/research.md. Would you like to brainstorm any of these improvements, or do you have questions about the codebase?"
```
