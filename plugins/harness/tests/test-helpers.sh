#!/usr/bin/env bash
# Helper functions for harness plugin tests
# Adapted from agent-workflow/tests/claude-code/test-helpers.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Get the plugin root directory
get_plugin_root() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "$(cd "${script_dir}/.." && pwd)"
}

# Run Claude Code with a prompt and capture output
# Usage: run_claude "prompt text" [timeout_seconds] [allowed_tools]
run_claude() {
    local prompt="$1"
    local timeout="${2:-60}"
    local allowed_tools="${3:-}"
    local output_file=$(mktemp)

    # Build command
    local cmd="claude -p \"$prompt\""
    if [ -n "$allowed_tools" ]; then
        cmd="$cmd --allowed-tools=$allowed_tools"
    fi

    # Run Claude in headless mode with timeout
    if timeout "$timeout" bash -c "$cmd" > "$output_file" 2>&1; then
        cat "$output_file"
        rm -f "$output_file"
        return 0
    else
        local exit_code=$?
        cat "$output_file" >&2
        rm -f "$output_file"
        return $exit_code
    fi
}

# Check if output contains a pattern
# Usage: assert_contains "output" "pattern" "test name"
assert_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    ((TESTS_RUN++))

    if echo "$output" | grep -q "$pattern"; then
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "  Expected to find: $pattern"
        echo "  In output (first 500 chars):"
        echo "$output" | head -c 500 | sed 's/^/    /'
        ((TESTS_FAILED++))
        return 1
    fi
}

# Check if output does NOT contain a pattern
# Usage: assert_not_contains "output" "pattern" "test name"
assert_not_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    ((TESTS_RUN++))

    if echo "$output" | grep -q "$pattern"; then
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "  Did not expect to find: $pattern"
        ((TESTS_FAILED++))
        return 1
    else
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        ((TESTS_PASSED++))
        return 0
    fi
}

# Check if a command succeeds
# Usage: assert_success "command" "test name"
assert_success() {
    local cmd="$1"
    local test_name="${2:-test}"

    ((TESTS_RUN++))

    if eval "$cmd" > /dev/null 2>&1; then
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "  Command failed: $cmd"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Check if a command fails
# Usage: assert_failure "command" "test name"
assert_failure() {
    local cmd="$1"
    local test_name="${2:-test}"

    ((TESTS_RUN++))

    if eval "$cmd" > /dev/null 2>&1; then
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "  Command should have failed: $cmd"
        ((TESTS_FAILED++))
        return 1
    else
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        ((TESTS_PASSED++))
        return 0
    fi
}

# Check if JSON is valid
# Usage: assert_valid_json "json_string" "test name"
assert_valid_json() {
    local json="$1"
    local test_name="${2:-JSON is valid}"

    ((TESTS_RUN++))

    if echo "$json" | jq -e . > /dev/null 2>&1; then
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "  Invalid JSON:"
        echo "$json" | head -c 200 | sed 's/^/    /'
        ((TESTS_FAILED++))
        return 1
    fi
}

# Check if file exists
# Usage: assert_file_exists "path" "test name"
assert_file_exists() {
    local path="$1"
    local test_name="${2:-File exists: $path}"

    ((TESTS_RUN++))

    if [[ -f "$path" ]]; then
        echo -e "  ${GREEN}[PASS]${NC} $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} $test_name"
        echo "  File not found: $path"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Print test summary
print_summary() {
    echo ""
    echo "========================================"
    echo "Test Summary"
    echo "========================================"
    echo -e "Total:  $TESTS_RUN"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
    echo "========================================"

    if [[ $TESTS_FAILED -gt 0 ]]; then
        return 1
    fi
    return 0
}

# Start a test suite
start_suite() {
    local suite_name="$1"
    echo ""
    echo -e "${YELLOW}Running: $suite_name${NC}"
    echo "----------------------------------------"
}

# Create a temporary test directory
create_test_dir() {
    mktemp -d
}

# Cleanup test directory
cleanup_test_dir() {
    local test_dir="$1"
    if [[ -d "$test_dir" ]]; then
        rm -rf "$test_dir"
    fi
}

# Export functions for use in test scripts
export -f get_plugin_root
export -f run_claude
export -f assert_contains
export -f assert_not_contains
export -f assert_success
export -f assert_failure
export -f assert_valid_json
export -f assert_file_exists
export -f print_summary
export -f start_suite
export -f create_test_dir
export -f cleanup_test_dir
