---
description: "Verify implementation against plan spec, run all automated verification, identify deviations"
argument-hint: "<path to plan file>"
---

# Validate Plan

You are tasked with validating that an implementation plan was correctly executed, verifying all success criteria, and identifying any deviations or issues.

## Initial Setup

When invoked:

1. **Determine context**:
   - If in existing conversation: Review what was implemented in this session
   - If fresh start: Need to discover what was done through git and codebase analysis

2. **Locate the plan**:
   - If plan path provided, use it
   - Otherwise, search recent commits for plan references or ask user

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
   - Verify actual code matches claimed completion

2. **Run automated verification**:
   - Execute each command from "Automated Verification"
   - Document pass/fail status
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
[check] Phase 1: [Name] - Fully implemented
[check] Phase 2: [Name] - Fully implemented
[warning] Phase 3: [Name] - Partially implemented (see issues)

### Automated Verification Results
[check] Build passes: `make build`
[check] Tests pass: `make test`
[fail] Linting issues: `make lint` (3 warnings)

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
- Phases completed: X/Y
- Automated checks: X passed, Y failed
- Deviations found: X

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

- [ ] All phases marked complete are actually done
- [ ] Automated tests pass
- [ ] Code follows existing patterns
- [ ] No regressions introduced
- [ ] Error handling is robust
- [ ] Documentation updated if needed
- [ ] Manual test steps are clear

## Important Guidelines

1. **Be thorough but practical** - Focus on what matters
2. **Run all automated checks** - Don't skip verification commands
3. **Document everything** - Both successes and issues
4. **Think critically** - Question if implementation truly solves the problem
5. **Consider maintenance** - Will this be maintainable long-term?

## Example Workflow

```
User: /ace-workflows:validate-plan thoughts/shared/plans/2025-01-15-feature.md

Agent: [Reads plan, runs verification commands]

Running automated verification...
- make test: PASS (42 tests)
- make lint: PASS
- make typecheck: PASS

Checking Phase 1: Database Schema
- [x] Migration file exists
- [x] Schema matches specification
- [x] Foreign keys correct

Checking Phase 2: API Endpoints
- [x] Routes implemented
- [x] Handlers complete
- [warning] Missing input validation on /api/users

Validation Complete

Overall Status: PARTIAL

All automated checks pass, but found:
- Missing input validation in Phase 2

Manual Testing Required:
- [ ] Create user via UI
- [ ] Test error handling for invalid input

Recommendation: Add input validation before proceeding.
```

## Cross-References

- Recommended workflow:
  1. `/ace-workflows:implement-plan` - Execute the implementation
  2. `/ace-workflows:validate-plan` - Verify correctness (this command)
  3. `/ace-workflows:create-handoff` - Generate handoff document
