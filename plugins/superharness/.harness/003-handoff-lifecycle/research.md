---
date: 2026-01-03T00:00:00Z
researcher: Claude
topic: "Handoff Artifact Lifecycle Management"
tags: [research, handoff, lifecycle, cleanup, archive]
status: complete
---

# Research: Handoff Artifact Lifecycle Management

## Research Question

How are handoffs created, detected as incomplete, and how should they be resolved/archived? What gap exists in the current system?

## Summary

The superharness system has a well-defined handoff creation and detection mechanism, but **lacks any handoff resolution/completion mechanism**. This causes completed handoffs to trigger "INCOMPLETE WORK DETECTED" warnings until they age past 7 days, at which point they silently disappear from detection.

### Key Gap Identified

| Artifact Type | Creation | Detection | Resolution |
|--------------|----------|-----------|------------|
| Plans | `create-plan` command | Phase trailers in git | Empty commit with `plan: abandoned` |
| Handoffs | `handoff` command | File age < 7 days | **NONE** |

## Detailed Findings

### 1. Handoff Creation (`commands/handoff.md`)

**Location**: `plugins/superharness/commands/handoff.md:1-187`

Handoffs are created in two locations:
- Feature-specific: `.harness/NNN-feature-slug/handoff.md`
- Cross-feature: `.harness/handoffs/YYYY-MM-DD_HH-MM-SS_description.md`

The template (`templates/handoff-template.md:7`) uses:
```yaml
status: in_progress
```

This status is never updated after creation.

### 2. Handoff Detection (`hooks/session-start.sh`)

**Location**: `plugins/superharness/hooks/session-start.sh:62-118`

Detection logic:
1. Scans `.harness/handoffs/*.md` and `.harness/*/handoff.md`
2. Extracts date from filename or falls back to file mtime
3. Calculates days old: `(current_timestamp - handoff_timestamp) / 86400`
4. Only surfaces handoffs < 7 days old

**Key code** (`session-start.sh:99-101`):
```bash
if [ "$days_old" -lt 7 ]; then
    PENDING_HANDOFFS="${PENDING_HANDOFFS}Handoff: ${handoff_topic} (${days_old} days old)\\nFile: ${handoff_file}\\n\\n"
fi
```

### 3. Plan Abandonment (Existing Pattern)

**Location**: `plugins/superharness/skills/superharness-core/SKILL.md:18`

Plans can be abandoned via:
```bash
git commit --allow-empty -m "chore: abandon plan

plan: abandoned"
```

Detection in `session-start.sh:31-35`:
```bash
if git log --all --format=%B 2>/dev/null | grep -q "plan: abandoned"; then
    continue
fi
```

**Note**: This check is imprecise - it looks for ANY `plan: abandoned` in git history, not tied to specific plan paths.

### 4. Resume Command (`commands/resume.md`)

**Location**: `plugins/superharness/commands/resume.md:1-219`

The resume command:
- Reads and verifies handoff state
- Creates todo list from action items
- Continues implementation

**Gap**: Resume does NOT mark the handoff as resolved after work continues.

### 5. Status Command (`commands/status.md`)

**Location**: `plugins/superharness/commands/status.md:101-104`

Shows handoffs but provides no mechanism to mark them complete:
```markdown
## Recent Handoffs

- `.harness/002-payment/handoff.md` (2 days ago)
  → Resume: `/superharness:resume .harness/002-payment/handoff.md`
```

## Gap Analysis

### Current Behavior (Problematic)

```
Day 0: Create handoff → INCOMPLETE WORK DETECTED
Day 1: Resume work, complete it → INCOMPLETE WORK DETECTED (handoff still exists)
Day 2-6: → INCOMPLETE WORK DETECTED
Day 7+: → Silent (handoff aged out, never properly resolved)
```

### Desired Behavior

```
Day 0: Create handoff → INCOMPLETE WORK DETECTED
Day 1: Resume work, complete it → Mark resolved → Clean state
OR
Day 1: Abandon handoff → Mark abandoned → Clean state
```

## Existing Patterns to Follow

### 1. Plan Abandonment Pattern

Uses git trailers:
```
chore: abandon plan

plan: .harness/NNN-slug/plan.md
reason: superseded by other work
```

### 2. Phase Completion Pattern

Uses git trailers:
```
feat: complete Phase 3 - Authentication

phase(3): complete
```

## Proposed Resolution Mechanisms

Based on existing patterns, handoff resolution should use:

### Option A: Git Trailer Pattern (Consistent with Plans)

```bash
# Resolve a handoff (work complete)
git commit --allow-empty -m "chore: resolve handoff

handoff: .harness/003-auth/handoff.md
reason: work completed"

# Abandon a handoff (work abandoned)
git commit --allow-empty -m "chore: abandon handoff

handoff: .harness/003-auth/handoff.md
reason: approach changed"
```

Session hook would check for `handoff: <path>` trailers.

### Option B: Archive Directory Pattern

Move resolved handoffs to archive:
```
.harness/handoffs/archive/YYYY-MM-DD_description.md
```

Session hook would skip files in `archive/` subdirectory.

### Option C: Status Frontmatter Pattern

Update handoff frontmatter:
```yaml
status: resolved  # or: abandoned, superseded
resolved_date: 2026-01-03
```

Session hook would check `status:` field.

## Code References

- `plugins/superharness/commands/handoff.md` - Handoff creation
- `plugins/superharness/commands/resume.md` - Handoff resumption
- `plugins/superharness/hooks/session-start.sh:62-118` - Handoff detection
- `plugins/superharness/hooks/session-start.sh:31-35` - Plan abandonment check
- `plugins/superharness/templates/handoff-template.md` - Handoff template
- `plugins/superharness/skills/superharness-core/SKILL.md` - Foundation skill

## Architecture Documentation

### Directory Structure (Current)

```
.harness/
├── NNN-feature-slug/
│   ├── research.md
│   ├── plan.md
│   └── handoff.md      ← No resolution mechanism
└── handoffs/
    └── YYYY-MM-DD_*.md ← No resolution mechanism
```

### Directory Structure (Proposed with Archive)

```
.harness/
├── NNN-feature-slug/
│   ├── research.md
│   ├── plan.md
│   └── handoff.md
└── handoffs/
    ├── YYYY-MM-DD_*.md
    └── archive/        ← Resolved handoffs moved here
        └── *.md
```

## Questions Resolved

1. ~~Should resolved handoffs be deleted, archived, or marked in-place?~~
   **Decision:** Archived to `archive/` subdirectory

2. ~~Should the resume command auto-resolve handoffs when work completes?~~
   **Decision:** Yes, prompts user at completion

3. ~~Should there be a separate `/superharness:resolve` command?~~
   **Decision:** Yes, created for explicit resolution

4. ~~How to handle feature-specific handoffs vs cross-feature handoffs consistently?~~
   **Decision:** Feature-specific in `.harness/NNN-feature/`, cross-feature in `.harness/handoffs/`

## Implementation (Completed)

The following approach was implemented:

1. Git trailers for resolution tracking (consistent with plans)
2. Archive mechanism for cleanup (keeps history available)
3. `/superharness:resolve` command for explicit resolution
4. `/superharness:resume` prompts to resolve on completion
