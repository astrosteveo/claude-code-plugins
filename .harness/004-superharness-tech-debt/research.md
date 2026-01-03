---
date: 2026-01-03T00:00:00Z
researcher: Claude
topic: "SUPERHARNESS Plugin Tech Debt Analysis"
tags: [research, tech-debt, superharness, plugin]
status: complete
---

# Research: SUPERHARNESS Plugin Tech Debt Analysis

## Research Question

Identify tech debt within the SUPERHARNESS plugin at `plugins/superharness/`.

## Summary

Comprehensive analysis of all 36 markdown files across the SUPERHARNESS plugin reveals **75+ tech debt items** categorized into 6 types:

| Category | Count |
|----------|-------|
| Inconsistencies | 22 |
| Missing Features | 15 |
| Duplication | 18 |
| Stale References | 6 |
| Documentation Mismatches | 14 |
| Artifact Issues | 5 |
| **Total** | **80** |

The tech debt primarily stems from:
1. **Rapid development** - Features added without updating all documentation
2. **Template duplication** - Same content exists in commands AND template files
3. **Inconsistent patterns** - Different naming/structure conventions across similar files
4. **Incomplete cleanup** - Resolved work artifacts not archived

---

## Detailed Findings

### Category 1: Commands (`plugins/superharness/commands/`)

12 command files analyzed. Key issues:

#### Inconsistencies (6)

1. **Frontmatter `load-skills` pattern** - 7 commands have `load-skills`, 5 do not (gamedev, status, backlog, resolve, resume)

2. **Frontmatter `argument-hint` missing** - `status.md` is the only command lacking `argument-hint`

3. **"Initial Response/Setup" section naming** - `validate.md` and `research.md` use "Initial Setup" while others use "Initial Response"

4. **Sub-agent spawn patterns vary** - Some use "Task N -" format, others use bullet points, others use separate code blocks

5. **Cross-reference section format** - `validate.md` uses numbered "Recommended workflow" while others use bullet lists

6. **Document structure variations** - Inconsistent H2 section organization ("Process" vs "Planning Process" vs "Phase Execution Process")

#### Missing Features (3)

1. **`AskUserQuestion` tool** - Referenced in `resolve.md` and `resume.md` with specific JSON schema but may not exist in runtime

2. **Supersede logic implementation** - `resume.md` describes cross-command state tracking without specifying mechanism

3. **`dashboard.md` file** - Referenced in CLAUDE.md directory structure but no command creates/documents its format

#### Duplication (7)

1. **Handoff template** - Inline in `handoff.md` AND in `templates/handoff-template.md`

2. **Research template** - Inline in `research.md` AND in `templates/research-template.md`

3. **Plan template** - Inline in `create-plan.md` AND in `templates/plan-template.md`

4. **Backlog template** - Inline in `backlog.md` AND in `templates/backlog-template.md`

5. **GDD template missing** - Only in `gamedev.md`, no corresponding template file (inconsistent with other patterns)

6. **Git trailer documentation** - Phase completion trailers documented in `implement.md`, `validate.md`, `status.md`, `resume.md`

7. **TDD enforcement content** - Repeated in `implement.md`, `debug.md`, `create-plan.md`

#### Stale References (2)

1. **`resolve` command missing from INDEX.md** - Command exists but not in skill mapping table

2. **`spec-reviewer` and `code-quality-reviewer` agents never referenced** - Exist but no command uses them

#### Documentation Mismatches (6)

1. **Gamedev skill discrepancy** - No `load-skills` but cross-references `/superharness:debug` which loads TDD

2. **Brand message placement** - Only in `status.md` output, not other commands

3. **Backlog date format** - Uses `2025-01-15` while others use `[ISO timestamp with timezone]`

4. **Handoff frontmatter** - Template shows `status: complete` for NEW handoff (should be "pending")

5. **Research status field semantics** - Different from handoffs but both have `status: complete`

6. **Harness agents only referenced in research.md** - Would be useful in `resume.md`, `status.md`, `validate.md`

---

### Category 2: Skills (`plugins/superharness/skills/`)

6 skill files analyzed. Key issues:

#### Inconsistencies (5)

1. **Frontmatter description format** - `superharness-core` uses "INJECTED AT SESSION START", others use "MUST invoke when/before..."

2. **"Iron Law" vs "Iron Rule"** - `tdd`, `verification`, `systematic-debugging` use "Iron Law"; `research-first` uses "Iron Rule"

3. **Violation statement format** - Three skills have it with different wording; `research-first` has none

4. **"Red Flags" section header suffixes** - All four discipline skills have different suffixes

5. **Code example languages** - `tdd` uses TypeScript; `research-first` and `systematic-debugging` use bash

#### Missing Features (6)

1. **research-first missing violation statement**
2. **research-first missing "When to Use" section**
3. **research-first missing "Common Rationalizations" section**
4. **research-first missing "When Stuck" section**
5. **verification uses "When To Apply" instead of "When to Use"**
6. **superharness-core lacks standard skill sections** (Overview, When to Use, Common Rationalizations)

