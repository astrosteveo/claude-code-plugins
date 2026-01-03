---
date: 2026-01-03T00:00:00Z
researcher: Claude
topic: "Superharness Plugin Backlog"
tags: [backlog, bugs, tech-debt, deferred]
status: active
---

# BACKLOG

Last Updated: 2026-01-03

## Priority Legend

| Priority | Description |
|----------|-------------|
| Critical | Blocking production / security issue |
| High | Significant impact, should address soon |
| Medium | Important but not urgent |
| Low | Nice to have, address when time permits |

---

## Bugs

| ID | Description | Priority | Related | Added |
|----|-------------|----------|---------|-------|

*(No open bugs)*

---

## Deferred Features

| ID | Description | Priority | Related | Added |
|----|-------------|----------|---------|-------|
| FEAT-001 | Dashboard.md creation mechanism | Medium | `hooks/session-start.sh` | 2026-01-03 |
| FEAT-002 | Backlog-to-plan workflow integration | Medium | `commands/backlog.md` | 2026-01-03 |
| FEAT-003 | Version compatibility matrix | Low | `README.md`, `plugin.json` | 2026-01-03 |

### Feature Details

#### FEAT-001: Dashboard.md Creation Mechanism

**Added:** 2026-01-03
**Priority:** Medium
**Related:** `hooks/session-start.sh:196`

**Description:**
Session hook references `.harness/dashboard.md` as if it exists, but no command creates this file and no template exists.

**Why Deferred:**
Core workflow functions without it; enhancement rather than requirement.

**Implementation Notes:**
Either create a `status` command that generates dashboard.md, or remove all references to it.

#### FEAT-002: Backlog-to-Plan Workflow Integration

**Added:** 2026-01-03
**Priority:** Medium
**Related:** `commands/backlog.md`, `skills/superharness-core/SKILL.md`

**Description:**
Backlog command exists but integration is incomplete:
- No clear mechanism for converting backlog items to plans
- Backlog missing from superharness-core decision tree (lines 38-79)
- No "create-plan-from-backlog" workflow documented

**Implementation Notes:**
Add backlog to decision tree, document workflow: backlog item -> research -> plan -> implement

#### FEAT-003: Version Compatibility Matrix

**Added:** 2026-01-03
**Priority:** Low
**Related:** `README.md`, `plugin.json`

**Description:**
No documentation of minimum Claude Code version required, tested versions, or breaking changes between versions.

**Implementation Notes:**
Add "Requirements" section to README.md with compatibility info.

---

## Technical Debt

| ID | Description | Priority | Related | Added |
|----|-------------|----------|---------|-------|
| DEBT-004 | Duplicate documentation across files | Medium | Multiple | 2026-01-03 |

### Debt Details

#### DEBT-004: Duplicate Documentation Across Files

**Added:** 2026-01-03
**Priority:** Medium
**Related:** Multiple skills/commands

**Description:**
Core concepts documented in 4+ places:
- TDD red flags: `skills/tdd/SKILL.md` vs `skills/superharness-core/SKILL.md`
- Research-first: research.md, research-first skill, CLAUDE.md, README.md
- Handoff lifecycle: resume.md, resolve.md, handoff.md, CLAUDE.md
- Progress tracking: git trailers explained identically in multiple places

**Current State:**
Updates require edits in 4-5 places; high risk of divergence.

**Proposed Fix:**
Create single `.harness-philosophy.md` with core concepts, reference from commands/skills.

**Effort Estimate:** Large

---

## Improvements

| ID | Description | Priority | Related | Added |
|----|-------------|----------|---------|-------|

---

## Quick Wins

Items that can be done in < 30 minutes:

- [x] ~~DEBT-007: Add cross-references to gamedev.md~~ (already existed)
- [x] ~~DEBT-009: Add deprecation note to CHANGELOG.md~~
- [x] ~~BUG-001: Fix agent count in CLAUDE.md and CHANGELOG.md~~
- [x] ~~DEBT-005: Document skill loading in INDEX.md~~
- [x] ~~DEBT-006: Create templates/README.md~~
- [x] ~~DEBT-008: Add glossary to CLAUDE.md~~

---

## Completed (Archive)

Items moved here when completed for reference.

| ID | Description | Completed | Notes |
|----|-------------|-----------|-------|
| BUG-001 | Agent count mismatch - docs say 8 agents, only 6 exist | 2026-01-03 | Fixed CLAUDE.md and CHANGELOG.md |
| DEBT-001 | Hardcoded magic numbers in session-start.sh | 2026-01-03 | Added config vars with env overrides |
| DEBT-002 | Missing error handling in session hook | 2026-01-03 | Added is_git_repo, safe_mktemp helpers |
| DEBT-003 | Commands lack edge case documentation | 2026-01-03 | Added "What If" sections to research, implement, debug |
| DEBT-005 | Skill loading mechanism unexplained | 2026-01-03 | Added technical details to INDEX.md |
| DEBT-006 | Template validation rules missing | 2026-01-03 | Created templates/README.md with spec |
| DEBT-007 | Gamedev command missing cross-references | 2026-01-03 | Already existed at lines 263-268 |
| DEBT-008 | Inconsistent terminology across docs | 2026-01-03 | Added Glossary section to CLAUDE.md |
| DEBT-009 | No deprecation path for removed agents | 2026-01-03 | Added explanations to CHANGELOG.md |
| DEBT-010 | Agent documentation incomplete | 2026-01-03 | Added Operational Spec to all 6 agents |
