#!/usr/bin/env bash
# SessionStart hook for feature-dev plugin
# Reads .feature-dev/dashboard.md and displays next step recommendations

set -euo pipefail

DASHBOARD_FILE=".feature-dev/dashboard.md"

# Check if dashboard exists
if [ ! -f "$DASHBOARD_FILE" ]; then
    # No dashboard, output minimal JSON
    cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": ""
  }
}
EOF
    exit 0
fi

# Read dashboard content
DASHBOARD_CONTENT=$(cat "$DASHBOARD_FILE" 2>/dev/null || echo "")

# Check if dashboard has content beyond the template headers
if [ -z "$DASHBOARD_CONTENT" ] || ! echo "$DASHBOARD_CONTENT" | grep -qE '^\| .+ \| .+ \||\- \[[ x]\]'; then
    # Dashboard exists but is empty/just template
    cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": ""
  }
}
EOF
    exit 0
fi

# Extract top items from each section
# Get first non-header row from Recommended Next Steps table and extract description
RECOMMENDED=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Recommended Next Steps/,/^##/p' | grep -E '^\| (High|Medium|Low)' | head -1 | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $3); print $3}' || echo "")

# Get first unchecked bug
BUG=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Priority Bugs/,/^##/p' | grep -E '^- \[ \]' | head -1 | sed 's/^- \[ \] //' || echo "")

# Get first unchecked tech debt
TECH_DEBT=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Tech Debt Queue/,/^##/p' | grep -E '^- \[ \]' | head -1 | sed 's/^- \[ \] //' || echo "")

# Get first quick win
QUICK_WIN=$(echo "$DASHBOARD_CONTENT" | sed -n '/## Quick Wins/,/^##/p' | grep -E '^- \[ \]' | head -1 | sed 's/^- \[ \] //' || echo "")

# Build the message
MESSAGE=""

if [ -n "$RECOMMENDED" ] || [ -n "$BUG" ] || [ -n "$TECH_DEBT" ] || [ -n "$QUICK_WIN" ]; then
    MESSAGE="**What's Next** (from .feature-dev/dashboard.md):\\n\\n"

    if [ -n "$RECOMMENDED" ]; then
        MESSAGE="${MESSAGE}  - **Recommended**: ${RECOMMENDED}\\n"
    fi

    if [ -n "$BUG" ]; then
        MESSAGE="${MESSAGE}  - **Bug**: ${BUG}\\n"
    fi

    if [ -n "$TECH_DEBT" ]; then
        MESSAGE="${MESSAGE}  - **Tech Debt**: ${TECH_DEBT}\\n"
    fi

    if [ -n "$QUICK_WIN" ]; then
        MESSAGE="${MESSAGE}  - **Quick Win**: ${QUICK_WIN}\\n"
    fi

    MESSAGE="${MESSAGE}\\nRun \`/feature-dev\` to start a new feature, or ask me to tackle any of the above."
fi

# Escape for JSON
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

if command -v jq &> /dev/null; then
    MESSAGE_ESCAPED=$(jq -Rs '.' <<< "$MESSAGE" | sed 's/^"//;s/"$//')
else
    MESSAGE_ESCAPED=$(escape_for_json "$MESSAGE")
fi

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${MESSAGE_ESCAPED}"
  }
}
EOF

exit 0
