#!/usr/bin/env bash
# SessionStart hook for feature-dev plugin
# Reads .feature-dev/dashboard.md and displays next step recommendations

set -euo pipefail

DASHBOARD_FILE=".feature-dev/dashboard.md"

# Require jq for JSON handling
if ! command -v jq &> /dev/null; then
    echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Install jq for dashboard summaries: https://jqlang.github.io/jq/download/"}}'
    exit 0
fi

# Check if dashboard exists
if [ ! -f "$DASHBOARD_FILE" ]; then
    echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":""}}'
    exit 0
fi

# Read dashboard content
DASHBOARD_CONTENT=$(cat "$DASHBOARD_FILE" 2>/dev/null || echo "")

# Check if dashboard has content beyond template headers
if [ -z "$DASHBOARD_CONTENT" ] || ! echo "$DASHBOARD_CONTENT" | grep -qE '^\| .+ \| .+ \||\- \[[ x]\]'; then
    echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":""}}'
    exit 0
fi

# Extract top items from each section
RECOMMENDED=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Recommended Next Steps/,/^##/p' | grep -E '^\| (High|Medium|Low)' | head -1 | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $3); print $3}' || echo "")
BUG=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Priority Bugs/,/^##/p' | grep -E '^- \[ \]' | head -1 | sed 's/^- \[ \] //' || echo "")
TECH_DEBT=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Tech Debt Queue/,/^##/p' | grep -E '^- \[ \]' | head -1 | sed 's/^- \[ \] //' || echo "")
QUICK_WIN=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Quick Wins/,/^##/p' | grep -E '^- \[ \]' | head -1 | sed 's/^- \[ \] //' || echo "")

# Build message if we have content
MESSAGE=""
if [ -n "$RECOMMENDED" ] || [ -n "$BUG" ] || [ -n "$TECH_DEBT" ] || [ -n "$QUICK_WIN" ]; then
    MESSAGE="**What's Next** (from .feature-dev/dashboard.md):\n\n"
    [ -n "$RECOMMENDED" ] && MESSAGE+="  - **Recommended**: ${RECOMMENDED}\n"
    [ -n "$BUG" ] && MESSAGE+="  - **Bug**: ${BUG}\n"
    [ -n "$TECH_DEBT" ] && MESSAGE+="  - **Tech Debt**: ${TECH_DEBT}\n"
    [ -n "$QUICK_WIN" ] && MESSAGE+="  - **Quick Win**: ${QUICK_WIN}\n"
    MESSAGE+="\nRun \`/feature-dev\` to start a new feature, or ask me to tackle any of the above."
fi

# Output JSON using jq for proper escaping
jq -n --arg msg "$MESSAGE" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$msg}}'

exit 0
