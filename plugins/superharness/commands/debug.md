---
description: "Systematic 4-phase debugging with root cause analysis - no random fixes"
argument-hint: "<description of issue or path to relevant file>"
load-skills:
  - systematic-debugging
  - tdd
---

# Debug

You are tasked with helping debug issues using systematic 4-phase root cause analysis. This command allows you to investigate problems methodically - no random fixes allowed.

## CRITICAL: 4-Phase Systematic Debugging

**Phase 1: Root Cause Investigation** - Gather evidence first
**Phase 2: Pattern Analysis** - Compare working vs broken
**Phase 3: Hypothesis Testing** - One change at a time
**Phase 4: Implementation** - TDD for regression test

**NO FIXES until you complete Phases 1-3. Find the root cause FIRST.**

## Purpose

Debug is for SYSTEMATIC investigation, not random fixes. Use it to:
- Understand what's actually happening in the system
- Find the TRUE root cause of failures
- Form and test hypotheses methodically
- Generate actionable debug reports with TDD fix approach

## Initial Response

### If context provided (file path, error message, or description):

```
I'll help debug the issue with [context] using systematic 4-phase analysis.

Before I investigate, what specific problem are you encountering?
- What were you trying to do?
- What went wrong?
- Any error messages?

I'll find the root cause FIRST, then propose a TDD fix approach.
```

### If no parameters provided:

```
I'll help debug your current issue using systematic 4-phase analysis.

Please describe what's going wrong:
- What are you working on?
- What specific problem occurred?
- When did it last work?

Remember: We find root cause FIRST. No random fixes.
```

Wait for user input.

## Debug Process

### Phase 1: Root Cause Investigation

**Goal**: Gather evidence. Do NOT propose fixes yet.

1. **Read any provided context** (plan, ticket, error file):
   - Understand what they're implementing/testing
   - Note which phase or step they're on
   - Identify expected vs actual behavior

2. **Spawn parallel investigation tasks**:

```
Task 1 - Check Recent Logs:
Find and analyze logs for errors:
1. Find relevant log files
2. Search for errors, warnings around problem timeframe
3. Look for stack traces or repeated errors
4. Note timestamps and error patterns
Return: Key errors/warnings with timestamps

Task 2 - Application/Database State:
Check relevant application state:
1. Examine configuration files
2. Check database state if applicable
3. Look for stuck states, stale data, anomalies
Return: Relevant state findings

Task 3 - Git and File State:
Understand what changed recently:
1. Check git status and current branch
2. Look at recent commits: git log --oneline -10
3. Check uncommitted changes: git diff
4. Check if changes correlate with issue timing
Return: Git state and any file issues

Task 4 - Code Investigation:
Examine the code around the issue:
1. Read files involved in the error
2. Trace the call path if possible
3. Look for recent changes to these files
Return: Code findings and potential issues
```

3. **Wait for ALL tasks** - Don't jump to conclusions

4. **Document evidence**:
   - What errors did you find?
   - What was the state when it failed?
   - What changed recently?

### Phase 2: Pattern Analysis

**Goal**: Compare working behavior to broken behavior.

1. **Find working examples**:
   - Use codebase-pattern-finder to locate similar code that WORKS
   - Find previous implementations of the same pattern

2. **Compare working vs broken**:
   - What's different between working and broken code?
   - What conditions exist in working case but not broken?
   - What recent changes affected this area?

3. **Document patterns**:
   - "Working code does X, broken code does Y"
   - "This pattern expects Z, but we're providing W"

### Phase 3: Hypothesis Testing

**Goal**: Form and test a SINGLE hypothesis.

1. **Form ONE specific hypothesis**:
   - "The failure occurs because [specific cause]"
   - "If I'm right, then [testable prediction]"

2. **Test MINIMALLY**:
   - Add ONE diagnostic
   - Make ONE small change
   - Check ONE condition

3. **Evaluate results**:
   - Did it confirm or refute the hypothesis?
   - If refuted, go back to Phase 1 with new information

**3 FAILED FIXES = STOP**

If you've tried 3 fixes and none worked:
- The problem is architectural, not a bug
- Present findings to user
- Ask for guidance on approach

### Phase 4: Implementation (TDD Required)

**Goal**: Fix with a regression test.

1. **Write failing test FIRST**:
   - Test should reproduce the bug
   - Run test, verify it fails
   - This proves you understand the problem

2. **Implement the fix**:
   - Make the MINIMAL change to fix
   - Run test, verify it passes

3. **Verify no regressions**:
   - Run full test suite
   - Check related functionality

## Debug Report Format

```markdown
## Debug Report

### Issue Summary
[Clear statement of the issue based on user description and evidence]

### Phase 1: Root Cause Investigation

**From Logs:**
- [Error/warning with timestamp]
- [Pattern or repeated issue]

**From Application State:**
- [Relevant state finding]
- [Configuration issue if any]

**From Git/Files:**
- [Recent changes related to issue]
- [Uncommitted changes]

**From Code Investigation:**
- [Relevant code finding at file:line]
- [Potential bug location]

### Phase 2: Pattern Analysis

**Working Example Found:**
- `path/to/working.ts:45` - [How it works correctly]

**Comparison:**
- Working code: [description]
- Broken code: [description]
- Key difference: [what changed]

### Phase 3: Root Cause

**Hypothesis**: [Specific cause statement]

**Evidence**: [Why we believe this]

**Confidence Level**: [High/Medium/Low]

### Phase 4: Recommended Fix (TDD)

**Step 1 - Write Failing Test:**
```typescript
// Test that reproduces the bug
test('should handle [case] correctly', () => {
  // Arrange
  // Act
  // Assert - this will fail before fix
});
```

**Step 2 - Implement Fix:**
File: `path/to/file.ts:line`
Change: [Description of minimal fix]

**Step 3 - Verify:**
```bash
npm test  # All tests should pass
```

### Alternative Hypotheses (if root cause uncertain)
- [Other possible cause]
- [Additional investigation needed]
```

## Red Flags (You're Skipping the Process)

| Thought | Reality |
|---------|---------|
| "Let me try this fix" | NO. Complete Phases 1-3 first. |
| "I think I know what's wrong" | Prove it with evidence. |
| "Quick fix should work" | Quick fixes hide bugs. Find root cause. |
| "Just restart the service" | That's not debugging, that's hoping. |
| "It worked before" | What changed? Investigate. |

## Cross-References

- After debugging: `/superharness:create-plan` to plan the fix
- To document findings: `/superharness:handoff`
- For codebase understanding: `/superharness:research`
