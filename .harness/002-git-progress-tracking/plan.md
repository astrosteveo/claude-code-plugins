# Git-Based Progress Tracking Implementation Plan

> **For Claude:** Execute using subagent per Phase. Each Phase is a cohesive unit.

**Goal:** Replace PENDING_EXECUTION.md marker with git-based progress detection using phase completion commit trailers.

**Architecture:** Update 6 skills to remove marker file references. Add commit trailer convention `phase(N): complete`. Session start scans git log against plan phases to detect incomplete work.

**Tech Stack:** Bash, Git, Markdown (no external dependencies)

**Research Summary:** Internal harness changes only. Reviewed all skill files containing PENDING_EXECUTION references.

**Sources:** Existing skill files in `plugins/harness/skills/`

**Phases:**
1. Phase 1: Update using-harness (2 tasks) - Replace marker detection with git-based
2. Phase 2: Update subagent-driven-development (2 tasks) - Add phase commit trailers
3. Phase 3: Update executing-plans (2 tasks) - Add phase commit trailers
4. Phase 4: Update handling-context-exhaustion (2 tasks) - Remove marker, keep checkpoint
5. Phase 5: Update resuming-work (2 tasks) - Git-based detection
6. Phase 6: Update writing-plans (2 tasks) - Remove marker from handoff
7. Phase 7: Create end-to-end test (3 tasks) - Test script and validation

---

## Phase 1: Update using-harness Skill

### Task 1.1: Replace Marker Detection with Git-Based Detection

**Files:**
- Modify: `plugins/harness/skills/using-harness/SKILL.md`

**Step 1: Find the "Session Start - Pending Execution Check" section**

Locate the section that starts with `## Session Start - Pending Execution Check`.

**Step 2: Replace the entire section with git-based detection**

Replace from `## Session Start - Pending Execution Check` through `## Marker Edge Cases` (inclusive) with:

```markdown
## Session Start - Pending Execution Check

**Before any other action**, check for incomplete work using git:

```
On session start:
    ↓
