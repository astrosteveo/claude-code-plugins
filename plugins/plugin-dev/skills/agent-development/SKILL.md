---
name: Agent Development
description: This skill should be used when the user asks to "create an agent", "add a subagent", "write an agent", "agent frontmatter", "agent file format", "agent tools", "agent model", "permissionMode", or needs guidance on subagent structure, system prompts, triggering conditions, or agent development best practices for Claude Code.
version: 0.2.0
---

# Subagent Development for Claude Code

## Overview

Subagents are specialized AI assistants that Claude Code can delegate tasks to. Each subagent has its own context window, custom system prompt, and configurable tool access. This skill covers how to create and configure subagents properly.

**Key concepts:**
- Subagents operate in their own context, separate from main conversation
- Markdown file format with YAML frontmatter
- Simple string description field (no XML, no examples in frontmatter)
- System prompt in the markdown body defines behavior
- Tools specified as comma-separated strings

## File Locations

| Type | Location | Scope | Priority |
|:-----|:---------|:------|:---------|
| Project subagents | `.claude/agents/` | Current project only | Highest |
| User subagents | `~/.claude/agents/` | All projects | Lower |
| Plugin agents | `agents/` in plugin root | When plugin installed | Via plugin |

When names conflict, project-level subagents take precedence over user-level.

## File Format

Each subagent is a Markdown file with YAML frontmatter:

```markdown
---
name: your-agent-name
description: Description of when this subagent should be invoked
tools: Read, Grep, Glob, Bash
model: sonnet
color: blue
permissionMode: default
skills: skill1, skill2
---

Your subagent's system prompt goes here. This can be multiple paragraphs
and should clearly define the subagent's role, capabilities, and approach
to solving problems.

Include specific instructions, best practices, and any constraints
the subagent should follow.
```

## Configuration Fields

| Field | Required | Description |
|:------|:---------|:------------|
| `name` | **Yes** | Unique identifier using lowercase letters and hyphens |
| `description` | **Yes** | Natural language description of when to invoke (simple string) |
| `tools` | No | Comma-separated list of tools. If omitted, inherits all tools |
| `model` | No | Model alias (`sonnet`, `opus`, `haiku`) or `inherit`. Default: sonnet |
| `color` | No | Visual identifier: `blue`, `cyan`, `green`, `yellow`, `magenta`, `red` |
| `permissionMode` | No | `default`, `acceptEdits`, `bypassPermissions`, `plan`, or `ignore` |
| `skills` | No | Comma-separated list of skill names to auto-load |

### name (required)

Unique identifier for the subagent.

**Format:** Lowercase letters, numbers, and hyphens only (2-50 characters)
**Examples:** `code-reviewer`, `test-runner`, `api-analyzer`

### description (required)

A simple, natural language string describing when Claude should invoke this agent.

**IMPORTANT:** The description is a plain string. Do NOT include:
- XML tags like `<example>` or `<commentary>`
- Newline escape sequences like `\n`
- Structured data or formatting

**Good descriptions:**
```yaml
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.

description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.

description: Data analysis expert for SQL queries, BigQuery operations, and data insights. Use proactively for data analysis tasks.
```

**Bad descriptions (DO NOT USE):**
```yaml
# WRONG - contains XML tags
description: Use this agent when... Examples:\n\n<example>\nuser: "review my code"\n</example>

# WRONG - contains escape sequences
description: Use this agent when the user asks to review code.\nAlso use when...
```

**Tips for effective descriptions:**
- Include phrases like "use proactively" or "use immediately after" to encourage automatic delegation
- Be specific about the types of tasks the agent handles
- Keep it concise (1-3 sentences)

### tools (optional)

Comma-separated list of tools the agent can use.

```yaml
tools: Read, Grep, Glob, Bash
```

**Available tools:** Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch, and any MCP tools

**Default behavior:** If omitted, the agent inherits all tools from the main thread, including MCP tools.

**Best practice:** Limit to only necessary tools (principle of least privilege).

### model (optional)

Which model the subagent should use.

**Options:**
- `sonnet` - Claude Sonnet (default if omitted)
- `opus` - Claude Opus (most capable)
- `haiku` - Claude Haiku (fastest, cheapest)
- `inherit` - Use same model as main conversation

```yaml
model: inherit
```

**Environment variable:** Set `CLAUDE_CODE_SUBAGENT_MODEL` to configure the default model for all subagents.

### color (optional)

Visual identifier for the agent in the UI.

**Options:** `blue`, `cyan`, `green`, `yellow`, `magenta`, `red`

```yaml
color: blue
```

**Note:** The `color` field is implemented in Claude Code but not documented in the official specification. It works reliably but may change in future versions.

**Guidelines:**
- blue/cyan: Analysis, review tasks
- green: Generation, creation tasks
- yellow: Validation, caution-related tasks
- red: Security, critical tasks
- magenta: Creative, transformation tasks

### permissionMode (optional)

Controls how the subagent handles permission requests.

**Options:**
- `default` - Normal permission behavior
- `acceptEdits` - Auto-accept file edits
- `bypassPermissions` - Skip permission prompts
- `plan` - Planning mode only
- `ignore` - Ignore permission system

### skills (optional)

Comma-separated list of skills to auto-load when the subagent starts.

```yaml
skills: api-testing, code-standards
```

## System Prompt Design

The markdown body after the frontmatter becomes the agent's system prompt. Write clear, specific instructions.

### Recommended Structure

```markdown
You are [role description] specializing in [domain].

When invoked:
1. [First step]
2. [Second step]
3. [Third step]

[Domain-specific guidance]:
- [Guideline 1]
- [Guideline 2]
- [Guideline 3]

For each [task type], provide:
- [Output element 1]
- [Output element 2]
- [Output element 3]

[Additional constraints or best practices]
```

