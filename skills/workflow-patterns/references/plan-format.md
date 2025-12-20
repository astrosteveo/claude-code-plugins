# Plan Document Format

Template for `.claude/workflow/epics/[epic-slug]/plan.md`.

## Template

```markdown
# Plan: [epic-slug]

## Approach

[1-2 paragraphs describing the high-level technical approach. Explain the strategy, key decisions made, and how this builds on existing code patterns found during research.]

## Stories

### Story: [story-slug]

**Description**: As a [user type], I want [goal], so that [benefit]

**Effort**: [fibonacci points]

#### Acceptance Criteria

- [ ] [Specific, testable criterion]
- [ ] [Another criterion]
- [ ] [Another criterion]

#### Implementation

1. **[Step description]**: `path/to/file.ts` - [What to do]
2. **[Step description]**: `path/to/file.ts` - [What to do]
3. **[Step description]**: `path/to/file.ts` - [What to do]

#### Blockers

- None | [story-slug that must complete first]

---

### Story: [story-slug-2]

[... same format ...]

---

## File Change Summary

| File | Action | Stories |
|------|--------|---------|
| `path/to/file.ts` | create | story-1 |
| `path/to/existing.ts` | modify | story-1, story-2 |
| `path/to/another.ts` | modify | story-2 |

## Order of Operations

1. **[story-slug]** - No dependencies, start here
2. **[story-slug-2]** - Depends on story-slug
3. **[story-slug-3]** - Depends on story-slug, can parallel with story-slug-2
```

## Section Guidelines

### Approach

Write 1-2 paragraphs covering:
- Overall technical strategy
- Key architectural decisions
- How this integrates with existing code
- Any notable patterns being followed

**Good example:**
```markdown
## Approach

Build the track editor as a new ECS system following the existing patterns in `src/ecs/`. The editor will be a modal panel using the UI framework from `src/ui/`, with a canvas-based workspace for track piece placement. Track data will use the existing JSON format from `assets/tracks/` to ensure compatibility with the TrackLoader.

The implementation follows a progressive approach: first establish the core editor UI and piece placement, then add persistence, and finally validation. This order allows early testing of the editing experience before adding save/load complexity.
```

### Story Structure

Each story needs:

#### Description
Use the standard user story format:
- **As a** [who] - the user or role
- **I want** [what] - the goal or feature
- **so that** [why] - the benefit or value

**Good:**
```markdown
**Description**: As a player, I want to place track pieces on a grid, so that I can visually design my racing track
```

**Bad:**
```markdown
**Description**: Add track piece placement
```

#### Effort
Assign Fibonacci points: 1, 2, 3, 5, 8, 13

Consider:
- Number of files to create/modify
- Integration complexity
- Testing requirements
- If 8+, consider splitting

#### Acceptance Criteria

Write specific, testable criteria. Use checkboxes.

**Good AC:**
```markdown
- [ ] Grid displays 32x32 pixel cells
- [ ] Clicking toolbar piece selects it (visual highlight)
- [ ] Clicking grid cell places selected piece
- [ ] Placed pieces render correctly
- [ ] Clicking existing piece removes it
```

**Bad AC:**
```markdown
- [ ] Piece placement works
- [ ] UI looks good
- [ ] No bugs
```

#### Implementation

List concrete steps with file paths:

**Good:**
```markdown
1. **Create editor panel**: `src/ui/panels/TrackEditorPanel.ts` - Extend Panel class, add canvas and toolbar
2. **Create piece toolbar**: `src/ui/components/PieceToolbar.ts` - Display available pieces, handle selection
3. **Add grid system**: `src/editor/EditorGrid.ts` - Manage grid state and piece placement
4. **Register with game**: `src/game/GameManager.ts:45` - Add editor panel to UI stack
```

**Bad:**
```markdown
1. Make the UI
2. Add functionality
3. Test it
```

#### Blockers

List story slugs that must complete first, or "None":

```markdown
#### Blockers
- track-editor-ui (must exist before adding persistence)
```

### File Change Summary

Table showing all files affected and which stories touch them:

```markdown
| File | Action | Stories |
|------|--------|---------|
| `src/ui/panels/TrackEditorPanel.ts` | create | track-editor-ui |
| `src/editor/EditorGrid.ts` | create | track-editor-ui |
| `src/editor/TrackSerializer.ts` | create | track-persistence |
| `src/game/GameManager.ts` | modify | track-editor-ui |
| `src/types/Track.ts` | modify | track-persistence |
```

**Actions:**
- `create` - New file
- `modify` - Change existing file
- `delete` - Remove file (rare)

### Order of Operations

Specify the implementation sequence based on dependencies:

```markdown
## Order of Operations

1. **track-editor-ui** - No dependencies, establishes core editor
2. **track-persistence** - Depends on track-editor-ui
3. **track-validation** - Depends on track-persistence
4. **track-sharing** - Depends on track-persistence, can start after UI done
```

## Complete Example