Glob for .harness/*/plan.md
    ↓
For each plan.md found:
    ↓
    Check git log for "plan: abandoned" commit for this plan
    [If abandoned] → Skip this plan
    ↓
    Parse Phases count from plan header
    ↓
    Find commit that added plan.md:
    git log --diff-filter=A --format=%H -- <plan-path>
    ↓
    Count phase completions since plan creation:
    git log <sha>..HEAD | grep -E "^phase\([0-9]+\): complete$" | wc -l
    ↓
    Compare: completed phases vs total phases
    ↓
[If any plan has completed < total]
    ↓
    Display incomplete work info
    ↓
    Ask: "Resume? [Yes / No / Abandon]"
    ↓
    [Yes] → Read plan, determine next phase, invoke subagent-driven-development
    [No] → Continue normal session (will prompt again next session)
    [Abandon] → Create abandon commit, continue normal session
    ↓
[If all plans complete or no plans]
    ↓
    Normal using-harness behavior (check for applicable skills)
```

**Display format when incomplete work found:**

```
📋 **Incomplete work detected**

Feature: [feature name from plan path]
Progress: [X] of [Y] phases complete
Next: Phase [N]: [Phase name from plan]

Resume? [Yes / No / Abandon this plan]
```

**Handling responses:**
- **Yes**: Read plan, find next incomplete phase, invoke `harness:subagent-driven-development`
- **No**: Proceed with normal session, will prompt again next session
- **Abandon**: Create commit with `plan: abandoned` trailer, continue normal session

## Git Detection Edge Cases

| Case | Handling |
|------|----------|
| Plan exists but no commits since | All phases pending, prompt to resume |
| Plan file deleted but commits exist | Ignore (no plan to parse) |
| Multiple incomplete plans | Prompt for each, user chooses which to resume |
| Commit messages don't match convention | Count only exact matches, may under-count |
| Plan modified after phases started | Use current plan phase count |

**Abandon commit format:**

```bash
git commit --allow-empty -m "chore: abandon [feature-name] plan

plan: abandoned
Reason: [user-provided or 'No longer needed']"
```
```

**Step 3: Verify the section was replaced**

Read the file and confirm:
- No references to `PENDING_EXECUTION.md`
- Git-based detection flow is present
- Abandon commit format is documented

**Step 4: Commit**

```bash
git add plugins/harness/skills/using-harness/SKILL.md
git commit -m "feat(using-harness): replace marker detection with git-based

phase(1): complete"
```

---

### Task 1.2: Update Red Flags Section

**Files:**
- Modify: `plugins/harness/skills/using-harness/SKILL.md`

**Step 1: Search for any remaining PENDING_EXECUTION references**

```bash
grep -n "PENDING_EXECUTION" plugins/harness/skills/using-harness/SKILL.md
```

If any found, update those references to use git-based language.

**Step 2: Verify no marker references remain**

```bash
grep -c "PENDING_EXECUTION\|marker" plugins/harness/skills/using-harness/SKILL.md
```

Expected: 0 (or only in historical context)

**Step 3: Commit if changes made**

```bash
git add plugins/harness/skills/using-harness/SKILL.md
git commit -m "fix(using-harness): remove remaining marker references"
```

---

## Phase 2: Update subagent-driven-development Skill

### Task 2.1: Add Phase Completion Commit Convention

**Files:**
- Modify: `plugins/harness/skills/subagent-driven-development/SKILL.md`

**Step 1: Find "The Process" section flow diagram**

Locate the process flow that ends with `Mark Phase complete in TodoWrite`.

**Step 2: Add commit trailer requirement after Phase completion**

After `Mark Phase complete in TodoWrite`, before `[If checkpoint mode]`, add:

```markdown
        ↓
    Create phase completion commit with trailer:
    git commit --allow-empty -m "feat: complete Phase N - [Phase name]

    phase(N): complete"
```

**Step 3: Update the "Per-Phase flow details" list**

Add a new item after item 5 (Quality review):

```markdown
6. **Phase commit:** Create commit with `phase(N): complete` trailer
7. **Checkpoint (if enabled):** Pause for human approval before next Phase
```

(Renumber existing item 6 to 7)

**Step 4: Commit**

```bash
git add plugins/harness/skills/subagent-driven-development/SKILL.md
git commit -m "feat(subagent-driven): add phase completion commit convention

phase(2): complete"
```

---

### Task 2.2: Add Commit Convention Documentation

**Files:**
- Modify: `plugins/harness/skills/subagent-driven-development/SKILL.md`

**Step 1: Add new section before "Red Flags"**

Add this section:

```markdown
## Commit Conventions

### Phase Completion Trailer

After each Phase completes (reviews passed), create a commit with the phase completion trailer:

```bash
git commit --allow-empty -m "feat: complete Phase N - [Phase name]

phase(N): complete"
```

**Format requirements:**
- Trailer must be on its own line
- Format: `phase(N): complete` where N is the phase number
- Can be on an existing commit or an empty commit
- Used by session start detection to track progress

### Plan Abandonment

If user chooses to abandon a plan:

```bash
git commit --allow-empty -m "chore: abandon [feature-name] plan

plan: abandoned
Reason: [explanation]"
```

This stops the session start hook from prompting about this plan.
```

**Step 2: Commit**

```bash
git add plugins/harness/skills/subagent-driven-development/SKILL.md
git commit -m "docs(subagent-driven): document commit conventions"
```

---

## Phase 3: Update executing-plans Skill

### Task 3.1: Add Phase Completion Commit to Process

**Files:**
- Modify: `plugins/harness/skills/executing-plans/SKILL.md`

**Step 1: Find "Step 2: Execute Phase" section**

Locate the numbered list under "Execute one Phase at a time".

**Step 2: Add commit trailer step**

After step 6 (`Mark Phase as completed when all Tasks done`), add:

```markdown
7. Create phase completion commit:
   ```bash
   git commit --allow-empty -m "feat: complete Phase N - [Phase name]

   phase(N): complete"
   ```
```

**Step 3: Commit**

```bash
git add plugins/harness/skills/executing-plans/SKILL.md
git commit -m "feat(executing-plans): add phase completion commit convention

phase(3): complete"
```

---

### Task 3.2: Add Commit Convention Reference

**Files:**
- Modify: `plugins/harness/skills/executing-plans/SKILL.md`

**Step 1: Add reference to commit conventions in "Remember" section**

Add to the Remember list:

```markdown
- Create `phase(N): complete` commit trailer after each Phase
```

**Step 2: Commit**

```bash
git add plugins/harness/skills/executing-plans/SKILL.md
git commit -m "docs(executing-plans): reference commit conventions"
```

---

## Phase 4: Update handling-context-exhaustion Skill

### Task 4.1: Remove Marker Creation Step

**Files:**
- Modify: `plugins/harness/skills/handling-context-exhaustion/SKILL.md`

**Step 1: Find "Step 5: Create PENDING_EXECUTION Marker" section**

Locate and delete the entire section from `### Step 5: Create PENDING_EXECUTION Marker` through the end of its content (before `### Step 6`).

**Step 2: Renumber remaining steps**

- Step 6 (Commit In-Progress Work) becomes Step 5
- Step 7 (Inform User) becomes Step 6

**Step 3: Verify deletion**

```bash
grep -n "PENDING_EXECUTION" plugins/harness/skills/handling-context-exhaustion/SKILL.md
```

Should find no matches in the process steps.

**Step 4: Commit**

```bash
git add plugins/harness/skills/handling-context-exhaustion/SKILL.md
git commit -m "feat(context-exhaustion): remove PENDING_EXECUTION marker creation

phase(4): complete"
```

---

### Task 4.2: Update User Notification and Integration

**Files:**
- Modify: `plugins/harness/skills/handling-context-exhaustion/SKILL.md`

**Step 1: Update the "Inform User" step (now Step 6)**

Replace the notification format with:

```markdown
### Step 6: Inform User

Report to user with clear next steps:

```
⚠️ **Context limit approaching. Progress saved.**

- Checkpoint: `.harness/NNN-feature/checkpoint.md`
- Progress: Phase [N] of [M] complete (tracked via git)
- Branch: [current branch]

**Start a new session to continue.**

The session start hook will detect incomplete work from git
history and prompt you to resume.
```
```

**Step 2: Update "Handoff to New Session" section**

Replace with:

```markdown
## Handoff to New Session

When context is exhausted and checkpoint is complete:

1. Tell user: "Context limit approaching. Progress saved."
2. Reference: "Checkpoint at `.harness/NNN-feature/checkpoint.md`"
3. Instruction: "Start a new session - git history tracks your progress"

The `harness:using-harness` skill's session start hook scans git for
`phase(N): complete` commits and determines where you left off.
```

**Step 3: Update "Integration with Other Skills" section**

Find the line referencing PENDING_EXECUTION.md and update:

```markdown
- **harness:using-harness** - Session start hook detects incomplete work via git history
```

**Step 4: Commit**

```bash
git add plugins/harness/skills/handling-context-exhaustion/SKILL.md
git commit -m "docs(context-exhaustion): update notifications for git-based tracking"
```

---

## Phase 5: Update resuming-work Skill

### Task 5.1: Replace Marker Check with Git-Based Detection

**Files:**
- Modify: `plugins/harness/skills/resuming-work/SKILL.md`

**Step 1: Replace "Step 1: Check for Pending Execution Marker" entirely**

Replace from `### Step 1:` through `Continue to Step 2 (manual checkpoint discovery)` with:

```markdown
### Step 1: Check Git for Incomplete Work

First, check git for incomplete plans:

```bash
# Find all plans
for plan in .harness/*/plan.md; do
  # Skip if abandoned
  if git log --grep="^plan: abandoned$" -- "$plan" | grep -q .; then
    continue
  fi

  # Count phases in plan
  total=$(grep -c "^## Phase" "$plan")

  # Find when plan was added
  plan_sha=$(git log --diff-filter=A --format=%H -- "$plan" | head -1)

  # Count completed phases since plan creation
  completed=$(git log ${plan_sha}..HEAD --format=%B | grep -c "^phase([0-9]*): complete$")

  if [ "$completed" -lt "$total" ]; then
    echo "Incomplete: $plan ($completed/$total phases)"
  fi
