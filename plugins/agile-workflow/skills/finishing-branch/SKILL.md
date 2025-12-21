---
name: finishing-branch
description: Use this skill when implementation is complete and ready to merge, after all stories are done, or when asked what to do with a feature branch. Provides structured options for branch completion.
---

# Finishing a Development Branch

## Purpose

Structured process for completing work on a feature branch. Provides exactly 4 options - no variations.

## When to Use

- All stories in epic are complete
- Implementation is ready to merge
- User asks "what now?" after finishing work
- Need to clean up a development branch

## Process

### Step 1: Verify Tests Pass

**MANDATORY: Run full test suite before presenting options.**

```bash
npm test        # Node.js
pytest          # Python
go test ./...   # Go
cargo test      # Rust
```

**If tests fail: STOP. Cannot proceed.**

```
Tests are failing. Cannot complete branch.

Failures:
- [test name]: [error]

Please fix failing tests before completing the branch.
```

### Step 2: Determine Base Branch

```bash
# Find where this branch split from
git merge-base HEAD main

# Or for repos using master
git merge-base HEAD master
```

Confirm with user if unclear: "This branch split from main - is that correct?"

### Step 3: Present Exactly 4 Options

**Always present exactly these 4 options. No variations.**

```
Implementation complete. Tests passing. What would you like to do?

1. **Merge back to [base-branch] locally**
   - Merges changes into [base-branch]
   - Deletes feature branch after merge
   - Good for: Solo work, small changes

2. **Push and create a Pull Request**
   - Pushes branch to remote
   - Creates PR for review
   - Good for: Team review, CI checks

3. **Keep the branch as-is**
   - No merge or push
   - Worktree preserved
   - Good for: Not ready yet, need more work

4. **Discard this work**
   - Deletes branch and changes
   - Cannot be undone
   - Good for: Abandoned experiments

Which option? (1-4)
```

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout main

# Get latest
git pull origin main

# Merge feature
git merge feature/feature-name

# Run tests after merge
npm test

# Only delete after tests pass
git branch -d feature/feature-name
```

**If merge conflicts:** Report and help resolve, then re-run tests.

**If tests fail after merge:** Report and help fix before deleting branch.

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin feature/feature-name

# Create PR
gh pr create --title "[Title]" --body "## Summary
[Description of changes]

## Test Plan
- [How to verify]

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)"
```

Report: "PR created: [URL]"

#### Option 3: Keep As-Is

Do NOT cleanup worktree.

Report:
```
Keeping branch feature/feature-name.
Worktree preserved at: [path]

Resume work anytime by:
  cd [path]
```

#### Option 4: Discard

**Requires explicit confirmation:**

```
⚠️ This will permanently delete:
- Branch: feature/feature-name
- All uncommitted changes
- All commits not merged elsewhere

Type 'discard' to confirm:
```

Only proceed if user types exactly 'discard'.

```bash
# Switch away from branch
git checkout main

# Force delete branch
git branch -D feature/feature-name
```

### Step 5: Cleanup Worktree

**For Options 1 and 4:** Remove the worktree

```bash
git worktree remove .worktrees/feature-name
```

**For Options 2 and 3:** Keep the worktree

## Post-Completion Report

### After Merge (Option 1)
```
✅ Merged feature/feature-name into main
✅ Tests passing after merge
✅ Feature branch deleted
✅ Worktree cleaned up

Changes are now in main. Ready for next feature.
```

### After PR (Option 2)
```
✅ Pushed feature/feature-name to origin
✅ PR created: [URL]

Branch and worktree preserved for any PR feedback.
After PR merges, clean up with:
  git worktree remove .worktrees/feature-name
  git branch -d feature/feature-name
```

### After Keep (Option 3)
```
Branch feature/feature-name preserved.
Worktree at: [path]

Resume anytime.
```

### After Discard (Option 4)
```
✅ Branch feature/feature-name deleted
✅ Worktree cleaned up

Work discarded. Ready for next feature.
```

## Constraints

- **Never proceed with failing tests** - Must pass before presenting options
- **Never merge without re-running tests** - Test after merge
- **Never delete work without confirmation** - Require 'discard' for Option 4
- **Never force-push** - Not without explicit request
- **Never add extra options** - Exactly 4 options, always
- **Always determine base branch** - Don't assume main
- **Always cleanup worktree** for Options 1 and 4

## Integration Points

- Use after `implement` completes all stories
- Pairs with `git-worktrees` for full lifecycle
- Follows `spec-compliance-review` and `code-quality-review`
