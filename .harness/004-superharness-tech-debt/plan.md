# SUPERHARNESS Tech Debt Cleanup - Implementation Plan

> **For Claude:** Execute using subagent per Phase. Each Phase is a cohesive unit - complete all tasks within a Phase before moving to the next.

**Goal:** Clean up High + Medium priority tech debt in SUPERHARNESS plugin, focusing on token efficiency (template extraction) and removing unused code.

**Architecture:** Option C (Pragmatic) - Fix functional issues and achieve token efficiency, skip cosmetic inconsistencies.

**Tech Stack:** Markdown files only (no code dependencies)

**Research Summary:** 80 tech debt items identified across 36 files. Targeting ~18 files for High + Medium priority items.

**Sources:** `.harness/004-superharness-tech-debt/research.md`

**Phases:**
1. Phase 1: Remove Unused Agents (2 tasks)
2. Phase 2: Extract Templates from Commands (4 tasks)
3. Phase 3: Fix Documentation Gaps (5 tasks)
4. Phase 4: Fix Stale References (3 tasks)
5. Phase 5: Clean Plugin Artifacts (3 tasks)

---

## What We're NOT Doing

- Cosmetic naming standardization ("Iron Law" vs "Iron Rule")
- Creating dashboard.md feature (removing references instead)
- Standardizing "Initial Setup" vs "Initial Response" naming
- Fixing agent section heading style variations
- Adding error handling guidance to agents

---

## Phase 1: Remove Unused Agents

### Overview
Delete `spec-reviewer.md` and `code-quality-reviewer.md` which are defined but never referenced by any command.

### Tasks

- [x] Task 1.1: Delete unused agent files
- [x] Task 1.2: Update CHANGELOG.md to reflect removal

### Changes

#### Task 1.1: Delete unused agent files
**Files to delete:**
- `plugins/superharness/agents/spec-reviewer.md`
- `plugins/superharness/agents/code-quality-reviewer.md`

**Verification:**
```bash
ls plugins/superharness/agents/
# Should show 6 files, not 8
```

#### Task 1.2: Update CHANGELOG.md
**File:** `plugins/superharness/CHANGELOG.md`

Add to `[Unreleased]` section:
```markdown
### Removed
- `spec-reviewer` agent (unused)
- `code-quality-reviewer` agent (unused)
```

### Success Criteria

#### Automated Verification:
- [x] Only 6 agent files exist in `plugins/superharness/agents/`
- [x] No grep hits for "spec-reviewer" or "code-quality-reviewer" in commands/

#### Manual Verification:
- [x] CHANGELOG.md has removal entry

### Commit
```bash
git add -A && git commit -m "chore: remove unused spec-reviewer and code-quality-reviewer agents

phase(1): complete"
```

---

## Phase 2: Extract Templates from Commands

### Overview
Replace inline templates in 4 commands with references to template files. This removes ~400 lines of duplication and improves token efficiency.

### Tasks

- [x] Task 2.1: Extract template from `research.md`
- [x] Task 2.2: Extract template from `create-plan.md`
- [x] Task 2.3: Extract template from `handoff.md`
- [x] Task 2.4: Extract template from `backlog.md`

### Changes

#### Task 2.1: Extract template from research.md
**File:** `plugins/superharness/commands/research.md`

**Current state:** Contains ~50 line inline template starting around "Create Research Artifact" section.

**New state:** Replace inline template with:
```markdown
### Step 5: Create Research Artifact

**Location:** `.harness/NNN-feature-slug/research.md`
- NNN is the next available feature number (001, 002, etc.)
- feature-slug is a brief kebab-case description

**Template:** Use `templates/research-template.md`

**If researching a standalone topic (not tied to a feature):**
- Use `.harness/research/YYYY-MM-DD-topic.md`
```

#### Task 2.2: Extract template from create-plan.md
**File:** `plugins/superharness/commands/create-plan.md`

**Current state:** Contains ~90 line inline plan template.

**New state:** Replace inline template with:
```markdown
### Step 4: Write the Plan

**Location:** `.harness/NNN-feature-slug/plan.md`
- NNN matches the feature number from research
- feature-slug is a brief kebab-case description

**Template:** Use `templates/plan-template.md`

Key sections to complete:
- Overview and architecture choice
- Phase breakdown with TDD tasks
- Success criteria (automated + manual)
- Testing strategy
```

#### Task 2.3: Extract template from handoff.md
**File:** `plugins/superharness/commands/handoff.md`

**Current state:** Contains ~70 line inline handoff template.

**New state:** Replace inline template with:
```markdown
### Step 3: Create Handoff Document

**Location:**
- Feature-specific: `.harness/NNN-feature/handoff.md`
- Cross-feature: `.harness/handoffs/YYYY-MM-DD_HH-MM-SS_description.md`

**Template:** Use `templates/handoff-template.md`

Key sections to complete:
- Current state and progress
- Key learnings and decisions
- Blockers and next steps
- Resume instructions
```

