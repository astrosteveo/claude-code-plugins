# Research Document Format

Template for `.claude/workflow/epics/[epic-slug]/research.md`.

## Template

```markdown
# Research: [epic-slug]

## Summary

[2-3 sentences describing what was found during exploration. Focus on key findings relevant to implementing this epic.]

## Relevant Files

### [Category Name]

| File | Lines | Purpose |
|------|-------|---------|
| `src/path/to/file.ts` | 1-145 | [What this file does] |
| `src/path/to/other.ts` | 23-67 | [What this section does] |

### [Another Category]

| File | Lines | Purpose |
|------|-------|---------|
| `src/different/file.ts` | 1-89 | [Purpose] |

## Patterns Observed

- **[Pattern Name]**: `file:line` - [Description of pattern and how it's used]
- **[Another Pattern]**: `file:line` - [Description]

## Dependencies

| Dependency | Version | Usage |
|------------|---------|-------|
| `package-name` | ^1.2.3 | [What it's used for] |

## Constraints

- [Constraint 1 discovered during exploration]
- [Constraint 2 that affects implementation]

## Questions/Unknowns

- [Any unresolved questions that need answers before planning]
```

## Section Guidelines

### Summary

Write 2-3 sentences covering:
- What exists in the codebase relevant to this epic
- Key findings that will influence implementation
- Overall assessment of complexity

**Good example:**
```markdown
## Summary

The codebase has an existing Entity-Component system in `src/ecs/` that handles all game objects. Track rendering uses a tile-based approach with the TileRenderer component. No existing track editing functionality exists, so this will be built from scratch using the existing UI framework in `src/ui/`.
```

### Relevant Files

Group files by logical category. Always include:
- Exact file path from project root
- Line range (or full file if relevant throughout)
- Clear purpose statement

**Categories might include:**
- Core Systems
- UI Components
- Data Models
- Utilities
- Tests
- Configuration

**Good example:**
```markdown
### Core Systems

| File | Lines | Purpose |
|------|-------|---------|
| `src/ecs/EntityManager.ts` | 1-234 | Manages entity lifecycle, will need to register track editor entities |
| `src/ecs/components/Transform.ts` | 1-45 | Position/rotation component, used for track piece placement |

### UI Framework

| File | Lines | Purpose |
|------|-------|---------|
| `src/ui/Panel.ts` | 1-156 | Base panel class, extend for editor panel |
| `src/ui/Toolbar.ts` | 1-89 | Toolbar component, reuse for track piece selection |
```

### Patterns Observed

Document coding patterns, conventions, and architectural decisions found:

**Good examples:**
```markdown
- **Component Registration**: `src/ecs/EntityManager.ts:45` - Components register via `registerComponent()` in module initialization
- **Event Handling**: `src/ui/Button.ts:23` - UI uses pub/sub pattern via `EventEmitter.emit('event-name', data)`
- **State Management**: `src/game/GameState.ts:1` - Global state singleton accessed via `GameState.instance`
- **File Naming**: All components use PascalCase with `.component.ts` suffix
```

### Dependencies

List external dependencies relevant to this epic:

```markdown
| Dependency | Version | Usage |
|------------|---------|-------|
| `pixi.js` | ^7.2.0 | Rendering engine, use for track editor canvas |
| `zustand` | ^4.3.0 | State management, use for editor state |
| `immer` | ^10.0.0 | Immutable updates, use for track data mutations |
```

### Constraints

Document limitations discovered:

**Good examples:**
```markdown
- Maximum entity count is 10,000 due to ECS performance limits
- UI framework doesn't support drag-and-drop natively, will need custom implementation
- Save files must be under 1MB for cloud sync compatibility
- Existing physics engine has fixed timestep, editor preview must match
```

### Questions/Unknowns

List anything unresolved:

```markdown
- Should track pieces snap to grid or allow free placement?
- What file format for saved tracks? (JSON vs binary)
- How to handle backwards compatibility if track format changes?
```

## Complete Example

```markdown
# Research: track-creator

## Summary

The codebase uses an Entity-Component-System architecture in `src/ecs/` that can support track editor entities. UI is built with a custom framework in `src/ui/` supporting panels, toolbars, and buttons. No existing editor functionality exists. Track rendering uses `src/rendering/TrackRenderer.ts` which loads track data from JSON files in `assets/tracks/`.

## Relevant Files

### Core ECS

| File | Lines | Purpose |
|------|-------|---------|
| `src/ecs/EntityManager.ts` | 1-234 | Entity lifecycle management |
| `src/ecs/Component.ts` | 1-56 | Base component class |
| `src/ecs/System.ts` | 1-78 | Base system class |

### Track System

| File | Lines | Purpose |
|------|-------|---------|
| `src/tracks/TrackLoader.ts` | 1-123 | Loads track JSON, need reverse for saving |
| `src/tracks/TrackPiece.ts` | 1-89 | Track piece definitions and types |
| `src/rendering/TrackRenderer.ts` | 1-234 | Renders loaded tracks |

### UI Framework

| File | Lines | Purpose |
|------|-------|---------|
| `src/ui/Panel.ts` | 1-156 | Base panel class for editor panels |
| `src/ui/Toolbar.ts` | 1-89 | Toolbar component for piece selection |
| `src/ui/Button.ts` | 1-67 | Button with hover/click states |

### Data Models

| File | Lines | Purpose |
|------|-------|---------|
| `src/types/Track.ts` | 1-45 | Track data type definitions |
| `assets/tracks/demo.json` | 1-234 | Example track data format |

## Patterns Observed

- **Component Registration**: `src/ecs/EntityManager.ts:45` - Use `em.registerComponent(MyComponent)` at module load
- **Event System**: `src/ui/Button.ts:34` - UI events via `this.emit('click', eventData)`
- **JSON Schema**: `assets/tracks/demo.json:1` - Tracks use `{pieces: [], metadata: {}}` structure
- **Naming Convention**: Components are PascalCase, files match class names

## Dependencies

| Dependency | Version | Usage |
|------------|---------|-------|
| `pixi.js` | ^7.2.4 | Rendering, use for editor canvas |
| `file-saver` | ^2.0.5 | Already installed, use for track export |
| `uuid` | ^9.0.0 | Already installed, use for track piece IDs |

## Constraints

- Entity limit is 10,000 - track pieces must be lightweight
- Track JSON must be under 500KB for sharing feature
- UI framework has no built-in drag-drop, need custom implementation
- TrackRenderer expects specific piece type enum, must match

## Questions/Unknowns

- Grid snap size: 32px like existing tiles, or configurable?
- Should editor support undo/redo? (increases complexity significantly)
- Track validation rules: what makes a track "valid"?
```

## Best Practices

1. **Be precise**: Use exact file:line references, not vague descriptions
2. **Stay relevant**: Only include files that matter for this epic
3. **Group logically**: Categories help the planning agent find information
4. **Note patterns**: Implementation will follow existing conventions
5. **Surface constraints early**: Better to know limitations before planning
6. **Ask questions**: Unknowns should be resolved in planning phase
