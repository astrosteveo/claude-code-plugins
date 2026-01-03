---
description: "Resume work from a handoff document with context analysis and state verification"
argument-hint: "<path to handoff document>"
---

# Resume Handoff

You are tasked with resuming work from a handoff document. Handoffs contain critical context, learnings, and next steps from previous sessions that need to be understood and continued.

This command is the **primary interface for handoff lifecycle management**:
- No path? → Picker dialog shows available handoffs
- Work complete? → Prompts to resolve the handoff
- Creating checkpoint? → Automatically supersedes the previous handoff

## Initial Response

### If handoff path provided:

- Skip the picker dialog
- Immediately read the handoff document FULLY
- Immediately read any plan or research documents it references
- DO NOT use sub-agents to read these critical files - read them yourself
- Begin the analysis process
- Store the handoff path for later resolution

### If no parameters provided:

**Run the Handoff Picker Dialog:**

1. **Discover available handoffs**:
   ```bash
   # Find feature handoffs
   ls -t .harness/*/handoff.md 2>/dev/null

   # Find cross-feature handoffs
   ls -t .harness/handoffs/*.md 2>/dev/null | grep -v '/archive/'
   ```

2. **Filter out resolved handoffs** by checking git log:
   ```bash
   # For each handoff, check if resolved
   git log --format=%B | grep -F "handoff: <path>"
   git log --format=%B | grep -F "handoff-abandoned: <path>"
   ```

3. **Extract metadata** for each pending handoff:
   - Topic from frontmatter or H1 heading
   - Date from filename or file mtime
   - Days old calculation

4. **Present picker using AskUserQuestion**:

   If handoffs found:
   ```
   Use AskUserQuestion with:
   - question: "Which handoff would you like to resume?"
   - header: "Resume"
   - options: Array of handoffs formatted as "[Topic] (N days ago)"
   - Include "None - start fresh" as final option
   - multiSelect: false
   ```

   If no handoffs found:
   ```
   No pending handoffs found. You can:

   1. Create a new handoff: `/superharness:handoff`
   2. Check if handoffs were resolved: `git log --format=%B | grep "handoff:"`
   3. Start fresh with your current task

   What would you like to do?
   ```

5. **Handle selection**:
   - If user selects a handoff → Continue with resume process
   - If user selects "None - start fresh" → End the command gracefully
   - Store selected handoff path for later resolution

## Resume Process

### Step 1: Read and Analyze Handoff

1. **Read handoff document COMPLETELY**:
   - Use Read tool WITHOUT limit/offset parameters
   - Extract all sections:
     - Task(s) and their statuses
     - Phase progress
     - Critical references
     - Recent changes
     - Learnings
     - Artifacts
     - Action items and next steps

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
   Task 2 - Verify Phase Progress:
   Check git log for phase completion trailers:
   1. Run: git log --format=%B | grep "phase("
   2. Count completed phases
   3. Compare to handoff's claimed progress
   Return: Verified phase completion status
   ```

4. **Wait for ALL sub-tasks to complete**

### Step 2: Synthesize and Present Analysis

Present comprehensive analysis to the user:

```
I've analyzed the handoff from [date]. Here's the current situation:

**Phase Progress (Verified via Git):**
- Phase 1: Complete (phase(1): complete found in git)
- Phase 2: Complete (phase(2): complete found in git)
- Phase 3: In Progress (no completion trailer yet)

**Original Tasks:**
- [Task 1]: [Status from handoff] -> [Current verification]
- [Task 2]: [Status from handoff] -> [Current verification]

**Key Learnings (Still Valid):**
- [Learning with file:line reference] - [Verification status]
- [Pattern discovered] - [Still applicable]

**Recent Changes Status:**
- [Change 1] - [Verified present / Missing / Modified since handoff]
- [Change 2] - [Status]

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

### Step 5: Completion Flow

When work is complete or user indicates they're done, present completion options:

```
Work session ending. How would you like to handle the handoff?

Use AskUserQuestion with:
- question: "How should we handle the current handoff?"
- header: "Handoff"
- options:
  - "Complete - Work is finished, resolve handoff"
  - "Checkpoint - Create new handoff, supersede old one"
  - "Keep Open - Leave handoff pending for next session"
- multiSelect: false
```

**Handle each option:**

#### Option: Complete
1. Create resolution commit:
   ```bash
   git commit --allow-empty -m "chore: resolve handoff

   handoff: <handoff-path>
   reason: complete"
   ```
2. Optionally archive (ask user)
3. Confirm: "Handoff resolved! It will no longer appear in session warnings."

#### Option: Checkpoint (Supersede)
1. Run `/superharness:handoff` to create new handoff
2. Add `supersedes: <old-handoff-path>` to new handoff frontmatter
3. Auto-resolve old handoff:
   ```bash
   git commit --allow-empty -m "chore: resolve handoff

   handoff: <old-handoff-path>
   reason: superseded by <new-handoff-path>"
   ```
4. Confirm: "New checkpoint created. Previous handoff auto-resolved."

#### Option: Keep Open
1. No action needed
2. Confirm: "Handoff will remain pending. Run `/superharness:resume` next session."

## Supersede Logic

When creating a new handoff during an active resume session:

1. **Track the active handoff path** from picker or argument
2. **When `/superharness:handoff` is invoked**:
   - Detect we're in an active resume session
   - Add to new handoff frontmatter:
     ```yaml
     supersedes: <old-handoff-path>
     ```
3. **Auto-resolve the old handoff**:
   ```bash
   git commit --allow-empty -m "chore: resolve handoff

   handoff: <old-handoff-path>
   reason: superseded by <new-handoff-path>"
   ```
4. **Inform user**: "Previous handoff auto-resolved as superseded."

## Guidelines

### Be Thorough in Analysis

- Read the entire handoff document first
- Verify ALL mentioned changes still exist
- Check git log for phase completion trailers
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
- Prompt for resolution when work completes

### Validate Before Acting

- Never assume handoff state matches current state
- Verify all file references still exist
- Check for breaking changes since handoff
- Confirm patterns are still valid

## Common Scenarios

### Scenario 1: Clean Continuation

- All changes from handoff are present
- Phase trailers match claimed progress
- No conflicts or regressions
- Clear next steps in action items
- **Action**: Proceed with recommended actions

### Scenario 2: Diverged Codebase

- Some changes missing or modified
- New related code added since handoff
- Need to reconcile differences
- **Action**: Adapt plan based on current state

### Scenario 3: Incomplete Phase Work

- Tasks marked as "in_progress" in handoff
- Partial implementations to complete
- May need to re-understand partial work
- **Action**: Focus on completing before new work

### Scenario 4: Stale Handoff

- Significant time has passed
- Major refactoring has occurred
- Original approach may no longer apply
- **Action**: Re-evaluate strategy, possibly re-research

### Scenario 5: Multiple Pending Handoffs

- Picker shows multiple options
- User must choose which to resume
- Consider resolving old ones that are no longer relevant
- **Action**: Select most relevant, resolve/abandon others

## Cross-References

- To create handoff: `/superharness:handoff`
- To resolve handoff explicitly: `/superharness:resolve`
- For planning: `/superharness:create-plan`
- For research: `/superharness:research`
- For status overview: `/superharness:status`
