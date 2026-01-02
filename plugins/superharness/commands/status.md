---
name: status
description: "Show current work status, phase progress, and recommendations"
---

# Status

You are tasked with providing a comprehensive status overview of current work, including phase progress, backlog items, and recommendations for what to work on next.

## Process

### Step 1: Gather Status Information

Run these checks in parallel:

```
Task 1 - Find Active Plans:
Search for plan files in .harness/
1. List all .harness/*/plan.md files
2. Check each for completion status (checkboxes)
3. Identify in-progress phases
Return: List of plans with completion percentage

Task 2 - Check Git Progress:
Analyze git log for phase completions:
1. Run: git log --format=%B | grep "phase("
2. Find most recent phase completion
3. Check for uncommitted changes
Return: Phase progress and git state

Task 3 - Read Backlog:
Check .harness/BACKLOG.md for priority items:
1. Count items by type and priority
2. Extract Critical/High priority items
3. Identify quick wins
Return: Backlog summary

Task 4 - Find Recent Handoffs:
Check for pending handoffs:
1. List .harness/*/handoff.md files
2. List .harness/handoffs/*.md files
3. Check dates (< 7 days = pending)
Return: Recent handoffs
```

### Step 2: Sync Validation

**Check checkbox ↔ git trailer sync:**

1. Count checked phases in plan files (`- [x] Phase N`)
2. Count `phase(N): complete` trailers in git log
3. If mismatch, flag it:

```
⚠️ SYNC WARNING: Plan checkboxes don't match git trailers
- Plan shows: 3 phases complete
- Git shows: 2 phase trailers

The plan.md checkboxes may be out of sync. Consider:
- Updating plan checkboxes to match git
- Or committing missing phase trailers
```

### Step 3: Present Status

```
# SUPERHARNESS Status

## Active Work

### Current Plan: .harness/003-auth/plan.md
**Progress**: Phase 2 of 4 (50%)
- [x] Phase 1: Database Schema (phase(1): complete ✓)
- [x] Phase 2: API Endpoints (phase(2): complete ✓)
- [ ] Phase 3: Frontend Integration
- [ ] Phase 4: Testing & Documentation

**Next Action**: Continue with Phase 3 - Frontend Integration
**Command**: `/superharness:implement .harness/003-auth/plan.md`

### Sync Status: ✓ OK
Checkboxes and git trailers are in sync.

---

## Backlog Summary

| Type | Critical | High | Medium | Low |
|------|----------|------|--------|-----|
| Bugs | 1 | 2 | 0 | 0 |
| Features | 0 | 1 | 3 | 2 |
| Tech Debt | 0 | 0 | 2 | 1 |

**Priority Items:**
- [BUG-001] [Critical] Race condition in session handling
- [BUG-002] [High] Missing input validation on /api/users

**View full backlog**: `/superharness:backlog`

---

## Recent Handoffs

- `.harness/002-payment/handoff.md` (2 days ago)
  → Resume: `/superharness:resume .harness/002-payment/handoff.md`

---

## Recommendations

Based on current state, here's what I suggest:

1. **Continue Active Work**
   `/superharness:implement .harness/003-auth/plan.md`
   Phase 3 is ready to start.

2. **Address Critical Bug**
   `/superharness:debug` for BUG-001 (race condition)
   This is blocking and should be prioritized.

3. **Resume Previous Work**
   `/superharness:resume .harness/002-payment/handoff.md`
   Payment feature was paused 2 days ago.

---

ARE YOU HARNESSING THE FULL POWER OF CLAUDE CODE?
```

### Step 4: Handle Follow-up

Be ready to:
- Provide more detail on any section
- Start recommended actions
- Update backlog items
- Fix sync issues between checkboxes and git

## Status Checks

### Healthy State
- Active plan with clear next phase
- Checkboxes match git trailers
- No critical backlog items
- No stale handoffs

### Warning State
- Checkbox/git sync mismatch
- Critical bugs in backlog
- Handoffs older than 7 days
- Multiple in-progress plans

### Action Required
- No active plans (start with `/superharness:research`)
- Critical bugs blocking work
- Context approaching limits (create handoff)

## Cross-References

- Continue work: `/superharness:implement`
- View backlog: `/superharness:backlog`
- Resume handoff: `/superharness:resume`
- Start new work: `/superharness:research`
