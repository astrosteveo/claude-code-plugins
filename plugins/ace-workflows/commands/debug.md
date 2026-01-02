---
description: "Investigate issues by examining logs, state, and git history with parallel investigation tasks"
argument-hint: "<description of issue or path to relevant file>"
---

# Debug

You are tasked with helping debug issues during implementation or manual testing. This command allows you to investigate problems by examining logs, application state, and git history without editing files.

## Purpose

Debug is for investigation, not modification. Use it to:
- Understand what's happening in the system
- Find root causes of failures
- Examine state and logs
- Generate actionable debug reports

Think of this as bootstrapping a debugging session without consuming the primary window's context with exploratory work.

## Initial Response

### If context provided (file path, error message, or description):

```
I'll help debug the issue with [context]. Let me understand the current state.

What specific problem are you encountering?
- What were you trying to do?
- What went wrong?
- Any error messages?

I'll investigate logs, state, and git history to help identify the issue.
```

### If no parameters provided:

```
I'll help debug your current issue.

Please describe what's going wrong:
- What are you working on?
- What specific problem occurred?
- When did it last work?

I can investigate logs, application state, and recent changes to help identify the issue.
```

Wait for user input.

## Debug Process

### Step 1: Understand the Problem

1. **Read any provided context** (plan, ticket, error file):
   - Understand what they're implementing/testing
   - Note which phase or step they're on
   - Identify expected vs actual behavior

2. **Quick state check**:
   - Current git branch and recent commits
   - Any uncommitted changes
   - When the issue started occurring

### Step 2: Spawn Parallel Investigation Tasks

Launch multiple investigation tasks concurrently:

```
Task 1 - Check Recent Logs:
Find and analyze logs for errors:
1. Find relevant log files in common locations:
   - Application logs
   - Error logs
   - Debug output
2. Search for errors, warnings, or issues around the problem timeframe
3. Look for stack traces or repeated errors
4. Note timestamps and error patterns
Use tools: Bash, Read, Grep
Return: Key errors/warnings with timestamps and context
```

```
Task 2 - Application/Database State:
Check relevant application state:
1. Examine configuration files
2. Check database state if applicable (e.g., sqlite3 queries)
3. Look for stuck states, stale data, or anomalies
4. Check environment variables if relevant
Use tools: Bash, Read
Return: Relevant state findings
```

```
Task 3 - Git and File State:
Understand what changed recently:
1. Check git status and current branch
2. Look at recent commits: git log --oneline -10
3. Check uncommitted changes: git diff
4. Verify expected files exist
5. Look for file permission issues
6. Check if changes correlate with issue timing
Use tools: Bash
Return: Git state and any file issues
```

```
Task 4 - Code Investigation (if relevant area known):
Examine the code around the issue:
1. Read the files involved in the error
2. Trace the call path if possible
3. Look for recent changes to these files
4. Check for obvious issues (typos, logic errors)
Use tools: Read, Grep
Return: Code findings and potential issues
```

### Step 3: Synthesize and Present Debug Report

Based on investigation, present a focused debug report:

```markdown
## Debug Report

### Issue Summary
[Clear statement of the issue based on user description and evidence]

### Evidence Found

**From Logs:**
- [Error/warning with timestamp]
- [Pattern or repeated issue]
- [Relevant stack trace snippet]

**From Application State:**
- [Relevant state finding]
- [Configuration issue if any]

**From Git/Files:**
- [Recent changes that might be related]
- [File state issues]
- [Uncommitted changes that could affect behavior]

**From Code Investigation:**
- [Relevant code finding]
- [Potential bug location]

### Root Cause Analysis
[Most likely explanation based on evidence]

**Confidence Level**: [High/Medium/Low]

**Alternative Hypotheses**:
- [Other possible causes if root cause is uncertain]

### Recommended Actions

1. **Try This First**:
   ```bash
   [Specific command or action]
   ```

2. **If That Doesn't Work**:
   - [Alternative approach]
   - [Another debugging step]

3. **To Verify Fix**:
   ```bash
   [Command to confirm issue is resolved]
   ```

### Additional Investigation Needed
[If issue couldn't be fully diagnosed:]
- [What additional information would help]
- [What the user should check manually]
- [Areas outside automated investigation reach]

Would you like me to investigate any specific area further?
```

### Step 4: Interactive Follow-up

Be ready to:
- Investigate specific areas deeper
- Run additional diagnostic commands
- Read more files based on findings
- Refine the root cause hypothesis

## Investigation Techniques

### Log Analysis

```bash
# Find recent logs
find . -name "*.log" -mmin -60 2>/dev/null

# Search for errors
grep -r "error\|Error\|ERROR" --include="*.log" .

# Tail recent activity
tail -100 path/to/log.file
```

### Git Investigation

```bash
# What changed recently
git log --oneline -10
git diff HEAD~5..HEAD --stat

# Who changed what file
git log --oneline -5 -- path/to/file.ts

# Find when something was introduced
git log -S "problematic_code" --oneline
```

### Process/Service Status

```bash
# Check if processes are running
ps aux | grep [process_name]

# Check ports in use
lsof -i :PORT
netstat -tlnp | grep PORT
```

### File System Checks

```bash
# Check permissions
ls -la path/to/file

# Check disk space
df -h

# Find large/recent files
find . -size +10M -mmin -60
```

## Important Guidelines

### Focus on Investigation

- This is for debugging, not fixing
- Do NOT edit files during debug
- Gather evidence, form hypotheses
- Present findings for user decision

### Be Systematic

- Start with broad investigation
- Narrow down based on evidence
- Don't jump to conclusions
- Document what was checked

### Consider Context

- What phase of implementation is the user in?
- Did it work before? What changed?
- Is this a new feature or regression?
- Environment-specific or reproducible?

### Guide When Limited

Some things are outside automated reach:
- Browser console errors
- UI visual issues
- Real-time service behavior
- External API responses

Guide the user to check these manually.

## Example Interaction Flow

```
User: /ace-workflows:debug The API is returning 500 errors after the last commit

Agent: I'll help debug the 500 errors. Let me investigate...

[Spawns parallel investigation tasks]
[Waits for completion]

## Debug Report

### Issue Summary
API returning 500 Internal Server Error after commit abc1234

### Evidence Found

**From Logs:**
- `[14:32:15] TypeError: Cannot read property 'id' of undefined at handlers/user.ts:45`
- Error started appearing after 14:30:00

**From Git:**
- Commit abc1234 modified handlers/user.ts
- Changed line 43-47 in the user lookup logic

**From Code:**
- Line 45 accesses `user.id` but user could be null if not found
- Previous code had null check, new code removed it

### Root Cause Analysis
The recent commit removed a null check on user lookup, causing TypeError when user not found.

**Confidence Level**: High

### Recommended Actions

1. **Quick Fix**:
   Add null check at handlers/user.ts:45:
   ```typescript
   if (!user) return res.status(404).json({ error: 'User not found' });
   ```

2. **Verify Fix**:
   ```bash
   curl -X GET http://localhost:3000/api/user/nonexistent
   # Should return 404, not 500
   ```

Would you like me to investigate further?
```

## Cross-References

- After debugging: `/ace-workflows:create-plan` to plan the fix
- To document findings: `/ace-workflows:create-handoff`
- For codebase understanding: `/ace-workflows:research-codebase`
