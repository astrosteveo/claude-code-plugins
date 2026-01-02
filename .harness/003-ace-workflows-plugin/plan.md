# ace-workflows Plugin Implementation Plan

> **For Claude:** Execute using subagent per Phase.

**Goal:** Create the ace-workflows plugin implementing ACE-FCA (Advanced Context Engineering for Coding Agents) principles adapted from HumanLayer's .claude implementation.

**Tech Stack:** Claude Code Plugin Format (markdown, JSON, shell)

**Research Summary:**
- Source: HumanLayer `.claude` directory at `~/workspace/humanlayer/.claude`
- Framework: ACE-FCA (Research → Plan → Implement workflow)
- 6 documentarian agents for parallel research
- 11 core commands for minimal viable workflow
- Plugin format from existing harness/feature-dev plugins

**Phases:**
1. Phase 1: Plugin Scaffolding (3 tasks)
2. Phase 2: Agent Definitions (6 tasks)
3. Phase 3: Core Workflow Commands (5 tasks)
4. Phase 4: Variant & Support Commands (6 tasks)
5. Phase 5: Hooks & Documentation (3 tasks)

---

## Phase 1: Plugin Scaffolding

### Task 1.1: Create Directory Structure

**Files:**
- Create: `plugins/ace-workflows/`
- Create: `plugins/ace-workflows/.claude-plugin/`
- Create: `plugins/ace-workflows/agents/`
- Create: `plugins/ace-workflows/commands/`
- Create: `plugins/ace-workflows/hooks/`

**Step 1: Create directories**
```bash
mkdir -p plugins/ace-workflows/.claude-plugin
mkdir -p plugins/ace-workflows/agents
mkdir -p plugins/ace-workflows/commands
mkdir -p plugins/ace-workflows/hooks
```

**Step 2: Verify structure**
```bash
tree plugins/ace-workflows/
```
Expected: Directory tree showing all folders

### Task 1.2: Create plugin.json

**Files:**
- Create: `plugins/ace-workflows/.claude-plugin/plugin.json`

**Step 1: Write plugin.json**
```json
{
  "name": "ace-workflows",
  "version": "0.1.0",
  "description": "ACE-FCA workflow plugin implementing Research → Plan → Implement cycles with intentional context compaction",
  "author": {
    "name": "AstroSteveo"
  },
  "keywords": [
    "ace-fca",
    "context-engineering",
    "research",
    "planning",
    "workflows",
    "handoffs"
  ],
  "license": "MIT"
}
```

### Task 1.3: Create marketplace.json

**Files:**
- Create: `plugins/ace-workflows/.claude-plugin/marketplace.json`

**Step 1: Write marketplace.json**
```json
{
  "name": "ace-workflows",
  "owner": {
    "name": "astrosteveo"
  },
  "plugins": [
    {
      "name": "ace-workflows",
      "description": "ACE-FCA workflow plugin: Research → Plan → Implement with intentional context compaction"
    }
  ]
}
```

---

## Phase 2: Agent Definitions

> Reference: `~/workspace/humanlayer/.claude/agents/` for source content

### Task 2.1: Create codebase-analyzer.md

**Files:**
- Create: `plugins/ace-workflows/agents/codebase-analyzer.md`
- Reference: `~/workspace/humanlayer/.claude/agents/codebase-analyzer.md`

**Content:** Adapt HumanLayer agent to plugin format:
- HOW code works
- Traces data flow, implementation details
- Returns structured analysis with file:line refs
- DOES NOT suggest improvements (documentarian)

### Task 2.2: Create codebase-locator.md

**Files:**
- Create: `plugins/ace-workflows/agents/codebase-locator.md`
- Reference: `~/workspace/humanlayer/.claude/agents/codebase-locator.md`

**Content:** Adapt HumanLayer agent:
- WHERE files live
- Directory structure, naming patterns
- Categorized file lists
- DOES NOT analyze code quality

### Task 2.3: Create codebase-pattern-finder.md

**Files:**
- Create: `plugins/ace-workflows/agents/codebase-pattern-finder.md`
- Reference: `~/workspace/humanlayer/.claude/agents/codebase-pattern-finder.md`

