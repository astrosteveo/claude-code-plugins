# Codebase Exploration: Identify Gaps and Missing Features

**Date**: 2025-12-14
**Feature Slug**: 002-identify-codebase-gaps

## Goal

Document gaps, missing features, inconsistencies, and areas for improvement in the explore-plan-implement Claude Code plugin, with specific focus on the context reporting discrepancy where subagents report their own context usage rather than parent conversation context utilization.

## Summary

The explore-plan-implement plugin is a well-structured markdown-based workflow system, but systematic exploration reveals gaps between documented requirements and actual implementation. Key findings: (1) Context reporting instructions exist in commands but **subagents cannot report parent context utilization** - they can only report their own isolated context usage, (2) A `/compact` command referenced in documentation does not exist, (3) Two validator agents (plan-validator, implementation-validator) are fully defined but never invoked by their respective commands. Note: TaskOutput and AskUserQuestion ARE valid Claude Code tools (contrary to initial analysis).

## Key Files and Locations

| File | Lines | Purpose |
|------|-------|---------|
| `/home/astrosteveo/workspace/research-plan-implement/.claude-plugin/plugin.json` | 15-20 | Commands manifest - lists 5 commands but references missing `/compact` and validator invocations |
| `/home/astrosteveo/workspace/research-plan-implement/commands/explore.md` | 192-209 | Uses `TaskOutput` tool to retrieve background agent results |
| `/home/astrosteveo/workspace/research-plan-implement/commands/explore.md` | 333-350 | Context reporting instructions - agents cannot access parent context utilization data |
| `/home/astrosteveo/workspace/research-plan-implement/commands/plan.md` | 1-17 | Plan phase lacks integration with plan-validator agent |
| `/home/astrosteveo/workspace/research-plan-implement/commands/implement.md` | 111, 199 | Uses AskUserQuestion for phase transitions |
| `/home/astrosteveo/workspace/research-plan-implement/commands/implement.md` | 199-202 | Phase transition flow with user confirmation |
| `/home/astrosteveo/workspace/research-plan-implement/commands/validate.md` | 160-170 | Validation results template but no integration with validation/results.md |
| `/home/astrosteveo/workspace/research-plan-implement/commands/commit.md` | 135-145 | Commit requires user confirmation via AskUserQuestion but no blocking mechanism |
| `/home/astrosteveo/workspace/research-plan-implement/CLAUDE.md` | 39-40 | References `/compact` command but command doesn't exist |
| `/home/astrosteveo/workspace/research-plan-implement/.claude/rules/VISION.md` | 320-369 | Describes context compaction and artifact-based resumption but no `/compact` implementation |
| `/home/astrosteveo/workspace/research-plan-implement/agents/plan-validator.md` | 1-120 | Agent specification exists but never invoked by `/plan` command |
| `/home/astrosteveo/workspace/research-plan-implement/agents/implementation-validator.md` | 1-146 | Agent specification exists but never invoked by `/implement` command |

## Architecture Overview

The plugin architecture defines 5 command entry points, 4 specialized agents, and 2 skill packages:

```
Plugin Entry Points (plugin.json:15-20)
├── commands/
│   ├── explore.md (9.8 KB) - COMPLETE
│   ├── plan.md (5.9 KB) - INCOMPLETE
│   ├── implement.md (6.5 KB) - INCOMPLETE
│   ├── validate.md (6.3 KB) - COMPLETE
│   ├── commit.md (5.5 KB) - INCOMPLETE
│   └── [MISSING] compact.md - Referenced in CLAUDE.md line 39 but doesn't exist
├── agents/
│   ├── codebase-explorer.md - Invoked, well-defined
│   ├── docs-researcher.md - Invoked, well-defined
│   ├── plan-validator.md - DEFINED but NEVER INVOKED
│   └── implementation-validator.md - DEFINED but NEVER INVOKED
└── skills/
    ├── workflow-guide/
    └── command-creator/
```

## Critical Gaps by Category

### 1. MISSING COMMAND: `/compact`

**Files affected**: CLAUDE.md:39-40, VISION.md:320-369

**Issue**: The `/compact` command is referenced in critical documentation but has no implementation:

- CLAUDE.md line 39 states "Run `/compact` or starting fresh session"
- VISION.md describes intentional compaction workflow in detail (320-369)
- No `commands/compact.md` file exists
- Plugin manifest (plugin.json:15-20) lists only 5 commands, `/compact` not included

**Impact**: Users cannot compact context during long sessions as documented. The entire "Frequent Intentional Compaction" workflow is undermined.

