#!/usr/bin/env bash
# SessionStart hook for SUPERHARNESS plugin
# Injects foundation skill and detects incomplete work

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Initialize variables
INCOMPLETE_PLANS=""
PENDING_HANDOFFS=""
DASHBOARD_ITEMS=""
WORK_NOTIFICATION=""

# =============================================================================
# INCOMPLETE WORK DETECTION
# =============================================================================

# Check for incomplete plans in .harness/*/plan.md
if [ -d ".harness" ]; then
    for plan_file in .harness/*/plan.md; do
        [ -f "$plan_file" ] || continue

        # Extract feature name from path
        feature_dir=$(dirname "$plan_file")
        feature_name=$(basename "$feature_dir")

        # Check if plan was abandoned
        if git log --all --format=%B 2>/dev/null | grep -q "plan: abandoned"; then
            # Check if this specific feature was abandoned
            if git log --all --format=%B 2>/dev/null | grep -q "plan: abandoned.*${feature_name}"; then
                continue
            fi
        fi

        # Count total phases from plan header (look for "## Phase N:" patterns)
        total_phases=$(grep -cE "^## Phase [0-9]+:" "$plan_file" 2>/dev/null || echo "0")
        total_phases=${total_phases:-0}

        if [ "$total_phases" -eq 0 ]; then
            continue
        fi

        # Count completed phases from git log trailers
        # Look for "phase(N): complete" trailers in commit messages
        completed_phases=$(git log --format=%B 2>/dev/null | grep -cE "^phase\([0-9]+\): complete$" || echo "0")
        completed_phases=${completed_phases:-0}

        # If not all phases complete, add to list
        if [ "$completed_phases" -lt "$total_phases" ]; then
            next_phase=$((completed_phases + 1))
            # Get next phase name
            next_phase_name=$(grep -E "^## Phase ${next_phase}:" "$plan_file" 2>/dev/null | sed 's/^## Phase [0-9]*: //' || echo "Unknown")
            INCOMPLETE_PLANS="${INCOMPLETE_PLANS}Feature: ${feature_name}\\nProgress: ${completed_phases} of ${total_phases} phases complete\\nNext: Phase ${next_phase}: ${next_phase_name}\\nPlan: ${plan_file}\\n\\n"
        fi
    done
fi

# =============================================================================
# HANDOFF DETECTION
# =============================================================================

# Check for pending handoffs in .harness/handoffs/ or .harness/*/handoff.md
check_handoff() {
    local handoff_file="$1"
    local handoff_name
    local handoff_topic
    local handoff_date
    local handoff_timestamp
    local current_timestamp
    local days_old

    handoff_name=$(basename "$handoff_file" .md)

    # Extract topic from frontmatter if exists
    handoff_topic=$(grep -E "^topic:" "$handoff_file" 2>/dev/null | sed 's/^topic: *//' | tr -d '"' || echo "")
    if [ -z "$handoff_topic" ]; then
        # Fallback to first H1 heading
        handoff_topic=$(grep -E "^# " "$handoff_file" 2>/dev/null | head -1 | sed 's/^# //' || echo "$handoff_name")
    fi

    # Check if handoff is recent (within last 7 days)
    # Try to extract date from filename (YYYY-MM-DD format)
    handoff_date=$(echo "$handoff_name" | grep -oE "^[0-9]{4}-[0-9]{2}-[0-9]{2}" || echo "")

    if [ -n "$handoff_date" ]; then
        # Use file date from filename
        handoff_timestamp=$(date -d "$handoff_date" +%s 2>/dev/null || echo "0")
    else
        # Fall back to file modification time
        handoff_timestamp=$(stat -c %Y "$handoff_file" 2>/dev/null || stat -f %m "$handoff_file" 2>/dev/null || echo "0")
    fi

    current_timestamp=$(date +%s)
    days_old=$(( (current_timestamp - handoff_timestamp) / 86400 ))

    if [ "$days_old" -lt 7 ]; then
        PENDING_HANDOFFS="${PENDING_HANDOFFS}Handoff: ${handoff_topic} (${days_old} days old)\\nFile: ${handoff_file}\\n\\n"
    fi
}