#### Task 2.4: Extract template from backlog.md
**File:** `plugins/superharness/commands/backlog.md`

**Current state:** Contains ~50 line inline backlog template.

**New state:** Replace inline template with:
```markdown
### Create Backlog (if needed)

**Location:** `.harness/BACKLOG.md`

**Template:** Use `templates/backlog-template.md`

Key sections:
- Bugs table (ID, Description, Priority, Related, Added)
- Deferred Features table
- Tech Debt table
```

### Success Criteria

#### Automated Verification:
- [x] `grep -c "templates/" plugins/superharness/commands/research.md` returns 1+
- [x] `grep -c "templates/" plugins/superharness/commands/create-plan.md` returns 1+
- [x] `grep -c "templates/" plugins/superharness/commands/handoff.md` returns 1+
- [x] `grep -c "templates/" plugins/superharness/commands/backlog.md` returns 1+

#### Manual Verification:
- [x] Commands still explain what each template section is for
- [x] Template file paths are correct

### Commit
```bash
git add -A && git commit -m "refactor: extract inline templates from commands to template references

Commands now reference templates/ files instead of embedding full templates.
Removes ~400 lines of duplication.

phase(2): complete"
```

---

## Phase 3: Fix Documentation Gaps

### Overview
Update INDEX.md, CHANGELOG.md, README.md, and CLAUDE.md to fix missing entries and inconsistencies.

### Tasks

- [x] Task 3.1: Add `resolve` command to INDEX.md mapping
- [x] Task 3.2: Add `resolve` command to CHANGELOG.md
- [x] Task 3.3: Fix CHANGELOG.md command count (11 → 12)
- [x] Task 3.4: Add `backlog-template.md` to CLAUDE.md directory structure
- [x] Task 3.5: Document `test-session-start.sh` in CLAUDE.md

### Changes

#### Task 3.1: Add resolve to INDEX.md
**File:** `plugins/superharness/skills/INDEX.md`

**Location:** Command-to-Skill Mapping table (around line 114-126)

**Add row:**
```markdown
| `/superharness:resolve` | (none) |
```

#### Task 3.2: Add resolve to CHANGELOG.md
**File:** `plugins/superharness/CHANGELOG.md`

**Location:** Commands list in v0.1.0 section

**Add:**
```markdown
- `/superharness:resolve` - Resolve handoff (complete, supersede, or abandon)
```

#### Task 3.3: Fix command count in CHANGELOG.md
**File:** `plugins/superharness/CHANGELOG.md`

**Change:** `#### Commands (11 total)` → `#### Commands (12 total)`

#### Task 3.4: Add backlog-template to README.md
**File:** `plugins/superharness/README.md`

**Location:** Directory structure section (around line 79-92)

**Add under templates:**
```markdown
│   └── backlog-template.md       # Bug/feature/debt tracking
```

#### Task 3.5: Document test-session-start.sh in CLAUDE.md
**File:** `plugins/superharness/CLAUDE.md`

**Location:** hooks/ section in Repository Structure

**Change:**
```markdown
├── hooks/
│   ├── hooks.json
│   ├── session-start.sh
│   └── test-session-start.sh     # Hook testing script
```

### Success Criteria

#### Automated Verification:
- [x] `grep "resolve" plugins/superharness/skills/INDEX.md` finds entry
- [x] `grep "12 total" plugins/superharness/CHANGELOG.md` finds entry
- [x] `grep "backlog-template" plugins/superharness/CLAUDE.md` finds entry
- [x] `grep "test-session-start" plugins/superharness/CLAUDE.md` finds entry

#### Manual Verification:
- [x] INDEX.md table is properly formatted
- [x] CHANGELOG.md list is in alphabetical order

### Commit
```bash
git add -A && git commit -m "docs: fix documentation gaps in INDEX.md, CHANGELOG.md, README.md, CLAUDE.md

- Add resolve command to INDEX.md mapping
- Add resolve command to CHANGELOG.md
- Fix command count (11 → 12)
- Add backlog-template.md to README.md
- Document test-session-start.sh in CLAUDE.md

phase(3): complete"
```

---

## Phase 4: Fix Stale References

### Overview
Fix outdated year in examples and remove references to unused dashboard.md feature.

### Tasks

- [x] Task 4.1: Update year in research-first examples
- [x] Task 4.2: Remove dashboard.md from CLAUDE.md directory structure
- [x] Task 4.3: Remove dashboard.md references from harness-locator.md

### Changes

#### Task 4.1: Update year in research-first
**File:** `plugins/superharness/skills/research-first/SKILL.md`

**Location:** Lines 181-186 (External Research section)

**Change:** Replace "2025" with dynamic guidance:
```markdown
**Search queries to try:**
- "[library name] latest version [current year]"
- "[library name] changelog"
- "[library name] vs [alternative] [current year]"
- "[library name] breaking changes"
```

