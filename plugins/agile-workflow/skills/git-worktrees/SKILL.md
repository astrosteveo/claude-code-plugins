---
name: git-worktrees
description: Use this skill when starting a new feature, creating an isolated development environment, or when asked to set up a worktree. Provides safe, isolated workspace for development without affecting main branch.
---

# Git Worktrees

## Purpose

Create isolated development environments for features without affecting the main branch. Each worktree is a separate working directory with its own branch.

## When to Use

- Starting a new feature or epic
- Need to work on something without disturbing current work
- Want clean separation between features
- After design approval, before implementation

## Directory Selection Priority

1. **Existing `.worktrees/` directory** - If project already has one, use it
2. **CLAUDE.md preference** - Check if project specifies a location
3. **Ask user** - "Where should I create the worktree?"

## Safety Requirements

### For Project-Local Worktrees (`.worktrees/`)

**CRITICAL: Verify `.gitignore` contains the pattern BEFORE creating worktree.**

```bash
# Check if .gitignore contains .worktrees/
grep -q "\.worktrees" .gitignore

# If NOT found, add it FIRST
echo ".worktrees/" >> .gitignore
git add .gitignore
git commit -m "chore: add .worktrees to gitignore"
```

**Never proceed without this check. Worktree contents must not be committed.**

### For Global Worktrees (`~/.config/superpowers/worktrees/`)

No `.gitignore` verification needed - these are outside the project.

## Setup Process

### Step 1: Choose Location

```bash
# Option A: Project-local (recommended for most cases)
WORKTREE_DIR=".worktrees"

# Option B: Global (for cross-project work)
WORKTREE_DIR="$HOME/.config/superpowers/worktrees"
```

### Step 2: Safety Check (Project-Local Only)

```bash
# Verify .gitignore
if ! grep -q "\.worktrees" .gitignore; then
  echo ".worktrees/" >> .gitignore
  git add .gitignore
  git commit -m "chore: add .worktrees to gitignore"
fi
```

### Step 3: Create Worktree

```bash
# Create directory if needed
mkdir -p "$WORKTREE_DIR"

# Create worktree with new branch
git worktree add "$WORKTREE_DIR/feature-name" -b feature/feature-name

# Or from existing branch
git worktree add "$WORKTREE_DIR/feature-name" feature/feature-name
```

### Step 4: Project Setup

Auto-detect project type and run setup:

```bash
cd "$WORKTREE_DIR/feature-name"

# Node.js
if [ -f "package.json" ]; then
  npm install
fi

# Python (Poetry)
if [ -f "pyproject.toml" ]; then
  poetry install
fi

# Python (pip)
if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt
fi

# Go
if [ -f "go.mod" ]; then
  go mod download
fi

# Rust
if [ -f "Cargo.toml" ]; then
  cargo build
fi
```

### Step 5: Verify Baseline

**Run tests before declaring ready:**

```bash
# Run project test suite
npm test        # Node.js
pytest          # Python
go test ./...   # Go
cargo test      # Rust
```

If tests fail:
1. **Do NOT proceed without asking**
2. Report: "Baseline tests failing in worktree. Should I investigate or proceed anyway?"

### Step 6: Report Ready

```
Worktree ready at: /path/to/worktree
Branch: feature/feature-name
Tests: 47 passing, 0 failing

Ready to implement [feature-name]
```

## Worktree Management

### List Worktrees

```bash
git worktree list
```

### Switch Between Worktrees

```bash
# Just cd to the directory
cd .worktrees/feature-name
cd .worktrees/other-feature
```

### Remove Worktree

```bash
# After merging or discarding
git worktree remove .worktrees/feature-name

# Force remove (if unmerged changes)
git worktree remove --force .worktrees/feature-name
```

### Prune Stale Worktrees

```bash
# Clean up references to deleted worktrees
git worktree prune
```

## Common Patterns

### Feature Development

```bash
# Setup
git worktree add .worktrees/user-auth -b feature/user-auth
cd .worktrees/user-auth
npm install
npm test  # Verify baseline

# Work...

# Complete (after merge)
cd /original/project
git worktree remove .worktrees/user-auth
```

### Parallel Features

```bash
# Create multiple worktrees
git worktree add .worktrees/feature-a -b feature/feature-a
git worktree add .worktrees/feature-b -b feature/feature-b

# Work on either independently
cd .worktrees/feature-a  # Work on A
cd .worktrees/feature-b  # Work on B

# They don't interfere with each other
```

### Hotfix While on Feature

```bash
# Already on feature branch in worktree
# Need to do urgent fix on main

git worktree add .worktrees/hotfix -b hotfix/urgent-fix main
cd .worktrees/hotfix
# Fix, test, commit, push
cd ..
git worktree remove .worktrees/hotfix
```

## Constraints

- **Never skip .gitignore check** for project-local worktrees
- **Never proceed with failing baseline tests** without asking
- **Always run project setup** (npm install, etc.)
- **Always verify tests pass** before declaring ready
- **Always clean up** worktrees after merging/discarding
- **Never force-remove** without explicit user consent

## Integration Points

- Use after `brainstorming` approves a design
- Use before `writing-plans` creates implementation plan
- Pair with `finishing-branch` for completion workflow
