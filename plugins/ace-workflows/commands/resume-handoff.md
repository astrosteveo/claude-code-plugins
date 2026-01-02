---
description: "Resume work from a handoff document with context analysis and state verification"
argument-hint: "<path to handoff document>"
---

# Resume Handoff

You are tasked with resuming work from a handoff document. Handoffs contain critical context, learnings, and next steps from previous sessions that need to be understood and continued.

## Initial Response

### If handoff path provided:

- Skip the default message
- Immediately read the handoff document FULLY
- Immediately read any plan or research documents it references
- DO NOT use sub-agents to read these critical files - read them yourself
- Begin the analysis process

### If no parameters provided:

```
I'll help you resume work from a handoff document.

Which handoff would you like to resume from? Please provide the path.

Tip: List recent handoffs with `ls -lt thoughts/shared/handoffs/ | head`

Or invoke directly: `/ace-workflows:resume-handoff thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS_description.md`
```

Wait for user input.

## Resume Process

### Step 1: Read and Analyze Handoff

1. **Read handoff document COMPLETELY**:
   - Use Read tool WITHOUT limit/offset parameters
   - Extract all sections:
     - Task(s) and their statuses
     - Critical references
     - Recent changes
     - Learnings
     - Artifacts
     - Action items and next steps
     - Other notes

2. **Read referenced critical documents**:
   - Plans mentioned in "Critical References"
   - Research documents referenced
   - Read these yourself in main context - not via sub-agents

3. **Verify current state** by spawning focused research tasks:

   ```
   Task 1 - Verify Recent Changes:
   Check that changes mentioned in the handoff still exist:
   1. Read files listed in "Recent Changes"
   2. Verify the described modifications are present
   3. Check for any newer changes since the handoff
   Use tools: Read, Grep, Bash (git commands)
   Return: Status of each change (present/modified/missing)
   ```

   ```
   Task 2 - Gather Artifact Context:
   Read artifacts mentioned in the handoff:
   1. Read documents listed in "Artifacts"
   2. Extract key requirements and decisions
   3. Note any updates since the handoff
   Use tools: Read
   Return: Summary of artifact contents
   ```

4. **Wait for ALL sub-tasks to complete**

### Step 2: Synthesize and Present Analysis

Present comprehensive analysis to the user:

```
I've analyzed the handoff from [date]. Here's the current situation:

**Original Tasks:**
- [Task 1]: [Status from handoff] -> [Current verification]
- [Task 2]: [Status from handoff] -> [Current verification]

**Key Learnings (Still Valid):**
- [Learning with file:line reference] - [Verification status]
- [Pattern discovered] - [Still applicable]

**Recent Changes Status:**
- [Change 1] - [Verified present / Missing / Modified since handoff]
- [Change 2] - [Status]

**Artifacts Reviewed:**
- [Document 1]: [Key takeaway]
- [Document 2]: [Key takeaway]

**Recommended Next Actions:**
Based on the handoff's action items and current state:
1. [Most logical next step]
2. [Second priority]
3. [Additional tasks if discovered]

**Potential Issues Identified:**
- [Any conflicts found between handoff state and current state]
- [Missing dependencies or unexpected changes]

Shall I proceed with [recommended action 1], or would you like to adjust the approach?
```

**Get confirmation before proceeding.**

### Step 3: Create Action Plan

1. **Use TodoWrite to create task list**:
   - Convert action items from handoff into todos
   - Add any new tasks discovered during analysis
   - Prioritize based on dependencies and handoff guidance

2. **Present the plan**:

```
I've created a task list based on the handoff:

[Show todo list]

Ready to begin with: [first task description]

Proceed?
```

### Step 4: Begin Implementation

1. **Start with the first approved task**
2. **Reference learnings from handoff** throughout implementation
3. **Apply patterns and approaches documented** in the handoff
4. **Update progress** as tasks are completed
5. **Consider creating a new handoff** when this session ends

## Guidelines

### Be Thorough in Analysis

- Read the entire handoff document first
- Verify ALL mentioned changes still exist
- Check for any regressions or conflicts
- Read all referenced artifacts

### Be Interactive

- Present findings before starting work
- Get buy-in on the approach
- Allow for course corrections
- Adapt based on current state vs handoff state

### Leverage Handoff Wisdom

- Pay special attention to "Learnings" section
- Apply documented patterns and approaches
- Avoid repeating mistakes mentioned
- Build on discovered solutions

### Track Continuity

- Use TodoWrite to maintain task continuity
- Reference the handoff document in commits if relevant
- Document any deviations from original plan
- Consider creating a new handoff when done

### Validate Before Acting

- Never assume handoff state matches current state
- Verify all file references still exist
- Check for breaking changes since handoff
- Confirm patterns are still valid

## Common Scenarios

### Scenario 1: Clean Continuation

- All changes from handoff are present
- No conflicts or regressions
- Clear next steps in action items
- **Action**: Proceed with recommended actions

### Scenario 2: Diverged Codebase

- Some changes missing or modified
- New related code added since handoff
- Need to reconcile differences
- **Action**: Adapt plan based on current state

### Scenario 3: Incomplete Handoff Work

- Tasks marked as "in_progress" in handoff
- Partial implementations to complete
- May need to re-understand partial work
- **Action**: Focus on completing before new work

### Scenario 4: Stale Handoff

- Significant time has passed
- Major refactoring has occurred
- Original approach may no longer apply
- **Action**: Re-evaluate strategy, possibly re-research

## Example Interaction Flow

```
User: /ace-workflows:resume-handoff thoughts/shared/handoffs/2025-01-15_14-30-22_auth-implementation.md

Agent: Let me read and analyze that handoff document...

[Reads handoff completely]
[Reads referenced plan and research]
[Spawns verification tasks]
[Waits for completion]

I've analyzed the handoff from 2025-01-15. Here's the current situation:

**Original Tasks:**
- Implement JWT validation: In Progress -> Verified, changes present in auth/handler.ts
- Add refresh token logic: Planned -> Not started

**Key Learnings (Still Valid):**
- Token expiry edge case at auth/handler.ts:67 - Still relevant
- Rate limiting pattern from middleware.ts - Still applicable

**Recommended Next Actions:**
1. Complete JWT validation (finish error handling)
2. Implement refresh token logic
3. Add integration tests

Shall I proceed with completing the JWT validation?

User: Yes, proceed

Agent: [Creates todo list and begins implementation]
```

## Cross-References

- To create handoff: `/ace-workflows:create-handoff`
- For planning: `/ace-workflows:create-plan`
- For research: `/ace-workflows:research-codebase`