# Check cross-feature handoffs directory
if [ -d ".harness/handoffs" ]; then
    for handoff_file in .harness/handoffs/*.md; do
        [ -f "$handoff_file" ] || continue
        check_handoff "$handoff_file"
    done
fi

# Check per-feature handoffs
if [ -d ".harness" ]; then
    for handoff_file in .harness/*/handoff.md; do
        [ -f "$handoff_file" ] || continue
        check_handoff "$handoff_file"
    done
fi

# =============================================================================
# DASHBOARD RECOMMENDATIONS
# =============================================================================

DASHBOARD_FILE=".harness/dashboard.md"
if [ -f "$DASHBOARD_FILE" ]; then
    # Extract first item from each section (if exists)
    NEXT_STEP=$(grep -A1 "## Recommended Next Steps" "$DASHBOARD_FILE" 2>/dev/null | grep -E "^\| (High|Critical)" | head -1 | sed 's/|//g' | xargs || echo "")
    PRIORITY_BUG=$(grep -A2 "## Priority Bugs" "$DASHBOARD_FILE" 2>/dev/null | grep -E "^\- \[ \]" | head -1 | sed 's/- \[ \] //' || echo "")
    QUICK_WIN=$(grep -A2 "## Quick Wins" "$DASHBOARD_FILE" 2>/dev/null | grep -E "^\- \[ \]" | head -1 | sed 's/- \[ \] //' || echo "")
    TECH_DEBT=$(grep -A2 "## Tech Debt Queue" "$DASHBOARD_FILE" 2>/dev/null | grep -E "^\- \[ \]" | head -1 | sed 's/- \[ \] //' || echo "")

    if [ -n "$NEXT_STEP" ] || [ -n "$PRIORITY_BUG" ] || [ -n "$QUICK_WIN" ] || [ -n "$TECH_DEBT" ]; then
        DASHBOARD_ITEMS="\\n\\n---\\n\\n**DASHBOARD - What's Next**\\n\\n"
        [ -n "$NEXT_STEP" ] && DASHBOARD_ITEMS="${DASHBOARD_ITEMS}**Recommended:** ${NEXT_STEP}\\n"
        [ -n "$PRIORITY_BUG" ] && DASHBOARD_ITEMS="${DASHBOARD_ITEMS}**Priority Bug:** ${PRIORITY_BUG}\\n"
        [ -n "$TECH_DEBT" ] && DASHBOARD_ITEMS="${DASHBOARD_ITEMS}**Tech Debt:** ${TECH_DEBT}\\n"
        [ -n "$QUICK_WIN" ] && DASHBOARD_ITEMS="${DASHBOARD_ITEMS}**Quick Win:** ${QUICK_WIN}\\n"
        DASHBOARD_ITEMS="${DASHBOARD_ITEMS}\\nSee \`.harness/dashboard.md\` for full list."
    fi
fi

# Also check BACKLOG.md for high priority items
BACKLOG_FILE=".harness/BACKLOG.md"
if [ -f "$BACKLOG_FILE" ] && [ -z "$DASHBOARD_ITEMS" ]; then
    # Extract critical/high priority items
    CRITICAL_ITEM=$(grep -E "^\| .*\| Critical \|" "$BACKLOG_FILE" 2>/dev/null | head -1 | sed 's/|//g' | xargs || echo "")
    HIGH_ITEM=$(grep -E "^\| .*\| High \|" "$BACKLOG_FILE" 2>/dev/null | head -1 | sed 's/|//g' | xargs || echo "")

    if [ -n "$CRITICAL_ITEM" ] || [ -n "$HIGH_ITEM" ]; then
        DASHBOARD_ITEMS="\\n\\n---\\n\\n**BACKLOG - Priority Items**\\n\\n"
        [ -n "$CRITICAL_ITEM" ] && DASHBOARD_ITEMS="${DASHBOARD_ITEMS}**Critical:** ${CRITICAL_ITEM}\\n"
        [ -n "$HIGH_ITEM" ] && DASHBOARD_ITEMS="${DASHBOARD_ITEMS}**High:** ${HIGH_ITEM}\\n"
        DASHBOARD_ITEMS="${DASHBOARD_ITEMS}\\nSee \`.harness/BACKLOG.md\` for full list."
    fi