done
```

**If incomplete work found:**
- Report which plan(s) have incomplete work
- Show progress (X of Y phases complete)
- Ask user which to resume, or continue to Step 2 for manual exploration

**If no incomplete work:**
- Continue to Step 2 (manual checkpoint discovery)
```

**Step 2: Commit**

```bash
git add plugins/harness/skills/resuming-work/SKILL.md
git commit -m "feat(resuming-work): replace marker check with git-based detection

phase(5): complete"
```

---

### Task 5.2: Update Cleanup Section

**Files:**
- Modify: `plugins/harness/skills/resuming-work/SKILL.md`

**Step 1: Replace the Cleanup section**

Find `## Cleanup` and replace with:

```markdown
## Cleanup

When execution completes successfully:

1. Create final phase completion commit (if not already done):
   ```bash
   git commit --allow-empty -m "feat: complete Phase N - [Final phase name]

   phase(N): complete"
   ```
2. Update checkpoint to show completion (optional, for context)
3. Proceed to `harness:finishing-a-development-branch`

**Note:** No marker file to delete - progress is tracked entirely in git history.
```

**Step 2: Commit**

```bash
git add plugins/harness/skills/resuming-work/SKILL.md
git commit -m "docs(resuming-work): update cleanup for git-based tracking"
```

