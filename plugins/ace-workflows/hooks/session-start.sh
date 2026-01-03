#!/usr/bin/env bash
# SessionStart hook for ace-workflows plugin
# Checks for incomplete work and surfaces context for session continuation

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Initialize variables for incomplete work detection
INCOMPLETE_PLANS=""
PENDING_HANDOFFS=""
WORK_NOTIFICATION=""

# Check for incomplete plans in .harness/shared/plans/
if [ -d ".harness/shared/plans" ]; then
    for plan_file in .harness/shared/plans/*.md; do
        [ -f "$plan_file" ] || continue

        # Extract plan name from filename
        plan_name=$(basename "$plan_file" .md)

        # Count total phases from plan (look for "## Phase N:" patterns)
        total_phases=$(grep -cE "^## Phase [0-9]+:" "$plan_file" 2>/dev/null || echo "0")
        total_phases=${total_phases:-0}

        if [ "$total_phases" -eq 0 ]; then
            continue
        fi

        # Count completed phases (checked checkboxes in Success Criteria)
        # Look for phases where ALL automated verification items are checked
        completed_phases=0
        for phase_num in $(seq 1 "$total_phases"); do
            # Extract the phase section and check if all automated verifications are complete
            phase_complete=$(awk "/^## Phase ${phase_num}:/,/^## Phase $((phase_num + 1)):|^## Testing Strategy|^## References|^---$/" "$plan_file" 2>/dev/null | grep -c "\- \[x\]" || echo "0")
            if [ "$phase_complete" -gt 0 ]; then
                completed_phases=$((completed_phases + 1))
            fi
        done

        # If not all phases complete, add to list
        if [ "$completed_phases" -lt "$total_phases" ]; then
            next_phase=$((completed_phases + 1))
            # Get next phase name
            next_phase_name=$(grep -E "^## Phase ${next_phase}:" "$plan_file" 2>/dev/null | sed 's/^## Phase [0-9]*: //' || echo "Unknown")
            INCOMPLETE_PLANS="${INCOMPLETE_PLANS}Plan: ${plan_name}\\nProgress: ${completed_phases} of ${total_phases} phases complete\\nNext: Phase ${next_phase}: ${next_phase_name}\\nFile: ${plan_file}\\n\\n"
        fi
    done
fi

# Check for pending handoffs in .harness/shared/handoffs/
if [ -d ".harness/shared/handoffs" ]; then
    # Get most recent handoff (by modification time)
    recent_handoff=$(ls -t .harness/shared/handoffs/*.md 2>/dev/null | head -1 || echo "")

    if [ -n "$recent_handoff" ] && [ -f "$recent_handoff" ]; then
        handoff_name=$(basename "$recent_handoff" .md)
        # Extract topic from frontmatter if exists
        handoff_topic=$(grep -E "^topic:" "$recent_handoff" 2>/dev/null | sed 's/^topic: *//' | tr -d '"' || echo "")
        if [ -z "$handoff_topic" ]; then
            # Fallback to first H1 heading
            handoff_topic=$(grep -E "^# " "$recent_handoff" 2>/dev/null | head -1 | sed 's/^# //' || echo "$handoff_name")
        fi

        # Check if handoff is recent (within last 7 days)
        handoff_date=$(echo "$handoff_name" | grep -oE "^[0-9]{4}-[0-9]{2}-[0-9]{2}" || echo "")
        if [ -n "$handoff_date" ]; then
            handoff_timestamp=$(date -d "$handoff_date" +%s 2>/dev/null || echo "0")
            current_timestamp=$(date +%s)
            days_old=$(( (current_timestamp - handoff_timestamp) / 86400 ))

            if [ "$days_old" -lt 7 ]; then
                PENDING_HANDOFFS="Recent handoff found (${days_old} days old):\\n- Topic: ${handoff_topic}\\n- File: ${recent_handoff}\\n\\n"
            fi
        fi
    fi
fi

# Build work notification if incomplete work found
if [ -n "$INCOMPLETE_PLANS" ] || [ -n "$PENDING_HANDOFFS" ]; then
    WORK_NOTIFICATION="\\n\\n---\\n\\n**INCOMPLETE WORK DETECTED**\\n\\n"

    if [ -n "$INCOMPLETE_PLANS" ]; then
        WORK_NOTIFICATION="${WORK_NOTIFICATION}**Incomplete Plans:**\\n${INCOMPLETE_PLANS}"
    fi

    if [ -n "$PENDING_HANDOFFS" ]; then
        WORK_NOTIFICATION="${WORK_NOTIFICATION}**Pending Handoffs:**\\n${PENDING_HANDOFFS}"
    fi

    WORK_NOTIFICATION="${WORK_NOTIFICATION}\\n**You should ask the user:** \\\"Would you like to resume previous work?\\\"\\n\\n- To resume a plan: \`/ace-workflows:implement-plan <path>\`\\n- To resume from handoff: \`/ace-workflows:resume-handoff <path>\`\\n- To start fresh: Continue with new request"
fi

# Build the context message
ACE_CONTEXT="You have ace-workflows commands available for structured development:\\n\\n"
ACE_CONTEXT="${ACE_CONTEXT}**Core Workflow (Research -> Plan -> Implement -> Validate):**\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:research-codebase\` - Research before planning\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:create-plan\` - Create phased implementation plan\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:implement-plan\` - Execute plan with verification gates\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:validate-plan\` - Verify implementation against spec\\n\\n"
ACE_CONTEXT="${ACE_CONTEXT}**Supporting Commands:**\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:iterate-plan\` - Update existing plans\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:create-handoff\` - Create context handoff document\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:resume-handoff\` - Resume from handoff\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:debug\` - Investigate issues\\n\\n"
ACE_CONTEXT="${ACE_CONTEXT}**No-Thoughts Variants (for projects without .harness/ directory):**\\n"
ACE_CONTEXT="${ACE_CONTEXT}- \`/ace-workflows:research-codebase-nt\`, \`/ace-workflows:create-plan-nt\`, \`/ace-workflows:iterate-plan-nt\`"

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<ACE_WORKFLOWS_CONTEXT>\n${ACE_CONTEXT}${WORK_NOTIFICATION}\n</ACE_WORKFLOWS_CONTEXT>"
  }
}
EOF

exit 0
