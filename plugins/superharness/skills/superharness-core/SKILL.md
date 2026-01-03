---
name: superharness-core
description: "INJECTED AT SESSION START. Foundation skill establishing command-driven workflow and quality gates."
---

<MANDATORY-SESSION-START-CHECK>
# INCOMPLETE WORK CHECK

**If you see "INCOMPLETE WORK DETECTED" above this skill content, you MUST:**

1. **STOP** - Do not respond to the user's message yet
2. **ASK** - Present the incomplete work info and ask: "Resume? [Yes / No / Abandon]"
3. **WAIT** - Do not proceed until the user responds

**Handling user response:**
- **Yes**: Run `/superharness:resume` (uses picker dialog if no path specified)
- **No**: Continue with the user's original request
- **Abandon**:
  - For plans: `git commit --allow-empty -m "chore: abandon plan\n\nplan: abandoned"`
  - For handoffs: `git commit --allow-empty -m "chore: abandon handoff\n\nhandoff-abandoned: <path>"`

| Rationalization for skipping | Reality |
|------------------------------|---------|
| "Let me respond to the user first" | NO. Ask about incomplete work FIRST. |
| "The user's question is more important" | Incomplete work is context. Address it first. |
| "I'll mention it later" | Later = forgotten. Ask NOW. |

</MANDATORY-SESSION-START-CHECK>

---

# ARE YOU HARNESSING THE FULL POWER OF CLAUDE CODE?

SUPERHARNESS is a command-driven development workflow. Users explicitly choose their stage.

## Available Commands

| Command | When to Use |
|---------|-------------|
| `/superharness:research` | Before building anything - understand codebase + verify current APIs |
| `/superharness:create-plan` | After research - design phased implementation with TDD tasks |
| `/superharness:implement` | After plan approved - execute with TDD and phase gates |
| `/superharness:validate` | After implementation - verify it matches the spec |
| `/superharness:iterate` | When plan needs updates based on feedback |
| `/superharness:debug` | When investigating issues - 4-phase root cause analysis |
| `/superharness:gamedev` | For game projects - playtesting gates instead of TDD |
| `/superharness:handoff` | When context is filling up - create handoff checkpoint |
| `/superharness:resume` | Resume from handoff - picker dialog + lifecycle management |
| `/superharness:resolve` | Resolve handoff explicitly (complete, supersede, abandon) |
| `/superharness:backlog` | View/manage bugs, deferred features, tech debt |
| `/superharness:status` | Check current progress and get recommendations |

## Command Decision Tree

```
User wants to build something new?
├─ YES → /superharness:research FIRST, then /superharness:create-plan
│
User has a plan ready to execute?
├─ YES → /superharness:implement
│
User is debugging an issue?
├─ YES → /superharness:debug (4-phase root cause, not random fixes)
│
User is building a game?
├─ YES → /superharness:gamedev (playtesting gates, not TDD)
│
User needs to pause work?
├─ YES → /superharness:handoff
│
User is resuming previous work?
├─ YES → /superharness:resume
│
User asks "what should I work on?"
├─ YES → /superharness:status (shows recommendations)
│
Not sure?
└─ ASK the user which command they want, or suggest based on context
```

## Quality Gates (Apply to ALL Commands)

### 1. Research Before Design
Never make architecture decisions based on training data. Always verify:
- Current library versions (training data may be 2+ years old)
- Current API signatures
- Current best practices

Use `/superharness:research` or the `web-researcher` agent.

### 2. TDD Mandatory (except gamedev)
For `/superharness:implement`:
- Write failing test FIRST
- Run test, verify it fails (RED)
- Write minimal code to pass
- Run test, verify it passes (GREEN)
- Refactor if needed

**No production code without a failing test first.**

### 3. Evidence Before Completion
For `/superharness:validate`:
- Run verification commands fresh
- Read full output, check exit codes
- No "should work" or "probably passes"
- Only claim done WITH evidence

### 4. Systematic Debugging
For `/superharness:debug`:
- Phase 1: Root cause investigation (gather evidence)
- Phase 2: Pattern analysis (compare working vs broken)
- Phase 3: Hypothesis testing (one change at a time)
- Phase 4: Implementation (TDD for regression test)

**No random fixes. Find root cause first.**

## Directory Structure

All work is tracked in `.harness/`:

```
.harness/
├── BACKLOG.md                    # Bugs, deferred tasks, tech debt
├── dashboard.md                  # Recommendations for next session
├── NNN-feature-slug/             # Per-feature work
│   ├── research.md               # Codebase + external research
│   ├── plan.md                   # Phased implementation plan
│   ├── handoff.md                # Context handoff (if paused)
│   └── archive/                  # Resolved handoffs
└── handoffs/                     # Cross-feature handoffs
    ├── YYYY-MM-DD_HH-MM-SS_description.md
    └── archive/                  # Resolved handoffs
```

## Progress Tracking

**Phase completion uses git trailers:**
```
feat: complete Phase 2 - Authentication

phase(2): complete
```

**Keep plan.md checkboxes in sync:**
- When phase completes, check the checkbox AND commit with trailer
- Same commit updates both

## Context Management

**Signs of context exhaustion:**
- Forgetting earlier context, repeating questions
- Incomplete responses, cutting off mid-thought
- Slower responses, degraded reasoning

**When approaching limits:**
1. Run `/superharness:handoff` to capture state
2. Tell user: "Context limit approaching. Handoff created."
3. Start new session and run `/superharness:resume`

## Red Flags (You're Rationalizing)

| Thought | Reality |
|---------|---------|
| "Let me just read one file first" | Use `/superharness:research` for exploration |
| "I know the current API version" | Training data is stale. Research first. |
| "This is too simple for TDD" | Simple code breaks too. Write the test. |
| "I'll add tests later" | Later = never. RED-GREEN-REFACTOR now. |
| "Let me try this fix" | Root cause first. Use `/superharness:debug`. |
| "I think it works" | Evidence required. Run `/superharness:validate`. |

## User Intent vs Command

When user says... → Recommend...
- "Add feature X" → `/superharness:research` then `/superharness:create-plan`
- "Fix this bug" → `/superharness:debug`
- "Continue the work" → `/superharness:resume`
- "What's next?" → `/superharness:status`
- "Ship it" → `/superharness:validate` first

**Users choose commands explicitly. If they don't know which, recommend based on context.**
