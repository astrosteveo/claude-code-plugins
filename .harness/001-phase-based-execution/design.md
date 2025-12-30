# Phase-Based Execution Design

## Overview

Streamline the planning-to-execution workflow by:
1. Auto-checkpointing at end of planning
2. Using Phase (not Task) as the unit of subagent execution
3. Simplifying to 2 execution options (Continue / New Session)
4. Adding marker-driven auto-resume on session start

## Key Concepts

### Phase Structure
- Plans organized into Phases (2-6 tasks each)
- Each Phase = 1 subagent dispatch
- Phases are cohesive units of related work
- Fresh context per Phase prevents exhaustion

### PENDING_EXECUTION.md Marker
- Created at end of planning (if "New Session" chosen)
- Created on context exhaustion mid-execution
- Session start hook detects and auto-resumes
- Deleted on successful completion

### Simplified Options
| Option | Description |
|--------|-------------|
| Continue | Execute now in this session |
| New Session | Start fresh session (marker created) |

| Mode | Description |
|------|-------------|
| Autonomous | Runs all Phases without stopping |
| Checkpoint | Pauses after each Phase for approval |

## Skills Affected

1. `writing-plans` - Phase structure, new handoff
2. `subagent-driven-development` - Phase-level dispatch
3. `executing-plans` - Align with Phase-based execution
4. `handling-context-exhaustion` - Marker creation
5. `using-harness` - Session start hook
6. `resuming-work` - Marker integration
