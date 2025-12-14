---
description: Research codebase and external docs for a feature
argument-hint: <feature-description>
allowed-tools:
  - Read
  - Write
  - Glob
  - Task
  - Bash(ls:*, mkdir:*, date:*)
---

# Explore Phase

Execute the **Explore** phase of the Frequent Intentional Compaction workflow.

Launch research agents to understand the codebase and, when needed, gather external documentation before planning any changes.

## Input

**Feature to explore:** $ARGUMENTS

If no feature description provided, ask user what they want to explore.

## Process

### 1. Initialize Artifact Directory

Determine the next sequence number:
```bash
ls .claude/workflows/ 2>/dev/null | grep -E '^[0-9]{3}-' | sort | tail -1
```

Generate a kebab-case slug from the feature description:
- "add user authentication" → `add-user-authentication`
- "fix payment bug" → `fix-payment-bug`

Create directory structure:
```bash
mkdir -p .claude/workflows/[NNN]-[slug]/research
mkdir -p .claude/workflows/[NNN]-[slug]/plans
mkdir -p .claude/workflows/[NNN]-[slug]/implementation
mkdir -p .claude/workflows/[NNN]-[slug]/validation
```

### 2. Determine Research Scope

Analyze the feature description to decide if external documentation research is needed.

**Launch BOTH agents (codebase-explorer + docs-researcher) when the feature:**
- Mentions a specific library, framework, or external API by name
- Involves security, authentication, or authorization
- Requires integrating a new dependency
- Mentions "upgrade", "migrate", or version changes
- Explicitly asks for best practices or documentation
- Involves unfamiliar technology

**Launch ONLY codebase-explorer when the feature:**
- Is a bug fix in existing code
- Is refactoring using existing patterns
- Adds functionality following established codebase conventions
- Is purely internal with no external dependencies
- User explicitly says "no external research needed"

**If unclear:** Ask the user:
```
This feature could benefit from external documentation research, or we could focus solely on the existing codebase.

Does this feature involve:
- New libraries or frameworks?
- Security considerations?
- External API integrations?

→ Research scope: [codebase only] or [codebase + external docs]?
```

### 3. Launch Research Agent(s)

#### Always Launch: codebase-explorer

```
Task tool parameters:
  subagent_type: explore-plan-implement:codebase-explorer
  run_in_background: true
  prompt: |
    Explore this codebase to understand: [feature description]

    Document your findings to: .claude/workflows/[NNN-slug]/research/codebase.md

    Focus on:
    - Relevant files with file:line references
    - Code flow and data flow
    - Existing patterns to follow
    - Dependencies and constraints
    - Integration points

    Use template structure from: ${CLAUDE_PLUGIN_ROOT}/templates/codebase.md
```

#### Conditionally Launch: docs-researcher

Only if research scope includes external docs:

```
Task tool parameters:
  subagent_type: explore-plan-implement:docs-researcher
  run_in_background: true
  prompt: |
    Research external documentation and best practices for: [feature description]

    Document your findings to: .claude/workflows/[NNN-slug]/research/docs.md

    Focus on:
    - Official documentation for relevant libraries
    - Current versions and breaking changes
    - Security best practices
    - Performance considerations
    - Authoritative code examples

    Use template structure from: ${CLAUDE_PLUGIN_ROOT}/templates/docs.md
```

**Critical:**
- All agents MUST use `run_in_background: true` to keep main context clean
- If launching both, send both Task calls in a single message for parallel execution
- Note the task IDs returned for later retrieval

### 4. Create State File

After launching agent(s), create the workflow state tracker.

**If both agents launched:**
```markdown
# Workflow State

**Feature**: [feature description]
**Slug**: [NNN-slug]
**Directory**: .claude/workflows/[NNN-slug]
**Current Phase**: explore
**Research Scope**: full (codebase + docs)
**Last Updated**: [ISO date]

## Background Agents

| Agent | Task ID | Status |
|-------|---------|--------|
| codebase-explorer | [task-id-1] | running |
| docs-researcher | [task-id-2] | running |

## Phase Status

| Phase | Status | Artifact |
|-------|--------|----------|
| Explore | in_progress | research/*.md |
| Plan | pending | plans/implementation-plan.md |
| Implement | pending | implementation/progress.md |
| Validate | pending | validation/results.md |
| Commit | pending | git commit |
```

**If only codebase-explorer launched:**
```markdown
# Workflow State

**Feature**: [feature description]
**Slug**: [NNN-slug]
**Directory**: .claude/workflows/[NNN-slug]
**Current Phase**: explore
**Research Scope**: codebase only
**Last Updated**: [ISO date]

## Background Agents

| Agent | Task ID | Status |
|-------|---------|--------|
| codebase-explorer | [task-id-1] | running |

## Phase Status

| Phase | Status | Artifact |
|-------|--------|----------|
| Explore | in_progress | research/codebase.md |
| Plan | pending | plans/implementation-plan.md |
| Implement | pending | implementation/progress.md |
| Validate | pending | validation/results.md |
| Commit | pending | git commit |
```

