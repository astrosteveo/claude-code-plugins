# Installing Agent Workflow for Codex

Quick setup to enable agent-workflow skills in Codex.

## Installation

1. **Clone agent-workflow repository**:
   ```bash
   mkdir -p ~/.codex/agent-workflow
   cd ~/.codex/agent-workflow
   git clone https://github.com/obra/superpowers.git .
   ```

2. **Create personal skills directory**:
   ```bash
   mkdir -p ~/.codex/skills
   ```

3. **Update ~/.codex/AGENTS.md** to include this agent-workflow section:
   ```markdown
   ## Agent Workflow System

   <EXTREMELY_IMPORTANT>
   You have agent-workflow skills. Agent Workflow teaches you new skills and capabilities. RIGHT NOW run: `~/.codex/agent-workflow/.codex/agent-workflow-codex bootstrap` and follow the instructions it returns.
   </EXTREMELY_IMPORTANT>
   ```

## Verification

Test the installation:
```bash
~/.codex/agent-workflow/.codex/agent-workflow-codex bootstrap
```

You should see skill listings and bootstrap instructions. The system is now ready for use.