---
name: research-first
description: "MUST invoke before any design decisions or implementation planning."
---

# Research-First

## Overview

Research happens BEFORE design. Period.

Research = **Codebase Exploration** + **External Research**. Both are required. You cannot skip either.

## First Action (MANDATORY)

```
IMMEDIATELY START EXPLORING. DO NOT ASK THE USER ANYTHING.
```

When this skill is invoked:
1. Say: "I'm using the research-first skill to explore the codebase and gather current information before designing anything."
2. **In the same response**, start running Glob/Grep/Read commands to explore the codebase
3. Do NOT ask the user any questions - the codebase has the answers
4. Do NOT wait for permission to explore - that's what this skill is for

**If you find yourself wanting to ask a question, STOP.** Search the codebase instead.

## The Iron Rule

```
NO DESIGNING UNTIL RESEARCH IS COMPLETE
```

This means:
- No proposing approaches
- No recommending architectures
- No writing implementation details
- No making technology choices

Until you have:
1. Explored the codebase thoroughly
2. Researched external technologies/APIs
3. Looked for creative solutions

## Red Flags - You're Skipping Research

| Thought | Reality |
|---------|---------|
| "I already know how this works" | Training data is stale. Verify. |
| "The codebase is simple" | Simple codebases have patterns you'll miss. Explore. |
| "I'll research as I go" | Research after design = rework. Research first. |
| "Just a quick design first" | NO. Research first, then design. |
| "I can see the pattern" | Seeing isn't knowing. Read the actual code. |
| "This is similar to X" | Similar isn't same. Verify current state. |
| "I'll check if needed" | You always need to check. That's the point. |
| "Let me propose something first" | NO. Research THEN propose. |
| "Let me ask the user about the code" | NO. The codebase answers code questions. Explore. |
| "What's the current state?" | DON'T ASK. Search for it. |

## The Research Process

### Phase 1: Codebase Exploration (REQUIRED)

**You cannot skip this.** Even if you "know" the codebase.

**Exploration Strategy: Parallel Agents**

For non-trivial features, dispatch 2-3 exploration agents in parallel with different focuses:

```
Task tool (Explore):
  Agent 1: "Explore existing patterns for [feature area]"
  Agent 2: "Explore dependencies and integration points for [feature area]"
  Agent 3: "Explore test patterns and edge cases for [feature area]"
```

**Why parallel exploration:**
- Single-threaded exploration misses cross-cutting concerns
- Different focuses catch different things
- Faster than sequential deep dives
- Prevents Claude's anti-pattern of reading 2-3 files and assuming understanding

**When to use parallel exploration:**
| Feature Size | Exploration Approach |
|--------------|---------------------|
| Micro (< 5 min) | Single quick search |
| Small (< 30 min) | 1-2 focused searches |
| Medium (30 min - 2 hrs) | 2 parallel agents |
| Large (> 2 hrs) | 3 parallel agents |

**What each agent explores:**

**Agent 1: Patterns & Architecture**
- How is similar functionality implemented?
- What abstractions exist?
- What patterns are used (naming, structure, error handling)?

**Agent 2: Dependencies & Integration**
- What files touch the area you're working on?
- What are the dependencies?
- What might break if you change things?
- What external services/APIs are involved?

**Agent 3: Tests & Edge Cases**
- How are similar features tested?
- What testing patterns are used?
- What edge cases are covered?
- What's been changed recently in this area?

**How to explore (for each agent):**

```bash
# Find related files
glob "**/*relevant-keyword*"

# Search for patterns
grep "similar function or pattern"

# Check recent commits
git log --oneline -20 -- path/to/area

# Read related code
read actual files, don't assume
```

**Consolidate findings:** After agents complete, synthesize into unified research document.

**Document what you find:**

```markdown
## Codebase Exploration

**Area:** [What part of codebase]
**Date:** YYYY-MM-DD

### Existing Patterns
- [Pattern 1]: Found in [files], used for [purpose]
- [Pattern 2]: ...

### Related Code
- [File/module]: [What it does, how it relates]

### Testing Approach
- Tests are in [location]
- Pattern used: [describe]

### Recent Activity
- [Relevant recent changes]

### Key Observations
- [Things that will affect the design]
```

### Phase 2: External Research (REQUIRED)

**For any external dependencies, APIs, or technologies:**

1. **Current Versions**
   - What's the latest stable version?
   - What breaking changes exist?
   - What's deprecated?

2. **API Signatures**
   - What are the actual method signatures?
   - What are the parameters and return types?
   - What errors can be thrown?

3. **Best Practices**
   - What does official documentation recommend?
   - What are common pitfalls?
   - What patterns are current?

4. **Creative Solutions**
   - What are OTHER ways to solve this?
   - What libraries exist for this problem?
   - What approaches haven't we considered?

**Use web search for:**

```
"[library name] latest version 2025"
"[library name] [feature] best practices"
"[problem domain] approaches comparison"
"how to [specific task] [technology]"
"[library name] vs [alternative] 2025"
```

**Document what you find:**

```markdown
## External Research

**Technologies:** [List]
**Date:** YYYY-MM-DD

### [Library/Framework Name]

**Current Version:** X.Y.Z (released YYYY-MM-DD)
**Documentation:** [URL]

**Key Findings:**
- [Important discovery]

**API Details:**
- [Relevant method signatures]

**Recommendations:**
- [What to use]

**Avoid:**
- [What's deprecated or problematic]

### Alternative Approaches Considered
- [Approach 1]: [Pros/cons]
- [Approach 2]: [Pros/cons]
```

### Phase 3: Save Research

Save to: `.harness/NNN-feature-slug/research.md`

**Complete research document structure:**

```markdown
# Research: [Feature Name]

**Date:** YYYY-MM-DD
**Context:** [What task this supports]

## Codebase Exploration

[From Phase 1]

## External Research

[From Phase 2]

## Key Insights

- [Insight 1 that affects design]
- [Insight 2 that affects design]

## Questions Resolved

- [Question]: [Answer from research]

## Open Questions

- [Things that still need clarification]
```

## When Called From Other Commands

### From /superharness:create-plan

Research happens BEFORE writing any implementation details:

```
Have requirements -> Explore affected codebase areas
  -> Verify all tech versions/APIs
  -> Research implementation patterns
  -> Save research
  -> NOW write plan
```

### From /superharness:iterate

Research happens BEFORE proposing plan changes:

```
Feedback received -> Explore affected areas again
  -> Verify any new tech involved
  -> Save updated research
  -> NOW propose changes
```

## Key Principles

- **Codebase exploration is research** - Don't skip it
- **Web search is research** - Don't skip it either
- **Both are required** - Every time
- **Research before design** - Always
- **Never assume from training** - Verify everything
- **Look for creative solutions** - Not just obvious ones
- **Document findings** - So you can reference them

## After Research

Only after completing BOTH phases:
- Proceed to design proposals (in planning)
- Proceed to writing implementation details (in implementation)
- Reference research document in all downstream artifacts