**Content:** Adapt HumanLayer agent:
- SIMILAR implementations
- Finds existing patterns, usage examples
- Concrete code examples with file:line refs
- DOES NOT evaluate approaches

### Task 2.4: Create thoughts-locator.md

**Files:**
- Create: `plugins/ace-workflows/agents/thoughts-locator.md`
- Reference: `~/workspace/humanlayer/.claude/agents/thoughts-locator.md`

**Content:** Adapt HumanLayer agent:
- FIND documents in thoughts/ directory
- Discovers tickets, research, plans, handoffs
- Returns list of relevant docs with paths

### Task 2.5: Create thoughts-analyzer.md

**Files:**
- Create: `plugins/ace-workflows/agents/thoughts-analyzer.md`
- Reference: `~/workspace/humanlayer/.claude/agents/thoughts-analyzer.md`

**Content:** Adapt HumanLayer agent:
- EXTRACT insights from documents
- Filters ruthlessly: decisions, constraints, rationale
- Key insights affecting current task
- DOES NOT provide summaries

### Task 2.6: Create web-search-researcher.md

**Files:**
- Create: `plugins/ace-workflows/agents/web-search-researcher.md`
- Reference: `~/workspace/humanlayer/.claude/agents/web-search-researcher.md`

**Content:** Adapt HumanLayer agent:
- EXTERNAL research
- APIs, versions, best practices
- Findings with source links
- Advanced search strategies

---

## Phase 3: Core Workflow Commands

> Reference: `~/workspace/humanlayer/.claude/commands/` for source content
> All commands use fully qualified names: `/ace-workflows:command-name`

### Task 3.1: Create research-codebase.md

**Files:**
- Create: `plugins/ace-workflows/commands/research-codebase.md`
- Reference: `~/workspace/humanlayer/.claude/commands/research_codebase.md`

**Content:** Adapt to plugin format:
- YAML frontmatter with description
- Spawns parallel sub-agents (codebase-locator, codebase-analyzer, codebase-pattern-finder, thoughts-locator)
- Synthesizes findings into research.md
- Human leverage point: review research
- Output: `thoughts/shared/research/YYYY-MM-DD-description.md`

### Task 3.2: Create create-plan.md

**Files:**
- Create: `plugins/ace-workflows/commands/create-plan.md`
- Reference: `~/workspace/humanlayer/.claude/commands/create_plan.md`

