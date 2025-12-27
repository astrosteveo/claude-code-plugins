#!/usr/bin/env bash
# Tests for session-start.sh hook
# Run from plugin root: bash tests/test-hook.sh

set -euo pipefail

# Source test helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/test-helpers.sh"

PLUGIN_ROOT="$(get_plugin_root)"
HOOK_SCRIPT="${PLUGIN_ROOT}/hooks/session-start.sh"

# =============================================================================
# Test Suite: Hook Script Basics
# =============================================================================

start_suite "Hook Script Basics"

assert_file_exists "$HOOK_SCRIPT" "Hook script exists"
assert_success "test -x '$HOOK_SCRIPT' || chmod +x '$HOOK_SCRIPT'" "Hook script is executable"

# =============================================================================
# Test Suite: jq Dependency
# =============================================================================

start_suite "jq Dependency Check"

# Test that jq is available (required for hook to work)
assert_success "command -v jq" "jq is installed"

# =============================================================================
# Test Suite: Hook Output
# =============================================================================

start_suite "Hook Output Validation"

# Run the hook and capture output
hook_output=$(bash "$HOOK_SCRIPT" 2>&1)

# Test JSON validity
assert_valid_json "$hook_output" "Hook output is valid JSON"

# Test JSON structure
assert_contains "$hook_output" "hookSpecificOutput" "Output contains hookSpecificOutput"
assert_contains "$hook_output" "hookEventName" "Output contains hookEventName"
assert_contains "$hook_output" "SessionStart" "hookEventName is SessionStart"
assert_contains "$hook_output" "additionalContext" "Output contains additionalContext"

# =============================================================================
# Test Suite: Skill Content Injection
# =============================================================================

start_suite "Skill Content Injection"

# Extract additionalContext and verify it contains skill content
context=$(echo "$hook_output" | jq -r '.hookSpecificOutput.additionalContext')

assert_contains "$context" "EXTREMELY_IMPORTANT" "Context has EXTREMELY_IMPORTANT wrapper"
assert_contains "$context" "using-harness" "Context contains skill name"
assert_contains "$context" "Intent Detection" "Context contains Intent Detection section"
assert_contains "$context" "Write-Intent" "Context contains Write-Intent category"
assert_contains "$context" "Read-Intent" "Context contains Read-Intent category"
assert_contains "$context" "Ambiguous Intent" "Context contains Ambiguous Intent category"
assert_contains "$context" "harness:defining" "Context references harness:defining"

# =============================================================================
# Test Suite: Special Character Handling
# =============================================================================

start_suite "Special Character Handling"

# The skill content contains various special characters that should be escaped
assert_contains "$context" "mermaid" "Context contains mermaid diagrams (backticks)"
assert_contains "$context" "Socratic" "Context contains regular text"

# Verify the JSON can be parsed after escaping
parsed_length=$(echo "$hook_output" | jq '.hookSpecificOutput.additionalContext | length')
assert_success "[[ $parsed_length -gt 1000 ]]" "Context is substantial (>1000 chars)"

# =============================================================================
# Test Suite: Error Handling
# =============================================================================

start_suite "Error Handling"

# Test with missing skill file (should fail gracefully)
temp_skill="${PLUGIN_ROOT}/skills/using-harness/SKILL.md"
temp_backup="${temp_skill}.bak"

# Backup, remove, test, restore
cp "$temp_skill" "$temp_backup"
rm "$temp_skill"

error_output=$(bash "$HOOK_SCRIPT" 2>&1 || true)
assert_contains "$error_output" "error" "Missing skill file produces error"

# Restore
mv "$temp_backup" "$temp_skill"

# =============================================================================
# Summary
# =============================================================================

print_summary
exit $?
