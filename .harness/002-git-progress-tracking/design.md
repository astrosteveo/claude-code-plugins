# Git-Based Progress Tracking Design

## Problem

The `PENDING_EXECUTION.md` marker becomes stale after each phase completes. It duplicates information already in git commit history, creating another point of failure.

## Solution

Eliminate `PENDING_EXECUTION.md` entirely. Derive progress from git commits + plan structure.

## Commit Conventions

### Phase Completion

Trailer on its own line:

```
feat(auth): implement login validation

phase(2): complete
```

**Detection pattern:** `grep -E "^phase\([0-9]+\): complete$"`

### Plan Abandonment

Explicit commit to stop prompting:

```
chore: abandon login-redesign plan

plan: abandoned
Reason: Requirements changed, no longer needed
```

**Detection pattern:** `grep -E "^plan: abandoned$"`

## Session Start Detection

```
On session start:
    ↓
Glob for .harness/*/plan.md
    ↓
For each plan.md found:
    ↓
    Check git log for "plan: abandoned" referencing this plan
    [If abandoned] → Skip this plan
    ↓
    Parse Phases count from plan header
    ↓
    Find commit that added plan.md: git log --diff-filter=A --format=%H -- <plan-path>
    ↓
    Count phase completions since: git log <sha>..HEAD --grep="^phase([0-9]+): complete$"
    ↓
    Compare: completed phases vs total phases
    ↓
[If any plan has completed < total]
    ↓
    Display: "Incomplete work found"
    Show: feature name, X of Y phases complete
    Ask: "Resume? [Yes / No / Abandon]"
    ↓
    [Yes] → Read plan, determine next phase, invoke subagent-driven-development
    [No] → Continue normal session (will prompt again next session)
    [Abandon] → Create abandon commit, continue normal session
```

**Display format:**

```
📋 **Incomplete work detected**

Feature: 001-auth-redesign
Progress: 2 of 5 phases complete
Next: Phase 3 - Session Management

Resume? [Yes / No / Abandon this plan]
```

## Checkpoint.md Role (Context Only)

**Purpose shift:** Checkpoint is no longer a marker - it's a context document for rich handoff notes.

**When to update:**
- After each phase (optional but recommended)
- When context exhaustion forces session end
- When significant decisions are made mid-execution

**Simplified format:**

```markdown
# Checkpoint

**Plan:** .harness/001-feature/plan.md
**Branch:** feature-branch

## Key Decisions
- Chose X over Y because [reason]
- Discovered gotcha: [detail]

## Notes for Next Session
- Test X is flaky, may need retry
- API endpoint changed from /v1 to /v2
```

**Removed from checkpoint:**
- `Status: in-progress` (git tells us this now)
- `Progress:` section with phase list (git tells us this)
- `Resume At:` (derived from git)

**Retained:**
- Contextual notes that git commits don't capture
- Decisions and gotchas
- Anything a future session needs to know beyond "where are we"

## Skills to Update

| Skill | Changes |
|-------|---------|
| **writing-plans** | Remove PENDING_EXECUTION.md creation from handoff. Add phase completion commit convention to task template. |
| **subagent-driven-development** | After each phase, ensure commit includes `phase(N): complete` trailer. Remove marker updates. |
| **handling-context-exhaustion** | Remove PENDING_EXECUTION.md creation. Checkpoint.md remains for context only. |
| **using-harness** | Replace marker detection with git-based detection. Add abandon flow. |
| **resuming-work** | Remove marker reading. Use git log to determine progress. |
| **executing-plans** | Add phase completion trailer to commits. |

## End-to-End Test

**Location:** `tests/git-progress-tracking/`

**Test cases:**
1. No completions → detects incomplete plan
2. Partial completion → correct count (2 of 3)
3. Full completion → no prompt
4. Abandoned plan → skipped
5. Multiple plans → reports all incomplete with correct progress

## Files to Delete/Update

**Remove all references to:**
- `PENDING_EXECUTION.md` format
- `PENDING_EXECUTION.md` creation
- Marker-based session detection

**Add documentation for:**
- Phase completion trailer convention
- Plan abandonment commit convention
