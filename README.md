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
/epic:explore → /epic:plan → /epic:implement → /epic:validate → /epic:commit
```

### 1. Explore (`/epic:explore <feature-description>`)

Launches research agents to understand the problem space before writing any code.

**Agents launched:**
- **codebase-explorer** (always): Maps relevant files with `file:line` references. Documents facts only—no suggestions or critique.
- **docs-researcher** (conditional): Fetches external documentation. Only launched when the feature involves external libraries, security, or unfamiliar technology.

**Output:** `.claude/workflows/NNN-slug/codebase-research.md` (and `docs-research.md` if applicable)

### 2. Plan (`/epic:plan`)

Creates a phased implementation plan based solely on research findings.

Each phase includes:
- Specific file changes with line numbers
- Automated verification steps (tests, lint, types)
- Manual verification checkpoints

**Output:** `.claude/workflows/NNN-slug/plan.md`

### 3. Implement (`/epic:implement [--phase N] [--continue]`)

Executes the approved plan phase-by-phase:
- One phase at a time
- Verification after each phase
- **STOPS if reality diverges from plan** — asks for guidance

**Output:** Progress tracked in `.claude/workflows/NNN-slug/state.md`

### 4. Validate (`/epic:validate [--fix] [--skip-tests]`)

Auto-detects project type and runs comprehensive validation:
- Tests (npm/cargo/pytest/go test)
- Linting (eslint/clippy/ruff)
- Type checking (tsc/mypy/cargo check)
- Build verification

**Output:** `.claude/workflows/NNN-slug/validation.md`

### 5. Commit (`/epic:commit [--amend]`)

Creates a well-documented commit including workflow artifacts for traceability.

### 6. Handoff (`/epic:handoff [description]`)

Creates a structured handoff document for transferring work to another session. Captures current state, recent changes, learnings, and next steps.

**Output:** `.claude/handoffs/NNN-slug/YYYY-MM-DD_HH-MM-SS_description.md`

### 7. Resume (`/epic:resume [path]`)

Resumes work from a handoff document or workflow state. If no path provided, shows a picker with available workflows and handoffs.

## Artifact Structure

All workflow artifacts are stored in a flat structure:

```
.claude/workflows/
└── 001-add-authentication/
    ├── state.md              # Workflow state + progress tracking
    ├── codebase-research.md  # Internal codebase findings
    ├── docs-research.md      # External documentation (if researched)
    ├── plan.md               # Phased plan with verification steps
    └── validation.md         # Test/lint/build results

.claude/handoffs/
└── 001-add-authentication/
    └── 2025-01-15_14-30-22_phase2-complete.md  # Session handoff documents
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
- **Compaction points**: Workflow naturally compacts at phase boundaries
- **Handoff/Resume**: Transfer work between sessions without losing context

**Optimal range:** 40-60% context utilization. Consider starting fresh at 80%+.

## Based On

This plugin implements the workflow described in [Frequent Intentional Compaction](VISION.md) — a methodology for getting AI to work effectively in complex, brownfield codebases.
