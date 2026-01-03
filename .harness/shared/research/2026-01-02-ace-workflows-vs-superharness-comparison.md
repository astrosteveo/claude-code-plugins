---
date: 2026-01-02T23:00:50-06:00
researcher: Claude
git_commit: 17a1f65cf095c68d0b1abda15ad5eaf3d8bafddb
branch: main
repository: claude-code-plugins
topic: "Comparison of ace-workflows and superharness plugins"
tags: [research, plugins, ace-workflows, superharness, comparison]
status: complete
last_updated: 2026-01-02
last_updated_by: Claude
---

# Research: ace-workflows vs superharness Plugin Comparison

**Date**: 2026-01-02T23:00:50-06:00
**Researcher**: Claude
**Git Commit**: 17a1f65cf095c68d0b1abda15ad5eaf3d8bafddb
**Branch**: main
**Repository**: claude-code-plugins

## Research Question

Compare the ace-workflows plugin against the superharness plugin.

## Summary

Both plugins provide structured development workflows for Claude Code, but they have different origins, philosophies, and feature sets:

| Aspect | ace-workflows | superharness |
|--------|---------------|--------------|
| **Origin** | Adapted from HumanLayer's `.claude` implementation | Merge of ace-workflows + harness disciplines |
| **Commands** | 27 commands | 11 commands |
| **Agents** | 6 agents | 8 agents |
| **Skills** | None (disciplines embedded in commands) | 5 loadable skills |
| **Templates** | None | 4 templates |
| **TDD** | Not enforced | Mandatory (iron law) |
| **Linear Integration** | Deep integration (6 commands) | None |
| **Game Development** | None | Dedicated gamedev command |
| **State Directory** | `.harness/` | `.harness/` |

## Detailed Findings

### 1. Plugin Architecture

#### ace-workflows
**Location**: `plugins/ace-workflows/`

- **Plugin Configuration**: No plugin.json or marketplace.json present
- **Directory Structure**:
  - `commands/` - 27 command definitions
  - `agents/` - 6 sub-agent definitions
  - `hooks/` - Session start hook
  - `README.md` - Documentation

#### superharness
**Location**: `plugins/superharness/`

- **Plugin Configuration**:
  - `plugin.json` - Version 0.1.0, author Steven Mosley
  - `marketplace.json` - Listed as "superharness-dev"
- **Directory Structure**:
  - `commands/` - 11 command definitions
  - `agents/` - 8 sub-agent definitions
  - `skills/` - 5 loadable discipline definitions
  - `templates/` - 4 document templates
  - `hooks/` - Session start hook
  - `CLAUDE.md` - Developer documentation
  - `README.md` - User documentation
  - `CHANGELOG.md` - Version history

### 2. Command Comparison

#### Core Workflow Commands

| Workflow Stage | ace-workflows | superharness |
|----------------|---------------|--------------|
| Research | `/ace-workflows:research-codebase` | `/superharness:research` |
| Planning | `/ace-workflows:create-plan` | `/superharness:create-plan` |
| Implementation | `/ace-workflows:implement-plan` | `/superharness:implement` |
| Validation | `/ace-workflows:validate-plan` | `/superharness:validate` |
| Iteration | `/ace-workflows:iterate-plan` | `/superharness:iterate` |
| Debugging | `/ace-workflows:debug` | `/superharness:debug` |
| Handoff Create | `/ace-workflows:create-handoff` | `/superharness:handoff` |
| Handoff Resume | `/ace-workflows:resume-handoff` | `/superharness:resume` |

#### ace-workflows Unique Commands (19)

**No-Thoughts Variants (3):**
- `/ace-workflows:research-codebase-nt` - Research without `.harness/` directory
- `/ace-workflows:create-plan-nt` - Planning without `.harness/` directory
- `/ace-workflows:iterate-plan-nt` - Iteration without `.harness/` directory

**Generic Variants (2):**
- `/ace-workflows:research-codebase-generic` - Research without project conventions
- `/ace-workflows:create-plan-generic` - Planning without project conventions

**Linear Integration (6):**
- `/ace-workflows:linear` - Manage Linear tickets (create, update, comment)
- `/ace-workflows:ralph-research` - Research highest priority Linear ticket
- `/ace-workflows:ralph-plan` - Create plan for highest priority ticket
- `/ace-workflows:ralph-impl` - Implement highest priority small ticket
- `/ace-workflows:oneshot` - Research ticket and launch planning session
- `/ace-workflows:oneshot-plan` - Execute plan and implementation for ticket

