# Agent Development Best Practices

Consolidated best practices for creating effective Claude Code subagents.

## 1. Start with Claude-Generated Agents

The recommended approach is to generate your initial subagent with Claude and then iterate:

1. Run `/agents`
2. Select "Create New Agent"
3. Describe what you need
4. Let Claude generate the initial configuration
5. Customize to your specific needs

This gives you a solid foundation that follows all conventions.

## 2. Design Focused Agents

Create agents with single, clear responsibilities:

**Good:**
- `code-reviewer` - Reviews code for quality issues
- `test-runner` - Runs tests and fixes failures
- `security-auditor` - Audits for security vulnerabilities

**Bad:**
- `helper` - Does everything (too generic)
- `code-and-tests-and-docs` - Too many responsibilities

Single-purpose agents are more predictable and perform better.

## 3. Write Effective Descriptions

The description field controls when Claude invokes your agent automatically.

**Include proactive language:**
```yaml
description: Expert code review specialist. Use PROACTIVELY after writing or modifying code.
```

**Be specific about triggers:**
```yaml
description: Debugging specialist for errors, test failures, and unexpected behavior. Use immediately when encountering any issues.
```

**Avoid vague descriptions:**
```yaml
# BAD - too vague
description: Helps with code

# GOOD - specific and actionable
description: TypeScript type analyzer. Use when checking type safety, fixing type errors, or improving type annotations.
```

## 4. Follow the Description Format

The description must be a simple string:

**Correct:**
```yaml
description: Expert code reviewer. Use proactively after code changes.
```

**Incorrect:**
```yaml
# WRONG - XML tags
description: Use this agent when... <example>user asks to review</example>

# WRONG - escape sequences
description: Use this agent when the user asks to review code.\nAlso use when...
```

## 5. Apply Principle of Least Privilege

Only grant tools the agent needs:

```yaml
# Analysis agent - read-only tools
tools: Read, Grep, Glob

# Modification agent - includes Edit
tools: Read, Edit, Bash, Grep, Glob

# Full access - omit tools field entirely
# (inherits all tools including MCP tools)
```

Limiting tools:
- Improves security
- Helps the agent focus
- Reduces unintended side effects

## 6. Write Detailed System Prompts

The system prompt (markdown body) should include:

### Role Definition
```markdown
You are a senior code reviewer ensuring high standards of code quality and security.
```

### Clear Process Steps
```markdown
When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately
```

### Quality Standards
```markdown
Review checklist:
- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
```

### Output Format
```markdown
Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)
```

## 7. Use Second Person Voice

Write system prompts addressing the agent directly:

**Correct:**
```markdown
You are responsible for reviewing code...
You will analyze the changes...
Your process should include...
```

**Incorrect:**
```markdown
The agent is responsible for...
This agent will analyze...
I will analyze...
```

## 8. Handle Edge Cases

Include guidance for unusual situations:

```markdown
Edge cases:
- No issues found: Provide positive feedback and validation
- Too many issues: Group and prioritize top 10
- Unclear code: Request clarification rather than guessing
```

## 9. Choose the Right Model

| Model | When to Use |
|:------|:------------|
| `haiku` | Fast searches, simple tasks, cost-sensitive |
| `sonnet` | Most tasks (default) - good balance |
| `opus` | Complex reasoning, security analysis, critical tasks |
| `inherit` | Match main conversation model |

## 10. Version Control Your Agents

Check project agents into version control:

```
.claude/agents/
├── code-reviewer.md
├── test-runner.md
└── debugger.md
```

Benefits:
- Team can use and improve agents
- Track changes over time
- Consistent workflows across team

## 11. Test Your Agents

After creating an agent:

1. Test typical task execution
2. Test edge cases
3. Verify output format matches expectations
4. Check that tool usage is appropriate
5. Iterate based on results

## 12. Naming Conventions

Use lowercase letters, numbers, and hyphens:

**Valid names:**
- `code-reviewer`
- `test-runner-v2`
- `api-analyzer`

**Invalid names:**
- `Code_Reviewer` (uppercase, underscore)
- `my agent` (space)
- `agent!` (special character)

Name length: 2-50 characters.

## 13. Avoid Common Pitfalls

### Vague Responsibilities
```markdown
# BAD
Your Core Responsibilities:
1. Help the user with their code
2. Provide assistance
3. Be helpful
```

### Missing Process Steps
```markdown
# BAD
Analyze the code and provide feedback.

# GOOD
Analysis Process:
1. Read code files using Read tool
2. Scan for type annotations on all functions
3. Check for 'any' type usage
4. Verify generic type parameters
5. List findings with file:line references
```

### Undefined Output Format
```markdown
# BAD
Provide a report.

# GOOD
Output Format:
## Summary
[Overview of findings]

## Issues Found
- `file.ts:42` - Missing return type on `processData`
```

## Summary

Effective agents are:

- **Focused** - Single, clear purpose
- **Specific** - Detailed descriptions and prompts
- **Actionable** - Clear process steps
- **Proactive** - Encourage automatic delegation
- **Constrained** - Limited to necessary tools
- **Tested** - Verified to work as expected
