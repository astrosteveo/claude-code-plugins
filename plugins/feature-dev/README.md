# Feature Development Plugin

A comprehensive, structured workflow for feature development with specialized agents for codebase exploration, architecture design, and quality review.

## Overview

The Feature Development Plugin provides a systematic 7-phase approach to building new features. Instead of jumping straight into code, it guides you through understanding the codebase, asking clarifying questions, designing architecture, and ensuring quality—resulting in better-designed features that integrate seamlessly with your existing code.

## Philosophy

Building features requires more than just writing code. You need to:
- **Understand the codebase** before making changes
- **Ask questions** to clarify ambiguous requirements
- **Design thoughtfully** before implementing
- **Review for quality** after building

This plugin embeds these practices into a structured workflow that runs automatically when you use the `/feature-dev` command.

## Command: `/feature-dev`

Launches a guided feature development workflow with 7 distinct phases.

**Usage:**
```bash
/feature-dev Add user authentication with OAuth
```

Or simply:
```bash
/feature-dev
```

The command will guide you through the entire process interactively.

## The 7-Phase Workflow

### Phase 1: Requirements

**Goal**: Fully understand what needs to be built through Socratic dialogue

**What happens:**
- Starts broad, then narrows down through questioning
- **Problem Space**: What problem is being solved? Who experiences it?
- **Solution Vision**: What does success look like? What's the user experience?
- **Constraints**: Technical constraints, performance requirements, compatibility needs?
- **Success Criteria**: How do we know it's done? How do we test it?
- Questions are asked ONE AT A TIME - no assumptions

**Example:**
```
You: /feature-dev Add caching
Claude: Let me understand what you need...
        - What problem is this solving? (slow API responses, repeated computations?)
        - Who experiences this problem most?
        - What does success look like for you?
```

**Artifact produced:** `requirements.md`

### Phase 2: Exploration

**Goal**: Understand relevant existing code and patterns

**What happens:**
- Launches 2-3 `code-explorer` agents in parallel
- Each agent explores different aspects (similar features, architecture, patterns)
- Agents return comprehensive analyses with key files to read
- Claude reads all identified files to build deep understanding
- Documents any tech debt, bugs, or improvements discovered (logged to backlog)

**Agents launched:**
- "Find features similar to [feature] and trace implementation"
- "Map the architecture and abstractions for [area]"
- "Identify patterns, testing approaches, extension points"

**Example output:**
```
Found similar features:
- User authentication (src/auth/): Uses JWT tokens, middleware pattern
- Session management (src/session/): Redis-backed, 24hr expiry
- API security (src/api/middleware/): Rate limiting, CORS

Key files to understand:
- src/auth/AuthService.ts:45 - Core authentication logic
- src/middleware/authMiddleware.ts:12 - Request authentication
- src/config/security.ts:8 - Security configuration
```

**Artifact produced:** `exploration.md`

### Phase 3: Architecture

**Goal**: Design multiple implementation approaches

**What happens:**
- Launches 2-3 `code-architect` agents with different focuses:
  - **Minimal changes**: Smallest diff, maximum reuse
  - **Clean architecture**: Maintainability, elegant abstractions
  - **Pragmatic balance**: Speed + quality
- Reviews all approaches and forms recommendation
- Presents comparison with trade-offs
- **Asks which approach you prefer**

**Example output:**
```
I've designed 3 approaches:

Approach 1: Minimal Changes
- Extend existing AuthService with OAuth methods
- Add new OAuth routes to existing auth router
Pros: Fast, low risk
Cons: Couples OAuth to existing auth, harder to test

Approach 2: Clean Architecture
- New OAuthService with dedicated interface
- Separate OAuth router and middleware
Pros: Clean separation, testable, maintainable
Cons: More files, more refactoring

Approach 3: Pragmatic Balance
- New OAuthProvider abstraction
- Integrate into existing AuthService
Pros: Balanced complexity and cleanliness
Cons: Some coupling remains

Recommendation: Approach 3 - fits your existing architecture well.

Which approach would you like to use?
```

**Artifact produced:** `architecture.md`

### Phase 4: Plan

**Goal**: Create detailed implementation steps

**What happens:**
- Reviews all artifacts: requirements, exploration, architecture
- Breaks down into specific, ordered tasks
- Identifies dependencies between tasks
- Creates testing and verification plan

**Example output:**
```
## Tasks

### Task 1: Create OAuthProvider interface
- File: src/auth/OAuthProvider.ts (new)
- Depends on: nothing

### Task 2: Implement GoogleOAuthProvider
- File: src/auth/providers/GoogleOAuthProvider.ts (new)
- Depends on: Task 1

### Task 3: Update AuthService
- File: src/auth/AuthService.ts (modify)
- Depends on: Task 2
```

**Artifact produced:** `plan.md`

### Phase 5: Implementation

**Goal**: Build the feature

**What happens:**
- **Waits for explicit approval** before starting ("Proceed with implementation?")
- Works through each task from the plan in order
- Follows codebase conventions strictly
- Updates todos as progress is made

**Notes:**
- Implementation only starts after you say "yes"
- Follows patterns discovered in Phase 2
- Uses architecture chosen in Phase 3
- All tasks must complete before proceeding

### Phase 6: Review

**Goal**: Ensure quality

**What happens:**
- Launches 3 `code-reviewer` agents in parallel with different focuses:
  - **Simplicity/DRY/Elegance**: Code quality and maintainability
  - **Bugs/Correctness**: Functional correctness and logic errors
  - **Conventions/Abstractions**: Project standards and patterns
