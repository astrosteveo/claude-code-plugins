# Codebase Analysis: Harness Plugin Enhancements

## Relevant Files

### Intent Detection (Requirement 1)
| File | Purpose | Lines of Interest |
|------|---------|-------------------|
| `skills/using-harness/SKILL.md` | Meta-skill with intent detection rules | L14-51 (intent patterns), L52-56 (exceptions) |
| `hooks/session-start.sh` | Injects using-harness at session start | L32-42 (JSON output) |

### Hook Robustness (Requirement 2)
| File | Purpose | Lines of Interest |
|------|---------|-------------------|
| `hooks/session-start.sh` | Manual JSON escaping | L14-30 (escape_for_json function) |
| `hooks/hooks.json` | Hook configuration | L1-15 (SessionStart matcher) |
| `hooks/run-hook.cmd` | Cross-platform wrapper | Polyglot bash/batch |

### Documentation (Requirement 3)
| File | Purpose |
|------|---------|
| `WORKFLOW.md` | Master workflow documentation (251 lines) |
| `skills/*/SKILL.md` | Individual skill documentation |
| `.harness/001-implement-workflow/` | Existing example artifacts |

## Existing Patterns

### Intent Detection Pattern (using-harness/SKILL.md)

Current implementation uses a table-based pattern matching:

```markdown
| User Says | Your Response |
|-----------|---------------|
| "Let's add X" | → Invoke harness:defining |
| "Take a look at Y" | → Invoke harness:defining |
...
```

**Key observation**: ALL patterns map to `harness:defining`. There's no distinction between:
- Clear write-intent (should invoke defining)
- Clear read-intent (should respond directly)
- Ambiguous intent (should ask for clarification)

The only exceptions (L52-56):
```markdown
**The ONLY time you respond directly (no skill):**
- Pure greetings: "Hello", "Hi", "Good morning"
- Meta questions about the workflow itself: "What is harness?", "How does this work?"
- Explicit requests to skip: "Just do X without the workflow"
```

### JSON Escaping Pattern (session-start.sh)

Current approach (L14-30):
```bash
escape_for_json() {
    local input="$1"
    local output=""
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        case "$char" in
            $'\\') output+='\\' ;;
            '"') output+='\"' ;;
            $'\n') output+='\n' ;;
            $'\r') output+='\r' ;;
            $'\t') output+='\t' ;;
            *) output+="$char" ;;
        esac
    done
    printf '%s' "$output"
}
```

**Vulnerabilities identified**:
1. Character-by-character loop is slow for large files (SKILL.md is 173 lines)
2. Missing escapes: backslash not properly doubled, control characters beyond \n\r\t
3. No handling for Unicode edge cases
4. No error handling if cat fails

### Skill Documentation Pattern

Each skill follows this structure:
```markdown
---
name: {skill-name}
description: "{brief description}"
---

## When to Use
{trigger conditions}

## The Process
{numbered steps}

## Key Principles
{bulleted list}
```

### Example Artifact Pattern (001-implement-workflow)

The existing task demonstrates artifact structure:
- `requirements.md` - Vision, functional requirements, constraints, success criteria
- `codebase.md` - File analysis, patterns, dependencies
- `research.md` - Best practices, API docs, recommendations
- `design.md` - Architecture, mermaid diagrams
- `plan.md` - Granular steps with commit messages

## Git History

| File:Line | Commit | Summary |
|-----------|--------|---------|
| `skills/using-harness/SKILL.md` | `468a8ef` | Convert ASCII flowchart to mermaid |
| `skills/using-harness/SKILL.md` | `1d0f5ca` | Address peer review findings |
| `skills/using-harness/SKILL.md` | `000b73b` | Add aggressive intent detection with phrase matching |
| `skills/using-harness/SKILL.md` | `a8a63cb` | Make using-harness more aggressive at intercepting tasks |
| `hooks/session-start.sh` | `176bdf6` | Initial implementation (feat: implement 5-phase workflow) |

**Key insight**: The intent detection has been made progressively more aggressive over commits. This enhancement will introduce nuance while preserving the core discipline.

## Testing Infrastructure

### Available Test Framework
Located at: `plugins/agent-workflow/tests/claude-code/test-helpers.sh`

Key functions:
- `run_claude()` - Run Claude Code headlessly with timeout
- `assert_contains()` - Verify output contains pattern
- `assert_not_contains()` - Verify pattern absent
- `assert_count()` - Verify occurrence count
- `assert_order()` - Verify pattern ordering
- `create_test_project()` / `cleanup_test_project()` - Temp directory management

### Testing Approach for Harness
No existing tests for harness plugin. Options:
1. Adapt agent-workflow's test-helpers.sh pattern
2. Create harness-specific test scripts
3. Manual verification (current approach per plan.md Step 001-11)

## Technical Dependencies

| Dependency | Used For | Required By |
|------------|----------|-------------|
| bash | Hook scripts | session-start.sh |
| Git Bash (Windows) | Cross-platform execution | run-hook.cmd |
| jq (proposed) | JSON encoding | session-start.sh enhancement |
| Claude Code CLI | Runtime environment | All hooks and skills |
