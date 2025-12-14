---
feature: 003-add-compact-resume-commands
phase: research
topic: codebase
created: 2025-12-14
status: complete
---

# Codebase Analysis: Add /epic:handoff and /epic:resume Commands

**Date**: 2025-12-14
**Feature Slug**: 003-add-compact-resume-commands

## Goal

Understand the existing command structure, state management, artifact patterns, and workflow architecture to implement two new commands (`/epic:handoff` and `/epic:resume`) that enable the Frequent Intentional Compaction (FIC) methodology - allowing developers to save context checkpoints when reaching 40-60% utilization and resume work efficiently in fresh sessions.

## Summary

The epic plugin implements a structured workflow through five commands (explore, plan, implement, validate, commit) that create and manage artifacts in `.claude/workflows/NNN-slug/` directories. Each command follows a consistent pattern: locating active workflow state via `state.md`, reading relevant artifacts, executing operations, and updating state/artifacts. The new `/epic:handoff` and `/epic:resume` commands would fit seamlessly into this architecture by capturing context state between phases and restoring it efficiently.

## Relevant Files

### Command Definitions (Structure Reference)
| File | Lines | Purpose |
|------|-------|---------|
| `commands/explore.md` | 1-342 | Defines explore phase: launches subagents, creates workflow directory, initializes state.md |
| `commands/plan.md` | 1-232 | Defines plan phase: reads research, creates implementation plan, validates plan quality |
| `commands/implement.md` | 1-285 | Defines implement phase: executes plan phases, tracks progress, verifies each phase |
| `commands/validate.md` | 1-313 | Defines validate phase: runs tests/lint/build, writes validation results |
| `commands/commit.md` | 1-211 | Defines commit phase: stages changes, creates commit with artifacts |

### Plugin Configuration
| File | Lines | Purpose |
|------|-------|---------|
| `.claude-plugin/plugin.json` | 1-27 | Manifest defining command and agent entry points |
| `CLAUDE.md` | 1-100+ | Project documentation including workflow overview and principles |

### Artifact Templates
| File | Lines | Purpose |
|------|-------|---------|
| `templates/state.md` | 1-27 | Template for workflow state file tracking phase status and task IDs |
| `templates/progress.md` | 1-62 | Template for implementation progress tracking during /implement phase |
| `templates/implementation-plan.md` | 1-80 | Template for detailed phased implementation plans |
| `templates/codebase.md` | 1-49 | Template for codebase research output from codebase-explorer agent |
| `templates/docs.md` | [exists] | Template for external documentation research |
| `templates/validation-results.md` | [exists] | Template for validation phase results |

## Code Flow

### Workflow State Location and Discovery
```
User runs command → Command finds .claude/workflows/*/state.md
                  → Reads feature directory path from state.md
                  → Uses path to access artifacts at root level
```

**Key Pattern**: All commands follow step 1 "Locate Active Feature" which uses glob pattern:
```
.claude/workflows/*/state.md
```

This is documented in:
- `commands/explore.md:37` - Creates state.md after initializing directory
- `commands/plan.md:21-29` - Locates and reads state.md
- `commands/implement.md:31-38` - Locates and reads state.md
- `commands/validate.md:28-35` - Locates and reads state.md
- `commands/commit.md:20-32` - Locates and reads state.md

### State Management Pattern

**state.md Fields** (from `templates/state.md`):
```markdown
---
feature: {{SLUG}}
current_phase: {{PHASE}}
created: {{DATE}}
last_updated: {{DATE}}
---

# Workflow State: {{FEATURE}}

## Phase Status
| Phase | Status | Artifact |
| Explore | pending/complete | *-research.md |
| Plan | pending/complete | plan.md |
| Implement | pending/in_progress/complete | (this file) |
| Validate | pending/complete | validation.md |
| Commit | pending/complete | git commit |

## Current Progress
...

## Blockers
...

## Next Steps
...
```

**State Update Pattern**: Every command updates state.md at specific points.

### Artifact Organization (Flat Structure)

**Directory Structure**:
```
.claude/workflows/NNN-slug/
├── state.md              # Current phase, progress, status
├── plan.md               # Implementation plan
├── {topic}-research.md   # Research artifacts
└── validation.md         # Test/lint/build results
```

### Progress Tracking

Progress is tracked directly in the `state.md` file under the "Current Progress" section, eliminating the need for a separate progress.md file.

## Design Decisions

### 1. Flatten Directory Structure
**Decision**: No subdirectories per phase. All artifacts at workflow root.

### 2. Combine state.md + progress.md
**Decision**: Merge into single `state.md` with progress tracking section.

### 3. Research File Naming
**Decision**: Use `{topic}-research.md` pattern with frontmatter metadata.

### 4. Handoffs in Shared Location
**Decision**: Handoffs stored at `.claude/handoffs/NNN-slug/`.

### 5. Frontmatter for All Artifacts
**Decision**: Each artifact has YAML frontmatter for self-describing metadata.

### 6. Command Naming
**Decision**: Use "handoff" terminology (clearer intent than "compact").
- `/epic:handoff` - Create handoff document for session transfer
- `/epic:resume <path>` - Resume from a specific handoff document

### 7. Resume UX
**Decision**: Use AskUserQuestion for workflow/handoff selection.
- `/epic:resume` with no argument → shows picker via AskUserQuestion
- `/epic:resume <path>` with explicit path → loads that handoff directly

## Integration Points

### Where /epic:handoff Fits
1. **During any phase** - Can be invoked mid-phase when context reaches 60%
2. **Reads current state** - Uses same `.claude/workflows/*/state.md` discovery
3. **Creates handoff artifact** - Saves to `.claude/handoffs/NNN-slug/`
4. **Updates state.md** - Records timestamp
5. **Output context estimation** - Like all other commands

### Where /epic:resume Fits
1. **At session start** - Used to load artifacts from previous session
2. **Loads state.md** - Uses same discovery pattern
3. **Reads all relevant artifacts** - Based on current phase
4. **Restores context efficiently** - Loads only necessary artifacts
5. **Presents summary** - Shows what was loaded and next steps

## Template Reference for Output

Commands follow patterns from existing commands:

**Command definition location**: `commands/handoff.md` and `commands/resume.md`

**Required sections**:
1. YAML frontmatter with description, allowed-tools
2. Command description
3. Input/Arguments explanation
4. Process section with numbered steps
5. Output Format section with Success/Blocked/Incomplete examples