```markdown
# Plan: track-creator

## Approach

Build the track editor as a modal panel using the existing UI framework from `src/ui/`. The editor canvas will use PixiJS for rendering (already a project dependency) with a tile-based grid matching the 32px tile size used by TrackRenderer. Track data will serialize to the existing JSON format in `assets/tracks/` for compatibility.

Implementation proceeds in three phases: core editing UI, persistence layer, and validation system. This allows early playtesting of the editor UX before adding complexity. The existing TrackPiece enum will be extended with any new piece types needed.

## Stories

### Story: track-editor-ui

**Description**: As a player, I want a visual track editor, so that I can design tracks by placing pieces on a grid

**Effort**: 5

#### Acceptance Criteria

- [ ] Editor panel opens from main menu
- [ ] Grid displays with 32px cells
- [ ] Toolbar shows all available track pieces
- [ ] Clicking piece in toolbar selects it
- [ ] Clicking grid cell places selected piece
- [ ] Right-clicking removes piece
- [ ] ESC closes editor

#### Implementation

1. **Create editor panel**: `src/ui/panels/TrackEditorPanel.ts` - Extend Panel, contain canvas and toolbar
2. **Create piece toolbar**: `src/ui/components/PieceToolbar.ts` - Display TrackPiece types with icons
3. **Create editor grid**: `src/editor/EditorGrid.ts` - Manage grid state, handle mouse events
4. **Create grid renderer**: `src/editor/GridRenderer.ts` - Render grid and placed pieces
5. **Add menu button**: `src/ui/panels/MainMenuPanel.ts:34` - Add "Track Editor" button
6. **Register editor**: `src/game/GameManager.ts:78` - Add panel to UI system

#### Blockers

- None

---

### Story: track-persistence

**Description**: As a player, I want to save my tracks, so that I can continue editing later

**Effort**: 3

#### Acceptance Criteria

- [ ] Save button persists track to localStorage
- [ ] Load button shows saved track list
- [ ] Selecting saved track loads it into editor
- [ ] New button clears editor for fresh track
- [ ] Track names are editable

#### Implementation

1. **Create serializer**: `src/editor/TrackSerializer.ts` - Convert grid state to/from JSON
2. **Create storage service**: `src/editor/TrackStorage.ts` - localStorage CRUD operations
3. **Add save UI**: `src/ui/panels/TrackEditorPanel.ts:89` - Save/Load/New buttons
4. **Create load dialog**: `src/ui/dialogs/LoadTrackDialog.ts` - List and select saved tracks

#### Blockers

- track-editor-ui

---

### Story: track-validation

**Description**: As a player, I want track validation, so that I only save playable tracks

**Effort**: 5

#### Acceptance Criteria

- [ ] Validator checks for start piece
- [ ] Validator checks for finish piece
- [ ] Validator checks path connectivity
- [ ] Invalid tracks show error message
- [ ] Problem pieces highlight in red
- [ ] Save disabled until track valid

#### Implementation

1. **Create validator**: `src/editor/TrackValidator.ts` - Validation logic and rules
2. **Create path checker**: `src/editor/PathChecker.ts` - Graph traversal for connectivity
3. **Add error display**: `src/ui/components/ValidationErrors.ts` - Show error messages
4. **Integrate with editor**: `src/ui/panels/TrackEditorPanel.ts:120` - Run validation on changes

#### Blockers

- track-persistence

---

## File Change Summary

| File | Action | Stories |
|------|--------|---------|
| `src/ui/panels/TrackEditorPanel.ts` | create | track-editor-ui, track-persistence, track-validation |
| `src/ui/components/PieceToolbar.ts` | create | track-editor-ui |
| `src/editor/EditorGrid.ts` | create | track-editor-ui |
| `src/editor/GridRenderer.ts` | create | track-editor-ui |
| `src/editor/TrackSerializer.ts` | create | track-persistence |
| `src/editor/TrackStorage.ts` | create | track-persistence |
| `src/ui/dialogs/LoadTrackDialog.ts` | create | track-persistence |
| `src/editor/TrackValidator.ts` | create | track-validation |
| `src/editor/PathChecker.ts` | create | track-validation |
| `src/ui/components/ValidationErrors.ts` | create | track-validation |
| `src/ui/panels/MainMenuPanel.ts` | modify | track-editor-ui |
| `src/game/GameManager.ts` | modify | track-editor-ui |

## Order of Operations

1. **track-editor-ui** - No dependencies, core functionality
2. **track-persistence** - Requires editor UI to exist
3. **track-validation** - Requires persistence for save gating
```

## Best Practices

1. **Reference research findings**: Use file:line refs from research.md
2. **Be specific**: Vague implementation steps lead to wrong assumptions
3. **Right-size stories**: 3-5 points ideal, 8+ should split
4. **Clear dependencies**: Explicit blockers prevent out-of-order work
5. **Complete AC**: Every criterion should be testable
6. **File summary accuracy**: Double-check all files are listed
7. **Logical order**: Sequence should make sense for incremental delivery
