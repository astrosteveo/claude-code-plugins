# Research: Harness Plugin Enhancements

## Best Practices

### Intent Classification in Conversational AI

For distinguishing read-intent vs write-intent:

1. **Pattern categories** (not binary triggers):
   - **Clear write-intent**: Action verbs + target ("Add X", "Fix Y", "Delete Z")
   - **Clear read-intent**: Question patterns ("What does X do?", "How does Y work?")
   - **Ambiguous**: Inspection verbs ("Review X", "Look at Y", "Check Z")

2. **Clarification best practices**:
   - Ask focused, binary questions when possible
   - Provide context for why you're asking
   - Make the options concrete ("Are you looking to understand this, or make changes?")

3. **Default behavior principle**:
   - When ambiguous, asking is safer than assuming
   - Clarification adds one exchange but prevents wrong-path recovery

### JSON Escaping with jq

From jq documentation and best practices:

```bash
# Robust JSON string encoding
echo "$content" | jq -Rs '.'

# Building JSON objects
jq -n --arg content "$content" '{"key": $content}'

# Full object construction
jq -n \
  --arg context "$skill_content" \
  '{
    hookSpecificOutput: {
      hookEventName: "SessionStart",
      additionalContext: $context
    }
  }'
```

**Key benefits**:
- Handles all Unicode correctly
- Escapes all control characters
- Handles null bytes
- Produces valid JSON guaranteed

**Fallback consideration**:
```bash
if ! command -v jq &> /dev/null; then
    echo "Warning: jq not installed, using fallback" >&2
    # Fallback to manual escaping or skip context injection
fi
```

### Quick-Start Guide Best Practices

