---
name: codex-review
description: Have OpenAI Codex review a PR or implementation plan. Usage: /codex-review <pr-number> [--repo owner/repo] or /codex-review plan
allowed-tools: Bash, Read, Glob, Grep, Agent
---

# Codex Review

The user wants Codex to review something. Parse the arguments:

- If the argument is a PR number (e.g., `5`, `#5`): Review that PR
- If the argument is `plan`: Review the current implementation plan from conversation context
- If the argument includes `--repo`: Use that repo, otherwise detect from current git directory

## For PR Review

1. Get the PR diff and summary:
   ```bash
   gh pr diff <number> --repo <repo>
   gh pr view <number> --repo <repo> --json title,body,headRefName,reviews
   ```

2. Write a review brief to `/tmp/codex-review-input.md` containing:
   - PR title and description
   - The full diff
   - Any existing review comments
   - Instruction: "Review this PR for bugs, logic errors, missed edge cases, and style issues. Be specific about line numbers and file paths. Focus on real bugs, not nitpicks."

3. Run Codex with the brief:
   ```bash
   cat /tmp/codex-review-input.md | codex --quiet "Review this pull request. Focus on real bugs and logic errors. Be specific with file paths and line numbers. Skip nitpicks and style issues."
   ```

4. Show the user Codex's review output.

## For Plan Review

1. Write the current conversation's implementation plan to `/tmp/codex-plan-review.md`
2. Include relevant repo context (branch state, file list, recent commits)
3. Run:
   ```bash
   cat /tmp/codex-plan-review.md | codex --quiet "Review this implementation plan against the actual repo state. Check for: contaminated branches, stale assumptions, missing dependencies between tasks, and incorrect file/variable references. Be specific."
   ```
4. Show the user Codex's feedback and incorporate it into the plan.

## Important

- If `codex` CLI is not installed, tell the user: `npm install -g @openai/codex`
- Always show the full Codex output to the user — don't summarize or filter it
- After showing review results, ask if the user wants to fix any issues found