**Evidence**:
- CLAUDE.md:39: "Run `/compact` to create documented commit"
- VISION.md:357-369: Extensive compaction workflow description with no corresponding command

### 2. CONTEXT REPORTING DISCREPANCY: Agents Cannot Report Parent Context

**Files affected**:
- `commands/explore.md:333-350` - Context Reporting section
- `commands/plan.md:215-235` - Context Reporting section
- `commands/implement.md:268-288` - Context Reporting section
- `commands/validate.md:306-326` - Context Reporting section
- `commands/commit.md:204-224` - Context Reporting section

**Issue**: All commands instruct users that agents will "report estimated context utilization" with format `**Context**: ~[X]K / 200K tokens ([Y]%)`, but:

1. **Subagents cannot access parent conversation context**: When `codebase-explorer` or `docs-researcher` run as background agents via Task tool with `run_in_background: true`, they operate in isolated contexts and can only report their OWN token usage, not the parent conversation's usage.

2. **The data isn't exposed**: Claude Code runtime doesn't expose parent context utilization to subagents. The system_warning tags showing context usage appear only in parent agent context.

3. **Instructions are impossible to follow**: Commands like `explore.md:335-350` say agents will report context utilization at the end, but agents executing in background have no mechanism to communicate back the parent conversation's context state.

**Evidence**:
- `explore.md:82-119`: Both codebase-explorer and docs-researcher launched with `run_in_background: true` to "keep main context clean"
- `explore.md:192-209`: Uses `TaskOutput` to collect results from background agents
- `explore.md:333-350`: "Context Reporting" section states agents will report format `**Context**: ~[X]K / 200K tokens ([Y]%)`
- Background agents receive NO information about parent context (tokens used before their execution)

**How it should work**: Only the MAIN agent (the command executor) can report context because only it has access to the full context window state. Subagents should NOT attempt context reporting; instead the main command should report after receiving subagent results.

### 3. ~~CORRECTION: TaskOutput and AskUserQuestion ARE Valid Tools~~

**Initial analysis incorrectly flagged these tools as non-existent.**

