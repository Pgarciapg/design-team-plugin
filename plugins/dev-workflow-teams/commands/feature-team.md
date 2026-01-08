---
description: Plan a feature development workflow with specialized agents
arguments:
  - name: feature
    description: Feature name or description to plan
    required: true
---

Create a **Feature Development** workflow plan for: **$ARGUMENTS.feature**

## Team Composition

| Agent | Role |
|-------|------|
| **Explore** | Initial codebase discovery and context gathering |
| **feature-dev:code-explorer** | Deep analysis of existing features and execution paths |
| **feature-dev:code-architect** | Architecture design and implementation blueprint |
| **orchestrator** | Coordinates multi-module work and delegates tasks |
| **test-architect** | Designs test strategy (unit/integration/e2e) |
| **code-reviewer** | Reviews implementation for bugs, security, quality |
| **docs-writer** | Creates/updates documentation |

## Requirements

1. **Phase the work** - Define clear phases (Discovery → Design → Implementation → Testing → Review → Documentation)
2. **Assign 2-3 concrete tasks per agent** relevant to this specific feature
3. **Establish dependencies** - Which agents must complete before others can start
4. **Define handoff artifacts** - What each agent produces for the next

## Output Format

For each agent, provide:
- **Agent**: Name and role summary
- **Phase**: When in the workflow this agent operates
- **Tasks**: Numbered list of specific tasks
- **Inputs**: What this agent needs from previous agents
- **Outputs**: What this agent produces for downstream agents
- **Trigger**: Conditions that invoke this agent

End with a **workflow diagram** showing the sequence and dependencies.
