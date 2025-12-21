---
name: project-tracking
description: Use this skill to maintain project context across sessions. Read docs/project.md at session start. Update it as work completes. Enables natural conversation about what to work on next.
---

# Project Tracking

Maintain a living document that tracks project evolution, enabling continuity between sessions.

## The Project File

**Location:** `docs/project.md`

This file is the source of truth for project context. Read it at session start. Update it as work progresses.

## Template

```markdown
# Project Name

## Vision
[What this project is and why it exists - 2-3 sentences]

## Tech Stack
- **Language/Framework**: [X]
- **Key Dependencies**: [Y]
- **Deployment**: [Z]

## Decisions Log
| Date | Decision | Rationale |
|------|----------|-----------|
| YYYY-MM-DD | [Decision made] | [Why we made it] |

## Completed
- [x] [Feature/milestone] (YYYY-MM-DD)

## Current Focus
[What we're actively working on right now - updated when starting new work]

## Next Steps
- [ ] [Next thing to build]
- [ ] [After that]
- [ ] [Then this]

## Notes
[Context useful between sessions - blockers, ideas, open questions, gotchas]
```

## When to Read

- **Session start**: Check docs/project.md for context
- **"What should we work on?"**: Read Next Steps, suggest based on priority
- **Before planning**: Understand what's done and what's next

## When to Update

- **After completing work**: Move item from Current Focus → Completed
- **After planning**: Add items to Next Steps
- **After key decisions**: Log in Decisions table
- **When context matters**: Add to Notes

## Natural Conversation

When user asks "what should we work on next?":
1. Read docs/project.md
2. Look at Next Steps and Current Focus
3. Consider what's Completed (dependencies)
4. Suggest the logical next item with reasoning

When user describes new work:
1. Check if it fits Vision
2. Add to Next Steps or Current Focus
3. Start brainstorming/research/planning as appropriate

## Creating New Projects

If no docs/project.md exists and user wants to start a new project:
1. Use brainstorming skill to understand what they're building
2. Create docs/project.md with initial Vision, Tech Stack
3. Add initial Next Steps from brainstorming output

## Keeping It Light

- This is a **living document**, not a formal spec
- Update incrementally, don't rewrite
- Keep sections concise
- If it gets too long, archive old completed items