Per Claude Code documentation (https://code.claude.com/docs/en/settings#tools-available-to-claude):
- **TaskOutput**: Valid tool for retrieving results from background Task executions
- **AskUserQuestion**: Valid tool for asking users questions during execution (does not require permission)

The commands correctly reference these tools. No gap exists here.

### 4. UNIMPLEMENTED AGENT INVOCATIONS

**Files affected**:
- `commands/plan.md:1-230` - Never invokes plan-validator
- `agents/plan-validator.md:1-120` - Defined but never called
- `commands/implement.md:67-220` - Never invokes implementation-validator after phases
- `agents/implementation-validator.md:1-146` - Defined but never called

**Issue**: Two validator agents are fully documented but never integrated into workflow:

1. **plan-validator**: Agent exists (`agents/plan-validator.md`) with full validation framework (1-120) but `/plan` command (lines 1-230) has no step that invokes it. Process ends at line 182 with "Update State" with no validation step.

2. **implementation-validator**: Agent exists (`agents/implementation-validator.md`) with validation process (1-146) but `/implement` command has no phase that validates implementation against plan. Commands suggest manual human review but no agent invocation.

**Impact**: The "highest-leverage human review point" mentioned in VISION.md (line 245) has no automated validation gate. Plans are created without systematic validation.

**Evidence**:
- `plan.md` process steps: Initialize → Load Research → Design Phases → Write Plan → Validate Plan Quality (local check only) → Present → Update State
- No Task invocation with `plan-validator` subagent
- `implement.md` process: No phase validation step after changes made
- `agents/implementation-validator.md` describes detailed validation but is orphaned

### 5. INCOMPLETE STATE MANAGEMENT

**Files affected**:
- `templates/state.md:1-27` - State template
- `commands/explore.md:127-188` - State file creation
- `commands/plan.md:178-182` - State updates
- `commands/implement.md:65, 208` - State updates
- `commands/validate.md:220-222` - State updates
- `commands/commit.md:160-164` - State updates

**Issues**:

1. **Task ID tracking for resumption**: `explore.md:127-188` documents that task IDs must be recorded in state.md for later retrieval with `TaskOutput`.
   - TaskOutput works for retrieving results within a session
   - No documented mechanism for resuming work in a fresh session using stored task IDs
   - state.md template shows task_id field but no instructions for cross-session resumption

2. **Research Scope field unused**: `state.md:7` includes "Research Scope" field (full/codebase only) but:
   - Never referenced in subsequent commands
   - `/plan` should check this but doesn't
   - No conditional logic based on research scope

3. **Context Estimate field**: `state.md:9` has "Context Estimate" field but:
   - Never written to by any command
   - No mechanism to update after each phase
   - Cannot track context accumulation across session

4. **Phase completion validation missing**: Commands don't validate prerequisites:
   - `/plan` doesn't check if Explore phase is actually complete before proceeding
   - `/implement` doesn't verify Plan phase complete
   - `/validate` doesn't check Implementation complete
   - `/commit` doesn't verify Validation complete

**Evidence**:
- `explore.md:143-147`: Records task IDs; TaskOutput retrieves within session, but cross-session resumption unclear
- `plan.md:19-36`: Has check for Explore phase but only looks at `state.md` status value, doesn't verify artifacts exist
- `templates/state.md:22-26`: Shows phase status but no validation logic in commands

### 6. INCOMPLETE ERROR HANDLING

**Files affected**: All command files

**Issues**:

1. **Deviation handling incomplete** (`implement.md:95-111`):
   - Shows "Deviation Detected" template with AskUserQuestion (tool exists)
   - No documented recovery path after user responds
   - States "Do NOT proceed without guidance" but next steps unclear

2. **Research insufficient handling** (`plan.md:55-64`):
   - Shows warning about missing research
   - Lists options but doesn't show how to execute "Re-run /explore"
   - No mechanism to merge updated research with existing plan

3. **Agent failure handling missing**:
   - `explore.md` has no section for "What if background agents fail?"
   - No timeout handling documented
   - No retry logic specified

4. **Validation failure paths incomplete** (`validate.md:242-261`):
   - Shows failure template but no explicit path to re-implement or modify plan
   - No documented workflow for fixing failures
   - State management unclear after failures

### 7. TEMPLATE MISMATCHES WITH COMMAND EXPECTATIONS

**Files affected**:
- `templates/codebase.md` vs `commands/explore.md` output
- `templates/docs.md` vs `commands/explore.md` output
- `templates/implementation-plan.md` vs `commands/plan.md` output
- `templates/progress.md` vs `commands/implement.md` progress tracking
- `templates/validation-results.md` vs `commands/validate.md` output

**Issues**:

1. **Codebase template placeholder mismatch**:
   - `templates/codebase.md:1` uses `{{FEATURE}}` placeholder
   - `commands/explore.md:84-97` shows agent should write to this template
   - But agent prompt doesn't show how to substitute placeholders
   - Unclear if agent writes raw markdown or pre-processes variables

2. **Validation results don't match command template**:
   - `templates/validation-results.md:1-71` has detailed structure
   - `commands/validate.md:166-218` shows different structure for "Compile Results"
   - Two different templates for same output

3. **Progress template and command progress tracking differ**:
   - `templates/progress.md:20-45` shows phase-by-phase breakdown
   - `commands/implement.md:152-182` shows different progress structure
   - Confusion about which format is canonical

### 8. INCONSISTENT ALLOWED-TOOLS DECLARATIONS

**Files affected**: All command YAML frontmatter

**Issues**:

1. **Commands declare tools they use but don't actually use**:
   - `explore.md:4-9` declares `Task` but inline documentation shows how to use it
   - `plan.md:3-8` declares `Task` but never shows invocation syntax
   - Other tools listed but not consistently used

2. **Tools declared but not documented**:
   - `implement.md:11` declares `AskUserQuestion` but provides no documentation
   - `commit.md:9` declares `AskUserQuestion` but provides no documentation
   - No explanation of how to invoke these tools

3. **Bash command restrictions unclear**:
   - `explore.md:9` allows `Bash(ls:*, mkdir:*, date:*)`
   - Other commands show different Bash restrictions
   - Unclear if wildcard `*` means any command or specific subset

### 9. MISSING DOCUMENTATION FOR CORE WORKFLOWS

**Files affected**:
- Commands directory
- Agents directory

**Issues**:

1. **No documented flow from plan-validator failures to plan revision**:
   - `agents/plan-validator.md` describes output format including "NEEDS REVISION"
   - No command or workflow shown for how user responds to revision request
   - No mechanism to re-invoke `/plan` with adjustments

2. **No documented workflow for fresh session resumption**:
   - VISION.md describes carrying forward state.md to fresh session
   - No command shows how to load state.md and resume work
   - TaskOutput mechanism to retrieve agent results is broken

3. **No documented commit message generation**:
   - `commands/commit.md:107-131` shows template but no generation logic
   - Uses feature name and progress.md summary but unclear how these are combined
   - No example of actual generated commit message

4. **No context compaction workflow documented**:
   - VISION.md has extensive explanation but no `/compact` command
   - No shown artifact structure for compacted state
   - No way to "carry forward" structured state to fresh session

## Data Flow Issues

```
Current Flow:
[Background Agent] --Task--> [Isolated Context]
                              ├─ Cannot access parent tokens
                              ├─ Cannot report parent context
                              └─ Results retrieved via TaskOutput ✓

[Main Agent] --TaskOutput--> [Receives subagent results]
                             └─ Only main agent can see context utilization
```

### The Core Issue: Subagent Context Reporting

The commands instruct subagents (codebase-explorer, docs-researcher) to report context utilization, but:

1. **Subagents run in isolated contexts** - They have NO visibility into the parent conversation's token usage
2. **Only the main/parent agent sees context warnings** - System reminders about context appear only in the parent context
3. **Subagents report their OWN usage** - Any context reporting from subagents reflects their isolated session, not the main conversation

### Implications:

1. Context reporting instructions (explore.md:333-350) cannot be followed **by subagents** as written
2. Only the **main command executor** can report actual context utilization
3. TaskOutput works correctly for retrieving results, but context data doesn't flow back

## Open Questions / Ambiguities

1. **Context Reporting Fix**: Should we:
   - Remove context reporting instructions from subagent prompts entirely?
   - Move context reporting to the main command executor only?
   - Remove context reporting feature altogether?

2. **Validator Invocation Pattern**: Should plan-validator and implementation-validator be:
   - Invoked inline by commands?
   - Invoked in background like codebase-explorer?
   - Blocking or non-blocking?

3. **Compact Command**: Should `/compact` be:
   - A separate command that creates summarized state.md?
   - A mechanism to close current workflow and archive artifacts?
   - Invoked automatically when context exceeds 60%?

4. **State.md as workflow state machine**: Current state.md only tracks phase status, but doesn't track:
   - Current execution point within a phase
   - What deviations have been encountered
   - What decisions have been made
   - Context accumulated so far
   - Whether agent results are stale

5. **Template variable substitution**: Are commands responsible for substituting `{{VARIABLES}}` in templates before writing, or should agents do this, or is there automated substitution?

6. **Error recovery**: What should happen when:
   - Research is insufficient for planning?
   - Implementation deviates from plan?
   - Validation fails mid-workflow?
   - User cancels mid-phase?

## Patterns Observed

### Pattern 1: Context Isolation Mismatch
- Commands instruct subagents to report parent context utilization
- Subagents operate in isolated contexts with no parent visibility
- Instructions impossible for subagents to follow as designed

### Pattern 2: Context Management Theory vs. Practice
- VISION.md extensively documents context compaction
- Commands have "Context Reporting" sections
- But no mechanism to actually execute compaction or access context data

### Pattern 3: Validator Agents Orphaned
- plan-validator and implementation-validator fully specified
- Never invoked by their respective commands
- Incomplete separation of concerns (command doesn't validate its own output)

### Pattern 4: State Management Incomplete
- state.md template exists but under-utilized
- No phase prerequisite validation in commands
- Context estimates never written to state

## Integration Points

- **Plugin entry**: `plugin.json:15-20` lists 5 commands; `/compact` referenced in docs but missing
- **Command chain**: explore → plan → implement → validate → commit, but validator agents (plan-validator, implementation-validator) are never invoked
- **Agent framework**: Task + TaskOutput work correctly; subagent context isolation is the issue
- **Artifact flow**: Files written to workflow directory, TaskOutput retrieves results properly

## Recommendations for Gaps Document

The following gaps should be prioritized for fixing:

### CRITICAL (Blocks workflow):
1. ~~**Remove subagent context reporting**~~ - **RESOLVED** (2025-12-14): Removed Context Reporting sections from all 5 command files and CLAUDE.md
2. Implement `/compact` command or remove from documentation

### HIGH (Incomplete workflows):
3. Integrate plan-validator agent into `/plan` command
4. Integrate implementation-validator agent into `/implement` command
5. Add phase prerequisite validation (check explore before plan, etc.)
6. Document fresh session resumption workflow

### MEDIUM (Consistency):
7. Reconcile state.md template usage across commands
8. Unify template structures across command outputs
9. Document error recovery paths for all failure modes
10. Clarify allowed-tools declarations and actual tool usage

### LOW (Documentation):
11. Document how template variables are substituted
12. Provide example workflow artifacts showing actual vs. template format
13. Create decision trees for ambiguous workflow branches