Write to: `.claude/workflows/[NNN-slug]/state.md`

### 5. Retrieve Background Agent Results

Use `TaskOutput` to collect results from background agent(s):

```
TaskOutput tool parameters:
  task_id: [codebase-explorer task ID]
  block: true  # Wait for completion
  timeout: 300000  # 5 minute timeout
```

If docs-researcher was launched:
```
TaskOutput tool parameters:
  task_id: [docs-researcher task ID]
  block: true
  timeout: 300000
```

**Note:** If both agents running, call both TaskOutput tools in parallel to wait simultaneously.

After agent(s) complete, verify artifacts exist:
- `.claude/workflows/[NNN-slug]/research/codebase.md` (always)
- `.claude/workflows/[NNN-slug]/research/docs.md` (if docs-researcher ran)

Update `state.md`: Set Explore status to "complete".

### 6. Present Summary

**If both agents ran:**
```
## Explore Phase Complete

**Feature**: [description]
**Artifacts**: .claude/workflows/[NNN-slug]/
**Research Scope**: Full (codebase + external docs)

### Codebase Findings
- [X] relevant files identified
- Key patterns: [list]
- Integration points: [list]

### External Research
- [X] documentation sources reviewed
- Key technologies: [list with versions]
- Key considerations: [list]

### Open Questions
- [Any questions requiring human input]

---

**Next Step**: Review the research artifacts, then run `/plan`

⚠️ Review research before planning - errors here cascade to 1000s of bad lines of code.
```

**If only codebase-explorer ran:**
```
## Explore Phase Complete

**Feature**: [description]
**Artifacts**: .claude/workflows/[NNN-slug]/
**Research Scope**: Codebase only

### Codebase Findings
- [X] relevant files identified
- Key patterns: [list]
- Integration points: [list]

### Open Questions
- [Any questions requiring human input]

---

**Next Step**: Review the research artifact, then run `/plan`

💡 No external docs research was performed. If you need library/framework documentation, re-run with `/explore [feature] --with-docs`
```

## Output Format

### Success (Full Research)
```
✓ Explore Phase Complete

Feature: [description]
Directory: .claude/workflows/[NNN-slug]/
Research Scope: full

Research Artifacts:
- codebase.md ([X] files documented)
- docs.md ([Y] sources cited)

**Context**: ~[X]K / 200K tokens ([Y]%)

Next: Review artifacts, then run `/plan`
```

### Success (Codebase Only)
```
✓ Explore Phase Complete

Feature: [description]
Directory: .claude/workflows/[NNN-slug]/
Research Scope: codebase only

Research Artifacts:
- codebase.md ([X] files documented)

**Context**: ~[X]K / 200K tokens ([Y]%)

Next: Review artifact, then run `/plan`
```

### Blocked
```
⚠️ Explore Phase Incomplete

Issue: [specific problem]
- Agent failed: [which one]
- Missing: [what's missing]

Resolution: [specific action]
```

## Context Efficiency

This command delegates heavy exploration to **background subagent(s)** to keep the main context clean.

**DO:**
- Launch agent(s) with `run_in_background: true`
- Use `TaskOutput` with `block: true` to wait for results
- Let agents do the searching and reading
- Keep summaries concise
- Skip docs-researcher when not needed (saves cost and time)

**DON'T:**
- Read large files in main context
- Duplicate agent work
- Include raw search results
- Launch docs-researcher for simple bug fixes or internal refactoring

## Context Reporting

At the end of this command, report estimated context utilization:

**Format**: `**Context**: ~[X]K / 200K tokens ([Y]%)`

**Estimation guidance**:
- Codebase-only exploration: ~15-30K tokens
- Full exploration (both agents): ~25-50K tokens
- Complex exploration with many files: ~40-70K tokens

**Threshold warnings**:
- 40-60%: Optimal range, continue normally
- 60-80%: Consider compacting after current phase
- >80%: Recommend immediate compaction before continuing

If context exceeds 60%, append warning:
```
⚠️ Context at [Y]% - consider running `/compact` or starting fresh session
```

## Important

1. **Conditional research** - Only launch docs-researcher when external documentation adds value
2. **Background agents** - All agents use `run_in_background: true`
3. **Task ID tracking** - Record task IDs in state.md for retrieval with TaskOutput
4. **Facts only** - Research documents contain observations, not suggestions
5. **file:line references** - All code locations must be precisely referenced
6. **State tracking** - state.md enables fresh session resumption (includes task IDs and research scope)
7. **Human review** - Remind user this is the highest-leverage review point