fi

# =============================================================================
# BUILD WORK NOTIFICATION
# =============================================================================

if [ -n "$INCOMPLETE_PLANS" ] || [ -n "$PENDING_HANDOFFS" ]; then
    WORK_NOTIFICATION="\\n\\n---\\n\\n**INCOMPLETE WORK DETECTED**\\n\\n"

    if [ -n "$INCOMPLETE_PLANS" ]; then
        WORK_NOTIFICATION="${WORK_NOTIFICATION}**Incomplete Plans:**\\n${INCOMPLETE_PLANS}"
    fi

    if [ -n "$PENDING_HANDOFFS" ]; then
        WORK_NOTIFICATION="${WORK_NOTIFICATION}**Pending Handoffs:**\\n${PENDING_HANDOFFS}"
    fi

    WORK_NOTIFICATION="${WORK_NOTIFICATION}\\n**You MUST ask the user BEFORE doing anything else:** \\\"Resume? [Yes / No / Abandon]\\\"\\n\\n- **Yes**: Run \`/superharness:resume <path>\` with the plan or handoff\\n- **No**: Continue with user's request (will prompt again next session)\\n- **Abandon**: Create abandon commit, continue normal session\\n\\n**DO NOT skip this prompt. DO NOT respond to the user's message until they answer.**"
fi

# =============================================================================
# READ FOUNDATION SKILL
# =============================================================================

foundation_skill_content=$(cat "${PLUGIN_ROOT}/skills/superharness-core/SKILL.md" 2>&1 || echo "Error reading foundation skill")

# Escape for JSON - prefer jq if available, fallback to bash
if command -v jq &> /dev/null; then
    foundation_escaped=$(jq -Rs '.' <<< "$foundation_skill_content" | sed 's/^"//;s/"$//')
else
    # Fallback to bash escaping
    escape_for_json() {
        local input="$1"
        local output=""
        local i char
        for (( i=0; i<${#input}; i++ )); do
            char="${input:$i:1}"
            case "$char" in
                $'\\') output+='\\\\' ;;
                '"') output+='\\"' ;;
                $'\n') output+='\\n' ;;
                $'\r') output+='\\r' ;;
                $'\t') output+='\\t' ;;
                *) output+="$char" ;;
            esac
        done
        printf '%s' "$output"
    }
    foundation_escaped=$(escape_for_json "$foundation_skill_content")
fi

# =============================================================================
# BUILD BRAND MESSAGE (fallback when nothing to surface)
# =============================================================================

BRAND_MESSAGE=""
if [ -z "$WORK_NOTIFICATION" ] && [ -z "$DASHBOARD_ITEMS" ]; then
    BRAND_MESSAGE="\\n\\n---\\n\\n**ARE YOU HARNESSING THE FULL POWER OF CLAUDE CODE?**\\n\\nNo incomplete work detected. Ready for new tasks!\\n\\nUse \`/superharness:status\` to see recommendations."
fi

# =============================================================================
# OUTPUT JSON
# =============================================================================

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have SUPERHARNESS - a command-driven development workflow.\n\n**Below is your foundation skill that applies to ALL sessions:**\n\n---\n\n${foundation_escaped}${WORK_NOTIFICATION}${DASHBOARD_ITEMS}${BRAND_MESSAGE}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