---

## Phase 6: Update writing-plans Skill

### Task 6.1: Remove Marker from Handoff

**Files:**
- Modify: `plugins/harness/skills/writing-plans/SKILL.md`

**Step 1: Find "Execution Handoff" section, Step 3**

Locate `**If "New Session" chosen:**` and the PENDING_EXECUTION.md marker format below it.

**Step 2: Replace "New Session" handling**

Replace from `**If "New Session" chosen:**` through `Save marker to: \`.harness/PENDING_EXECUTION.md\`` with:

```markdown
**If "New Session" chosen:**
- Display: "Plan saved. Start a new session to begin execution."
- Display: "Git will track your progress via phase completion commits."
- User starts new session, hook auto-detects incomplete work from git
```

**Step 3: Remove the PENDING_EXECUTION.md format block entirely**

Delete the markdown block showing the marker format.

**Step 4: Commit**

```bash
git add plugins/harness/skills/writing-plans/SKILL.md
git commit -m "feat(writing-plans): remove PENDING_EXECUTION marker from handoff

phase(6): complete"
```

---

### Task 6.2: Remove Split Plan Marker Reference

**Files:**
- Modify: `plugins/harness/skills/writing-plans/SKILL.md`

**Step 1: Find "Execution order" note in Plan Size Limits section**

Locate: `**Execution order:** Execute plan parts sequentially. Each part creates its own PENDING_EXECUTION marker when paused.`

**Step 2: Replace with git-based tracking note**

Replace with:

```markdown
**Execution order:** Execute plan parts sequentially. Progress is tracked via git phase completion commits.
```

**Step 3: Verify no PENDING_EXECUTION references remain**

```bash
grep -c "PENDING_EXECUTION" plugins/harness/skills/writing-plans/SKILL.md
```

Expected: 0

**Step 4: Commit**

```bash
git add plugins/harness/skills/writing-plans/SKILL.md
git commit -m "docs(writing-plans): remove remaining marker references"
```

---

## Phase 7: Create End-to-End Test

### Task 7.1: Create Test Directory and Script

**Files:**
- Create: `plugins/harness/tests/git-progress-tracking/test-git-progress-tracking.sh`

**Step 1: Create test directory**

```bash
mkdir -p plugins/harness/tests/git-progress-tracking
```

**Step 2: Create test script**

