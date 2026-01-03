# SUPERHARNESS Skills Index

Skills are loadable discipline content that commands reference via frontmatter.

## Foundation Skill (Injected at Session Start)

| Skill | Purpose | Loaded By |
|-------|---------|-----------|
| `superharness-core` | Core philosophy, command decision tree, quality gates | Session hook |

## Discipline Skills (Loaded by Commands)

| Skill | Purpose | Loaded By Commands |
|-------|---------|-------------------|
| `tdd` | RED-GREEN-REFACTOR cycle enforcement | `implement`, `debug` |
| `research-first` | Verify current APIs/versions before design | `research`, `create-plan`, `iterate` |
| `verification` | Evidence-based completion, no assumptions | `validate`, `implement`, `handoff` |
| `systematic-debugging` | 4-phase root cause analysis | `debug` |

## Skill Summaries

### superharness-core (Foundation)

**Injected at session start.** Establishes:
- Command decision tree (which command to use when)
- Quality gates (research before design, TDD, verification, systematic debugging)
- Incomplete work detection handling
- Directory structure (`.harness/`)
- Progress tracking (git trailers + checkbox sync)

### tdd (Test-Driven Development)

**The Iron Law:** No production code without a failing test first.

**RED-GREEN-REFACTOR cycle:**
1. RED: Write failing test
2. Verify RED: Watch it fail (MANDATORY)
3. GREEN: Write minimal code to pass
4. Verify GREEN: Watch it pass (MANDATORY)
5. REFACTOR: Clean up
6. Repeat

**Key rules:**
- Write code before test? Delete it. Start over.
- Test passes immediately? You're testing wrong thing.
- No exceptions without explicit user bypass.

### research-first

**The Iron Rule:** No designing until research is complete.

**Two required phases:**
1. **Codebase Exploration** - Use parallel agents to explore patterns, dependencies, tests
2. **External Research** - Verify current versions, APIs, best practices via web search

**Key rules:**
- Immediately start exploring. Don't ask questions.
- Training data is stale. Always verify.
- Both phases required every time.

### verification

**The Iron Law:** No completion claims without fresh verification evidence.

**The Gate Function:**
1. IDENTIFY: What command proves this claim?
2. RUN: Execute full command fresh
3. READ: Full output, check exit code
4. VERIFY: Does output confirm claim?
5. ONLY THEN: Make the claim

**Key rules:**
- "Should work" is not verification.
- Linter != compiler != tests.
- Trust agent success? Verify independently.

### systematic-debugging

**The Iron Law:** No fixes without root cause investigation first.

**Four phases:**
1. **Root Cause Investigation** - Read errors, reproduce, trace data flow
2. **Pattern Analysis** - Find working examples, compare differences
3. **Hypothesis Testing** - One change at a time, verify before continuing
4. **Implementation** - TDD for regression test, fix root cause

**Key rules:**
- 3+ failed fixes = question architecture, not fix again
- Never propose solutions before tracing data flow
- Simple bugs have root causes too

## Skill Loading Mechanism

Commands load skills via frontmatter:

```yaml
---
name: implement
description: "Execute plan with TDD and verification gates"
load-skills:
  - tdd
  - verification
---
```

When command is invoked:
1. Claude Code reads command file
2. Parses `load-skills` array
3. Prepends each skill's SKILL.md content
4. Claude receives: [skill content] + [command instructions]

## Command-to-Skill Mapping

| Command | Skills Loaded |
|---------|---------------|
| `/superharness:research` | `research-first` |
| `/superharness:create-plan` | `research-first` |
| `/superharness:implement` | `tdd`, `verification` |
| `/superharness:validate` | `verification` |
| `/superharness:iterate` | `research-first` |
| `/superharness:debug` | `systematic-debugging`, `tdd` |
| `/superharness:gamedev` | (none - uses playtesting gates) |
| `/superharness:handoff` | `verification` |
| `/superharness:resume` | (none) |
| `/superharness:backlog` | (none) |
| `/superharness:status` | (none) |
| `/superharness:resolve` | (none) |

## Skill File Format

```markdown
---
name: skill-name
description: "When this skill applies and what it enforces"
---

# Skill Title

## The Rule
What must always happen...

## The Process
Step-by-step instructions...

## Red Flags
Signs you're rationalizing skipping this...
```

## Adding New Skills

1. Create directory: `skills/new-skill-name/`
2. Create `SKILL.md` with frontmatter
3. Add to this INDEX.md
4. Reference in command frontmatter via `load-skills`