**Git/PR Commands (5):**
- `/ace-workflows:commit` - Interactive commit with user approval
- `/ace-workflows:ci-commit` - Automated commit (no approval)
- `/ace-workflows:describe-pr` - Generate PR description
- `/ace-workflows:ci-describe-pr` - CI-focused PR description
- `/ace-workflows:describe-pr-nt` - PR description without thoughts

**Worktree/Review (2):**
- `/ace-workflows:create-worktree` - Create worktree for isolated development
- `/ace-workflows:local-review` - Set up worktree for reviewing colleague's branch

**Special (1):**
- `/ace-workflows:founder-mode` - Create ticket and PR for experimental features

#### superharness Unique Commands (3)

- `/superharness:gamedev` - Game development with playtesting gates
- `/superharness:backlog` - Manage bugs, features, tech debt
- `/superharness:status` - Show current progress and recommendations

### 3. Agent Comparison

| Purpose | ace-workflows | superharness |
|---------|---------------|--------------|
| File Location | `codebase-locator` | `codebase-locator` |
| Code Analysis | `codebase-analyzer` | `codebase-analyzer` |
| Pattern Finding | `codebase-pattern-finder` | `codebase-pattern-finder` |
| Thoughts Location | `thoughts-locator` | `harness-locator` |
| Thoughts Analysis | `thoughts-analyzer` | `harness-analyzer` |
| Web Research | `web-search-researcher` | `web-researcher` |
| Spec Review | - | `spec-reviewer` |
| Quality Review | - | `code-quality-reviewer` |

**Key Differences:**
- ace-workflows uses "thoughts" terminology; superharness uses "harness"
- superharness adds `spec-reviewer` and `code-quality-reviewer` agents for verification

### 4. Skills System (superharness only)

superharness implements a skill loading system where commands declare which skills to inject:

| Skill | Purpose | Used By |
|-------|---------|---------|
| `superharness-core` | Foundation philosophy, decision tree | Session hook (all sessions) |
| `tdd` | Test-driven development enforcement | `implement`, `debug` |
| `research-first` | Research before design enforcement | `research`, `create-plan`, `iterate` |
| `verification` | Evidence before completion | `validate`, `implement`, `handoff` |
| `systematic-debugging` | 4-phase root cause analysis | `debug` |

Each skill contains "iron laws" that enforce strict discipline:
- **TDD**: "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST"
- **Research-First**: "NO DESIGNING UNTIL RESEARCH IS COMPLETE"
- **Verification**: "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE"
- **Systematic Debugging**: "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST"

ace-workflows embeds these disciplines directly in command prompts rather than as separate loadable modules.

### 5. Session Hook Behavior

#### ace-workflows (`hooks/session-start.sh`)

1. Checks for incomplete plans in `.harness/shared/plans/*.md`
2. Checks for pending handoffs in `.harness/shared/handoffs/*.md` (< 7 days old)
3. Builds work notification with resume suggestions
4. Outputs available ace-workflows commands

#### superharness (`hooks/session-start.sh`)

1. Checks for incomplete plans using git commit trailers (`phase(N): complete`)
2. Checks for pending handoffs (< 7 days old)
3. Reads dashboard/backlog for recommendations
4. **Injects foundation skill** (`superharness-core`) into every session
5. Forces user to respond to incomplete work before proceeding

**Key Difference**: superharness uses git commit trailers for progress tracking, while ace-workflows checks plan checkboxes directly.

### 6. Progress Tracking

| Aspect | ace-workflows | superharness |
|--------|---------------|--------------|
| Phase Completion | Plan checkboxes (`- [x]`) | Git trailers + checkboxes |
| Verification | Checkbox sync | Trailer-checkbox sync validation |
| Commit Format | Standard | `phase(N): complete` trailer required |

### 7. Directory Structure

Both plugins use `.harness/` for state persistence:

#### ace-workflows
```
.harness/
├── shared/
│   ├── research/      # Research documents
│   ├── plans/         # Implementation plans
│   ├── handoffs/      # Session handoffs
│   ├── tickets/       # Linear ticket snapshots
│   └── prs/           # PR descriptions
├── [username]/        # Personal notes
├── global/            # Cross-repo thoughts
└── searchable/        # Read-only search index
```