```bash
#!/bin/bash
# Test git-based progress tracking detection
# Tests the logic that session start uses to find incomplete work

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_REPO=$(mktemp -d)
PASSED=0
FAILED=0

cleanup() {
  rm -rf "$TEST_REPO"
}
trap cleanup EXIT

# Setup test repo with a plan
setup_test_repo() {
  cd "$TEST_REPO"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"

  mkdir -p .harness/001-test-feature
  cat > .harness/001-test-feature/plan.md << 'EOF'
# Test Feature Plan

**Phases:**
1. Phase 1: Setup (2 tasks)
2. Phase 2: Core (2 tasks)
3. Phase 3: Polish (2 tasks)

---

## Phase 1: Setup
### Task 1.1: First task
### Task 1.2: Second task

## Phase 2: Core
### Task 2.1: Third task
### Task 2.2: Fourth task

## Phase 3: Polish
### Task 3.1: Fifth task
### Task 3.2: Sixth task
EOF

  git add .harness/
  git commit -q -m "docs: add test plan"
}

# Count phases in a plan
count_plan_phases() {
  local plan="$1"
  grep -c "^## Phase" "$plan" 2>/dev/null || echo 0
}

# Count completed phases from git
count_completed_phases() {
  local plan="$1"
  local plan_sha=$(git log --diff-filter=A --format=%H -- "$plan" 2>/dev/null | head -1)
  if [ -z "$plan_sha" ]; then
    echo 0
    return
  fi
  git log ${plan_sha}..HEAD --format=%B 2>/dev/null | grep -c "^phase([0-9]*): complete$" || echo 0
}

# Check if plan is abandoned
is_abandoned() {
  local plan="$1"
  git log --format=%B -- "$plan" 2>/dev/null | grep -q "^plan: abandoned$"
}

# Test helper
assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="$3"
  if [ "$expected" = "$actual" ]; then
    echo "✅ PASS: $msg"
    ((PASSED++))
  else
    echo "❌ FAIL: $msg (expected: $expected, got: $actual)"
    ((FAILED++))
  fi
}

# Test 1: No completions
test_no_completions() {
  echo "Test 1: No completions detected"
  setup_test_repo

  local total=$(count_plan_phases ".harness/001-test-feature/plan.md")
  local completed=$(count_completed_phases ".harness/001-test-feature/plan.md")

  assert_eq "3" "$total" "Total phases = 3"
  assert_eq "0" "$completed" "Completed phases = 0"
}

# Test 2: Partial completion
test_partial_completion() {
  echo "Test 2: Partial completion"
  setup_test_repo

  # Complete phase 1
  git commit -q --allow-empty -m "feat: complete Phase 1

phase(1): complete"

  # Complete phase 2
  git commit -q --allow-empty -m "feat: complete Phase 2

phase(2): complete"

  local completed=$(count_completed_phases ".harness/001-test-feature/plan.md")
  assert_eq "2" "$completed" "Completed phases = 2"
}

# Test 3: Full completion
test_full_completion() {
  echo "Test 3: Full completion"
  setup_test_repo

  git commit -q --allow-empty -m "phase(1): complete"
  git commit -q --allow-empty -m "phase(2): complete"
  git commit -q --allow-empty -m "phase(3): complete"

  local total=$(count_plan_phases ".harness/001-test-feature/plan.md")
  local completed=$(count_completed_phases ".harness/001-test-feature/plan.md")

  assert_eq "$total" "$completed" "All phases complete"
}

# Test 4: Abandoned plan
test_abandoned_plan() {
  echo "Test 4: Abandoned plan"
  setup_test_repo

  git commit -q --allow-empty -m "chore: abandon test plan

plan: abandoned"

  if is_abandoned ".harness/001-test-feature/plan.md"; then
    echo "✅ PASS: Plan detected as abandoned"
    ((PASSED++))
  else
    echo "❌ FAIL: Plan should be detected as abandoned"
    ((FAILED++))
  fi
}

# Test 5: Multiple plans
test_multiple_plans() {
  echo "Test 5: Multiple plans"
  setup_test_repo

  # Add second plan
  mkdir -p .harness/002-other-feature
  cat > .harness/002-other-feature/plan.md << 'EOF'
# Other Feature

**Phases:**
1. Phase 1: Only phase (2 tasks)

---

## Phase 1: Only phase
### Task 1.1: Task
### Task 1.2: Task
EOF
  git add .harness/002-other-feature/
  git commit -q -m "docs: add second plan"

  # Complete first plan partially
  git commit -q --allow-empty -m "phase(1): complete"

  local completed1=$(count_completed_phases ".harness/001-test-feature/plan.md")
  local completed2=$(count_completed_phases ".harness/002-other-feature/plan.md")

  assert_eq "1" "$completed1" "First plan: 1 phase complete"
  assert_eq "0" "$completed2" "Second plan: 0 phases complete"
}

# Run all tests
echo "=== Git Progress Tracking Tests ==="
echo ""

test_no_completions
echo ""
test_partial_completion
echo ""
test_full_completion
echo ""
test_abandoned_plan
echo ""
test_multiple_plans

echo ""
echo "=== Results ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
```

