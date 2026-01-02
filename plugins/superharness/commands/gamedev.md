---
name: gamedev
description: "Game development workflow with playtesting gates instead of TDD - for when 'does it feel fun?' can't be automated"
argument-hint: "<game concept or path to GDD>"
---

# Gamedev

You are tasked with guiding game development using a feel-first approach. Unlike standard development, games require manual playtesting because "is this fun?" cannot be automated.

## CRITICAL: Playtesting Gates Replace TDD

For game development:
- **TDD cannot verify feel** - "Does this jump feel good?" is subjective
- **Playtesting gates** pause for human testing between phases
- **Core mechanic first** - Validate the fun before building features
- **Reference game research** - Study what works in similar games

## Initial Response

### If concept/GDD provided:

```
I'll help you develop [game concept] using feel-first methodology.

Let me start by understanding:
1. What's the core mechanic? (The ONE thing players do most)
2. What reference games inspire this? (2-3 examples)
3. What should the core loop feel like? (Satisfying? Tense? Relaxing?)

This will guide our development approach.
```

### If no parameters provided:

```
I'll help you develop a game using feel-first methodology.

Tell me about your game:
1. High concept (1-2 sentences)
2. Core mechanic (the main thing players do)
3. Reference games (what inspired this?)

We'll build the core feel first, then add features.
```

## Gamedev Process

### Phase 1: Research & Reference Games

1. **Research reference games**:
   - Use web-researcher to find design analysis of reference games
   - Understand what makes their core loop engaging
   - Document patterns that work

2. **Create research document**:
   `.harness/NNN-game-name/research.md`

```markdown
# Research: [Game Name]

## Reference Games Analysis

### [Reference Game 1]
- Core loop: [Description]
- What makes it feel good: [Specifics]
- What to borrow: [Patterns]

### [Reference Game 2]
...

## Technical Research
- Engine/framework: [What to use]
- Key technical patterns: [How similar games are built]
```

### Phase 2: Game Design Document (GDD)

Create a focused GDD at `.harness/NNN-game-name/gdd.md`:

```markdown
# [Game Name] - Game Design Document

## High Concept
[1-2 sentences describing the game]

## Core Mechanic
[The ONE thing players do most - this MUST feel good]

### Core Loop
1. [Action 1]
2. [Feedback 1]
3. [Action 2]
4. [Feedback 2]
→ Return to 1

### Target Feel
[How should this feel? Snappy? Weighty? Floaty?]

## Reference Games
- [Game 1]: Borrowing [specific element]
- [Game 2]: Inspired by [specific element]

## MVP Scope (Core Only)
- [ ] Core mechanic implemented
- [ ] Basic feedback (sound, visual)
- [ ] One complete loop
- [ ] Playable prototype

## Nice-to-Have (After Core Validated)
- [ ] Feature A
- [ ] Feature B
- [ ] Feature C

## Out of Scope (Future/Never)
- [ ] Feature X
- [ ] Feature Y
```

### Phase 3: Implementation Plan with Playtesting Gates

Create plan at `.harness/NNN-game-name/plan.md`:

```markdown
# [Game Name] Implementation Plan

## Phase 1: Core Mechanic Prototype

### Goal
Implement the core mechanic in its simplest form.

### Changes
- [Basic input handling]
- [Core action implementation]
- [Minimal visual feedback]

### Playtesting Gate
**STOP and playtest before proceeding:**
- [ ] Does the core action feel responsive?
- [ ] Is the basic timing right?
- [ ] Does it feel like the reference games?

**Questions to answer:**
- What adjustments are needed?
- Is this worth continuing?

---

## Phase 2: Core Loop

### Goal
Complete one full loop of gameplay.

### Changes
- [State management]
- [Loop completion logic]
- [Basic scoring/feedback]

### Playtesting Gate
**STOP and playtest before proceeding:**
- [ ] Is one loop satisfying?
- [ ] Does "one more loop" feeling exist?
- [ ] What breaks the flow?

---

## Phase 3: Polish & Juice

### Goal
Add feedback that enhances the feel.

### Changes
- [Screen shake, particles, etc.]
- [Sound effects]
- [Animation polish]

### Playtesting Gate
**STOP and playtest before proceeding:**
- [ ] Does it FEEL better?
- [ ] Is any feedback annoying?
- [ ] Ready for external testers?
```

### Phase 4: Execute with Playtesting

When implementing, follow this pattern:

1. **Implement phase changes**
2. **Commit work**
3. **STOP at playtesting gate**

```
Phase 1 Complete - Ready for Playtesting

I've implemented the core mechanic. Before proceeding:

Please playtest and answer:
- [ ] Does the core action feel responsive?
- [ ] Is the basic timing right?
- [ ] Does it feel like [reference game]?

What adjustments should we make before Phase 2?
```

Wait for user feedback before continuing.

## Key Principles

### Feel First, Features Later

1. Core mechanic MUST feel good before adding features
2. Resist feature creep until core is validated
3. Cut features that don't serve the core loop

### Playtest Early, Playtest Often

- Every phase ends with a playtesting gate
- External playtester feedback > developer assumptions
- Watch people play, don't just ask what they think

### Reference Games Are Your Guide

- Study what works in successful games
- Borrow proven patterns (this is good game design)
- Understand WHY something works, not just WHAT works

### Iteration > Perfection

- First pass won't be right
- Plan to iterate based on playtest feedback
- Kill ideas that don't work (don't sink-cost them)

## When Things Don't Feel Right

If playtesting reveals problems:

1. **Analyze the feedback**
   - What specifically doesn't feel good?
   - When does it break down?

2. **Research solutions**
   - How do reference games solve this?
   - What techniques exist for this problem?

3. **Iterate the plan**
   - Use `/superharness:iterate` to update the plan
   - Add a fix phase before continuing

4. **Re-test**
   - After changes, playtest again
   - Don't proceed until it feels right

## Backlog for Games

Track game-specific items in BACKLOG.md:

```markdown
### [FEEL-001] [High] Jump feels floaty
**Source**: Phase 1 playtesting
**Description**: Jump doesn't have enough weight
**Reference**: Look at Celeste's gravity curve
```

## Cross-References

- For code research: `/superharness:research`
- To update plan: `/superharness:iterate`
- For debugging: `/superharness:debug`
- To handoff: `/superharness:handoff`
