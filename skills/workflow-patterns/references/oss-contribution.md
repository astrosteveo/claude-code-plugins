# OSS Contribution Workflow

Guide for using the agile-workflow plugin when contributing to open source projects.

## Key Principle

Your workflow artifacts stay local. The OSS project only sees:
- Your code changes
- Your commits (following *their* conventions)
- Your PR (following *their* template)

## Workflow Adaptation

| Standard Workflow | OSS Adaptation |
|-------------------|----------------|
| Create PRD from vision | Scope PRD to the issue you're tackling |
| Define requirements | Requirements come from the GitHub issue |
| Explore your codebase | Explore *their* codebase (critical!) |
| Plan implementation | Plan your contribution approach |
| Implement and commit | Follow *their* commit conventions |

## Directory Structure for OSS Contributions

```
their-project/
├── src/                    # Their code
├── CONTRIBUTING.md         # READ THIS FIRST
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md
└── .claude/
    └── workflow/           # Your local workflow (don't commit!)
        ├── PRD.md          # Your contribution scope
        ├── state.json
        ├── project-conventions.md  # Detected conventions
        └── epics/
            └── fix-issue-123/
                ├── research.md
                └── plan.md
```

**Important:** Add `.claude/` to your local `.git/info/exclude` to avoid accidentally committing workflow artifacts.

## PRD Format for OSS Contributions

```markdown
# PRD: Contribution to [project-name]

## Context
- **Repository**: [owner/repo]
- **Issue**: #123 - [issue title]
- **CONTRIBUTING.md**: [key requirements noted]

## Requirements
- [REQ-1] Fix the bug described in issue #123
- [REQ-2] Follow project's coding standards (see research)
- [REQ-3] Add tests per CONTRIBUTING.md requirements
- [REQ-4] Update documentation if behavior changes

## Epics

### Epic: fix-issue-123
- **Description**: This epic fixes [issue description]
- **Requirement**: REQ-1, REQ-2, REQ-3
- **Status**: explore
- **Effort**: TBD
```

## Convention Detection

### Files to Check

**Project Guidelines:**
- `CONTRIBUTING.md` or `.github/CONTRIBUTING.md`
- `CODE_OF_CONDUCT.md`
- `DEVELOPMENT.md` or `HACKING.md`

**Code Style:**
- `.editorconfig`
- `.prettierrc`, `.prettierrc.json`, `.prettierrc.js`
- `.eslintrc`, `.eslintrc.json`, `eslint.config.js`
- `biome.json`
- `rustfmt.toml`
- `.rubocop.yml`
- `.clang-format`

**Build/Test:**
- `Makefile`, `justfile`
- `package.json` scripts
- `.github/workflows/` (CI requirements)

**Commit Conventions:**
- `.gitmessage`
- Recent `git log --oneline` patterns
- CONTRIBUTING.md guidelines

### project-conventions.md Template

```markdown
# Project Conventions: [project-name]

## Source
- CONTRIBUTING.md: [path or "not found"]
- Code style config: [files found]
- CI workflows: [files found]

## Code Style
- Formatter: [e.g., prettier, rustfmt, none]
- Linter: [e.g., eslint, clippy, none]
- Run before commit: [commands]

## Commit Message Format
- Style: [Conventional Commits / project-specific / none]
- Example from git log: `[example message]`
- Required elements: [issue reference? scope?]

## PR Requirements
- Tests required: [yes/no]
- Coverage threshold: [if any]
- Changelog entry: [yes/no]
- Squash commits: [yes/no/preferred]

## CI Checks
- Must pass: [list of required checks]
- Commands to run locally: [list]
```

## Commit Message Patterns

### Conventional Commits (Common)
```
feat(auth): add OAuth login support

Implements OAuth2 login flow with Google provider.

Closes #123
```

### GitHub Style
```
Add OAuth login support (#123)

Implements OAuth2 login flow with Google provider.
```

### Linux Kernel Style
```
auth: add OAuth login support

Implements OAuth2 login flow with Google provider.

Signed-off-by: Your Name <email@example.com>
```

### Simple/No Convention
```
Add OAuth login support

This commit implements OAuth2 login flow with Google provider,
addressing the feature request in issue #123.
```

## Pre-Commit Checklist

Before committing to an OSS project:

1. **Code formatted?**
   ```bash
   npm run format  # or project equivalent
   ```

2. **Linter passes?**
   ```bash
   npm run lint  # or project equivalent
   ```

3. **Tests pass?**
   ```bash
   npm test  # or project equivalent
   ```

4. **Commit message follows conventions?**
   - Check CONTRIBUTING.md
   - Check recent git log

5. **Only code changes committed?**
   - No `.claude/workflow/` files
   - No unrelated changes

## PR Checklist

Before creating PR:

1. **Read PR template** (`.github/PULL_REQUEST_TEMPLATE.md`)
2. **Fill all required sections**
3. **Link to issue** (Closes #123 or Fixes #123)
4. **CI passes** on your branch
5. **Commits are clean** (squash if project prefers)
6. **No merge commits** (rebase if needed)

## Common Pitfalls

### Don't:
- Commit workflow artifacts to OSS repo
- Use your preferred commit style over theirs
- Skip running their test suite
- Ignore CI failures
- Make unrelated changes in same PR
- Force push to shared branches

### Do:
- Read CONTRIBUTING.md thoroughly
- Match existing code style exactly
- Run all checks locally before pushing
- Keep PRs focused on single issue
- Respond promptly to review feedback
- Be patient with maintainers
