---
name: verification
description: "MUST invoke before claiming work is complete, fixed, or passing."
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence != evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter != compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion != excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
OK: [Run test command] [See: 34/34 pass] "All tests pass"
BAD: "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
OK: Write -> Run (pass) -> Revert fix -> Run (MUST FAIL) -> Restore -> Run (pass)
BAD: "I've written a regression test" (without red-green verification)
```

**Build:**
```
OK: [Run build] [See: exit 0] "Build passes"
BAD: "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
OK: Re-read plan -> Create checklist -> Verify each -> Report gaps or completion
BAD: "Tests pass, phase complete"
```

**Agent delegation:**
```
OK: Agent reports success -> Check VCS diff -> Verify changes -> Report actual state
BAD: Trust agent report
```

## Why This Matters

From past failures:
- User said "I don't believe you" - trust broken
- Undefined functions shipped - would crash
- Missing requirements shipped - incomplete features
- Time wasted on false completion -> redirect -> rework
- Violates: "Honesty is a core value. If you lie, you'll be replaced."

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness

## Preserving Evidence

**What to preserve:** Test output, build logs, command output, screenshots of UI states.

**Where to save:**
- Commit messages - include key metrics (e.g., "34/34 tests pass")
- PR descriptions - summarize verification results
- `.harness/` docs - detailed logs for complex verifications

**Retention:** Keep until PR merged, minimum. Complex changes: keep longer.

**Why:** Supports "evidence over claims" - reviewers can verify your verification.

## When Verification Fails

**Immediate actions:**
1. STOP - don't push, don't commit
2. Preserve evidence (copy error output, save state)
3. Don't claim partial success

**Rollback options:**
- `git reset --soft HEAD~1` - undo commit, keep changes staged
- `git revert <sha>` - create reverting commit (safe for pushed code)
- Feature flags - disable broken feature without code rollback

**Rollback vs fix forward:**
- Rollback: broken in production, unclear cause, complex fix needed
- Fix forward: simple fix, cause is obvious, not yet deployed

**Post-failure checklist:**
- [ ] Document what failed and why
- [ ] Add systemic issues to backlog
- [ ] Update tests to catch this failure mode

## Finishing Work

After verification passes, present completion options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

### Option Handling

**Option 1: Merge Locally**
```bash
git checkout <base-branch>
git pull
git merge <feature-branch>
<run tests again>  # verify merged result
git branch -d <feature-branch>
```

**Option 2: Push and Create PR**
```bash
git push -u origin <feature-branch>
gh pr create --title "<title>" --body "## Summary
<bullets>

## Test Plan
- [ ] <verification steps>"
```

**Option 3: Keep As-Is**
Report: "Keeping branch <name>."

**Option 4: Discard**
Require typed confirmation: "Type 'discard' to confirm."
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

| Option | Merge | Push | Keep Branch |
|--------|-------|------|-------------|
| 1. Merge locally | Yes | - | Delete |
| 2. Create PR | - | Yes | Keep |
| 3. Keep as-is | - | - | Keep |
| 4. Discard | - | - | Force delete |

## The Bottom Line

**No shortcuts for verification.**

Run the command. Read the output. THEN claim the result.

This is non-negotiable.
