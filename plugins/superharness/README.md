# SUPERHARNESS

**ARE YOU HARNESSING THE FULL POWER OF CLAUDE CODE?**

SUPERHARNESS is a command-driven development workflow plugin for Claude Code. It combines structured planning, TDD enforcement, and context handoffs into a cohesive system.

## Installation

```bash
claude plugins add superharness
```

## Quick Start

```bash
# Research before building
/superharness:research "How does authentication work in this codebase?"

# Create a plan with 3 architecture options
/superharness:create-plan .harness/001-auth/research.md

# Implement with TDD and phase gates
/superharness:implement .harness/001-auth/plan.md

# Validate with evidence
/superharness:validate .harness/001-auth/plan.md

# Create handoff before ending session
/superharness:handoff
```

## Commands

| Command | Purpose |
|---------|---------|
| `/superharness:research` | Research codebase + external sources before planning |
| `/superharness:create-plan` | Create phased implementation plan with 3 architecture options |
| `/superharness:implement` | Execute plan with TDD and phase gates |
| `/superharness:validate` | Verify implementation matches spec with evidence |
| `/superharness:iterate` | Update existing plan based on feedback |
| `/superharness:debug` | 4-phase systematic debugging (root cause first) |
| `/superharness:gamedev` | Game development with playtesting gates |
| `/superharness:handoff` | Create context handoff checkpoint |
| `/superharness:resume` | Resume from handoff (picker dialog + lifecycle management) |
| `/superharness:resolve` | Resolve handoff (complete, supersede, or abandon) |
| `/superharness:backlog` | View/manage bugs, features, tech debt |
| `/superharness:status` | Show current progress and recommendations |

## Core Principles

### 1. Research First
Training data may be 2+ years stale. Always verify current library versions, API signatures, and best practices before making design decisions.

### 2. TDD Mandatory
For every implementation task:
1. Write failing test FIRST
2. Run test, verify RED
3. Write minimal code to pass
4. Run test, verify GREEN
5. Refactor if needed

No production code without a failing test first.

### 3. Evidence Before Completion
Run verification commands fresh. Show actual output. No "should work" or "probably passes" language.

### 4. Systematic Debugging
4-phase process:
1. **Root Cause Investigation** - Gather evidence
2. **Pattern Analysis** - Compare working vs broken
3. **Hypothesis Testing** - One change at a time
4. **Implementation** - TDD for regression test

No random fixes. Find root cause first.

### 5. Context Compaction
When context is filling up, create a handoff document. This preserves learnings and enables clean session continuation.

## Directory Structure

SUPERHARNESS stores all work in `.harness/`:

```
.harness/
├── BACKLOG.md                    # Bugs, deferred features, tech debt
├── 001-feature-name/             # Per-feature work
│   ├── research.md               # Codebase + external research
│   ├── plan.md                   # Phased implementation plan
│   └── handoff.md                # Context handoff (optional)
└── handoffs/                     # Cross-feature handoffs
    └── YYYY-MM-DD_HH-MM-SS_description.md
```

## Progress Tracking

Phases are tracked via git commit trailers:

```bash
git commit -m "feat: complete Phase 2 - Authentication

Implemented OAuth login flow.

phase(2): complete"
```

Plan checkboxes are kept in sync with git trailers. The session hook detects incomplete work automatically.

## Workflow Examples

### New Feature

```
1. /superharness:research "user authentication"
   → Creates .harness/001-auth/research.md

2. /superharness:create-plan .harness/001-auth/research.md
   → Presents 3 architecture options
   → Creates .harness/001-auth/plan.md

3. /superharness:implement .harness/001-auth/plan.md
   → Executes phases with TDD
   → Commits with phase(N): complete trailers
   → Pauses at human gates

4. /superharness:validate .harness/001-auth/plan.md
   → Runs all verification commands
   → Shows evidence
```

### Debugging

```
1. /superharness:debug "API returning 500 errors"
   → Phase 1: Gathers evidence (logs, git, state)
   → Phase 2: Compares working vs broken
   → Phase 3: Forms and tests hypothesis
   → Phase 4: Proposes TDD fix
```

### Session Handoff

```
1. /superharness:handoff
   → Creates .harness/001-auth/handoff.md
   → Documents progress, learnings, next steps

2. (New session)
   → Session hook detects pending handoff
   → Prompts: "Resume? [Yes / No / Abandon]"

3. /superharness:resume
   → Shows picker dialog with pending handoffs
   → Select one to resume
   → Verifies state matches handoff
   → Continues work

4. (Work complete)
   → Prompts: "Complete / Checkpoint / Keep Open"
   → Complete: Resolves handoff via git trailer
   → Checkpoint: Creates new handoff, supersedes old
   → Keep Open: Leaves pending for next session
```

### Handoff Lifecycle

Handoffs are checkpoints that can be:
- **Resolved**: Work complete, marked via `handoff:` git trailer
- **Superseded**: Replaced by newer handoff (auto-resolved)
- **Abandoned**: Cancelled via `handoff-abandoned:` git trailer
- **Archived**: Moved to `archive/` subdirectory for cleanup

### Game Development

```
1. /superharness:gamedev "2D platformer with tight controls"
   → Creates GDD at .harness/001-platformer/gdd.md
   → Creates plan with playtesting gates
   → Focuses on core mechanic feel first
```

## Session Hook

When you start a session, SUPERHARNESS:

1. **Detects incomplete work** - Shows plans with incomplete phases
2. **Surfaces recommendations** - Priority items from BACKLOG.md
3. **Prompts for action** - Resume previous work or start fresh

## Game Development

For games, use `/superharness:gamedev` instead of the standard workflow. Key differences:

- **Playtesting gates** replace TDD (can't automate "is this fun?")
- **Feel-first design** - Core mechanic must feel good before features
- **Reference game research** - Study what works in similar games

## License

MIT

## Credits

SUPERHARNESS merges ideas from:
- **ace-workflows** - ACE-FCA context engineering
- **harness** - Disciplined development (fork of obra/superpowers)

Both by AstroSteveo.
