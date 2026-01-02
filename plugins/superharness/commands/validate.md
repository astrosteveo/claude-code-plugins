---
name: validate
description: "Verify implementation against plan spec, run all automated verification, identify deviations"
argument-hint: "<path to plan file>"
load-skills:
  - verification
---

# Validate Plan

You are tasked with validating that an implementation plan was correctly executed, verifying all success criteria, and identifying any deviations or issues.

## CRITICAL: Evidence Before Claims

- Run ALL verification commands fresh - don't assume they pass
- Read FULL output - don't skim
- Check exit codes - 0 means success, anything else is failure
- NO "should work" or "probably passes" language
- Only claim success WITH evidence

## Initial Setup

When invoked:

1. **Determine context**:
   - If in existing conversation: Review what was implemented in this session
   - If fresh start: Need to discover what was done through git and codebase analysis

2. **Locate the plan**:
   - If plan path provided, use it
   - Otherwise, search `.harness/*/plan.md` or ask user

3. **Gather implementation evidence**:

```bash
# Check recent commits
git log --oneline -n 20
git diff HEAD~N..HEAD  # Where N covers implementation commits

# Run comprehensive checks
make check test  # or equivalent
```

## Validation Process

### Step 1: Context Discovery

If starting fresh or need more context:

1. **Read the implementation plan completely**

2. **Identify what should have changed**:
   - List all files that should be modified
   - Note all success criteria (automated and manual)
   - Identify key functionality to verify

3. **Spawn parallel research to discover implementation**:

```
Task 1 - Verify database changes:
Research if migrations were added and schema matches plan.
Return: What was implemented vs what plan specified

Task 2 - Verify code changes:
Find all modified files related to feature.
Compare actual changes to plan specifications.
Return: File-by-file comparison

Task 3 - Verify test coverage:
Check if tests were added/modified as specified.
Run test commands and capture results.
Return: Test status and any missing coverage
```

### Step 2: Systematic Validation

For each phase in the plan:

1. **Check completion status**:
   - Look for checkmarks `- [x]` in the plan
   - Check git log for `phase(N): complete` trailers
   - Verify actual code matches claimed completion

2. **Run automated verification**:
   - Execute EACH command from "Automated Verification"
   - Capture FULL output
   - Document pass/fail status with evidence
   - If failures, investigate root cause

3. **Assess manual criteria**:
   - List what needs manual testing
   - Provide clear steps for user verification

4. **Think deeply about edge cases**:
   - Were error conditions handled?
   - Are there missing validations?
   - Could implementation break existing functionality?

### Step 3: Generate Validation Report

Create comprehensive validation summary:

```markdown
## Validation Report: [Plan Name]

### Implementation Status
[x] Phase 1: [Name] - Fully implemented (phase(1): complete in git)
[x] Phase 2: [Name] - Fully implemented (phase(2): complete in git)
[!] Phase 3: [Name] - Partially implemented (see issues)

### Automated Verification Results
[x] Build passes: `make build` - exit code 0
[x] Tests pass: `make test` - 42/42 tests pass
[!] Linting issues: `make lint` - 3 warnings (see below)

### Evidence
```
$ make test
Running test suite...
42 tests passed, 0 failed
Exit code: 0

$ make lint
src/auth.ts:45 - warning: unused variable
...
```

### Code Review Findings

#### Matches Plan:
- Database migration correctly adds [table]
- API endpoints implement specified methods
- Error handling follows plan

#### Deviations from Plan:
- Used different variable names in [file:line]
- Added extra validation in [file:line] (improvement)

#### Potential Issues:
- Missing index on foreign key could impact performance
- No rollback handling in migration

### Manual Testing Required:
1. UI functionality:
   - [ ] Verify [feature] appears correctly
   - [ ] Test error states with invalid input

2. Integration:
   - [ ] Confirm works with existing [component]
   - [ ] Check performance with large datasets

### Recommendations:
- Address linting warnings before merge
- Consider adding integration test for [scenario]
- Document new API endpoints
```

### Step 4: Present Findings

```
Validation Complete

Overall Status: [PASS/PARTIAL/FAIL]

Summary:
- Phases completed: X/Y (verified via git trailers)
- Automated checks: X passed, Y failed
- Deviations found: X

Evidence:
[Show actual command output]

Key Issues:
1. [Issue 1]
2. [Issue 2]

Manual Testing Still Required:
- [ ] [Step 1]
- [ ] [Step 2]

Full report generated. Ready to discuss findings or proceed to handoff.
```

## Working with Existing Context

If you were part of the implementation:

- Review the conversation history
- Check your todo list for what was completed
- Focus validation on work done in this session
- Be honest about any shortcuts or incomplete items

## Validation Checklist

Always verify:

- [ ] All phases marked complete have `phase(N): complete` trailers
- [ ] Automated tests pass (with evidence)
- [ ] Code follows existing patterns
- [ ] No regressions introduced
- [ ] Error handling is robust
- [ ] Documentation updated if needed
- [ ] Manual test steps are clear

## Important Guidelines

1. **Show evidence** - Include actual command output
2. **Run all checks** - Don't skip verification commands
3. **Document everything** - Both successes and issues
4. **Think critically** - Question if implementation truly solves the problem
5. **Consider maintenance** - Will this be maintainable long-term?

## Cross-References

- Recommended workflow:
  1. `/superharness:implement` - Execute the implementation
  2. `/superharness:validate` - Verify correctness (this command)
  3. `/superharness:handoff` - Generate handoff document
