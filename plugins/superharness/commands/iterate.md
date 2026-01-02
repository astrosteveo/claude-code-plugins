---
description: "Update existing implementation plans based on user feedback with surgical edits"
argument-hint: "<path to plan file> <feedback/changes>"
load-skills:
  - research-first
---

# Iterate Implementation Plan

You are tasked with updating existing implementation plans based on user feedback. Make surgical edits that preserve good content while incorporating requested changes.

## Initial Response

**Parse input to identify:**
- Plan file path (e.g., `.harness/003-auth/plan.md`)
- Requested changes/feedback

### If NO plan file provided:

```
I'll help you iterate on an existing implementation plan.

Which plan would you like to update? Please provide the path.

Tip: List recent plans with `ls -lt .harness/*/plan.md | head`
```

Wait for user input.

### If plan file provided but NO feedback:

```
I've found the plan at [path]. What changes would you like to make?

Examples:
- "Add a phase for migration handling"
- "Update the success criteria to include performance tests"
- "Adjust the scope to exclude feature X"
- "Split Phase 2 into two separate phases"
```

Wait for user input.

### If BOTH plan file AND feedback provided:

Proceed immediately to Step 1.

## Iteration Process

### Step 1: Read and Understand Current Plan

1. **Read the existing plan COMPLETELY**:
   - Use Read tool WITHOUT limit/offset parameters
   - Understand current structure, phases, and scope
   - Note success criteria and implementation approach

2. **Parse requested changes**:
   - What does the user want to add/modify/remove?
   - Does this require codebase research?
   - What's the scope of the update?

### Step 2: Research If Needed

**Only spawn research if changes require new technical understanding.**

If user feedback requires understanding new code patterns:

1. Create a research todo list using TodoWrite

2. Spawn parallel sub-agents:
   - **codebase-locator** - Find relevant files
   - **codebase-analyzer** - Understand implementation details
   - **codebase-pattern-finder** - Find similar patterns
   - **web-researcher** - Verify external APIs if needed

3. Read any new files identified

4. Wait for ALL sub-tasks to complete

### Step 3: Present Understanding

Before making changes, confirm understanding:

```
Based on your feedback, I understand you want to:
- [Change 1 with specific detail]
- [Change 2 with specific detail]

My research found:
- [Relevant code pattern or constraint]
- [Important discovery affecting the change]

I plan to update the plan by:
1. [Specific modification]
2. [Another modification]

Does this align with your intent?
```

Get user confirmation before proceeding.

### Step 4: Update the Plan

1. **Make focused, precise edits**:
   - Use Edit tool for surgical changes
   - Maintain existing structure unless explicitly changing it
   - Keep all file:line references accurate
   - Update success criteria if needed

2. **Ensure consistency**:
   - New phases follow existing pattern
   - Scope changes update "What We're NOT Doing" section
   - Approach changes update "Implementation Approach" section
   - Maintain automated vs manual success criteria distinction

3. **Preserve quality**:
   - Include specific file paths and line numbers
   - Write measurable success criteria
   - Keep language clear and actionable
   - Ensure TDD tasks are included in new phases

### Step 5: Present Changes

```
I've updated the plan at `.harness/[path]/plan.md`

Changes made:
- [Specific change 1]
- [Specific change 2]

The updated plan now:
- [Key improvement]
- [Another improvement]

Would you like any further adjustments?
```

Be ready to iterate further based on feedback.

## Important Guidelines

### Be Surgical

- Make precise edits, not wholesale rewrites
- Preserve good content that doesn't need changing
- Only research what's necessary for specific changes
- Don't over-engineer the updates

### Be Skeptical

- Don't blindly accept change requests that seem problematic
- Question vague feedback - ask for clarification
- Verify technical feasibility with research
- Point out potential conflicts with existing phases

### Be Thorough

- Read the entire plan before making changes
- Research code patterns if needed
- Ensure updated sections maintain quality
- Verify success criteria are still measurable

### Be Interactive

- Confirm understanding before making changes
- Show what you plan to change before doing it
- Allow course corrections
- Don't disappear into research without communicating

### No Open Questions

- If changes raise questions, ASK
- Research or get clarification immediately
- Do NOT update the plan with unresolved questions
- Every change must be complete and actionable

## Cross-References

- Original plan creation: `/superharness:create-plan`
- After iteration: `/superharness:implement`
- For research: `/superharness:research`