- Consolidates findings (only high-confidence issues ≥80)
- Presents findings and **asks what you want to do**:
  - Fix now
  - Fix later
  - Proceed as-is
- Any pre-existing issues discovered are logged to the backlog

**Example output:**
```
Code Review Results:

Critical Issues:
1. [95] Missing error handling in OAuth callback (src/auth/oauth.ts:67)
2. [88] Memory leak: OAuth state not cleaned up (src/auth/oauth.ts:89)

Important Issues:
1. [82] Could simplify token refresh logic (src/auth/oauth.ts:120)

What would you like to do? Fix now, fix later, or proceed as-is?
```

**Artifact produced:** `review.md`

### Phase 7: Summary

**Goal**: Document completion and update project tracking

**What happens:**
- Marks all todos complete
- Summarizes what was built, key decisions, files changed, next steps
- Updates `.feature-dev/dashboard.md` with recommended next steps
- Promotes high-priority backlog items to dashboard
- Reminds you about the feature branch for PR/merge

**Example:**
```
Feature Complete: OAuth Authentication

What was built:
- OAuth provider abstraction supporting Google and GitHub
- OAuth routes and middleware integrated with existing auth
- Token refresh and session integration

Key decisions:
- Used pragmatic approach with OAuthProvider abstraction
- Integrated with existing session management

Files changed:
- src/auth/OAuthProvider.ts (new)
- src/auth/AuthService.ts
- src/routes/auth.ts

Next steps:
- Add tests for OAuth flows
- Add more OAuth providers (Microsoft, Apple)

Git: Work is on branch `feature/003-oauth-auth`. Ready to create PR or merge.
```

**Artifact produced:** `summary.md`

## Agents

### `code-explorer`

**Purpose**: Deeply analyzes existing codebase features by tracing execution paths

**Focus areas:**
- Entry points and call chains
- Data flow and transformations
- Architecture layers and patterns
- Dependencies and integrations
- Implementation details

**When triggered:**
- Automatically in Phase 2
- Can be invoked manually when exploring code

**Output:**
- Entry points with file:line references
- Step-by-step execution flow
- Key components and responsibilities
- Architecture insights
- List of essential files to read

### `code-architect`

**Purpose**: Designs feature architectures and implementation blueprints

**Focus areas:**
- Codebase pattern analysis
- Architecture decisions
- Component design
- Implementation roadmap
- Data flow and build sequence

**When triggered:**
- Automatically in Phase 3
- Can be invoked manually for architecture design

**Output:**
- Patterns and conventions found
- Architecture decision with rationale
- Complete component design
- Implementation map with specific files
- Build sequence with phases

### `code-reviewer`

**Purpose**: Reviews code for bugs, quality issues, and project conventions

**Focus areas:**
- Project guideline compliance (CLAUDE.md)
- Bug detection
- Code quality issues
- Confidence-based filtering (only reports high-confidence issues ≥80)

**When triggered:**
- Automatically in Phase 6
- Can be invoked manually after writing code

**Output:**
- Critical issues (confidence 75-100)
- Important issues (confidence 50-74)
- Specific fixes with file:line references
- Project guideline references

## Usage Patterns

### Full workflow (recommended for new features):
```bash
/feature-dev Add rate limiting to API endpoints
```

Let the workflow guide you through all 7 phases.

### Manual agent invocation:

**Explore a feature:**
```
"Launch code-explorer to trace how authentication works"
```

**Design architecture:**
```
"Launch code-architect to design the caching layer"
```

**Review code:**
```
"Launch code-reviewer to check my recent changes"
```

## Best Practices

1. **Use the full workflow for complex features**: The 7 phases ensure thorough planning
2. **Answer requirements questions thoughtfully**: Phase 1 prevents future confusion
3. **Choose architecture deliberately**: Phase 3 gives you options for a reason
4. **Don't skip code review**: Phase 6 catches issues before they reach production
5. **Read the suggested files**: Phase 2 identifies key files—read them to understand context

## When to Use This Plugin

**Use for:**
- New features that touch multiple files
- Features requiring architectural decisions
- Complex integrations with existing code
- Features where requirements are somewhat unclear

**Don't use for:**
- Single-line bug fixes
- Trivial changes
- Well-defined, simple tasks
- Urgent hotfixes

## Requirements

- Claude Code installed
- Git repository (for code review)
- Project with existing codebase (workflow assumes existing code to learn from)

## Troubleshooting

### Agents take too long

**Issue**: Code exploration or architecture agents are slow

**Solution**:
- This is normal for large codebases
- Agents run in parallel when possible
- The thoroughness pays off in better understanding

### Too many requirements questions

**Issue**: Phase 1 asks too many questions

**Solution**:
- Be more specific in your initial feature request
- Provide context about constraints upfront
- Say "whatever you think is best" if truly no preference

### Architecture options overwhelming

**Issue**: Too many architecture options in Phase 3

**Solution**:
- Trust the recommendation—it's based on codebase analysis
- If still unsure, ask for more explanation
- Pick the pragmatic option when in doubt

## Tips

- **Be specific in your feature request**: More detail = fewer clarifying questions
- **Trust the process**: Each phase builds on the previous one
- **Review agent outputs**: Agents provide valuable insights about your codebase
- **Don't skip phases**: Each phase serves a purpose
- **Use for learning**: The exploration phase teaches you about your own codebase

## Author

AstroSteveo

## Version

1.1.0
