#!/usr/bin/env bash
# SessionStart hook for harness plugin
# Injects using-harness skill content at session start

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check for jq dependency
if ! command -v jq &> /dev/null; then
    echo '{"error": "jq not installed - required for harness plugin. Install with: brew install jq (macOS) or apt install jq (Linux)"}' >&2
    exit 1
fi

# Read using-harness skill content
SKILL_FILE="${PLUGIN_ROOT}/skills/using-harness/SKILL.md"
if [[ ! -f "$SKILL_FILE" ]]; then
    echo '{"error": "using-harness skill not found"}' >&2
    exit 1
fi

skill_content=$(cat "$SKILL_FILE")

# Build the context message
read -r -d '' context_prefix << 'EOF' || true
<EXTREMELY_IMPORTANT>
You have harness workflow skills.

**Below is the full content of your 'harness:using-harness' skill - your introduction to the harness workflow. For all other harness skills, use the 'Skill' tool:**

---
EOF

read -r -d '' context_suffix << 'EOF' || true

</EXTREMELY_IMPORTANT>
EOF

full_context="${context_prefix}
${skill_content}
${context_suffix}"

# Output valid JSON using jq (handles all escaping automatically)
jq -n --arg context "$full_context" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $context
  }
}'

exit 0
