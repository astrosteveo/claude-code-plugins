---
feature: 003-add-compact-resume-commands
phase: plan
created: 2025-12-14
status: complete
---

# Implementation Plan: Add /epic:handoff and /epic:resume Commands

**Date**: 2025-12-14
**Feature Slug**: 003-add-compact-resume-commands
**Research**: [Codebase Research](./codebase-research.md)

## Goal

Implement the Frequent Intentional Compaction (FIC) methodology through two new commands:
1. `/epic:handoff` - Create a structured handoff document for session transfer
2. `/epic:resume` - Resume work from a handoff or workflow state

Additionally, refactor the artifact structure to use a flattened layout with frontmatter metadata, and migrate existing workflows.

## Approach Summary

Based on research findings, the implementation follows existing command patterns (YAML frontmatter, Process sections, Output Format). The key changes are:

1. **New commands** follow the same structure as `commands/commit.md` (211 lines, similar complexity)
2. **Flat artifact structure** eliminates subdirectories, uses `{topic}-research.md` naming
3. **Combined state.md** merges progress tracking into workflow state
4. **Handoffs in shared location** at `.claude/handoffs/NNN-slug/`
5. **AskUserQuestion for resume UX** when no path argument provided

---

## Phase 1: Create Handoff Template and Command

### Changes

| File | Action | Description |
|------|--------|-------------|
| `templates/handoff.md` | Create | Template for handoff documents with frontmatter |
| `commands/handoff.md` | Create | Command definition for `/epic:handoff` |
| `.claude-plugin/plugin.json` | Modify | Add handoff command to commands array |

### Verification

**Automated:**
- [x] File exists at `commands/handoff.md`
- [x] File exists at `templates/handoff.md`
- [x] plugin.json is valid JSON after edit

---

## Phase 2: Create Resume Command

### Changes

| File | Action | Description |
|------|--------|-------------|
| `commands/resume.md` | Create | Command definition for `/epic:resume` |
| `.claude-plugin/plugin.json` | Modify | Add resume command to commands array |

### Verification

**Automated:**
- [x] File exists at `commands/resume.md`
- [x] plugin.json is valid JSON after edit

---

## Phase 3: Update Templates for Flat Structure

### Changes

| File | Action | Description |
|------|--------|-------------|
| `templates/state.md` | Modify | Add frontmatter, merge progress tracking |
| `templates/codebase.md` | Modify | Add frontmatter |
| `templates/docs.md` | Modify | Add frontmatter |
| `templates/implementation-plan.md` | Modify | Add frontmatter |
| `templates/progress.md` | Delete | Merged into state.md |
| `templates/validation-results.md` | Modify | Add frontmatter |

### Verification

**Automated:**
- [x] All template files have valid YAML frontmatter
- [x] `templates/progress.md` no longer exists

---

## Phase 4: Update Existing Commands for Flat Structure

### Changes

| File | Action | Description |
|------|--------|-------------|
| `commands/explore.md` | Modify | Update artifact paths to flat structure |
| `commands/plan.md` | Modify | Update artifact paths to flat structure |
| `commands/implement.md` | Modify | Update to use state.md for progress |
| `commands/validate.md` | Modify | Update to write `validation.md` at root |
| `commands/commit.md` | Modify | Update artifact path references |
| `CLAUDE.md` | Modify | Update artifact structure documentation |

### Verification

**Automated:**
- [x] All command files updated
- [x] CLAUDE.md reflects new structure

---

## Phase 5: Migrate Existing Workflows

### Changes

| File | Action | Description |
|------|--------|-------------|
| `.claude/workflows/001-*/` | Migrate | Flatten structure, add frontmatter |
| `.claude/workflows/002-*/` | Migrate | Flatten structure, add frontmatter |
| `.claude/workflows/003-*/` | Migrate | Flatten structure, add frontmatter |

### Verification

**Automated:**
- [x] No subdirectories remain in workflow folders
- [x] All `.md` files have YAML frontmatter

---

## Phase 6: Create Handoffs Directory Structure

### Changes

| File | Action | Description |
|------|--------|-------------|
| `.claude/handoffs/.gitkeep` | Create | Establish handoffs directory |

### Verification

**Automated:**
- [x] Directory `.claude/handoffs/` exists

---

## Rollback Plan

If issues arise:
1. Git revert commits from this workflow
2. Restore templates from git history

## Success Criteria

- [x] `/epic:handoff` command created
- [x] `/epic:resume` command created with AskUserQuestion picker
- [x] All artifacts use flat structure with frontmatter
- [x] Existing workflows (001, 002, 003) migrated successfully
- [x] `.claude/handoffs/` directory created
