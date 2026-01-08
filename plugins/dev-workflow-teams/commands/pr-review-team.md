---
description: Plan a PR review workflow with specialized agents
arguments:
  - name: pr
    description: PR number, branch name, or description of changes
    required: true
---

Create a **PR Review** workflow plan for: **$ARGUMENTS.pr**

## Team Composition

| Agent | Role |
|-------|------|
| **code-reviewer** | Overall code quality, bugs, and conventions |
| **feature-dev:code-reviewer** | Confidence-based filtering for high-priority issues |
| **pr-review-toolkit:silent-failure-hunter** | Identify silent failures and inadequate error handling |
| **pr-review-toolkit:pr-test-analyzer** | Evaluate test coverage quality and gaps |
| **pr-review-toolkit:type-design-analyzer** | Analyze type design and invariant expression |
| **security-auditor** | Security vulnerabilities and compliance |
| **pr-review-toolkit:comment-analyzer** | Verify comment accuracy and maintainability |

## Requirements

1. **Parallelize where possible** - Many review agents can run concurrently
2. **Assign 2-3 concrete review tasks per agent** relevant to this PR
3. **Define severity levels** - How to categorize and prioritize findings
4. **Establish blocking criteria** - What issues must be fixed vs. can be deferred

## Output Format

For each agent, provide:
- **Agent**: Name and role summary
- **Review Focus**: Specific aspects this agent examines
- **Tasks**: Numbered list of specific review tasks
- **Outputs**: Types of issues this agent reports
- **Severity Levels**: How this agent categorizes findings

End with:
- **Parallel execution groups** - Which agents can run simultaneously
- **Blocking issue criteria** - What requires changes before merge
- **Review checklist** - Consolidated checklist for the PR author