### Best Practices

**DO:**
- Write in second person ("You are...", "You will...")
- Be specific about responsibilities
- Provide step-by-step processes
- Define expected output format
- Include quality standards
- Address edge cases

**DON'T:**
- Write in first person ("I am...", "I will...")
- Be vague or generic
- Omit process steps
- Leave output format undefined

## Complete Examples

### Code Reviewer

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### Debugger

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:
- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not the symptoms.
```

### Test Runner

```markdown
---
name: test-runner
description: Test automation expert. Use proactively to run tests after code changes and fix any failures.
tools: Read, Edit, Bash, Grep, Glob
---

You are a test automation expert ensuring code quality through comprehensive testing.

When invoked:
1. Identify which tests are relevant to recent changes
2. Run the appropriate test suite
3. Analyze any failures
4. Fix failing tests while preserving original test intent

Testing process:
- Check git diff to see what changed
- Run targeted tests first, then full suite if needed
- For failures, distinguish between:
  - Test bugs (fix the test)
  - Code bugs (fix the code)
  - Intentional changes (update test expectations)

For each test failure, provide:
- What failed and why
- Root cause analysis
- The fix applied
- Verification that fix works
```

## CLI-Based Configuration

You can define subagents dynamically using the `--agents` CLI flag with JSON:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

**Key differences from file-based agents:**
- Uses JSON format (tools as array, not comma-separated string)
- `prompt` field instead of markdown body for system prompt
- Priority: Lower than project-level agents, higher than user-level agents

**Use cases:**
- Quick testing of agent configurations
- Session-specific agents that don't need persistence
- Automation scripts requiring custom agents
- Sharing agent definitions in documentation

## Built-In Agents

Claude Code includes three built-in agents:

### General-Purpose Agent

- **Model:** Sonnet
- **Tools:** All tools available
- **Purpose:** Complex, multi-step tasks requiring both exploration and modification
- **Auto-invoked when:**
  - Task requires both exploration and modification
  - Complex reasoning is needed
  - Multiple strategies may be needed
  - Multi-step dependent tasks

### Plan Agent

- **Model:** Sonnet
- **Tools:** Read, Glob, Grep, Bash (exploration only)
- **Purpose:** Research and context gathering during plan mode
- **Auto-invoked:** When in plan mode and codebase research is needed
- **Note:** Prevents infinite nesting (subagents cannot spawn subagents)

### Explore Agent

- **Model:** Haiku (fast, low-latency)
- **Mode:** Strictly read-only
- **Tools:** Glob, Grep, Read, Bash (read-only commands only)
- **Purpose:** Fast codebase searching and analysis
- **Thoroughness levels:**
  - **Quick** - Fast searches, minimal exploration
  - **Medium** - Moderate exploration, balanced speed/depth
  - **Very thorough** - Comprehensive analysis across multiple locations

## Plugin Agents

Plugin agents are stored in the `agents/` directory at the plugin root:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   ├── code-reviewer.md
│   ├── test-runner.md
│   └── debugger.md
└── ...
```

All `.md` files in `agents/` are auto-discovered when the plugin is loaded.

## Creating Agents

### Using /agents Command (Recommended)

The `/agents` command provides an interactive interface:

1. Run `/agents`
2. Select "Create New Agent"
3. Choose project or user level
4. Describe the agent (Claude generates initial config)
5. Customize as needed
6. Save

### Manual Creation

1. Create the agent file: `agents/my-agent.md`
2. Add YAML frontmatter with required fields
3. Write system prompt in markdown body
4. Test by asking Claude to use the agent

## Validation

An agent file is valid when:

1. **Frontmatter:** Valid YAML between `---` markers
2. **name:** Lowercase letters, numbers, and hyphens only (2-50 characters)
3. **description:** Simple string (no XML tags or `\n` escapes)
4. **model:** If present, must be `inherit`, `sonnet`, `opus`, or `haiku`
5. **tools:** If present, comma-separated tool names (not JSON array)
6. **permissionMode:** If present, must be `default`, `acceptEdits`, `bypassPermissions`, `plan`, or `ignore`
7. **System prompt:** Non-empty content after frontmatter

Use `scripts/validate-agent.sh` to check agent files.

## Automatic vs Explicit Invocation

**Automatic:** Claude delegates based on task matching the description:
```
> Review my recent code changes
[Claude automatically invokes code-reviewer agent]
```

**Explicit:** Mention the agent by name:
```
> Use the test-runner agent to check if my changes broke anything
```

**Encouraging proactive use:** Include phrases in description like:
- "Use proactively..."
- "Use immediately after..."
- "MUST BE USED when..."

## Resumable Agents

Agents can be resumed to continue previous conversations:

- Each agent execution gets a unique `agentId`
- Agent conversation stored in: `agent-{agentId}.jsonl`
- Use the `resume` parameter with the `agentId` to continue
- When resumed, the agent continues with full context preserved

**Use cases:**
- Long-running research across multiple sessions
- Iterative refinement without losing context
- Multi-step workflows with sequential related tasks

**Explicit resume example:**
```
> Resume agent abc123 and now analyze the authorization logic as well
```

**Programmatic usage (Task tool):**
```json
{
  "description": "Continue analysis",
  "prompt": "Now examine the error handling patterns",
  "subagent_type": "code-analyzer",
  "resume": "abc123"
}
```

Claude Code displays the agent ID when a subagent completes its work.

## Additional Resources

- **`references/best-practices.md`** - Consolidated best practices for agent development
- **`references/subagents.md`** - Official Claude Code subagents documentation
- **`references/system-prompt-design.md`** - Detailed system prompt patterns
- **`examples/complete-agent-examples.md`** - More working examples
- **`scripts/validate-agent.sh`** - Validation utility
