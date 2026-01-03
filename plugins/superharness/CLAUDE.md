# SUPERHARNESS - Claude Code Plugin

**ARE YOU HARNESSING THE FULL POWER OF CLAUDE CODE?**

SUPERHARNESS is a command-driven development workflow that merges the best of **ace-workflows** (command structure, handoffs, context engineering) and **harness** (TDD, research-first, verification, systematic debugging).

## Architecture

**Baseline**: ace-workflows (command-based, explicit user intent)
**Disciplines**: harness (TDD, research-first, verification, debugging)
**Directory**: `.harness/` (brand identity)

## Core Concepts

### Command-Based Architecture

Users explicitly choose their stage:
- `/superharness:research` - Before building anything
- `/superharness:create-plan` - Design with 3 architecture options
- `/superharness:implement` - Execute with TDD and phase gates
- `/superharness:validate` - Verify with evidence
- `/superharness:debug` - 4-phase systematic debugging

### Skill Loading

Commands load discipline skills via frontmatter:

```yaml
---
name: implement
load-skills:
  - tdd
  - verification
---
```

### Foundation Skill

`skills/superharness-core/SKILL.md` is injected at every session start via the session hook. This is what makes discipline enforcement work.

### Progress Tracking

Uses git commit trailers AND plan checkboxes (kept in sync):

```bash
git commit -m "feat: complete Phase 2

phase(2): complete"
```

The session hook detects incomplete work via these trailers.

## Directory Structure

```
.harness/
├── BACKLOG.md                    # Bugs, deferred features, tech debt
├── dashboard.md                  # Recommendations (session hook reads this)
├── NNN-feature-slug/             # Per-feature work
│   ├── research.md               # Codebase + external research
│   ├── plan.md                   # Phased implementation plan
│   ├── handoff.md                # Context handoff (if paused)
│   └── archive/                  # Resolved handoffs (optional)
└── handoffs/                     # Cross-feature handoffs
    ├── YYYY-MM-DD_HH-MM-SS_description.md
    └── archive/                  # Resolved handoffs (optional)
```

## Repository Structure

```
superharness/
├── .claude-plugin/
│   ├── plugin.json               # Plugin metadata
│   └── marketplace.json          # Marketplace config
├── commands/                     # 12 commands
│   ├── research.md
│   ├── create-plan.md
│   ├── implement.md
│   ├── validate.md
│   ├── iterate.md
│   ├── debug.md
│   ├── gamedev.md
│   ├── handoff.md
│   ├── resume.md
│   ├── resolve.md                # NEW: Resolve handoff lifecycle
│   ├── backlog.md
│   └── status.md
├── agents/                       # 8 agents
│   ├── codebase-locator.md
│   ├── codebase-analyzer.md
│   ├── codebase-pattern-finder.md
│   ├── web-researcher.md
│   ├── spec-reviewer.md
│   ├── code-quality-reviewer.md
│   ├── harness-locator.md
│   └── harness-analyzer.md
├── skills/                       # Loadable disciplines
│   ├── INDEX.md
│   ├── superharness-core/SKILL.md  # Foundation (session start)
│   ├── tdd/SKILL.md
│   ├── research-first/SKILL.md
│   ├── verification/SKILL.md
│   └── systematic-debugging/SKILL.md
├── hooks/
│   ├── hooks.json
│   ├── session-start.sh
│   └── test-session-start.sh     # Hook testing script
├── templates/
│   ├── plan-template.md
│   ├── research-template.md
│   ├── handoff-template.md
│   └── backlog-template.md
├── CLAUDE.md                     # This file
├── README.md                     # User documentation
├── CHANGELOG.md                  # Version history
└── LICENSE                       # MIT
```

## Key Commands

| Command | Purpose | Skills Loaded |
|---------|---------|---------------|
| `research` | Codebase + external research | research-first |
| `create-plan` | 3-option architecture + phased plan | research-first |
| `implement` | TDD execution with phase gates | tdd, verification |
| `validate` | Evidence-based verification | verification |
| `debug` | 4-phase systematic debugging | systematic-debugging, tdd |
| `gamedev` | Playtesting gates (not TDD) | - |
| `handoff` | Create context handoff checkpoint | verification |
| `resume` | Resume from handoff (picker + lifecycle) | - |
| `resolve` | Resolve handoff (complete/supersede/abandon) | - |

## Session Hook

The session hook (`hooks/session-start.sh`):

1. Injects foundation skill content wrapped in `<EXTREMELY_IMPORTANT>`
2. Detects incomplete work via git trailers
3. Detects pending handoffs (< 7 days, not resolved)
4. Surfaces recommendations from BACKLOG.md
5. Shows brand message if nothing to surface

## Handoff Lifecycle

Handoffs are checkpoints that preserve context across sessions.

**Lifecycle states:**
- **Pending**: Handoff exists, < 7 days old, not resolved
- **Resolved**: Git trailer `handoff: <path>` exists
- **Abandoned**: Git trailer `handoff-abandoned: <path>` exists
- **Archived**: Moved to `archive/` subdirectory

**Resolution via git trailers:**
```bash
# Resolve (complete or superseded)
git commit --allow-empty -m "chore: resolve handoff

handoff: .harness/001-auth/handoff.md
reason: complete"

# Abandon
git commit --allow-empty -m "chore: abandon handoff

handoff-abandoned: .harness/001-auth/handoff.md
reason: approach changed"
```

**Primary interface:** `/superharness:resume`
- No args: Picker dialog shows pending handoffs
- Completion flow: Prompts to resolve when done
- Checkpoint mode: Creates new handoff, auto-resolves old one

## Development Guidelines

### Adding Commands

1. Create `commands/new-command.md` with frontmatter
2. Add `load-skills` if discipline needed
3. Update README.md

### Adding Skills

1. Create `skills/new-skill/SKILL.md`
2. Add to `skills/INDEX.md`
3. Reference in command frontmatter

### Modifying Session Hook

1. Edit `hooks/session-start.sh`
2. Test with: `./hooks/session-start.sh`
3. Verify JSON output format

## Release Process

1. **Version bump**: Update `.claude-plugin/plugin.json`
2. **Changelog**: Update `CHANGELOG.md`
3. **Tag**: `git tag -a v0.X.Y -m "v0.X.Y - Description"`
4. **Push**: `git push origin main --tags`

## Philosophy

1. **Research First** - Training data is stale. Verify before building.
2. **TDD Always** - No production code without failing test first.
3. **Evidence Over Claims** - Run verification, show output.
4. **Systematic Debugging** - Root cause first, no random fixes.
5. **Context Compaction** - Handoffs preserve knowledge across sessions.

## Origins

SUPERHARNESS merges:
- **ace-workflows** by AstroSteveo - ACE-FCA context engineering
- **harness** by AstroSteveo (fork of obra/superpowers) - Disciplined development

Both philosophies combined create something greater than either alone.
