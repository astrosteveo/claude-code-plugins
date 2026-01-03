# Templates

Templates for SUPERHARNESS workflow artifacts. All templates use YAML frontmatter for metadata.

## Frontmatter Specification

### Common Fields (All Templates)

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `date` | Yes | ISO 8601 | Creation timestamp (`YYYY-MM-DDTHH:MM:SSZ`) |
| `researcher` | Yes | String | Who created this document (usually `Claude`) |
| `topic` | Yes | String | Brief description (quoted if contains special chars) |
| `tags` | Yes | Array | Categorization tags `[tag1, tag2, tag3]` |
| `status` | Yes | Enum | Document state (see valid values below) |

### Valid Status Values

| Template | Valid Statuses | Description |
|----------|---------------|-------------|
| research | `in_progress`, `complete`, `blocked` | Research lifecycle |
| plan | `draft`, `approved`, `in_progress`, `complete`, `abandoned` | Plan lifecycle |
| handoff | `in_progress`, `resolved`, `abandoned` | Handoff lifecycle |
| backlog | `active` | Always active (living document) |

### Template-Specific Fields

#### research-template.md

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `context` | Yes | String | What task this research supports |
| `feature_directory` | Yes | Path | `.harness/NNN-feature-slug/` |

#### plan-template.md

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `feature_directory` | Yes | Path | `.harness/NNN-feature-slug/` |
| `research` | Yes | Path | Link to research.md that informed this plan |

#### handoff-template.md

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `supersedes` | Optional | Path | Previous handoff this replaces (for checkpoint mode) |

#### backlog-template.md

No additional fields required.

## Example Frontmatter

### Research
```yaml
---
date: 2026-01-03T14:30:00Z
researcher: Claude
topic: "Authentication System Research"
tags: [research, auth, security]
status: in_progress
context: "Research for adding OAuth2 support"
feature_directory: ".harness/003-auth/"
---
```

### Plan
```yaml
---
date: 2026-01-03T15:00:00Z
researcher: Claude
topic: "OAuth2 Implementation Plan"
tags: [plan, auth, oauth2]
status: approved
feature_directory: ".harness/003-auth/"
research: ".harness/003-auth/research.md"
---
```

### Handoff
```yaml
---
date: 2026-01-03T18:00:00Z
researcher: Claude
topic: "OAuth2 Phase 2 Checkpoint"
tags: [handoff, auth, oauth2]
status: in_progress
supersedes: ".harness/003-auth/handoff-phase1.md"
---
```

## Validation Rules

1. **Date format**: Must be valid ISO 8601 (`YYYY-MM-DDTHH:MM:SSZ`)
2. **Tags**: Must be array syntax `[tag1, tag2]`, not string
3. **Paths**: Use relative paths from repository root
4. **Quotes**: Use double quotes for values containing colons, special characters
5. **Status**: Must be one of the valid values for that template type
