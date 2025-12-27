# Implementation Plan: Harness Plugin Enhancements

## Overview

Implement three enhancements to improve the harness plugin's predictability, robustness, and approachability:
1. Three-tier intent detection (write/read/ambiguous)
2. jq-based JSON encoding in session hook
3. Quick-start guide and example artifacts
4. Test harness for validation

## Pre-Implementation Checklist

- [x] requirements.md reviewed
- [x] codebase.md created
- [x] research.md created
- [x] design.md approved
- [x] User approval of plan

---

## Step 002-1: Restructure intent detection

**Status:** ✅ Complete

**Files to modify:**
- `skills/using-harness/SKILL.md`

**Details:**

Replace the current single-action intent table with a three-tier system:

1. **Write-intent section**: Patterns that invoke `harness:defining` immediately
   - Add, Build, Create, Implement, Fix, Debug, Refactor, Update, Change, Modify, Delete, Remove, Migrate, Optimize, Write tests for, Set up

2. **Read-intent section**: Patterns that get direct response (no workflow)
   - "What does X do?", "How does X work?"
   - Pure greetings, meta questions about harness
   - Explicit skip requests

3. **Ambiguous section**: Patterns that trigger clarification first
   - Review, Take a look at, Look at, Check, Help me understand, Explain, Explore, Can you help me with
   - Include clarification template: "Before I proceed - are you looking to **understand/analyze** this, or do you want to **make changes**?"

4. Update the flowchart to show three branches instead of two

5. Update "Red Flags" section to reflect new behavior

**Commit message:** `enhance(harness): add three-tier intent detection with clarification for ambiguous requests`

---

## Step 002-2: Replace manual escaping with jq

**Status:** ✅ Complete

**Files to modify:**
- `hooks/session-start.sh`

**Details:**

1. Add jq availability check at script start:
   ```bash
   if ! command -v jq &> /dev/null; then
       echo '{"error": "jq not installed - required for harness plugin"}' >&2
       exit 1
   fi
   ```

2. Remove the `escape_for_json()` function entirely

3. Replace JSON construction with jq:
   ```bash
   skill_content=$(cat "${PLUGIN_ROOT}/skills/using-harness/SKILL.md")

   context_prefix="<EXTREMELY_IMPORTANT>
   You have harness workflow skills.

   **Below is the full content of your 'harness:using-harness' skill:**

   "
   context_suffix="

   </EXTREMELY_IMPORTANT>"

   full_context="${context_prefix}${skill_content}${context_suffix}"

   jq -n --arg context "$full_context" '{
     hookSpecificOutput: {
       hookEventName: "SessionStart",
       additionalContext: $context
     }
   }'
   ```

4. Verify output format matches current behavior

**Commit message:** `fix(harness): use jq for robust JSON encoding in session hook`

---

## Step 002-3: Create quick-start guide

**Status:** ✅ Complete

**Files to create:**
- `QUICKSTART.md`

**Details:**

Create a concise (~50 line) introduction covering:

1. **One-line description**: What harness is
2. **Why use it**: 3 bullet points on benefits
3. **The 5 phases**: Brief table with phase → purpose
4. **Getting started**: Numbered steps (describe task, answer questions, approve plan, watch build, verify)
5. **Commands reference**: Table of slash commands
6. **Learn more**: Link to WORKFLOW.md

Target: Someone can understand harness in under 2 minutes of reading.

**Commit message:** `docs(harness): add QUICKSTART.md for rapid onboarding`

---

## Step 002-4: Add example artifacts

**Status:** ✅ Complete

**Files to create:**
- `skills/defining/examples/requirements-example.md`
- `skills/researching/examples/codebase-example.md`
- `skills/researching/examples/research-example.md`
- `skills/planning/examples/plan-example.md`

**Details:**

Create realistic but generic examples based on 001-implement-workflow:

**requirements-example.md**:
- Generic "user authentication feature" scenario
- Shows vision, functional requirements, constraints, success criteria

**codebase-example.md**:
- Shows file analysis, patterns, git history table, dependencies
- Generic web application context

**research-example.md**:
- Shows best practices, API docs summary, security considerations
- Approach comparison with recommendation

**plan-example.md**:
- Shows step format with commit messages
- 3-4 example steps, summary table, deferred items

Each example should demonstrate good practices, not just structure.

**Commit message:** `docs(harness): add example artifacts for defining, researching, and planning skills`

---

## Step 002-5: Create test harness

**Status:** ✅ Complete

**Files to create:**
- `tests/test-helpers.sh`
- `tests/test-hook.sh`
- `tests/test-intent-detection.sh`

**Details:**

**test-helpers.sh** (adapt from agent-workflow):
- `run_claude()` - Run Claude Code headlessly with timeout
- `assert_contains()` - Check output contains pattern
- `assert_not_contains()` - Check pattern absent
- `create_test_project()` / `cleanup_test_project()` - Temp directory helpers

**test-hook.sh**:
- Test 1: Verify jq check works (mock jq unavailable)
- Test 2: Execute session-start.sh, validate JSON output
- Test 3: Parse output with jq to confirm valid JSON
- Test 4: Verify additionalContext contains skill content

**test-intent-detection.sh**:
- Test 1: Write-intent prompt → verify "harness:defining" appears in response
- Test 2: Read-intent prompt → verify no "harness:defining" invocation
- Test 3: Ambiguous prompt → verify clarification question asked

Note: Intent detection tests require running actual Claude Code sessions.

**Commit message:** `test(harness): add test harness for hook and intent detection validation`

---

## Step 002-6: Run verification

**Status:** ✅ Complete

**Manual verification checklist:**

Intent Detection:
- [x] "Add a new feature" → invokes harness:defining
- [x] "What does this function do?" → responds directly
- [x] "Review this code" → asks clarification question
- [ ] Clarification answer routes correctly (to be verified in live session)

Hook:
- [x] Session starts without errors
- [x] Context is injected (skill content visible)
- [x] Works with full SKILL.md content (special chars, code blocks)

Documentation:
- [x] QUICKSTART.md is readable in < 2 minutes
- [x] Examples are clear and realistic
- [x] Links work

Tests:
- [x] `tests/test-hook.sh` passes (19/19)
- [x] `tests/test-intent-detection.sh` passes (30/30)

**Commit message:** `test(harness): verify all enhancements work correctly`

---

## Summary

| Step | Description | Files | Type |
|------|-------------|-------|------|
| 002-1 | Three-tier intent detection | 1 | enhance |
| 002-2 | jq-based JSON encoding | 1 | fix |
| 002-3 | Quick-start guide | 1 | docs |
| 002-4 | Example artifacts | 4 | docs |
| 002-5 | Test harness | 3 | test |
| 002-6 | Verification | - | verify |

**Total: 10 files across 6 steps**

---

## Deferred Items

Items identified but out of scope for this task:

- [ ] **Reduce using-harness context size** - Consider referencing vs embedding full skill (optimization, lower priority)
- [ ] **Add more skill examples** - Examples for executing and verifying skills (could add later)
- [ ] **CI integration for tests** - Automate test runs on commits (infrastructure, future work)
- [ ] **jq installation instructions** - Add troubleshooting for users without jq (could add to QUICKSTART.md later)
