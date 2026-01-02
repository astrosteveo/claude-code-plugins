---
name: research
description: "Research codebase and external sources to document existing patterns before planning"
argument-hint: "<research question or area of interest>"
load-skills:
  - research-first
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase AND external sources to answer user questions by spawning parallel sub-agents and synthesizing their findings.

## CRITICAL: Document What Exists - Do Not Suggest Changes

- DO NOT suggest improvements or changes unless explicitly asked
- DO NOT perform root cause analysis unless explicitly asked
- DO NOT propose future enhancements unless explicitly asked
- DO NOT critique the implementation or identify problems
- ONLY describe what exists, where it exists, how it works, and how components interact
- You are creating a technical map/documentation of the existing system

## CRITICAL: Research External Sources Too

- Training data may be 2+ years stale
- ALWAYS verify current library versions, API signatures, and best practices
- Use `web-researcher` agent for external documentation
- Don't trust your memory of APIs - verify them

## Initial Setup

When this command is invoked, respond with:

```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components, connections, AND verifying current external documentation.
```

Then wait for the user's research query.

## Research Process

### Step 1: Read Directly Mentioned Files

If the user mentions specific files (tickets, docs, configs):
- Read them FULLY first using the Read tool WITHOUT limit/offset parameters
- Read these files yourself in the main context before spawning sub-agents
- This ensures full context before decomposing the research

### Step 2: Analyze and Decompose the Research Question

- Break down the query into composable research areas
- Think deeply about underlying patterns, connections, and architectural implications
- Identify specific components, patterns, or concepts to investigate
- Create a research plan using TodoWrite to track all subtasks
- Consider which directories, files, or architectural patterns are relevant

### Step 3: Spawn Parallel Sub-Agent Research

Create multiple sub-agents to research different aspects concurrently:

**Codebase Research Agents:**
- **codebase-locator** - Find WHERE files and components live
- **codebase-analyzer** - Understand HOW specific code works (without critiquing)
- **codebase-pattern-finder** - Find examples of existing patterns (without evaluating)

**Documentation Research Agents:**
- **harness-locator** - Discover what documents exist in `.harness/` about the topic
- **harness-analyzer** - Extract key insights from specific `.harness/` documents

**External Research (IMPORTANT - Don't skip this):**
- **web-researcher** - Verify current library versions, API signatures, best practices

**Key Principles:**
- Start with locator agents to find what exists
- Then use analyzer agents on the most promising findings
- Run multiple agents in parallel for different search areas
- Each agent documents, not evaluates - remind them of this
- ALWAYS include web-researcher for any library/API questions

### Step 4: Synthesize Findings

Wait for ALL sub-agents to complete, then:
- Compile all sub-agent results
- Prioritize live codebase findings as primary source of truth
- Use documentation findings as supplementary context
- **Highlight any discrepancies between codebase and current external docs**
- Connect findings across different components
- Include specific file paths and line numbers
- Answer the user's specific questions with concrete evidence

### Step 5: Create Research Artifact

**Filename format:** `.harness/NNN-feature-slug/research.md`
- NNN is the next available feature number (001, 002, etc.)
- feature-slug is a brief kebab-case description
- Example: `.harness/003-authentication/research.md`

**If researching a standalone topic (not tied to a feature):**
- Use `.harness/research/YYYY-MM-DD-topic.md`

**Document structure:**

```markdown
---
date: [ISO timestamp with timezone]
researcher: Claude
topic: "[User's Question/Topic]"
tags: [research, codebase, relevant-component-names]
status: complete
---

# Research: [User's Question/Topic]

## Research Question
[Original user query]

## Summary
[High-level documentation of what was found, answering the user's question]

## Detailed Findings

### [Component/Area 1]
- Description of what exists
- How it connects to other components
- Current implementation details (without evaluation)

### [Component/Area 2]
...

## External Documentation Findings
[What current docs/APIs say - include version numbers and links]
- Library X v2.3.4: [Key API patterns found]
- Current best practices: [Summary with sources]

## Code References
- `path/to/file.py:123` - Description of what's there
- `another/file.ts:45-67` - Description of the code block

## Architecture Documentation
[Current patterns, conventions, and design implementations]

## Related .harness/ Documents
[References to other relevant documents found]

## Open Questions
[Any areas that need further investigation]
```

### Step 6: Human Leverage Point - Review Research

Present findings to the user:

```
Research complete. I've documented my findings in:
`.harness/NNN-feature-slug/research.md`

Key discoveries:
- [Discovery 1]
- [Discovery 2]
- [Discovery 3]

External verification:
- [Library/API] is currently at version [X] (docs verified)

Please review the research before we proceed to planning.
Ready to answer follow-up questions or proceed to `/superharness:create-plan`.
```

### Step 7: Handle Follow-up Questions

If the user has follow-ups:
- Append to the same research document
- Add a new section: `## Follow-up Research [timestamp]`
- Spawn new sub-agents as needed
- Continue updating the document

## Important Notes

- Always use parallel sub-agents to maximize efficiency
- Always run fresh codebase research - never rely solely on existing documents
- **Always verify external APIs/libraries - training data is stale**
- Focus on finding concrete file paths and line numbers
- Research documents should be self-contained with all necessary context
- Keep the main agent focused on synthesis, not deep file reading
- Document cross-component connections and system interactions
- Include temporal context (when research was conducted)

## Cross-References

- After research, use `/superharness:create-plan` to create an implementation plan
- Research artifacts inform planning but don't replace it
