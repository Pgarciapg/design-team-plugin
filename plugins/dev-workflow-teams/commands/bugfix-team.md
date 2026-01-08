---
description: Plan a bug fix workflow with specialized agents
arguments:
  - name: bug
    description: Bug description or issue reference
    required: true
---

Create a **Bug Fix** workflow plan for: **$ARGUMENTS.bug**

## Team Composition

| Agent | Role |
|-------|------|
| **debugger** | Root cause analysis and hypothesis validation |
| **Explore** | Codebase exploration to understand affected areas |
| **feature-dev:code-explorer** | Trace execution paths and understand dependencies |
| **refactorer** | Implement fix with minimal, safe changes |
| **test-architect** | Design regression tests to prevent recurrence |
| **code-reviewer** | Verify fix correctness and no side effects |
| **pr-review-toolkit:silent-failure-hunter** | Check for related silent failures |

## Requirements

1. **Phase the work** - Define clear phases (Investigation → Analysis → Fix → Testing → Review)
2. **Assign 2-3 concrete tasks per agent** relevant to this specific bug
3. **Establish dependencies** - Which agents must complete before others can start
4. **Define success criteria** - How we know the bug is truly fixed

## Output Format

For each agent, provide:
- **Agent**: Name and role summary
- **Phase**: When in the workflow this agent operates
- **Tasks**: Numbered list of specific tasks
- **Inputs**: What this agent needs from previous agents
- **Outputs**: What this agent produces for downstream agents
- **Trigger**: Conditions that invoke this agent

End with a **workflow diagram** showing the sequence and dependencies.

## Investigation Checklist
- [ ] Reproduce the bug consistently
- [ ] Identify root cause (not just symptoms)
- [ ] Understand blast radius (what else might be affected)
- [ ] Document fix approach before implementing