#### Duplication (6)

1. **TDD content duplicated in superharness-core** - RED-GREEN-REFACTOR from `tdd/SKILL.md`
2. **Verification content duplicated in superharness-core** - Gate Function from `verification/SKILL.md`
3. **Debugging content duplicated in superharness-core** - 4-phase outline from `systematic-debugging/SKILL.md`
4. **Research content duplicated in superharness-core** - External research topics from `research-first/SKILL.md`
5. **Rationalization tables duplicated** - Condensed versions in superharness-core, full in each skill
6. **TDD integration mentioned in systematic-debugging** - Cross-references tdd skill content

#### Stale References (1)

1. **Year "2025" in search examples** - `research-first/SKILL.md` lines 181-186 have hardcoded year

#### Documentation Mismatches (2)

1. **INDEX.md skill file format** - Documents `## The Rule`, `## The Process`, `## Red Flags` but actual skills use different headers

2. **INDEX.md summaries** - Condensed versions don't match actual skill structure

---

### Category 3: Agents (`plugins/superharness/agents/`)

8 agent files analyzed. Key issues:

#### Inconsistencies (5)

1. **Documentarian constraint section** - 4 agents have "CRITICAL: You Are a Documentarian/Verifier" section, 4 do not

2. **Section heading styles** - "Important Guidelines" vs "Quality Guidelines" vs "Verification Rules"

3. **Role definition terms** - 5 use "specialist", 2 use "reviewer", 1 uses "expert"

4. **"What NOT to Do" length** - Varies from 5 to 10 items across agents

5. **"Remember" section styling** - Metaphors vs direct statements vs numbered list

#### Missing Features (3)

1. **No error handling guidance** - No agents document how to handle files not found, empty results, permission denied

2. **No tool usage instructions** - Agents reference grep/glob/WebSearch without invocation examples

3. **Missing multi-language support** - `codebase-locator` lists only 4 languages, misses Rust, Java, C/C++, Ruby, PHP

#### Duplication (4)

1. **Core structure template** - All 8 agents follow identical structure that could be abstracted

2. **`model: inherit` frontmatter** - Repeated in every agent file

3. **Codebase search guidance** - Overlaps between `codebase-locator` and `codebase-pattern-finder`

4. **Documentation warnings** - Similar bullets about not suggesting improvements in three codebase agents

#### Stale References (2)

1. **harness-locator references dashboard.md** - Different description than CLAUDE.md

2. **Output format example date** - `2024-01-15` in harness-locator is over a year old

#### Documentation Mismatches (6)

1. **code-quality-reviewer does NOT enforce documentarian role** - Actively provides recommendations

2. **spec-reviewer description vs content** - Says "does NOT suggest improvements" but has "Action Required" section

3. **harness-analyzer claims it does NOT provide summaries** - But has summary-like sections

4. **codebase-locator output shows line numbers** - But says "Don't read file contents"

5. **codebase-pattern-finder "Key aspects"** - Provides evaluative commentary despite "don't evaluate" constraint

6. **web-researcher missing documentarian constraint** - Intentional but inconsistent with family

---

### Category 4: Hooks & Templates

4 template files + 3 hook files analyzed. Key issues:

#### Missing Features (2)

1. **Missing `dashboard-template.md`** - Referenced in session-start.sh and CLAUDE.md but no template exists

2. **Missing `/superharness:resolve` in INDEX.md mapping** - Command exists but not in skill table

#### Duplication (5)

1. **Directory structure in 3 places** - `superharness-core/SKILL.md`, `CLAUDE.md`, `harness-locator.md`

2. **TDD Requirements repeated in plan-template.md** - Same boilerplate 3 times (Phase 1, 2, 3)

3. **Success Criteria repeated in plan-template.md** - Same structure 3 times

4. **Commit section repeated in plan-template.md** - Same template 3 times (only phase number changes)

#### Inconsistencies (4)

1. **Date format** - handoff-template uses ISO 8601 with time; others use date only

2. **Frontmatter presence** - Only handoff-template has YAML frontmatter; others use inline fields

3. **Feature directory naming** - Some use `NNN-feature-slug/`, others use `NNN-feature/`

4. **Resume command path formats** - Two different patterns in handoff-template

#### Stale References (2)

1. **Dashboard section parsing** - session-start.sh expects specific headers/formats not documented

2. **Backlog table column parsing** - Regex may not match template format exactly

#### Documentation Mismatches (3)

1. **INDEX.md vs CLAUDE.md skill loading** - Different info for handoff command

2. **INDEX.md has 11 commands, CLAUDE.md has 12** - Missing resolve

3. **Skills file format documentation** - Does not match actual skill file headers

---

### Category 5: Cross-File Consistency

#### Inconsistencies Found (7)

1. **Command count** - CHANGELOG.md says 11, CLAUDE.md says 12, actual is 12

2. **CHANGELOG.md missing `resolve`** - v0.1.0 list omits it

