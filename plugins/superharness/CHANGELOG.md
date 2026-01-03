# Changelog

All notable changes to SUPERHARNESS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Removed
- `spec-reviewer` agent (unused)
- `code-quality-reviewer` agent (unused)

## [0.1.0] - 2026-01-02

### Added

#### Commands (12 total)
- `/superharness:research` - Codebase + external research before planning
- `/superharness:create-plan` - Create phased implementation plan with 3-option architecture
- `/superharness:implement` - Execute plan with TDD and phase gates
- `/superharness:validate` - Verify implementation matches spec
- `/superharness:iterate` - Update existing plans based on feedback
- `/superharness:debug` - 4-phase systematic debugging
- `/superharness:gamedev` - Game development with playtesting gates (not TDD)
- `/superharness:handoff` - Create context handoff document
- `/superharness:resume` - Resume from handoff
- `/superharness:resolve` - Resolve handoff (complete, supersede, or abandon)
- `/superharness:backlog` - View/manage bugs, deferred features, tech debt
- `/superharness:status` - Show current progress and recommendations

#### Skills (5 total)
- `superharness-core` - Foundation skill injected at session start
- `tdd` - Test-Driven Development (RED-GREEN-REFACTOR)
- `research-first` - Research before design
- `verification` - Evidence before completion claims
- `systematic-debugging` - 4-phase root cause analysis

#### Agents (8 total)
- `codebase-locator` - Find WHERE files are (paths only)
- `codebase-analyzer` - Analyze HOW code works (file:line refs)
- `codebase-pattern-finder` - Find SIMILAR implementations
- `web-researcher` - External API/version verification
- `spec-reviewer` - Plan compliance verification
- `code-quality-reviewer` - Quality review with confidence score
- `harness-locator` - Find .harness/ documents
- `harness-analyzer` - Extract insights from .harness/

#### Session Hook
- Foundation skill injection with `<EXTREMELY_IMPORTANT>` wrapper
- Incomplete work detection via git trailers
- Handoff detection (< 7 days old)
- Dashboard/backlog recommendations
- Brand message fallback

#### Templates
- `plan-template.md` - Phased implementation plan
- `research-template.md` - Codebase + external research
- `handoff-template.md` - Context handoff document
- `backlog-template.md` - Bug/feature/debt tracking

### Architecture

- Command-based workflow (from ace-workflows)
- `.harness/` directory structure (brand identity)
- `load-skills` frontmatter for discipline injection
- Git trailers for progress tracking (`phase(N): complete`)
- Checkbox/trailer sync for human/machine views

### Origins

SUPERHARNESS merges:
- **ace-workflows** by AstroSteveo - ACE-FCA context engineering, command structure
- **harness** by AstroSteveo (fork of obra/superpowers) - TDD, research-first, verification

[Unreleased]: https://github.com/astrosteveo/superharness/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/astrosteveo/superharness/releases/tag/v0.1.0
