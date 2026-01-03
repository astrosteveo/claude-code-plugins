#!/usr/bin/env bash
# Test script for session-start.sh handoff lifecycle behavior
# Tests: resolved handoffs, archived handoffs, active handoffs

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORIGINAL_DIR=$(pwd)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0

# Array to track temp dirs for cleanup
TEMP_DIRS=()

final_cleanup() {
    cd "$ORIGINAL_DIR"
    for dir in "${TEMP_DIRS[@]}"; do
        rm -rf "$dir" 2>/dev/null || true
    done
}
trap final_cleanup EXIT

log_pass() {
    echo -e "${GREEN}PASS${NC}: $1"
    ((TESTS_PASSED++)) || true
}

log_fail() {
    echo -e "${RED}FAIL${NC}: $1"
    ((TESTS_FAILED++)) || true
}

setup_test_repo() {
    local test_dir
    test_dir=$(mktemp -d)
    TEMP_DIRS+=("$test_dir")
    cd "$test_dir"

    git init -q
    git config user.email "test@test.com"
    git config user.name "Test"

    # Create plugin structure (minimal for testing)
    mkdir -p plugins/superharness/hooks
    mkdir -p plugins/superharness/skills/superharness-core

    # Copy the hook script
    cp "$SCRIPT_DIR/session-start.sh" plugins/superharness/hooks/

    # Create minimal foundation skill
    cat > plugins/superharness/skills/superharness-core/SKILL.md << 'EOF'
---
name: superharness-core
---
# Foundation Skill (Test)
EOF

    # Initial commit
    git add -A
    git commit -q -m "Initial commit"
}

# =============================================================================
# TEST 1: Active handoff should appear in PENDING_HANDOFFS
# =============================================================================
test_active_handoff_appears() {
    setup_test_repo

    # Create an active handoff
    mkdir -p .harness/001-test
    cat > .harness/001-test/handoff.md << 'EOF'
---
topic: "Test Active Handoff"
status: in_progress
---
# Handoff: Test Active
EOF

    # Run the hook (from repo root where .harness exists)
    output=$(./plugins/superharness/hooks/session-start.sh 2>&1 || true)

    # Check if handoff appears in output
    if echo "$output" | grep -q "Test Active Handoff"; then
        log_pass "Active handoff appears in output"
    else
        log_fail "Active handoff should appear in output"
        echo "Output was: $output"
    fi
}

# =============================================================================
# TEST 2: Resolved handoff (with git trailer) should NOT appear
# =============================================================================
test_resolved_handoff_hidden() {
    setup_test_repo

    # Create a handoff
    mkdir -p .harness/002-resolved
    cat > .harness/002-resolved/handoff.md << 'EOF'
---
topic: "Test Resolved Handoff"
status: in_progress
---
# Handoff: Test Resolved
EOF

    git add -A
    git commit -q -m "Add handoff"

    # Resolve the handoff via git trailer
    git commit -q --allow-empty -m "chore: resolve handoff

handoff: .harness/002-resolved/handoff.md
reason: completed"

    # Run the hook (from repo root where .harness exists)
    output=$(./plugins/superharness/hooks/session-start.sh 2>&1 || true)

    # Check that resolved handoff does NOT appear
    if echo "$output" | grep -q "Test Resolved Handoff"; then
        log_fail "Resolved handoff should NOT appear in output"
        echo "Output was: $output"
    else
        log_pass "Resolved handoff is hidden from output"
    fi
}

# =============================================================================
# TEST 3: Archived handoff should NOT appear
# =============================================================================
test_archived_handoff_hidden() {
    setup_test_repo

    # Create an archived handoff
    mkdir -p .harness/handoffs/archive
    cat > .harness/handoffs/archive/2026-01-01_test-archived.md << 'EOF'
---
topic: "Test Archived Handoff"
status: resolved
---
# Handoff: Test Archived
EOF

    # Run the hook (from repo root where .harness exists)
    output=$(./plugins/superharness/hooks/session-start.sh 2>&1 || true)

    # Check that archived handoff does NOT appear
    if echo "$output" | grep -q "Test Archived Handoff"; then
        log_fail "Archived handoff should NOT appear in output"
        echo "Output was: $output"
    else
        log_pass "Archived handoff is hidden from output"
    fi
}

# =============================================================================
# TEST 4: Abandoned handoff (with git trailer) should NOT appear
# =============================================================================
test_abandoned_handoff_hidden() {
    setup_test_repo

    # Create a handoff
    mkdir -p .harness/003-abandoned
    cat > .harness/003-abandoned/handoff.md << 'EOF'
---
topic: "Test Abandoned Handoff"
status: in_progress
---
# Handoff: Test Abandoned
EOF

    git add -A
    git commit -q -m "Add handoff"

    # Abandon the handoff via git trailer
    git commit -q --allow-empty -m "chore: abandon handoff

handoff-abandoned: .harness/003-abandoned/handoff.md
reason: approach changed"

    # Run the hook (from repo root where .harness exists)
    output=$(./plugins/superharness/hooks/session-start.sh 2>&1 || true)

    # Check that abandoned handoff does NOT appear
    if echo "$output" | grep -q "Test Abandoned Handoff"; then
        log_fail "Abandoned handoff should NOT appear in output"
        echo "Output was: $output"
    else
        log_pass "Abandoned handoff is hidden from output"
    fi
}

# =============================================================================
# TEST 5: Hook outputs valid JSON
# =============================================================================
test_valid_json_output() {
    setup_test_repo

    # Run the hook (from repo root where .harness exists)
    output=$(./plugins/superharness/hooks/session-start.sh 2>&1 || true)

    # Check if output is valid JSON
    if echo "$output" | jq . > /dev/null 2>&1; then
        log_pass "Hook outputs valid JSON"
    else
        log_fail "Hook should output valid JSON"
        echo "Output was: $output"
    fi
}

# =============================================================================
# RUN ALL TESTS
# =============================================================================
echo "Running session-start.sh tests..."
echo "================================="
echo ""

test_active_handoff_appears
test_resolved_handoff_hidden
test_archived_handoff_hidden
test_abandoned_handoff_hidden
test_valid_json_output

echo ""
echo "================================="
echo "Results: ${TESTS_PASSED} passed, ${TESTS_FAILED} failed"

if [ "$TESTS_FAILED" -gt 0 ]; then
    exit 1
fi
exit 0
