#!/usr/bin/env bash
# Tests for intent detection in using-harness skill
# Run from plugin root: bash tests/test-intent-detection.sh
#
# Note: These tests verify the skill content is correct.
# Full integration tests (running Claude Code) require claude CLI.

set -euo pipefail

# Source test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

PLUGIN_ROOT="$(get_plugin_root)"
SKILL_FILE="${PLUGIN_ROOT}/skills/using-harness/SKILL.md"

# =============================================================================
# Test Suite: Skill File Structure
# =============================================================================

start_suite "Skill File Structure"

assert_file_exists "$SKILL_FILE" "Skill file exists"

skill_content=$(cat "$SKILL_FILE")

# Check frontmatter
assert_contains "$skill_content" "name: using-harness" "Has correct skill name"
assert_contains "$skill_content" "description:" "Has description"

# =============================================================================
# Test Suite: Three-Tier Intent Detection
# =============================================================================

start_suite "Three-Tier Intent Detection Structure"

# Check for all three intent categories
assert_contains "$skill_content" "### Write-Intent" "Has Write-Intent section"
assert_contains "$skill_content" "### Read-Intent" "Has Read-Intent section"
assert_contains "$skill_content" "### Ambiguous Intent" "Has Ambiguous Intent section"

# =============================================================================
# Test Suite: Write-Intent Patterns
# =============================================================================

start_suite "Write-Intent Patterns"

# These patterns should be in write-intent and invoke harness:defining
assert_contains "$skill_content" '"Add X".*harness:defining' "Add X triggers defining"
assert_contains "$skill_content" '"Fix X".*harness:defining' "Fix X triggers defining"
assert_contains "$skill_content" '"Build X".*harness:defining' "Build X triggers defining"
assert_contains "$skill_content" '"Create X".*harness:defining' "Create X triggers defining"
assert_contains "$skill_content" '"Delete X".*harness:defining' "Delete X triggers defining"
assert_contains "$skill_content" '"Refactor X".*harness:defining' "Refactor X triggers defining"

# =============================================================================
# Test Suite: Read-Intent Patterns
# =============================================================================

start_suite "Read-Intent Patterns"

# These patterns should be in read-intent and respond directly
assert_contains "$skill_content" '"What does X do?".*Respond directly' "What does X do responds directly"
assert_contains "$skill_content" '"How does X work?".*Respond directly' "How does X work responds directly"
assert_contains "$skill_content" 'Pure greetings.*Respond directly' "Greetings respond directly"
assert_contains "$skill_content" 'Meta questions.*Respond directly' "Meta questions respond directly"

# =============================================================================
# Test Suite: Ambiguous Patterns
# =============================================================================

start_suite "Ambiguous Patterns"

# These patterns should be in ambiguous section
assert_contains "$skill_content" '"Review X"' "Review X is listed"
assert_contains "$skill_content" '"Take a look at X"' "Take a look at X is listed"
assert_contains "$skill_content" '"Help me understand X"' "Help me understand X is listed"
assert_contains "$skill_content" '"Explain X"' "Explain X is listed"
assert_contains "$skill_content" '"Explore X"' "Explore X is listed"

# Check clarification template
assert_contains "$skill_content" "understand/analyze" "Clarification mentions understand/analyze"
assert_contains "$skill_content" "make changes" "Clarification mentions make changes"

# =============================================================================
# Test Suite: Decision Flow
# =============================================================================

start_suite "Decision Flow"

# Check mermaid flowchart exists with three branches
assert_contains "$skill_content" "flowchart TD" "Has mermaid flowchart"
assert_contains "$skill_content" "Clear write-intent" "Flowchart has write-intent branch"
assert_contains "$skill_content" "Clear read-intent" "Flowchart has read-intent branch"
assert_contains "$skill_content" "Ambiguous" "Flowchart has ambiguous branch"
assert_contains "$skill_content" "Ask clarifying question" "Flowchart shows clarification step"

# =============================================================================
# Test Suite: No Over-Aggressive Detection
# =============================================================================

start_suite "Intent Classification Accuracy"

# Verify Review X is NOT in write-intent (it should be ambiguous)
write_intent_section=$(sed -n '/### Write-Intent/,/### Read-Intent/p' "$SKILL_FILE")
assert_not_contains "$write_intent_section" '"Review X"' "Review X is not in write-intent"

# Verify "What does X do?" is NOT in ambiguous (it should be read-intent)
ambiguous_section=$(sed -n '/### Ambiguous Intent/,/## The Decision Flow/p' "$SKILL_FILE")
assert_not_contains "$ambiguous_section" '"What does X do?"' "What does X do is not ambiguous"

# =============================================================================
# Integration Test (requires Claude CLI)
# =============================================================================

start_suite "Integration Tests (optional)"

if command -v claude &> /dev/null; then
    echo "  Claude CLI found - running integration tests..."

    # Note: These tests actually run Claude and may take time/cost money
    # Uncomment to enable:

    # Test 1: Write-intent should invoke defining
    # output=$(run_claude "Add a new button to the header" 30)
    # assert_contains "$output" "harness:defining\|requirements\|Define" "Write-intent invokes workflow"

    # Test 2: Read-intent should respond directly
    # output=$(run_claude "What does the authentication middleware do?" 30)
    # assert_not_contains "$output" "harness:defining" "Read-intent responds directly"

    # Test 3: Ambiguous should ask clarification
    # output=$(run_claude "Review this code" 30)
    # assert_contains "$output" "understand\|analyze\|changes" "Ambiguous asks for clarification"

    echo -e "  ${YELLOW}[SKIP]${NC} Integration tests disabled (uncomment to enable)"
else
    echo -e "  ${YELLOW}[SKIP]${NC} Claude CLI not found - skipping integration tests"
fi

# =============================================================================
# Summary
# =============================================================================

print_summary
exit $?