**Content:** Adapt to plugin format:
- YAML frontmatter
- Reads research.md (doesn't re-explore)
- Creates phased plan with automated/manual verification
- Interactive refinement loop
- Human leverage point: approve plan
- Output: `thoughts/shared/plans/YYYY-MM-DD-description.md`

### Task 3.3: Create implement-plan.md

**Files:**
- Create: `plugins/ace-workflows/commands/implement-plan.md`
- Reference: `~/workspace/humanlayer/.claude/commands/implement_plan.md`

**Content:** Adapt to plugin format:
- YAML frontmatter
- Executes phases sequentially
- Runs automated verification per phase
- Pauses for manual verification (human gate)
- Updates plan checkboxes

### Task 3.4: Create iterate-plan.md

**Files:**
- Create: `plugins/ace-workflows/commands/iterate-plan.md`
- Reference: `~/workspace/humanlayer/.claude/commands/iterate_plan.md`

**Content:** Adapt to plugin format:
- YAML frontmatter
- Updates existing plan based on feedback
- Surgical edits, preserves good content
- Re-runs sync after changes

### Task 3.5: Create validate-plan.md

**Files:**
- Create: `plugins/ace-workflows/commands/validate-plan.md`
- Reference: `~/workspace/humanlayer/.claude/commands/validate_plan.md`

**Content:** Adapt to plugin format:
- YAML frontmatter
- Verifies implementation against plan
- Runs all automated verification
- Identifies deviations
- Generates validation report

---

## Phase 4: Variant & Support Commands

### Task 4.1: Create create-plan-nt.md

**Files:**
- Create: `plugins/ace-workflows/commands/create-plan-nt.md`
- Reference: `~/workspace/humanlayer/.claude/commands/create_plan_nt.md`

**Content:** No-thoughts variant of create-plan:
- Skips thoughts-locator and thoughts-analyzer
- For projects without thoughts/ directory
- Otherwise same workflow

### Task 4.2: Create research-codebase-nt.md

**Files:**
- Create: `plugins/ace-workflows/commands/research-codebase-nt.md`
- Reference: `~/workspace/humanlayer/.claude/commands/research_codebase_nt.md`

**Content:** No-thoughts variant of research-codebase:
- Only spawns codebase agents (no thoughts agents)
- For projects without thoughts/ directory

### Task 4.3: Create iterate-plan-nt.md

**Files:**
- Create: `plugins/ace-workflows/commands/iterate-plan-nt.md`
- Reference: `~/workspace/humanlayer/.claude/commands/iterate_plan_nt.md`

**Content:** No-thoughts variant of iterate-plan

### Task 4.4: Create create-handoff.md

**Files:**
- Create: `plugins/ace-workflows/commands/create-handoff.md`
- Reference: `~/workspace/humanlayer/.claude/commands/create_handoff.md`

**Content:** Intentional compaction command:
- YAML frontmatter with metadata
- Distills progress: completed tasks, learnings, artifacts, next steps
- Output: `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS_description.md`
- Enables fresh context continuation

### Task 4.5: Create resume-handoff.md

**Files:**
- Create: `plugins/ace-workflows/commands/resume-handoff.md`
- Reference: `~/workspace/humanlayer/.claude/commands/resume_handoff.md`

**Content:** Resume from handoff:
- YAML frontmatter
- Reads handoff document
- Verifies codebase matches handoff state
- Spawns verification tasks
- Creates todo list for continuation

### Task 4.6: Create debug.md

**Files:**
- Create: `plugins/ace-workflows/commands/debug.md`
- Reference: `~/workspace/humanlayer/.claude/commands/debug.md`

**Content:** Debug issues:
- YAML frontmatter
- Investigates logs, state, git history
- Spawns parallel investigation tasks
- Generates debug report with root cause

---

## Phase 5: Hooks & Documentation

### Task 5.1: Create hooks.json

**Files:**
- Create: `plugins/ace-workflows/hooks/hooks.json`
- Reference: `~/workspace/claude-code-plugins/plugins/harness/hooks/hooks.json`

**Content:**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh\""
          }
        ]
      }
    ]
  }
}
```

### Task 5.2: Create session-start.sh

**Files:**
- Create: `plugins/ace-workflows/hooks/session-start.sh`

**Content:**
- Check for incomplete work in thoughts/shared/plans/
- Check for pending handoffs
- Surface "INCOMPLETE WORK DETECTED" if applicable
- Return JSON with hookSpecificOutput

### Task 5.3: Create README.md

**Files:**
- Create: `plugins/ace-workflows/README.md`

**Content:**
- Plugin overview
- Installation instructions
- Command reference table (all 11 commands fully qualified)
- Workflow diagram
- thoughts/ directory structure
- Agent descriptions
- ACE-FCA principles summary

---

## Success Criteria

### Automated Verification
- [ ] All directories exist: `ls plugins/ace-workflows/`
- [ ] plugin.json valid JSON: `cat plugins/ace-workflows/.claude-plugin/plugin.json | jq .`
- [ ] All 6 agents exist: `ls plugins/ace-workflows/agents/`
- [ ] All 11 commands exist: `ls plugins/ace-workflows/commands/`
- [ ] hooks.json valid: `cat plugins/ace-workflows/hooks/hooks.json | jq .`
- [ ] session-start.sh executable: `test -x plugins/ace-workflows/hooks/session-start.sh`

### Manual Verification
- [ ] Commands reference fully qualified names (`/ace-workflows:command-name`)
- [ ] Agent files have clear output format specifications
- [ ] Commands include YAML frontmatter with description
- [ ] README documents complete workflow
- [ ] Cross-references between commands use correct names

---

## What We're NOT Doing

- Git/CI commands (commit.md, describe_pr.md, etc.)
- Linear integration
- Oneshot modes
- Generic variants beyond _nt
- Full 28-command parity with HumanLayer
