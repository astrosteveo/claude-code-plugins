---
date: 2026-01-02T00:00:00Z
researcher: Claude
topic: "SUPERHARNESS Plugin Build - COMPLETE"
tags: [handoff, superharness, plugin-build, complete]
status: complete
---

# Handoff: SUPERHARNESS Plugin Build - COMPLETE

## Overview

SUPERHARNESS is now complete! A Claude Code plugin that merges ace-workflows and harness into a command-driven development workflow with TDD enforcement, research-first planning, and context handoffs.

## Task Status

- **Completed**: ALL PHASES (1, 5, 6, 7, 8)
- **Status**: READY FOR USE

## Phase Progress

- [x] Phase 1: Foundation - COMPLETE
- [x] Phase 2: Core Commands (merged into Phase 1) - COMPLETE
- [x] Phase 3: Supporting Commands (merged into Phase 1) - COMPLETE
- [x] Phase 4: Utility Commands (merged into Phase 1) - COMPLETE
- [x] Phase 5: Skills (discipline content) - COMPLETE
- [x] Phase 6: Agents (8 total) - COMPLETE
- [x] Phase 7: Session Hook - COMPLETE
- [x] Phase 8: Templates & Docs - COMPLETE

---

## Final Plugin Structure

```
plugins/superharness/
├── .claude-plugin/
│   ├── plugin.json              ✓
│   └── marketplace.json         ✓
├── commands/                    ✓ 11 commands
│   ├── research.md
│   ├── create-plan.md
│   ├── implement.md
│   ├── validate.md
│   ├── iterate.md
│   ├── debug.md
│   ├── gamedev.md
│   ├── handoff.md
│   ├── resume.md
│   ├── backlog.md
│   └── status.md
├── agents/                      ✓ 8 agents
│   ├── codebase-locator.md
│   ├── codebase-analyzer.md
│   ├── codebase-pattern-finder.md
│   ├── web-researcher.md
│   ├── spec-reviewer.md
│   ├── code-quality-reviewer.md
│   ├── harness-locator.md
│   └── harness-analyzer.md
├── skills/                      ✓ 5 skills
│   ├── INDEX.md
│   ├── superharness-core/SKILL.md
│   ├── tdd/SKILL.md
│   ├── research-first/SKILL.md
│   ├── verification/SKILL.md
│   └── systematic-debugging/SKILL.md
├── hooks/                       ✓ Session hook
│   ├── hooks.json
│   └── session-start.sh
├── templates/                   ✓ 4 templates
│   ├── plan-template.md
│   ├── research-template.md
│   ├── handoff-template.md
│   └── backlog-template.md
├── CLAUDE.md                    ✓
├── README.md                    ✓
├── CHANGELOG.md                 ✓
└── LICENSE                      ✓ (MIT)
```

---

## Component Summary

### Commands (11)

| Command | Purpose | Skills Loaded |
|---------|---------|---------------|
| `research` | Codebase + external research | research-first |
| `create-plan` | 3-option architecture + phased plan | research-first |
| `implement` | TDD execution with phase gates | tdd, verification |
| `validate` | Evidence-based verification | verification |
| `iterate` | Update existing plans | research-first |
| `debug` | 4-phase systematic debugging | systematic-debugging, tdd |
| `gamedev` | Playtesting gates (not TDD) | (none) |
| `handoff` | Create context handoff | verification |
| `resume` | Resume from handoff | (none) |
| `backlog` | View/manage backlog | (none) |
| `status` | Show progress + recommendations | (none) |

### Skills (5)

| Skill | Iron Law |
|-------|----------|
| `superharness-core` | Foundation - command decision tree, quality gates |
| `tdd` | No production code without failing test first |
| `research-first` | No designing until research is complete |
| `verification` | No completion claims without fresh evidence |
| `systematic-debugging` | No fixes without root cause investigation |

### Agents (8)

| Agent | Purpose |
|-------|---------|
| `codebase-locator` | Find WHERE files are |
| `codebase-analyzer` | Analyze HOW code works |
| `codebase-pattern-finder` | Find SIMILAR implementations |
| `web-researcher` | External API/version research |
| `spec-reviewer` | Plan compliance verification |
| `code-quality-reviewer` | Quality review (80+ confidence) |
| `harness-locator` | Find .harness/ documents |
| `harness-analyzer` | Extract insights from .harness/ |

### Session Hook Features

1. Foundation skill injection (`<EXTREMELY_IMPORTANT>` wrapper)
2. Incomplete work detection (git trailers)
3. Handoff detection (< 7 days)
4. Dashboard/backlog recommendations
5. Brand message fallback

### Templates (4)

- `plan-template.md` - Phased implementation plan
- `research-template.md` - Codebase + external research
- `handoff-template.md` - Context handoff document
- `backlog-template.md` - Bug/feature/debt tracking

---

## Key Design Decisions

1. **Command-based architecture** - Users explicitly choose stage
2. **.harness/ directory** - Brand identity preserved
3. **load-skills frontmatter** - Commands load discipline skills
4. **Foundation skill injection** - superharness-core at session start
5. **Git trailers for progress** - `phase(N): complete` in commits
6. **Checkbox ↔ trailer sync** - Human/machine views stay in sync
7. **Gamedev exception** - Playtesting gates instead of TDD
8. **Documentarian agents** - Codebase agents only document, no suggestions
9. **EXTREMELY_IMPORTANT wrapper** - Ensures foundation skill is followed

---

## Origins

SUPERHARNESS merges:
- **ace-workflows** by AstroSteveo - ACE-FCA context engineering, command structure, handoffs
- **harness** by AstroSteveo (fork of obra/superpowers) - TDD, research-first, verification, systematic debugging

---

## Next Steps for Release

1. Test the plugin in a real project
2. Update version in plugin.json if needed
3. Create git tag: `git tag -a v0.1.0 -m "v0.1.0 - Initial release"`
4. Push to remote with tags