#### Task 4.2: Remove dashboard.md from CLAUDE.md
**File:** `plugins/superharness/CLAUDE.md`

**Location:** .harness/ directory structure (around line 58)

**Remove line:**
```markdown
├── dashboard.md                  # Recommendations (session hook reads this)
```

#### Task 4.3: Remove dashboard.md from harness-locator.md
**File:** `plugins/superharness/agents/harness-locator.md`

**Locations:** Multiple references to dashboard.md

**Remove/update:**
- Remove from directory structure example
- Remove from "Check dashboard.md for recommendations" instruction
- Remove from output format examples

### Success Criteria

#### Automated Verification:
- [x] `grep "2025" plugins/superharness/skills/research-first/SKILL.md` returns empty
- [x] `grep "dashboard.md" plugins/superharness/CLAUDE.md` returns empty
- [x] `grep "dashboard" plugins/superharness/agents/harness-locator.md` returns empty

#### Manual Verification:
- [x] research-first examples make sense with dynamic year guidance

### Commit
```bash
git add -A && git commit -m "fix: remove stale references (2025 year, unused dashboard.md)

- Update research-first examples to use dynamic year guidance
- Remove dashboard.md references (feature not implemented)

phase(4): complete"
```

---

## Phase 5: Clean Plugin Artifacts

### Overview
Clean up the plugin's own `.harness/` directory: archive resolved handoff, update unchecked checkboxes, close open questions.

### Tasks

- [ ] Task 5.1: Archive resolved handoff
- [ ] Task 5.2: Update plan.md checkboxes
- [ ] Task 5.3: Update research.md open questions

### Changes

#### Task 5.1: Archive resolved handoff
**Action:** Move `plugins/superharness/.harness/001-superharness-build/handoff.md` to archive

```bash
mkdir -p plugins/superharness/.harness/001-superharness-build/archive
mv plugins/superharness/.harness/001-superharness-build/handoff.md \
   plugins/superharness/.harness/001-superharness-build/archive/
```

#### Task 5.2: Update plan.md checkboxes
**File:** `plugins/superharness/.harness/003-handoff-lifecycle/plan.md`

**Change:** Update all 13 unchecked manual verification boxes to checked:
- Lines 110-112: Phase 1 manual verification → `[x]`
- Lines 159, 162-164: Phase 2 manual verification → `[x]`
- Lines 221-224: Phase 3 manual verification → `[x]`
- Lines 282-283: Phase 4 manual verification → `[x]`

#### Task 5.3: Update research.md open questions
**File:** `plugins/superharness/.harness/003-handoff-lifecycle/research.md`

**Location:** Open Questions section (lines 224-228)

**Change:** Replace with "Questions Resolved" section documenting decisions made:
```markdown
## Questions Resolved

1. ~~Should resolved handoffs be deleted, archived, or marked in-place?~~
   **Decision:** Archived to `archive/` subdirectory

2. ~~Should the resume command auto-resolve handoffs when work completes?~~
   **Decision:** Yes, prompts user at completion

3. ~~Should there be a separate `/superharness:resolve` command?~~
   **Decision:** Yes, created for explicit resolution

4. ~~How to handle feature-specific handoffs vs cross-feature handoffs consistently?~~
   **Decision:** Feature-specific in `.harness/NNN-feature/`, cross-feature in `.harness/handoffs/`
```

**Also update:** Recommendation section (lines 229-237) to past tense indicating these were implemented.

### Success Criteria

#### Automated Verification:
- [ ] `ls plugins/superharness/.harness/001-superharness-build/archive/` shows handoff.md
- [ ] `grep -c "\[ \]" plugins/superharness/.harness/003-handoff-lifecycle/plan.md` returns 0

#### Manual Verification:
- [ ] Research questions show decisions made
- [ ] Artifacts reflect completed state

### Commit
```bash
git add -A && git commit -m "chore: clean up plugin .harness/ artifacts

- Archive resolved handoff
- Update unchecked checkboxes to reflect completion
- Document resolved open questions

phase(5): complete"
```

---

## Summary

| Phase | Tasks | Files Changed | Focus |
|-------|-------|---------------|-------|
| 1 | 2 | 3 | Remove unused agents |
| 2 | 4 | 4 | Template extraction (token efficiency) |
| 3 | 5 | 4 | Documentation gaps |
| 4 | 3 | 3 | Stale references |
| 5 | 3 | 3 | Artifact cleanup |
| **Total** | **17** | **~17** | High + Medium priority tech debt |

## Testing Strategy

### Automated Tests
No automated tests needed - this is documentation/file cleanup.

### Manual Verification
After all phases:
1. Run `./plugins/superharness/hooks/session-start.sh` - should not error
2. Verify commands still reference valid template paths
3. Spot-check a few commands to ensure they're readable without inline templates
