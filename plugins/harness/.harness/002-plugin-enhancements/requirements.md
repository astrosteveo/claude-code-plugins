# Requirements: Harness Plugin Enhancements

## Vision

Make the harness plugin more complete and predictable by addressing three high-priority issues identified during comprehensive review:

1. **Intent ambiguity** - The plugin currently forces all code-related requests through the full workflow, even when users just want analysis or explanation. This creates friction and feels overly aggressive.

2. **Technical fragility** - The session-start hook uses manual JSON string escaping that could break on edge cases, making the plugin unpredictable.

3. **Onboarding gaps** - New users face a wall of documentation with no quick path to understanding or examples to learn from.

Success looks like: a plugin that gracefully handles different user intents, is technically robust, and is approachable for anyone trying to use structured workflows with AI.

## Functional Requirements

### 1. Read-intent vs Write-intent Distinction

**Behavior change**: When user intent is ambiguous (could be analysis OR code changes), the plugin should ask a brief clarifying question before deciding whether to invoke the workflow.

**Patterns that should trigger clarification**:
- "Review X" - could be code review (read) or fix issues found (write)
- "Take a look at X" - could be exploration (read) or investigation for changes (write)
- "Explain how X works" - could be pure education (read) or prep for changes (write)
- "Help me understand X" - similar ambiguity

**Clarification approach**:
- Ask a brief, focused question to determine intent
- Make best judgment based on response
- If clearly read-only (just wants explanation/analysis): respond directly, no artifacts
- If clearly write-intent (wants to build/fix/change): invoke harness:defining

**Clear write-intent patterns (no clarification needed)**:
- "Add X", "Build X", "Implement X", "Create X"
- "Fix X", "Debug X", "Refactor X"
- "Update X", "Change X", "Modify X"
- "Delete X", "Remove X"

**Clear read-intent patterns (no clarification needed)**:
- "What does X do?" (pure question)
- "How does X work?" (pure question)
- Greetings, meta-questions about the workflow itself

### 2. Robust Hook JSON Escaping

**Current problem**: `session-start.sh` uses manual bash string escaping that may fail on:
- Unusual Unicode characters
- Nested quotes or backticks in skill content
- Control characters beyond the common ones

**Solution**: Use `jq` for JSON encoding.

**Requirements**:
- Replace manual escaping with `jq` -based JSON construction
- Handle the case where `jq` is not installed (graceful degradation or clear error)
- Maintain the same output format (hookEventName, additionalContext)
- Test with the actual SKILL.md content including all its markdown, code blocks, and special characters

### 3. Documentation: Quick-start Guide & Examples

**QUICKSTART.md**:
- Create at plugin root (`plugins/harness/QUICKSTART.md`)
- Target audience: anyone trying to tame AI with structured workflows
- Should explain the core concept in under 2 minutes of reading
- Cover: what harness is, the 5 phases in brief, how to start, common commands
- Link to full WORKFLOW.md for details

**Example artifacts**:
- Create `examples/` directory within relevant skills
- Provide realistic example artifacts (requirements.md, plan.md, etc.)
- Examples should demonstrate good practices, not just structure
- Can use 001-implement-workflow as inspiration but should be generic/relatable

## Constraints

- **Scope**: Only these 3 items; other review findings are deferred
- **Breaking changes**: Acceptable; will document migration path (current user base: 1)
- **Dependencies**: `jq` is an acceptable new dependency
- **Testing**: Research needed on plugin test harness options (part of research phase)

## Success Criteria

1. **Intent handling**:
   - Ambiguous requests trigger a brief clarifying question
   - Clear read-intent requests get direct responses (no workflow)
   - Clear write-intent requests invoke harness:defining
   - No false positives forcing workflow on pure analysis tasks

2. **Hook robustness**:
   - `session-start.sh` uses `jq` for JSON encoding
   - Hook works with full SKILL.md content including code blocks and special chars
   - Graceful handling if `jq` not available

3. **Documentation**:
   - QUICKSTART.md exists and is genuinely helpful (someone new can understand harness in < 2 min)
   - At least 2 skills have example artifacts in `examples/` subdirectories
   - Examples are realistic and demonstrate good practices

4. **Validation**:
   - Manual testing confirms intent detection works as expected
   - Hook tested with actual skill content
   - QUICKSTART.md reviewed for clarity
