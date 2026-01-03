---
description: "Resolve a handoff (mark complete, superseded, or abandoned)"
argument-hint: "<handoff path> [--archive] [--abandon]"
---

# Resolve Handoff

You are tasked with resolving a handoff document - marking it as complete, superseded, or abandoned so it no longer triggers "INCOMPLETE WORK DETECTED" warnings.

## Purpose

Handoff resolution:
- **Clears pending state**: Resolved handoffs no longer appear in session start warnings
- **Preserves history**: Git trailers provide audit trail of handoff lifecycle
- **Enables cleanup**: Optional archive mechanism moves resolved handoffs out of active directories

## Resolution Types

| Type | When to Use | Git Trailer |
|------|-------------|-------------|
| **Complete** | Work from handoff is finished | `handoff: <path>` |
| **Superseded** | New handoff replaced this one | `handoff: <path>` with reason |
| **Abandoned** | Work was cancelled/approach changed | `handoff-abandoned: <path>` |

## Initial Response

### If handoff path provided:

1. Verify the handoff file exists
2. Check if already resolved (git trailer exists)
3. Present resolution options

### If no path provided:

```
I'll help you resolve a handoff. Please provide the path to the handoff file.

To find pending handoffs:
- Feature handoffs: `ls .harness/*/handoff.md`
- Cross-feature handoffs: `ls .harness/handoffs/*.md`

Or use `/superharness:resume` which includes a picker dialog.
```

Wait for user input.

## Resolution Process

### Step 1: Verify Handoff

1. **Read the handoff file** to confirm it exists
2. **Check git log** for existing resolution:
   ```bash
   git log --format=%B | grep -F "handoff: <path>"
   git log --format=%B | grep -F "handoff-abandoned: <path>"
   ```
3. **If already resolved**: Inform user and ask if they want to re-resolve

### Step 2: Determine Resolution Type

Present options to user:

```
How would you like to resolve this handoff?

1. **Complete** - Work is finished
2. **Superseded** - Replaced by a newer handoff
3. **Abandoned** - Work was cancelled

Additionally:
- Archive the file? (moves to archive/ subdirectory)
```

Use AskUserQuestion if needed:

```json
{
  "questions": [{
    "question": "How should this handoff be resolved?",
    "header": "Resolution",
    "options": [
      {"label": "Complete", "description": "Work from this handoff is finished"},
      {"label": "Superseded", "description": "A newer handoff replaced this one"},
      {"label": "Abandoned", "description": "Work was cancelled or approach changed"}
    ],
    "multiSelect": false
  }]
}
```

### Step 3: Create Git Trailer

Based on resolution type:

**For Complete or Superseded:**
```bash
git commit --allow-empty -m "chore: resolve handoff

handoff: <handoff-path>
reason: <complete|superseded by X>"
```

**For Abandoned:**
```bash
git commit --allow-empty -m "chore: abandon handoff

handoff-abandoned: <handoff-path>
reason: <user-provided reason>"
```

### Step 4: Archive (Optional)

If user requested archive:

1. **Determine archive location**:
   - Feature handoff `.harness/NNN-slug/handoff.md` → `.harness/NNN-slug/archive/handoff.md`
   - Cross-feature `.harness/handoffs/YYYY-MM-DD_*.md` → `.harness/handoffs/archive/YYYY-MM-DD_*.md`

2. **Create archive directory** if needed:
   ```bash
   mkdir -p <archive-dir>
   ```

3. **Move the file**:
   ```bash
   git mv <handoff-path> <archive-path>
   git commit -m "chore: archive resolved handoff

   Moved: <handoff-path> → <archive-path>"
   ```

### Step 5: Confirm Resolution

```
Handoff resolved successfully!

- File: <handoff-path>
- Resolution: <Complete|Superseded|Abandoned>
- Git trailer: Created
- Archived: <Yes|No>

This handoff will no longer appear in "INCOMPLETE WORK DETECTED" warnings.
```

## Flags

### `--archive`

Automatically archive the handoff after resolution (skip the prompt).

### `--abandon`

Shortcut for abandoned resolution type:
```
/superharness:resolve .harness/001-feature/handoff.md --abandon
```

## Examples

### Example 1: Complete Resolution

```
User: /superharness:resolve .harness/003-auth/handoff.md

Agent: I'll resolve this handoff. Let me verify it exists...

The handoff exists: "Authentication Implementation - Phase 2 Complete"

How should this handoff be resolved?
- Complete (work is finished)
- Superseded (replaced by newer handoff)
- Abandoned (work cancelled)

User: Complete

Agent: Creating resolution commit...

git commit --allow-empty -m "chore: resolve handoff

handoff: .harness/003-auth/handoff.md
reason: complete"

Would you like to archive this handoff? (moves to .harness/003-auth/archive/)

User: Yes

Agent: [Moves file to archive]

Handoff resolved successfully!
```

### Example 2: Superseded by New Handoff

```
User: /superharness:resolve .harness/handoffs/2026-01-01_session-1.md

Agent: This handoff will be marked as superseded.

What handoff superseded this one?

User: .harness/handoffs/2026-01-02_session-2.md

Agent: Creating resolution commit...

git commit --allow-empty -m "chore: resolve handoff

handoff: .harness/handoffs/2026-01-01_session-1.md
reason: superseded by .harness/handoffs/2026-01-02_session-2.md"

Handoff resolved!
```

### Example 3: Quick Abandon

```
User: /superharness:resolve .harness/002-feature/handoff.md --abandon

Agent: Abandoning handoff...

git commit --allow-empty -m "chore: abandon handoff

handoff-abandoned: .harness/002-feature/handoff.md
reason: abandoned by user"

Handoff abandoned and will no longer appear in warnings.
```

## Guidelines

### When to Resolve

- After completing work described in a handoff
- When creating a new handoff that supersedes an old one
- When abandoning an approach or feature

### Archive vs Keep

**Archive when:**
- Handoff is old and cluttering the directory
- You want a clean `.harness/` structure
- Historical reference isn't needed frequently

**Keep in place when:**
- Recent handoff that may be referenced
- Part of an ongoing feature's documentation
- Useful for understanding feature history

### Resolution is Tracked in Git

The git trailer system means:
- Resolution survives file moves/renames
- Can be queried: `git log --format=%B | grep "handoff:"`
- Provides audit trail of handoff lifecycle

## Cross-References

- To create handoff: `/superharness:handoff`
- To resume from handoff: `/superharness:resume`
- For status overview: `/superharness:status`
