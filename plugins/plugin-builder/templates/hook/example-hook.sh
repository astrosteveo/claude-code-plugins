#!/usr/bin/env bash
# Hook: {{DISPLAY_NAME}}
# Type: {{HOOK_TYPE}}
# Purpose: {{DESCRIPTION}}

set -euo pipefail

# For PreToolUse hooks: Read JSON input from stdin
# For SessionStart hooks: No input needed
{{INPUT_HANDLING}}

# Hook logic
{{HOOK_LOGIC}}

# Exit codes:
# 0 = allow/success
# 1 = error
# 2 = block (for PreToolUse hooks)
{{EXIT_CODE}}