**Step 3: Make executable**

```bash
chmod +x plugins/harness/tests/git-progress-tracking/test-git-progress-tracking.sh
```

**Step 4: Commit**

```bash
git add plugins/harness/tests/git-progress-tracking/
git commit -m "test: add git progress tracking e2e tests"
```

---

### Task 7.2: Run Tests and Verify

**Step 1: Run the test script**

```bash
./plugins/harness/tests/git-progress-tracking/test-git-progress-tracking.sh
```

**Expected output:**
```
=== Git Progress Tracking Tests ===

Test 1: No completions detected
✅ PASS: Total phases = 3
✅ PASS: Completed phases = 0

Test 2: Partial completion
✅ PASS: Completed phases = 2

Test 3: Full completion
✅ PASS: All phases complete

Test 4: Abandoned plan
✅ PASS: Plan detected as abandoned

Test 5: Multiple plans
✅ PASS: First plan: 1 phase complete
✅ PASS: Second plan: 0 phases complete

=== Results ===
Passed: 7
Failed: 0
```

**Step 2: Fix any failures**

If tests fail, debug and fix the test or the detection logic.

**Step 3: Commit test success**

```bash
git add -A
git commit -m "test: verify git progress tracking tests pass"
```

---

### Task 7.3: Version Bump and Final Cleanup

**Step 1: Check for any remaining PENDING_EXECUTION references**

```bash
grep -r "PENDING_EXECUTION" plugins/harness/skills/ --include="*.md"
```

Expected: No results

**Step 2: Update plugin version**

```bash
cat plugins/harness/.claude-plugin/plugin.json
```

If version is 0.4.x, bump to 0.5.0:

```bash
# Edit plugins/harness/.claude-plugin/plugin.json
# Change version from "0.4.x" to "0.5.0"
```

**Step 3: Final commit**

```bash
git add -A
git commit -m "chore: bump version to 0.5.0 for git-based progress tracking

phase(7): complete"
```

---

## Summary

| Phase | Tasks | Focus |
|-------|-------|-------|
| 1 | 1.1 - 1.2 | using-harness: Git-based session start detection |
| 2 | 2.1 - 2.2 | subagent-driven-development: Phase commit trailers |
| 3 | 3.1 - 3.2 | executing-plans: Phase commit trailers |
| 4 | 4.1 - 4.2 | handling-context-exhaustion: Remove marker creation |
| 5 | 5.1 - 5.2 | resuming-work: Git-based detection |
| 6 | 6.1 - 6.2 | writing-plans: Remove marker from handoff |
| 7 | 7.1 - 7.3 | End-to-end test and version bump |

**Total: 7 Phases, 15 Tasks**

**Key changes:**
- All PENDING_EXECUTION.md references removed
- Phase completion tracked via `phase(N): complete` commit trailer
- Plan abandonment tracked via `plan: abandoned` commit trailer
- Session start scans git log to detect incomplete work
- Checkpoint.md remains for context notes only
