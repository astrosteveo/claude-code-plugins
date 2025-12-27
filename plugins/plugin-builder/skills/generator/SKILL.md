---
name: generator
description: "Parse natural language to scaffold Claude Code components. Use when user requests creating skills, agents, commands, or hooks."
---

# Plugin Builder Generator

Parse natural language input to create Claude Code components in `.claude/` directory.

## When to Use

- User says "create a skill for X"
- User says "create an agent for Y"
- User says "create a command to Z"
- User says "create a hook for W"
- User wants to scaffold any Claude Code component

## NL Parsing Patterns

### Component Type Detection

**Keywords mapping:**
- "skill", "agent skill", "capability" → Type: **skill**
- "agent" (not "agent skill"), "subagent" → Type: **agent**
- "command", "slash command" → Type: **command**
- "hook" → Type: **hook**

**Note**: "agent skill" is treated as "skill" because it's a colloquial term for skills.

**Parsing algorithm:**
1. Extract verb: "create", "add", "make", "scaffold", "generate"
2. Extract type: First keyword match from types above
3. Extract domain: Everything after "for" or "to"
4. Generate name: Slugify domain (lowercase, hyphens, no spaces)

**Examples:**
- "create a skill for code quality review"
  → type="skill", domain="code quality review", name="code-quality-review"

- "create an agent for deployment automation"
  → type="agent", domain="deployment automation", name="deployment-automation"

- "add a command to run tests"
  → type="command", domain="run tests", name="run-tests"

- "create a hook for pre-commit validation"
  → type="hook", domain="pre-commit validation", name="pre-commit-validation"

### Domain Extraction

Extract the purpose/domain from common patterns:
- "create X **for** {domain}" → domain
- "create X **to** {purpose}" → domain
- "create a {domain} X" → domain

If domain is unclear, extract everything after the type keyword.

### Name Generation

Convert domain to valid filename:
1. Lowercase everything
2. Replace spaces with hyphens
3. Remove special characters except hyphens
4. Trim leading/trailing hyphens

Examples:
- "Code Quality Review" → "code-quality-review"
- "Test Runner (Fast)" → "test-runner-fast"
- "Deploy to Production" → "deploy-to-production"

## Template Selection Logic

Based on component type, select template directory:

```
type=skill   → templates/skill/
type=agent   → templates/agent/
type=command → templates/command/
type=hook    → templates/hook/
```

## File Generation Process

### For Skills

1. Parse NL input → extract type, domain, name
2. Load `templates/skill/base.md`
3. Generate domain-specific content (will be added in next step)
4. Substitute variables in template
5. Create `.claude/skills/{name}/`
6. Write `SKILL.md`
7. Load example templates
8. Generate domain-specific examples
9. Write `examples/simple.md`, `examples/advanced.md`, `examples/production.md`
10. Confirm creation

**Files created:**
```
.claude/skills/{name}/
├── SKILL.md
└── examples/
    ├── simple.md
    ├── advanced.md
    └── production.md
```

### For Agents

1. Parse NL input
2. Load `templates/agent/base.md`
3. Generate domain-specific content
4. Substitute variables
5. Create `.claude/agents/`
6. Write `{name}.md`
7. Confirm creation

**Files created:**
```
.claude/agents/{name}.md
```

### For Commands

1. Parse NL input
2. Load `templates/command/base.md`
3. Generate domain-specific content
4. Substitute variables
5. Create `.claude/commands/`
6. Write `{name}.md`
7. Confirm creation

**Files created:**
```
.claude/commands/{name}.md
```

### For Hooks

1. Parse NL input
2. Determine hook type (ask user if unclear)
3. Load `templates/hook/hooks.json` and `example-hook.sh`
4. Generate hook-specific logic
5. Substitute variables
6. Create/update `.claude/hooks/hooks.json`
7. Write `.claude/hooks/{name}.sh`
8. Make script executable
9. Confirm creation

**Files created:**
```
.claude/hooks/
├── hooks.json (created or updated)
└── {name}.sh
```

