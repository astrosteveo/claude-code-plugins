---
name: verification-before-completion
description: Use this skill before claiming any task is complete, before committing, before saying "done", or when about to report success. Enforces evidence-first verification. Triggers on "fixed", "done", "complete", "working now", or any success claim.
---

# Verification Before Completion

## The Iron Law

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE**

Never say "done", "fixed", or "working" without running verification and showing the output.

## The Gate Function

BEFORE making any completion claim:

1. **IDENTIFY** - What command proves this claim?
2. **RUN** - Execute the FULL command (fresh, complete)
3. **READ** - Full output, check exit code, count results
4. **VERIFY** - Does output actually confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. **ONLY THEN** - Make the claim

## Common Patterns

### Tests

```
✅ Run: npm test
   Output: "47 passing, 0 failing"
   Claim: "All tests pass"

❌ "Tests should pass now"
❌ "Looks correct"
❌ "I fixed it"
```

### Bug Fixes

```
✅ REQUIRES:
   1. Test original symptom passes
   2. All other tests still pass

   Run: npm test
   Output: "48 passing (including new regression test)"
   Claim: "Bug fixed, regression test added"

❌ "Code changed, should be fixed"
❌ "Applied the fix"
```

### Regression Tests (TDD Red-Green)

```
✅ REQUIRES:
   1. Write test → Run (PASS with fix)
   2. Revert fix → Run (MUST FAIL)
   3. Restore fix → Run (PASS)

   Claim: "Regression test verified - fails without fix, passes with it"

❌ "I've written a regression test" (without red-green verification)
```

### Build/Compile

```
✅ Run: npm run build
   Output: "Build completed successfully"
   Claim: "Build passes"

❌ "Should compile now"
❌ "Fixed the type error"
```

### Linting

```
✅ Run: npm run lint
   Output: "0 errors, 0 warnings"
   Claim: "Linting passes"

❌ "Lint errors fixed"
```

## Red Flags - STOP

You're about to violate this skill if you're:

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!")
- About to commit/push/PR without running tests
- Trusting your own success report without fresh run
- Relying on partial verification ("the main test passes")
- About to say "fixed" without showing test output

## Verification Commands by Context

### JavaScript/TypeScript
```bash
npm test                    # All tests
npm test -- --grep "name"   # Specific test
npm run build               # Build
npm run lint                # Lint
npm run typecheck           # Types
```

### Python
```bash
pytest                      # All tests
pytest path/to/test.py -v   # Specific file
pytest -k "test_name"       # Specific test
mypy .                      # Type check
ruff check .                # Lint
```

### Go
```bash
go test ./...               # All tests
go test ./path/... -v       # Specific package
go build ./...              # Build
golangci-lint run           # Lint
```

### Rust
```bash
cargo test                  # All tests
cargo test test_name        # Specific test
cargo build                 # Build
cargo clippy                # Lint
```

## Claim Templates

### Successful Completion
```
Verified: [command run]
Output: [relevant output or summary]
Result: [specific claim with evidence]
```

### Partial Completion
```
Verified: [command run]
Output: [what actually happened]
Status: [X of Y complete, specific blockers]
```

### Failed Verification
```
Verified: [command run]
Output: [actual error/failure]
Issue: [what's actually wrong]
Next: [what needs to happen]
```

## Constraints

- **Never claim success without fresh verification** - Always run the command
- **Never use hedging language** - No "should", "probably", "I think"
- **Never trust previous runs** - Run verification fresh each time
- **Never skip showing output** - Include the evidence
- **Never verify partially** - Run the full suite, not just one test
- **Always include the command** - Show what was run
- **Always include the output** - Show what happened
