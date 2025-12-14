# Commit Message Template

This template provides the structure for creating documented commits with workflow artifacts.

## Structure

```
<type>: <concise description from feature name>

<Summary of key changes from state.md>

Artifacts:
- Research: .claude/workflows/[slug]/*-research.md
- Plan: .claude/workflows/[slug]/plan.md
- State: .claude/workflows/[slug]/state.md
- Validation: .claude/workflows/[slug]/validation.md

Generated with Claude Code using explore-plan-implement workflow
```

## Components

### Subject Line
- **Format**: `<type>: <description>`
- **Type**: Use conventional commit type (feat, fix, refactor, docs, test, chore, etc.)
- **Description**: Concise summary from feature name in state.md (max 72 characters)
- **Example**: `feat: add user authentication with JWT`

### Body
- **Content**: Summary of key changes from state.md's "Current Progress" section
- **Format**: Clear bullet points or paragraphs describing what was implemented
- **Focus**: What changed and why (from the plan), not how (evident in the code)
- **Include**: Any deviations from original plan noted during implementation

### Artifacts Section
- **Purpose**: Document which workflow artifacts are included in this commit
- **Format**: Bulleted list with relative paths from repository root
- **List all**: Research (codebase + docs if applicable), Plan, State, Validation

### Footer
- **Signature**: `Generated with Claude Code using explore-plan-implement workflow`
- **Purpose**: Indicates this commit follows the structured workflow process

## Example 1: Feature Addition

```
feat: add user authentication with JWT

Implemented secure authentication system with the following changes:
- Created /api/auth/login and /api/auth/register endpoints
- Added JWT token generation and validation middleware
- Implemented password hashing using bcrypt
- Created user model with email/password fields
- Added protected route middleware for authenticated endpoints

All tests passing. Validation complete.

Artifacts:
- Research: .claude/workflows/001-add-auth/codebase-research.md
- Research: .claude/workflows/001-add-auth/docs-research.md
- Plan: .claude/workflows/001-add-auth/plan.md
- State: .claude/workflows/001-add-auth/state.md
- Validation: .claude/workflows/001-add-auth/validation.md

Generated with Claude Code using explore-plan-implement workflow
```

## Example 2: Bug Fix

```
fix: resolve user session timeout on refresh

Fixed issue where user sessions expired prematurely on page refresh:
- Updated token refresh logic in auth middleware
- Extended session duration from 1h to 24h
- Added automatic token refresh on application mount
- Fixed localStorage token persistence

Tests updated to cover refresh scenarios.

Artifacts:
- Research: .claude/workflows/002-fix-session/codebase-research.md
- Plan: .claude/workflows/002-fix-session/plan.md
- State: .claude/workflows/002-fix-session/state.md
- Validation: .claude/workflows/002-fix-session/validation.md

Generated with Claude Code using explore-plan-implement workflow
```

## Example 3: Refactoring

```
refactor: extract auth logic into service layer

Restructured authentication code for better maintainability:
- Created AuthService class to encapsulate auth logic
- Moved token validation from middleware to service
- Simplified controller methods using service layer
- No behavior changes, all existing tests pass

Artifacts:
- Research: .claude/workflows/003-refactor-auth/codebase-research.md
- Plan: .claude/workflows/003-refactor-auth/plan.md
- State: .claude/workflows/003-refactor-auth/state.md
- Validation: .claude/workflows/003-refactor-auth/validation.md

Generated with Claude Code using explore-plan-implement workflow
```

## Guidelines

### Subject Line
- Keep under 72 characters
- Use imperative mood ("add" not "added" or "adds")
- No period at the end
- Lowercase after the colon

### Body
- Wrap at 72 characters per line
- Use present tense
- Explain what and why, not how
- Reference key decisions from the plan
- Note any deviations or discoveries during implementation

### Artifacts
- Always list all artifacts committed
- Use paths relative to repository root
- Include both research files if docs were researched
- List in order: Research, Plan, State, Validation

### Footer
- Always include the workflow signature
- Helps future developers understand the process used
- Links commit to documented planning and validation