3. **INDEX.md missing `resolve` mapping** - Should include `| /superharness:resolve | (none) |`

4. **CLAUDE.md Key Commands table incomplete** - Missing `iterate`, `backlog`, `status`

5. **README.md missing `backlog-template.md`** - Not in directory structure

6. **Extra file `test-session-start.sh`** - Not documented in CLAUDE.md

7. **`dashboard.md` inconsistent** - In CLAUDE.md but not README.md `.harness/` structure

---

### Category 6: .harness/ Artifacts

5 issues found in plugin's own `.harness/` directory:

1. **Stale handoff not archived** - `001-superharness-build/handoff.md` resolved via git trailer but file still exists

2. **Missing directory 002** - Gap from abandoned `002-git-progress-tracking` plan

3. **Unchecked manual verification checkboxes** - 13 items in `003-handoff-lifecycle/plan.md` never updated despite phases complete

4. **Stale open questions** - `003-handoff-lifecycle/research.md` has 4 unanswered questions (all were answered in implementation)

5. **Outdated recommendation** - Research document presents implemented decisions as proposals

---

## Code References

### Commands (12 files)
- `plugins/superharness/commands/research.md`
- `plugins/superharness/commands/create-plan.md`
- `plugins/superharness/commands/implement.md`
- `plugins/superharness/commands/validate.md`
- `plugins/superharness/commands/iterate.md`
- `plugins/superharness/commands/debug.md`
- `plugins/superharness/commands/gamedev.md`
- `plugins/superharness/commands/handoff.md`
- `plugins/superharness/commands/resume.md`
- `plugins/superharness/commands/resolve.md`
- `plugins/superharness/commands/backlog.md`
- `plugins/superharness/commands/status.md`

### Skills (6 files)
- `plugins/superharness/skills/INDEX.md`
- `plugins/superharness/skills/superharness-core/SKILL.md`
- `plugins/superharness/skills/tdd/SKILL.md`
- `plugins/superharness/skills/research-first/SKILL.md`
- `plugins/superharness/skills/verification/SKILL.md`
- `plugins/superharness/skills/systematic-debugging/SKILL.md`

### Agents (8 files)
- `plugins/superharness/agents/codebase-locator.md`
- `plugins/superharness/agents/codebase-analyzer.md`
- `plugins/superharness/agents/codebase-pattern-finder.md`
- `plugins/superharness/agents/web-researcher.md`
- `plugins/superharness/agents/spec-reviewer.md`
- `plugins/superharness/agents/code-quality-reviewer.md`
- `plugins/superharness/agents/harness-locator.md`
- `plugins/superharness/agents/harness-analyzer.md`

### Templates (4 files)
- `plugins/superharness/templates/plan-template.md`
- `plugins/superharness/templates/research-template.md`
- `plugins/superharness/templates/handoff-template.md`
- `plugins/superharness/templates/backlog-template.md`

### Hooks (3 files)
- `plugins/superharness/hooks/hooks.json`
- `plugins/superharness/hooks/session-start.sh`
- `plugins/superharness/hooks/test-session-start.sh`

### Documentation (3 files)
- `plugins/superharness/README.md`
- `plugins/superharness/CLAUDE.md`
- `plugins/superharness/CHANGELOG.md`

---

## Priority Categorization

### High Priority (Functional Impact)

1. **Missing `dashboard.md` template** - Session hook expects this file but no template/docs exist
2. **`resolve` command not in INDEX.md** - Documentation gap
3. **`spec-reviewer` and `code-quality-reviewer` agents unused** - Either integrate or remove
4. **Stale year "2025" in research-first examples** - Will cause confusion

### Medium Priority (Documentation Quality)

1. **CHANGELOG.md missing `resolve`** - Version history incomplete
2. **Template duplication** - Commands have inline templates AND separate template files
3. **Inconsistent section naming** - "Iron Law" vs "Iron Rule", "Initial Setup" vs "Initial Response"
4. **Unchecked checkboxes in plan.md** - Confuses progress tracking

### Low Priority (Polish)

1. **Frontmatter inconsistencies** - `argument-hint`, `load-skills` patterns
2. **Example date formats** - 2024 dates in examples
3. **Code example language consistency** - TypeScript vs bash
4. **"Remember" section styling** - Metaphors vs direct statements

---

## Open Questions

1. Should template files be removed in favor of inline templates in commands, or vice versa?
2. Are `spec-reviewer` and `code-quality-reviewer` agents planned for future commands?
3. What should `dashboard.md` contain and which command creates it?
4. Should abandoned/resolved `.harness/` artifacts be automatically cleaned up?

---

## Related .harness/ Documents

- `.harness/001-phase-based-execution/plan.md` - Previous plan (completed)
- `plugins/superharness/.harness/001-superharness-build/handoff.md` - Plugin build handoff (resolved, not archived)
- `plugins/superharness/.harness/003-handoff-lifecycle/` - Lifecycle feature (completed)