From [technical documentation research](https://dev.to/auden/how-to-write-technical-documentation-in-2025-a-step-by-step-guide-1hh1):

1. **Get users running in 5 minutes or less**
   - Focus on immediate value, not comprehensive coverage
   - Show, don't tell

2. **Structure for scanning**:
   - What it is (1 sentence)
   - Why use it (2-3 bullets)
   - How to start (numbered steps)
   - What's next (link to deep docs)

3. **Audience segmentation** (Stripe pattern):
   - Quick-start for newcomers
   - Deep reference for experts
   - Don't force experts through beginner content

4. **Common pitfalls to avoid**:
   - Don't assume prior knowledge
   - Don't overload with jargon
   - Don't bury key information
   - Include practical examples, not just abstract concepts

5. **Progressive disclosure**:
   - Start basic, link to complexity
   - Overview page → detailed guides

### Example Artifact Best Practices

From analyzing effective documentation:

1. **Use realistic scenarios**
   - Generic but relatable ("User authentication", "API endpoint")
   - Not trivial ("Hello World") or domain-specific

2. **Show good practices in action**
   - Examples should demonstrate the principles, not just structure
   - Include the "why" comments

3. **Keep examples concise but complete**
   - Full enough to understand the pattern
   - Not so long they become reference docs themselves

## Plugin Testing Research

### Claude Code Plugin Testing Options

Based on investigation of the ecosystem:

**No official test framework exists.** Testing approaches:

1. **Integration testing** (agent-workflow pattern):
   - Run Claude Code with specific prompts
   - Capture output and session transcripts
   - Assert on patterns in output
   - Located at: `plugins/agent-workflow/tests/claude-code/test-helpers.sh`

2. **Hook testing**:
   - Execute hook scripts directly
   - Validate JSON output format
   - Check error handling paths
   - Can be done without running full Claude Code

3. **Manual verification**:
   - Current approach in harness (plan.md Step 001-11)
   - Effective but not automated

**Recommendation**: For this enhancement, focus on:
- Direct hook script testing (can validate jq output)
- Manual verification of intent detection changes
- Consider adapting test-helpers.sh pattern for future

### SessionStart Hook Behavior

From [Claude Code documentation](https://code.claude.com/docs/en/hooks):

- Triggers on: startup, resume, clear, compact
- Output format: JSON with `hookSpecificOutput`
- Known issue: First run with marketplace plugin may not execute hook (cached on subsequent runs)
- Testing: Run Claude Code, check if context appears in conversation

## Security Considerations

### JSON Injection Prevention

When building JSON from shell:
- Never interpolate raw strings into JSON templates
- Always use proper encoding (jq --arg)
- Validate/sanitize if accepting external input

Current code has potential injection vector:
```bash
# Current (vulnerable to special chars)
cat <<EOF
{"additionalContext": "${escaped_content}"}
EOF

# Better (jq handles everything)
jq -n --arg content "$content" '{"additionalContext": $content}'
```

## Performance Considerations

### Hook Execution Speed

Current escape_for_json:
- O(n) character-by-character loop
- SKILL.md is ~8KB (173 lines)
- Noticeable delay possible on slow systems

jq approach:
- Native C implementation
- Optimized for JSON operations
- Will be faster for large inputs

### Context Size

The using-harness skill content (~8KB) is injected at every session start. Consider:
- Is all content necessary?
- Could some be referenced rather than embedded?
- Trade-off: completeness vs context usage

## Implementation Recommendations

### 1. Intent Detection (using-harness/SKILL.md)

Restructure the intent detection table into three categories:

```markdown
## Intent Detection

### Clear Write-Intent (invoke harness:defining immediately)
| Pattern | Action |
|---------|--------|
| "Add/Build/Create/Implement X" | → harness:defining |
| "Fix/Debug/Refactor X" | → harness:defining |
| "Update/Change/Modify/Delete X" | → harness:defining |

### Clear Read-Intent (respond directly, no workflow)
| Pattern | Action |
|---------|--------|
| "What does X do?" | → Direct response |
| "How does X work?" | → Direct response |
| Greetings, meta-questions | → Direct response |

### Ambiguous Intent (ask clarifying question first)
| Pattern | Clarification |
|---------|---------------|
| "Review X" | "Are you looking for analysis, or to fix issues found?" |
| "Take a look at X" | "Do you want to understand this, or make changes?" |
| "Help me understand X" | "Is this for learning, or to inform upcoming changes?" |
```

### 2. Hook Robustness (session-start.sh)

Replace manual escaping with jq:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check for jq
if ! command -v jq &> /dev/null; then
    echo '{"error": "jq not installed - required for harness plugin"}' >&2
    exit 1
fi

# Read skill content
skill_content=$(cat "${PLUGIN_ROOT}/skills/using-harness/SKILL.md")

# Build context message
context_prefix="<EXTREMELY_IMPORTANT>
You have harness workflow skills.

**Below is the full content of your 'harness:using-harness' skill:**

"
context_suffix="

</EXTREMELY_IMPORTANT>"

full_context="${context_prefix}${skill_content}${context_suffix}"

# Output valid JSON using jq
jq -n --arg context "$full_context" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $context
  }
}'
```

### 3. Documentation (QUICKSTART.md)

Structure:
```markdown
# Harness Quick Start

> Tame your AI with structured workflows. Get from idea to working code without losing your way.

## What is Harness?

A 5-phase workflow that makes AI-assisted coding predictable:
**Define → Research → Plan → Execute → Verify**

## Why Use It?

- Prevents scope creep and premature coding
- Creates audit trail of decisions
- Ensures nothing gets missed

## Get Started (2 minutes)

1. Start a task: Just describe what you want to build
2. Answer questions: The AI guides you through requirements
3. Approve the plan: Review before any code is written
4. Watch it build: TDD-first implementation
5. Verify together: Tests pass + you're satisfied = done

## Commands

- `/define` - Start or clarify requirements
- `/research` - Explore codebase and options
- `/plan` - Design the implementation
- `/execute` - Build with TDD
- `/verify` - Validate everything works

## Learn More

See [WORKFLOW.md](./WORKFLOW.md) for the complete reference.
```

### 4. Example Artifacts

Create `examples/` in defining and planning skills with realistic samples based on 001-implement-workflow but genericized.
