---
description: "Create implementation plans without thoughts directory (codebase-only research)"
argument-hint: "<path to research doc or ticket>"
---

# Create Implementation Plan (No Thoughts)

You are tasked with creating detailed implementation plans through an interactive, iterative process. This is the no-thoughts variant for projects WITHOUT a thoughts/ directory.

## Difference from Standard create-plan

This variant:
- Skips thoughts-locator and thoughts-analyzer agents
- Only spawns codebase research agents
- Does not reference or create files in thoughts/shared/
- Use this for projects that don't have a thoughts/ directory structure

## CRITICAL: Read Research First - Don't Re-explore

- If research exists, READ IT FIRST
- Do NOT re-explore the codebase if research already documents it
- Use the research as your source of truth for existing patterns
- Only spawn new research agents if gaps are discovered

## Initial Response

**If parameters provided (file path or reference):**
- Skip the default message
- Immediately read any provided files FULLY
- Begin the planning process

**If no parameters provided:**

```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task description or reference to a requirements file
2. Any relevant context, constraints, or specific requirements
3. Links to related research documents

I'll analyze this information and work with you to create a comprehensive plan.

Tip: Run /ace-workflows:research-codebase-nt first if you need to understand the codebase.
```

Wait for user input.

## Planning Process

### Step 1: Context Gathering

1. **Read all mentioned files FULLY**:
   - Research documents
   - Ticket files or requirements documents
   - Related implementation plans
   - Use the Read tool WITHOUT limit/offset parameters
   - DO NOT spawn sub-tasks before reading files yourself

2. **If no research exists, spawn initial codebase research**:
   - Use codebase-locator to find relevant files
   - Use codebase-analyzer to understand current implementation
   - Use codebase-pattern-finder to identify patterns to follow
   - NOTE: Do NOT spawn thoughts-locator or thoughts-analyzer

3. **Analyze and verify understanding**:
   - Cross-reference requirements with actual code
   - Identify discrepancies or misunderstandings
   - Note assumptions that need verification

4. **Present understanding and focused questions**:

```
Based on the research/requirements, I understand we need to [accurate summary].

I've found that:
- [Current implementation detail with file:line reference]
- [Relevant pattern or constraint discovered]
- [Potential complexity or edge case]

Questions that need clarification:
- [Specific technical question requiring human judgment]
- [Business logic clarification]
- [Design preference affecting implementation]
```

Only ask questions you genuinely cannot answer through research.

### Step 2: Design Options

After getting clarifications:

1. **If user corrects misunderstanding:**
   - DO NOT just accept the correction
   - Spawn codebase research agents to verify
   - Proceed only after verifying facts yourself

2. **Present findings and design options**:

```
Based on my research:

**Current State:**
- [Key discovery about existing code]
- [Pattern or convention to follow]

**Design Options:**
1. [Option A] - [pros/cons]
2. [Option B] - [pros/cons]

**Open Questions:**
- [Technical uncertainty]
- [Design decision needed]

Which approach aligns best with your vision?
```

### Step 3: Plan Structure

Once aligned on approach:

```
Here's my proposed plan structure:

## Overview
[1-2 sentence summary]

## Implementation Phases:
1. [Phase name] - [what it accomplishes]
2. [Phase name] - [what it accomplishes]
3. [Phase name] - [what it accomplishes]

Does this phasing make sense? Should I adjust the order or granularity?
```

Get feedback on structure BEFORE writing details.

### Step 4: Write the Plan

**Filename format:** `plans/YYYY-MM-DD-description.md` (or appropriate location for project)
- YYYY-MM-DD is today's date
- description is a brief kebab-case description
- Example: `plans/2025-01-15-improve-error-handling.md`

**Plan Template:**

```markdown
# [Feature/Task Name] Implementation Plan

## Overview
[Brief description of what we're implementing and why]

## Current State Analysis
[What exists now, what's missing, key constraints discovered]

## Desired End State
[Specification of the desired end state and how to verify it]

### Key Discoveries:
- [Important finding with file:line reference]
- [Pattern to follow]
- [Constraint to work within]

## What We're NOT Doing
[Explicitly list out-of-scope items to prevent scope creep]

## Implementation Approach
[High-level strategy and reasoning]

---

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required:

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary of changes]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `make test` or equivalent
- [ ] Type checking passes
- [ ] Linting passes

#### Manual Verification:
- [ ] Feature works as expected when tested
- [ ] No regressions in related features

**Human Gate**: After automated verification passes, pause for manual confirmation before proceeding to next phase.

---

## Phase 2: [Descriptive Name]
[Similar structure with success criteria...]

---

## Testing Strategy

### Unit Tests:
- [What to test]
- [Key edge cases]

### Integration Tests:
- [End-to-end scenarios]

### Manual Testing Steps:
1. [Specific step to verify feature]
2. [Another verification step]

## References
- Research: `[path to research document]`
- Similar implementation: `[file:line]`
```

### Step 5: Human Leverage Point - Approve Plan

Present the draft plan:

```
I've created the implementation plan at:
`plans/YYYY-MM-DD-description.md`

Please review it and confirm:
- Are the phases properly scoped?
- Are the success criteria specific enough?
- Any technical details that need adjustment?
- Missing edge cases or considerations?

Ready to iterate with /ace-workflows:iterate-plan-nt or proceed to implementation.
```

### Step 6: Interactive Refinement

Iterate based on feedback:
- Add missing phases
- Adjust technical approach
- Clarify success criteria
- Add/remove scope items

Continue refining until user approves the plan.

## Important Guidelines

1. **Be Skeptical**:
   - Question vague requirements
   - Identify potential issues early
   - Don't assume - verify with research

2. **Be Interactive**:
   - Don't write the full plan in one shot
   - Get buy-in at each major step
   - Allow course corrections

3. **Be Thorough**:
   - Read all context files COMPLETELY
   - Include specific file paths and line numbers
   - Write measurable success criteria

4. **Be Practical**:
   - Focus on incremental, testable changes
   - Consider migration and rollback
   - Think about edge cases
   - Include "what we're NOT doing"

5. **No Open Questions in Final Plan**:
   - If you encounter open questions, STOP
   - Research or ask for clarification immediately
   - Plan must be complete and actionable

## Success Criteria Format

**Always separate into two categories:**

1. **Automated Verification** (can be run by agents):
   - Commands: `make test`, `npm run lint`, etc.
   - File existence checks
   - Type checking, compilation

2. **Manual Verification** (requires human testing):
   - UI/UX functionality
   - Performance verification
   - Edge cases hard to automate

## Cross-References

- For codebase research: `/ace-workflows:research-codebase-nt`
- To update plan: `/ace-workflows:iterate-plan-nt`
- Standard version (with thoughts): `/ace-workflows:create-plan`