#### superharness
```
.harness/
├── BACKLOG.md         # Bugs, features, debt, improvements
├── dashboard.md       # Recommendations (optional)
├── NNN-feature-slug/  # Per-feature directories
│   ├── research.md
│   ├── plan.md
│   └── handoff.md
└── handoffs/          # Cross-feature handoffs
    └── YYYY-MM-DD_HH-MM-SS_description.md
```

**Key Difference**: ace-workflows uses shared subdirectories; superharness uses numbered feature directories and includes a BACKLOG.md at root.

### 8. Model Preferences

Both plugins specify models for commands:

| Model | ace-workflows Usage | superharness Usage |
|-------|--------------------|--------------------|
| opus | Research, planning commands | Not specified (likely inherited) |
| sonnet | Sub-agents, ralph-impl | Not specified |
| (default) | Implementation, validation | Most commands |

### 9. Unique Features

#### ace-workflows Only
- **Linear Integration**: Deep workflow integration with Linear ticket management
- **Worktree Management**: Commands for isolated development environments
- **No-Thoughts Variants**: Commands that work without `.harness/` directory
- **Generic Variants**: Commands without project-specific conventions
- **CI Commands**: Automated commit and PR description for CI environments
- **Founder Mode**: Quick path from experimental code to ticket and PR

#### superharness Only
- **Skills System**: Loadable discipline modules with frontmatter declaration
- **TDD Enforcement**: Mandatory test-first development (iron law)
- **Game Development**: Dedicated gamedev command with playtesting gates
- **Backlog Management**: Built-in bug/feature/debt tracking
- **Status Command**: Progress overview with recommendations
- **Templates**: Standardized document formats
- **Quality Review Agents**: Spec compliance and code quality verification

## Architecture Documentation

### Design Philosophy Comparison

| Principle | ace-workflows | superharness |
|-----------|---------------|--------------|
| Research First | Yes (commands) | Yes (enforced by skill) |
| TDD | Encouraged | Mandatory (iron law) |
| Evidence-Based | Yes | Yes (iron law) |
| Human Gates | Yes | Yes |
| Context Compaction | Yes (handoffs) | Yes (handoffs) |
| Systematic Debugging | Yes | Yes (4-phase process) |
| Disciplinary Enforcement | Embedded in commands | Loadable skills |

### Integration Points

- **ace-workflows** is designed for HumanLayer's ecosystem with:
  - `humanlayer` CLI integration
  - Linear ticket management
  - Cross-repo thoughts via `humanlayer thoughts sync`
  - Worktree-based development

- **superharness** is designed as a standalone plugin with:
  - Git trailer-based progress tracking
  - Built-in backlog management
  - Game development support
  - Quality review agents

## Code References

### ace-workflows
- `plugins/ace-workflows/commands/` - 27 command definitions
- `plugins/ace-workflows/agents/` - 6 agent definitions
- `plugins/ace-workflows/hooks/session-start.sh` - Session hook
- `plugins/ace-workflows/README.md` - Documentation

### superharness
- `plugins/superharness/.claude-plugin/plugin.json` - Plugin configuration
- `plugins/superharness/commands/` - 11 command definitions
- `plugins/superharness/agents/` - 8 agent definitions
- `plugins/superharness/skills/` - 5 skill definitions
- `plugins/superharness/templates/` - 4 templates
- `plugins/superharness/hooks/session-start.sh` - Session hook
- `plugins/superharness/CLAUDE.md` - Developer docs
- `plugins/superharness/README.md` - User docs

## Summary Comparison Table

| Feature | ace-workflows | superharness |
|---------|---------------|--------------|
| Commands | 27 | 11 |
| Agents | 6 | 8 |
| Skills | 0 | 5 |
| Templates | 0 | 4 |
| Linear Integration | Yes (6 commands) | No |
| Worktree Support | Yes (2 commands) | No |
| No-Thoughts Mode | Yes (3 variants) | No |
| Generic Mode | Yes (2 variants) | No |
| CI Commands | Yes (2 commands) | No |
| TDD Enforcement | No | Yes (mandatory) |
| Gamedev Support | No | Yes |
| Backlog Management | No | Yes |
| Status Command | No | Yes |
| Quality Review Agents | No | Yes (2 agents) |
| Plugin Metadata | No | Yes |
| Changelog | No | Yes |

## Open Questions

1. Could the plugins be merged or used together?
2. Would ace-workflows benefit from a skills system?
3. Would superharness benefit from Linear integration?
4. How do users choose between the two plugins?
