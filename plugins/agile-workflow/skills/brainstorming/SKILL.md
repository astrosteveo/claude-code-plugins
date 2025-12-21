---
name: brainstorming
description: Use before any creative work - new features, new projects, or significant changes. Explores what the user really wants through Socratic dialogue before jumping into code.
---

# Brainstorming Ideas Into Designs

Turn ideas into fully formed designs through natural collaborative dialogue.

**Announce at start:** "I'm using brainstorming to design [topic]."

## The Process

**Understanding the idea:**
- Check current project context first (docs/project.md, recent files)
- Ask questions **one at a time** to refine the idea
- Prefer multiple choice when possible, open-ended when needed
- Focus on: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Lead with your recommendation and explain why
- Let user choose or suggest alternatives

**Presenting the design:**
- Once you understand what to build, present the design
- Break into sections of 200-300 words
- Ask after each section: "Does this look right so far?"
- Be ready to go back and clarify

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in chunks, validate each

## After the Design

**If new project:**
1. Create docs/project.md with Vision, Tech Stack, Next Steps
2. Offer to set up git worktree for isolated development
3. Proceed to planning

**If existing project:**
1. Update docs/project.md with new items in Next Steps
2. Proceed to research (if existing codebase) or planning (if greenfield addition)

## Questions to Ask

**For new projects:**
1. "What are you building? Give me the elevator pitch."
2. "What problem does this solve?"
3. "Who will use this?"
4. "What does success look like?"
5. "What's the tech stack?" (present options with recommendation)

**For new features:**
1. "What capability are you adding?"
2. "How does this relate to what exists?"
3. "What should the user experience be?"
4. "Any constraints or requirements?"

## Design Output

After validation, write the design to:
- `docs/plans/YYYY-MM-DD-<topic>-design.md`

Then offer next steps:
- "Ready to create an implementation plan?"
- "Want to research the codebase first?"
