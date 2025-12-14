# Explore-Plan-Implement Plugin

A Claude Code plugin implementing the **Frequent Intentional Compaction** workflow for effective AI-assisted development in complex codebases.

## The Problem

AI coding tools struggle with real production codebases. Common issues include:
- **Context exhaustion**: Agents fill their context window with grep/glob/read calls before getting to actual work
- **Slop accumulation**: AI-generated code often needs rework, diminishing productivity gains
- **Mental misalignment**: Teams lose track of what's changing and why when AI ships thousands of lines

## The Solution

This plugin structures AI-assisted development into deliberate phases with artifact documentation at each stage. By keeping context utilization at 40-60% and compacting learnings into reusable documents, you get:

- AI that works in **brownfield codebases** (large existing projects)
- Solutions to **complex multi-file problems**
- **No slop** (code that passes expert review)
- **Team alignment** through documented research and plans

## The Workflow

```
/explore → /plan → /implement → /validate → /commit
```

### 1. Explore (`/explore <feature-description>`)

Launches research agents to understand the problem space before writing any code.

**Agents launched:**
- **codebase-explorer** (always): Maps relevant files with `file:line` references. Documents facts only—no suggestions or critique.
- **docs-researcher** (conditional): Fetches external documentation. Only launched when the feature involves external libraries, security, or unfamiliar technology.

**Output:** `.claude/workflows/NNN-slug/research/`

### 2. Plan (`/plan`)

Creates a phased implementation plan based solely on research findings.

Each phase includes:
- Specific file changes with line numbers
- Automated verification steps (tests, lint, types)
- Manual verification checkpoints

**Output:** `.claude/workflows/NNN-slug/plans/implementation-plan.md`

### 3. Implement (`/implement [--phase N] [--continue]`)

Executes the approved plan phase-by-phase:
- One phase at a time
- Verification after each phase
- **STOPS if reality diverges from plan** — asks for guidance

**Output:** `.claude/workflows/NNN-slug/implementation/progress.md`

### 4. Validate (`/validate [--fix] [--skip-tests]`)

Auto-detects project type and runs comprehensive validation:
- Tests (npm/cargo/pytest/go test)
- Linting (eslint/clippy/ruff)
- Type checking (tsc/mypy/cargo check)
- Build verification

**Output:** `.claude/workflows/NNN-slug/validation/results.md`

### 5. Commit (`/commit [--amend]`)

Creates a well-documented commit including workflow artifacts for traceability.

## Artifact Structure

All workflow artifacts are stored together for future reference:

```
.claude/workflows/
└── 001-add-authentication/
    ├── state.md                    # Workflow state tracker
    ├── research/
    │   ├── codebase.md             # Internal codebase findings
    │   └── docs.md                 # External documentation (if researched)
    ├── plans/
    │   └── implementation-plan.md  # Phased plan with verification steps
    ├── implementation/
    │   └── progress.md             # Phase completion tracking
    └── validation/
        └── results.md              # Test/lint/build results
```

## The Leverage Hierarchy

```
Error in Research → 1000s of bad lines of code
Error in Plan     → 100s of bad lines of code
Error in Code     → ~1 bad line of code
```

**Focus your review attention on Research > Plan > Code.**

The highest-leverage human review happens at the research and planning phases. By the time you're reviewing code, errors are localized. But a misunderstanding in research cascades into a flawed plan, which generates hundreds of lines of wrong code.

## Installation

```bash
claude --plugin-dir /path/to/explore-plan-implement
```

## Context Management

The plugin is designed around context efficiency:

- **Background agents**: Research runs in background subagents to keep main context clean
- **Targeted exploration**: Agents use Grep before Glob, and read specific line ranges instead of entire files
- **Context reporting**: Each phase reports estimated utilization (`~XK / 200K tokens (Y%)`)
- **Compaction points**: Workflow naturally compacts at phase boundaries

**Optimal range:** 40-60% context utilization. Consider starting fresh at 80%+.

## Based On

This plugin implements the workflow described in [Frequent Intentional Compaction](.claude/rules/VISION.md) — a methodology for getting AI to work effectively in complex, brownfield codebases.
