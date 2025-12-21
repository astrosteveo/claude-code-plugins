---
name: systematic-debugging
description: Use this skill when debugging failures, investigating errors, fixing bugs, or when multiple fix attempts have failed. Enforces root cause investigation before any fixes. Triggers on error messages, test failures, "it's not working", or repeated fix attempts.
---

# Systematic Debugging

## The Iron Law

**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST**

If you've tried 2+ fixes and they haven't worked, STOP. You're guessing, not debugging.

## The Four Phases

### Phase 1: Root Cause Investigation (MUST complete before Phase 2)

1. **Read error messages carefully** - Don't skip or skim
2. **Reproduce consistently** - Can you trigger it reliably?
3. **Check recent changes** - `git diff`, recent commits
4. **Gather evidence** - Add diagnostic logging at component boundaries
5. **Trace data flow** - Follow the data backward to find the source

**Technique: Root Cause Tracing**

Trace backward through the call stack until you find the original trigger:

```
1. Observe symptom (error at specific location)
2. Find immediate cause (what code directly causes this?)
3. Ask: What called this?
4. Keep tracing up (what value was passed?)
5. Find original trigger (where did invalid data come from?)
```

**NEVER fix just where the error appears. Trace back to find the original trigger.**

### Phase 2: Pattern Analysis (MUST complete before Phase 3)

1. **Find working examples** - Same operation that works elsewhere in codebase
2. **Compare completely** - Line by line, character by character
3. **Identify differences** - List EVERY difference, however small
4. **Understand dependencies** - What else does this code rely on?

### Phase 3: Hypothesis and Testing

1. **Form single hypothesis** - "I think X is the root cause because Y"
2. **Test minimally** - Change ONE variable at a time
3. **Verify before continuing** - Did it actually fix the issue?
4. **When you don't know: say it** - Don't pretend or guess

### Phase 4: Implementation

1. **Create failing test case** (MANDATORY before fixing)
2. **Implement single fix** - ONE change at a time
3. **Verify fix** - Run the test, confirm it passes
4. **If 3+ fixes failed: STOP** - This is NOT a hypothesis problem, it's structural

## Adding Debug Instrumentation

When tracing bugs, add logging at EVERY component boundary:

```typescript
async function processData(input: Data) {
  const stack = new Error().stack;
  console.error('DEBUG processData:', {
    input,
    inputType: typeof input,
    cwd: process.cwd(),
    nodeEnv: process.env.NODE_ENV,
    stack,
  });
  // ... proceed
}
```

- Use `console.error()` in tests (not logger - may be suppressed)
- Capture: `npm test 2>&1 | grep 'DEBUG processData'`

## Defense-in-Depth Validation

Single validation: "We fixed the bug"
Multiple layers: "We made the bug impossible"

**The Four Layers:**

1. **Entry Point** - Reject obviously invalid input at API boundary
2. **Business Logic** - Ensure data makes sense for this operation
3. **Environment Guards** - Prevent dangerous operations in specific contexts
4. **Debug Instrumentation** - Capture context for forensics

```typescript
// Layer 1: Entry point
function createProject(name: string, dir: string) {
  if (!dir?.trim()) throw new Error('Directory required');
  if (!existsSync(dir)) throw new Error('Directory must exist');
}

// Layer 2: Business logic
function initializeWorkspace(projectDir: string) {
  if (!projectDir) throw new Error('projectDir required');
}

// Layer 3: Environment guards
async function gitInit(directory: string) {
  if (process.env.NODE_ENV === 'test') {
    if (!normalized.startsWith(tmpDir)) {
      throw new Error('In test: git init only in temp dirs');
    }
  }
}

// Layer 4: Debug instrumentation
async function gitInit(directory: string) {
  logger.debug('About to git init', { directory, cwd, stack });
}
```

## Red Flags - STOP Immediately

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Skip the test, I'll manually verify"
- Proposing solutions before tracing data flow
- "One more fix attempt" (when already tried 2+)
- Each fix reveals new problem in different place

## When to Use This Skill

- Error messages or exceptions
- Test failures
- "It's not working" or "It stopped working"
- Second or third fix attempt
- Intermittent failures
- "Works on my machine" scenarios

## Constraints

- **Never propose a fix before completing Phase 1**
- **Never skip the failing test case** - Write it before fixing
- **Never make multiple changes at once** - One variable at a time
- **Never continue after 3 failed fixes** - Reassess the problem structurally
- **Always trace to root cause** - Don't fix symptoms
