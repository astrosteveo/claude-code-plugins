---
description: "View and manage bugs, deferred features, and tech debt in BACKLOG.md"
argument-hint: "<action: view|add|update> [details]"
---

# Backlog

You are tasked with viewing and managing the project backlog. The backlog tracks bugs, deferred features, and technical debt discovered during development.

## Backlog Location

`.harness/BACKLOG.md`

If it doesn't exist, create it when adding the first item.

## Actions

### View Backlog

When user says "view", "show", "list", or provides no arguments:

1. Read `.harness/BACKLOG.md`
2. Present a summary:

```
## Current Backlog

### Bugs (X items)
- [BUG-001] [Critical] Description - Source: feature-name
- [BUG-002] [High] Description - Source: feature-name

### Deferred Features (X items)
- [FEAT-001] [High] Description - Source: feature-name

### Tech Debt (X items)
- [DEBT-001] [Medium] Description - Source: feature-name

### Improvements (X items)
- [IMP-001] [Low] Description - Source: feature-name

What would you like to do?
- Add item: `/superharness:backlog add [type] [description]`
- Update item: `/superharness:backlog update [ID] [status/priority]`
```

### Add Item

When user says "add" with details:

1. Parse the item type and description
2. Generate next ID for that type
3. Append to appropriate section
4. Confirm addition

**Item format:**
```markdown
### [ID] [Priority] Title
**Source**: feature-name or general
**Description**: Detailed description
**Suggested Fix**: (optional) How to address
**Added**: YYYY-MM-DD
```

### Update Item

When user says "update" with ID and changes:

1. Find the item by ID
2. Update the specified fields
3. Confirm changes

## Create Backlog (if needed)

**Location:** `.harness/BACKLOG.md`

**Template:** Use `templates/backlog-template.md`

Key sections:
- Bugs table (ID, Description, Priority, Source, Added)
- Deferred Features table
- Tech Debt table
- Improvements table

## Priority Levels

- **Critical**: Blocking other work or causing data loss
- **High**: Important for upcoming work or user-facing issues
- **Medium**: Should be addressed but not urgent
- **Low**: Nice to have, can wait

## ID Format

- `BUG-NNN` - Bugs
- `FEAT-NNN` - Deferred features
- `DEBT-NNN` - Technical debt
- `IMP-NNN` - Improvements

## When Items Get Added

During feature development, add to backlog when you:
- Discover a bug unrelated to current work
- Identify a feature that's out of scope
- Find code that should be refactored
- Notice an improvement opportunity

**Don't ignore these findings** - capture them in the backlog.

## Integration with Session Hook

The session hook reads BACKLOG.md and surfaces:
- Critical/High priority bugs
- Items relevant to current work
- Quick wins (items marked as low effort)

This helps users know what's outstanding when they start a session.

## Cross-References

- View project status: `/superharness:status`
- After implementation: `/superharness:validate`
- For planning: `/superharness:create-plan`