## Variable Substitution

Replace these placeholders in templates:

- `{{NAME}}` - Slugified name (e.g., "code-quality-review")
- `{{DISPLAY_NAME}}` - Human-readable (e.g., "Code Quality Review")
- `{{DESCRIPTION}}` - Brief description
- `{{DOMAIN}}` - Domain/purpose as provided by user
- `{{DOMAIN_INTRO}}` - Generated introduction for the domain
- `{{WHEN_TO_USE}}` - When to invoke (for skills)
- `{{PROCESS_STEPS}}` - Step-by-step process
- `{{KEY_PRINCIPLES}}` - Best practices
- `{{ROLE_DESCRIPTION}}` - Agent's role (for agents)
- `{{CAPABILITIES}}` - Agent capabilities (for agents)
- `{{COMMAND_INSTRUCTIONS}}` - Command instructions (for commands)
- `{{HOOK_TYPE}}` - SessionStart, PreToolUse, PostToolUse (for hooks)
- `{{MATCHER}}` - Regex matcher (for hooks)
- `{{INPUT_HANDLING}}` - Stdin reading pattern (for hooks)
- `{{HOOK_LOGIC}}` - Hook implementation (for hooks)
- `{{EXIT_CODE}}` - Exit code logic (for hooks)

For skill examples:
- `{{SIMPLE_*}}` - Simple approach variables
- `{{ADVANCED_*}}` - Advanced approach variables
- `{{PRODUCTION_*}}` - Production approach variables

## Implementation Steps

1. **Parse Input**
   ```
   Input: User's NL description
   Output: {type, domain, name}
   ```

2. **Validate Component Type**
   ```
   If type not in [skill, agent, command, hook]:
     Error: "Unknown component type '{type}'. Valid types: skill, agent, command, hook"
   ```

3. **Check if Exists**
   ```
   If .claude/{type}/{name}/ exists (or {name}.md for agents/commands):
     Ask: "Component '{name}' already exists. Overwrite? (yes/no)"
   ```

4. **Load Template**
   ```
   Read templates/{type}/base.md
   For skills: Also read examples/*.md
   ```

5. **Generate Content**
   ```
   Note: Domain-specific generation will be added in next step (001-5)
   For now, use placeholder text
   ```

6. **Substitute Variables**
   ```
   Replace all {{VARIABLES}} with actual values
   ```

7. **Write Files**
   ```
   Use Write tool to create files in .claude/ directory
   Ensure directories exist first
   ```

8. **Confirm**
   ```
   List files created
   Suggest next steps (how to use/test)
   ```

## Test Cases

Test the NL parsing with these inputs:

1. **Clear skill request:**
   - Input: "create a skill for code quality review"
   - Expected: type=skill, domain="code quality review", name="code-quality-review"

2. **Agent skill (treated as skill):**
   - Input: "create an agent skill for deployment automation"
   - Expected: type=skill, domain="deployment automation", name="deployment-automation"

3. **True agent request:**
   - Input: "create an agent for test analysis"
   - Expected: type=agent, domain="test analysis", name="test-analysis"

4. **Command request:**
   - Input: "create a command to run all tests"
   - Expected: type=command, domain="run all tests", name="run-all-tests"

5. **Hook request:**
   - Input: "create a hook for pre-commit validation"
   - Expected: type=hook, domain="pre-commit validation", name="pre-commit-validation"

6. **Ambiguous (missing type):**
   - Input: "create something for testing"
   - Expected: Ask clarification

7. **Missing domain:**
   - Input: "create a skill"
   - Expected: Error or ask for domain

## Key Principles

- **Clear parsing** - Extract type, domain, name accurately
- **Fail gracefully** - Provide helpful error messages
- **Confirm understanding** - List what will be created before writing
- **File safety** - Check if files exist, offer overwrite option
- **Helpful output** - Show files created, suggest next steps
- **Template-driven** - Use templates, don't hardcode content (except for basic scaffolding)
