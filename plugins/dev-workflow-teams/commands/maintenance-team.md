---
description: Plan a maintenance/refactoring workflow with specialized agents
arguments:
  - name: area
    description: Code area, module, or maintenance goal
    required: true
---

Create a **Maintenance/Refactoring** workflow plan for: **$ARGUMENTS.area**

## Team Composition

| Agent | Role |
|-------|------|
| **Explore** | Map current state and identify improvement areas |
| **feature-dev:code-explorer** | Analyze existing patterns and dependencies |
| **refactorer** | Improve structure while preserving behavior |
| **test-architect** | Ensure adequate test coverage before/after changes |
| **security-auditor** | Identify and address security debt |
| **code-reviewer** | Verify refactoring correctness |
| **docs-writer** | Update documentation to reflect changes |

## Requirements

1. **Phase the work** - Define clear phases (Assessment → Planning → Refactoring → Validation → Documentation)
2. **Assign 2-3 concrete tasks per agent** relevant to this maintenance area
3. **Establish safety gates** - Tests that must pass between phases
4. **Define rollback criteria** - When to revert changes

## Output Format

For each agent, provide:
- **Agent**: Name and role summary
- **Phase**: When in the workflow this agent operates
- **Tasks**: Numbered list of specific tasks
- **Inputs**: What this agent needs from previous agents
- **Outputs**: What this agent produces for downstream agents
- **Safety Checks**: Validations this agent performs

End with:
- **Workflow diagram** showing the sequence and dependencies
- **Risk assessment** - What could go wrong and mitigations
- **Success metrics** - How we measure improvement

## Refactoring Principles
- [ ] No behavior changes (pure refactoring)
- [ ] Tests pass before AND after each change
- [ ] Small, incremental commits
- [ ] Document the "why" for non-obvious changes
