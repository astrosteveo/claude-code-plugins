---
description: "Create detailed implementation plans through interactive research and iteration"
argument-hint: "<path to research doc or ticket>"
load-skills:
  - research-first
---

# Create Implementation Plan

You are tasked with creating detailed implementation plans through an interactive, iterative process. Work collaboratively with the user to produce high-quality technical specifications.

## CRITICAL: Read Research First - Don't Re-explore

- If research exists (from `/superharness:research`), READ IT FIRST
- Do NOT re-explore the codebase if research already documents it
- Use the research as your source of truth for existing patterns
- Only spawn new research agents if gaps are discovered

## CRITICAL: Present 3 Architecture Options

Before finalizing the plan, present 3 different approaches:
1. **Minimal** - Smallest diff, least disruption
2. **Clean** - Best architecture, may require more changes
3. **Pragmatic** - Balanced approach

Let the user choose before writing the detailed plan.

## Initial Response

**If parameters provided (file path or reference):**
- Skip the default message
- Immediately read any provided files FULLY
- Begin the planning process

**If no parameters provided:**

```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task description or reference to a research/ticket file
2. Any relevant context, constraints, or specific requirements
3. Links to related research (from /superharness:research)

I'll analyze this information and work with you to create a comprehensive plan.

Tip: Run /superharness:research first if you need to understand the codebase.
```

Wait for user input.

## Planning Process

### Step 1: Context Gathering

1. **Read all mentioned files FULLY**:
   - Research documents from `/superharness:research`
   - Ticket files or requirements documents
   - Related implementation plans
   - Use the Read tool WITHOUT limit/offset parameters
   - DO NOT spawn sub-tasks before reading files yourself

2. **If no research exists, spawn initial research**:
   - Use codebase-locator to find relevant files
   - Use codebase-analyzer to understand current implementation
   - Use codebase-pattern-finder to identify patterns to follow
   - **Use web-researcher to verify external APIs/libraries**

3. **Analyze and verify understanding**:
   - Cross-reference requirements with actual code
   - Identify discrepancies or misunderstandings
   - Note assumptions that need verification

4. **Present understanding and focused questions**:

```
Based on the research/ticket, I understand we need to [accurate summary].

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

### Step 2: Present 3 Architecture Options

After getting clarifications:

1. **If user corrects misunderstanding:**
   - DO NOT just accept the correction
   - Spawn research agents to verify the correct information
   - Proceed only after verifying facts yourself

2. **Present 3 design options with trade-offs**:

```
Based on my research, here are 3 approaches:

## Option A: Minimal (Smallest Diff)
- Changes: [List specific files]
- Pros: Low risk, quick to implement
- Cons: [Trade-offs]
- Estimated files changed: X

## Option B: Clean Architecture
- Changes: [List specific files]
- Pros: Better long-term maintainability
- Cons: More changes, higher initial effort
- Estimated files changed: Y

## Option C: Pragmatic Balance
- Changes: [List specific files]
- Pros: Good balance of quality and speed
- Cons: [Trade-offs]
- Estimated files changed: Z

**My Recommendation**: Option [X] because [reasoning]

Which approach aligns best with your vision?
```

### Step 3: Plan Structure

Once user selects approach:

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

**Location:** `.harness/NNN-feature-slug/plan.md`
- NNN matches the feature number from research
- feature-slug is a brief kebab-case description
- Example: `.harness/003-authentication/plan.md`

**Template:** Use `templates/plan-template.md`

Key sections to complete:
- Overview and architecture choice
- Current state analysis and desired end state
- What we're NOT doing (scope boundaries)
- Phase breakdown with TDD tasks
- Success criteria (automated + manual)
- Testing strategy

### Step 5: Human Leverage Point - Approve Plan

Present the draft plan:

```
I've created the implementation plan at:
`.harness/NNN-feature-slug/plan.md`

Please review it and confirm:
- Are the phases properly scoped?
- Are the success criteria specific enough?
- Any technical details that need adjustment?
- Missing edge cases or considerations?

Ready to iterate with /superharness:iterate or proceed to /superharness:implement.
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

4. **TDD in Every Phase**:
   - Each phase must have TDD tasks
   - Tests written BEFORE implementation code
   - No shortcuts on testing

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

- Before planning: `/superharness:research`
- To update plan: `/superharness:iterate`
- To execute plan: `/superharness:implement`
