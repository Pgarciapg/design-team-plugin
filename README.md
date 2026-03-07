# Pablo's Claude Code Plugins

A marketplace of plugins for Claude Code.

## Installation

Add this marketplace to Claude Code:

```
/plugins marketplace add https://github.com/Pgarciapg/pgarciapg-plugins
```

Then browse and install plugins with `/plugins`.

## Available Plugins

### design-team
A multi-agent design department for Claude Code: UX, visual, copy, accessibility, tokens, and implementation.

**Commands:** `/kickoff`, `/critique`, `/spec`, `/tokens`

**Skills:** mobile-polish, vercel-design-guidelines

**Agents:** a11y-reviewer, copywriter, design-lead, fe-implementer, ux-designer, visual-designer

---

### domain-scout
AI-powered domain name finder that analyzes your codebase, generates creative name suggestions, and searches registrars for availability and pricing.

**Commands:** `/domain-scout`

**Skills:** name-generation

**Agents:** codebase-analyzer, domain-searcher

Searches Namecheap, Porkbun, GoDaddy, Squarespace Domains, and Cloudflare. Requires Chrome + Claude in Chrome extension.

---

### exec-assistant
Autonomous executive assistant that scans your projects daily, sends Slack briefs, and runs overnight workers to fix bugs, add tests, and open PRs while you sleep.

**Commands:** `/exec-nightshift`, `/exec-scan`, `/exec-setup`, `/exec-status`

**Skills:** exec-assistant

**Agents:** night-planner, scanner

---

### hackathon
Run competitive multi-team hackathons with parallel agents building features against each other. Define teams, assign agents, and let them race to build the best feature.

**Commands:** `/hackathon`

---

### mvp-builder
End-to-end MVP builder for client projects using Next.js, Supabase, and Vercel. Orchestrates design, scaffolding, development, and deployment workflows.

**Commands:** `/mvp-kickoff`, `/mvp-scaffold`, `/mvp-db`, `/mvp-ship`, `/mvp-status`

**Skills:** nextjs-supabase-stack

**Agents:** feature-builder, supabase-expert

---

## License

MIT
