# PRD Document Format

Template for `.claude/workflow/PRD.md`.

## Template

```markdown
# PRD: [Project Name]

## Vision

[One paragraph describing what this project is and why it exists. Focus on the problem being solved and the value delivered.]

## Requirements

- [REQ-1] [Requirement description - what must be true when project is complete]
- [REQ-2] [Requirement description]
- [REQ-3] [Requirement description]

## Epics

### Epic: [epic-slug]
- **Description**: This epic implements [what], enabling [benefit]
- **Requirement**: REQ-1, REQ-2
- **Status**: explore | plan | implement | complete
- **Effort**: [normalized fibonacci] | TBD

### Epic: [epic-slug-2]
- **Description**: This epic implements [what], enabling [benefit]
- **Requirement**: REQ-3
- **Status**: pending
- **Effort**: TBD
```

## Section Guidelines

### Vision

Write one clear paragraph that answers:
- What is this project?
- Why does it exist?
- What problem does it solve?
- Who benefits?

**Good example:**
```markdown
## Vision

A racing game where players drive boxes instead of cars through procedurally generated tracks. The game emphasizes physics-based gameplay and creative track design, allowing players to build and share custom tracks with the community.
```

**Bad example:**
```markdown
## Vision

This is a game. It will be fun and have features.
```

### Requirements

List concrete, verifiable requirements using REQ-N format:

**Good requirements:**
```markdown
- [REQ-1] Players can drive box vehicles with realistic physics
- [REQ-2] Players can create custom tracks using an editor
- [REQ-3] Tracks can be saved, loaded, and shared
- [REQ-4] Multiplayer supports up to 4 players locally
```

**Bad requirements:**
```markdown
- [REQ-1] Game should be good
- [REQ-2] Should have features
- [REQ-3] Works correctly
```

### Epic Entries

Each epic entry needs:

1. **Slug**: kebab-case identifier after "Epic:"
2. **Description**: "This epic implements X, enabling Y"
3. **Requirement**: Which REQ-N items this epic addresses
4. **Status**: Current phase (`pending`, `explore`, `plan`, `implement`, `complete`)
5. **Effort**: Normalized Fibonacci or `TBD` if not yet estimated

**Good epic:**
```markdown
### Epic: track-creator
- **Description**: This epic implements the track creation system, allowing players to design and share custom racing tracks
- **Requirement**: REQ-2, REQ-3
- **Status**: explore
- **Effort**: TBD
```

**Bad epic:**
```markdown
### Epic: stuff
- **Description**: Does track things
- **Requirement**: various
- **Status**: working on it
- **Effort**: lots
```

## Complete Example

```markdown
# PRD: Box Racing Game

## Vision

A racing game where players drive physics-based box vehicles through creative tracks. The game focuses on accessible controls, satisfying physics, and community-driven content through a track editor and sharing system.

## Requirements

- [REQ-1] Players can control box vehicles with intuitive physics
- [REQ-2] Game includes at least 5 built-in tracks
- [REQ-3] Players can create custom tracks with an editor
- [REQ-4] Tracks can be saved locally and shared via export
- [REQ-5] Local multiplayer supports 2-4 players
- [REQ-6] Game runs at 60fps on mid-range hardware

## Epics

### Epic: core-physics
- **Description**: This epic implements the core vehicle physics system, enabling box vehicles to drive, jump, and collide realistically
- **Requirement**: REQ-1, REQ-6
- **Status**: complete
- **Effort**: 13

### Epic: built-in-tracks
- **Description**: This epic creates the default track collection, providing players with immediate gameplay content
- **Requirement**: REQ-2
- **Status**: implement
- **Effort**: 8

### Epic: track-creator
- **Description**: This epic implements the track creation system, allowing players to design and share custom racing tracks
- **Requirement**: REQ-3, REQ-4
- **Status**: explore
- **Effort**: TBD

### Epic: multiplayer
- **Description**: This epic adds local multiplayer support, enabling friends to race together on the same screen
- **Requirement**: REQ-5
- **Status**: pending
- **Effort**: TBD
```

## PRD Maintenance

### Adding New Epics

When adding a new epic:
1. Add new requirements to Requirements section if needed
2. Add epic entry with `pending` status and `TBD` effort
3. Update state.json to match
4. Commit: `docs(prd): add [epic-slug] epic`

### Updating Epic Status

When epic progresses:
1. Update Status field to new phase
2. Update Effort if newly estimated
3. Update state.json to match
4. Status changes committed automatically by workflow

### Completing Requirements

When requirement is fully met:
1. Verify all related epics are complete
2. Consider adding checkmark or note
3. Do not remove requirements (maintain history)
