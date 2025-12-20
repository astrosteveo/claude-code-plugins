# State Schema Reference

Complete JSON schema for `.claude/workflow/state.json`.

## Full Schema

```json
{
  "project": "project-name",
  "epics": {
    "epic-slug": {
      "name": "Epic Name",
      "description": "This epic implements X, enabling Y",
      "ac": [
        "Acceptance criterion 1",
        "Acceptance criterion 2"
      ],
      "effort": 13,
      "status": "pending | in_progress | completed",
      "phase": "explore | plan | implement | complete",
      "stories": {
        "story-slug": {
          "name": "Story Name",
          "description": "As a [user], I want [goal], so that [benefit]",
          "ac": [
            "Acceptance criterion 1",
            "Acceptance criterion 2"
          ],
          "effort": 5,
          "status": "pending | in_progress | completed",
          "blockers": ["other-story-slug"]
        }
      }
    }
  }
}
```

## Field Definitions

### Project Level

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `project` | string | Yes | Project identifier (slug format) |
| `epics` | object | Yes | Map of epic-slug to epic object |

### Epic Level

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Human-readable epic name |
| `description` | string | Yes | "This epic implements X, enabling Y" format |
| `ac` | string[] | Yes | Epic-level acceptance criteria |
| `effort` | number\|null | No | Sum of story points, normalized to Fibonacci |
| `status` | enum | Yes | `pending`, `in_progress`, `completed` |
| `phase` | enum\|null | No | `explore`, `plan`, `implement`, `complete` |
| `stories` | object | Yes | Map of story-slug to story object |

### Story Level

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Human-readable story name |
| `description` | string | Yes | User story format: "As a..., I want..., so that..." |
| `ac` | string[] | Yes | Testable acceptance criteria |
| `effort` | number | Yes | Fibonacci points: 1, 2, 3, 5, 8, 13 |
| `status` | enum | Yes | `pending`, `in_progress`, `completed` |
| `blockers` | string[] | Yes | Array of story slugs that block this story |

## Status Transitions

### Epic Status

```
pending → in_progress → completed
```

- `pending`: Epic not yet started
- `in_progress`: At least one phase has begun
- `completed`: All stories completed, epic done

### Epic Phase

```
null → explore → plan → implement → complete
```

- `null`: Epic created but not started
- `explore`: Researching codebase
- `plan`: Creating implementation plan
- `implement`: Executing stories
- `complete`: All work done

### Story Status

```
pending → in_progress → completed
```

- `pending`: Story not yet started
- `in_progress`: Currently being implemented
- `completed`: Story done, AC verified

## Example: Complete State File

```json
{
  "project": "racing-game",
  "epics": {
    "track-creator": {
      "name": "Track Creator",
      "description": "This epic implements the track creation system, allowing players to design custom racing tracks",
      "ac": [
        "Players can create new tracks from scratch",
        "Players can save and load track designs",
        "Tracks can be shared with other players"
      ],
      "effort": 13,
      "status": "in_progress",
      "phase": "implement",
      "stories": {
        "track-editor-ui": {
          "name": "Track Editor UI",
          "description": "As a player, I want a visual track editor, so that I can design tracks by placing elements",
          "ac": [
            "Canvas displays grid for track placement",
            "Toolbar shows available track pieces",
            "Drag and drop places pieces on grid"
          ],
          "effort": 5,
          "status": "completed",
          "blockers": []
        },
        "track-persistence": {
          "name": "Track Persistence",
          "description": "As a player, I want to save my tracks, so that I can continue editing later",
          "ac": [
            "Save button persists track to local storage",
            "Load button shows list of saved tracks",
            "Tracks serialize to JSON format"
          ],
          "effort": 3,
          "status": "in_progress",
          "blockers": []
        },
        "track-validation": {
          "name": "Track Validation",
          "description": "As a player, I want track validation, so that I only save playable tracks",
          "ac": [
            "Validator checks for connected start/finish",
            "Validator ensures no impossible jumps",
            "Error messages highlight problem areas"
          ],
          "effort": 5,
          "status": "pending",
          "blockers": ["track-persistence"]
        }
      }
    }
  }
}
```

## Effort Calculation

### Story Effort

Assign Fibonacci points based on complexity:

| Points | Meaning |
|--------|---------|
| 1 | Trivial change |
| 2 | Simple change |
| 3 | Moderate complexity |
| 5 | Complex work |
| 8 | Large scope |
| 13 | Very large (consider splitting) |

### Epic Effort

1. Sum all story points
2. Normalize to nearest Fibonacci

**Normalization:**
```
Sum 1-2   → 2
Sum 3-4   → 3
Sum 5-6   → 5
Sum 7-10  → 8
Sum 11-16 → 13
Sum 17-27 → 21
Sum 28+   → Break down further
```

## Validation Rules

### Required for Epic Start

Before `phase` can be set to `explore`:
- `name` must be set
- `description` must be set
- `ac` must have at least one item
- PRD.md must exist

### Required for Implementation

Before `phase` can be set to `implement`:
- `epics/[slug]/plan.md` must exist
- At least one story must be defined
- All stories must have `effort` assigned

### Blocker Resolution

- Stories with non-empty `blockers` cannot be `in_progress`
- Blockers must reference valid story slugs within same epic
- Circular blockers are invalid
