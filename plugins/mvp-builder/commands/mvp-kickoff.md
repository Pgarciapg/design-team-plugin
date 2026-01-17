---
description: Start a new MVP project - gather requirements, define scope, and create project brief
arguments:
  - name: project_name
    description: Name of the MVP project
    required: true
  - name: client
    description: Client name (optional)
    required: false
---

# MVP Kickoff

You are starting a new MVP project. Your goal is to gather requirements, define scope, and create a comprehensive project brief.

## Project Info
- **Project Name**: $ARGUMENTS.project_name
- **Client**: $ARGUMENTS.client

## Phase 1: Discovery

Ask the user these questions ONE AT A TIME using the AskUserQuestion tool:

### 1. Core Problem
"What problem does this MVP solve? Who is the target user?"

### 2. Key Features
"What are the 3-5 MUST-HAVE features for launch? (Be ruthless - MVP means minimum)"

### 3. User Authentication
Options:
- Email/password only
- Social login (Google, GitHub, etc.)
- Magic link / passwordless
- No auth needed

### 4. Data Requirements
"What data needs to be stored? (users, products, orders, content, etc.)"

### 5. Third-party Integrations
"Any external services needed? (payments, email, analytics, etc.)"

### 6. Design Direction
Options:
- Minimal / Clean (fastest to build)
- Modern / Polished (balanced)
- Custom branded (provide brand guidelines)

### 7. Timeline Priority
Options:
- Speed (ship in days, iterate later)
- Balance (solid foundation, reasonable timeline)
- Quality (more upfront work, less tech debt)

## Phase 2: Generate Project Brief

After gathering all requirements, create a PROJECT_BRIEF.md file in the current directory with:

```markdown
# [Project Name] - MVP Brief

## Overview
- **Client**: [client name]
- **Project**: [project name]
- **Created**: [date]
- **Timeline Priority**: [speed/balance/quality]

## Problem Statement
[What problem this solves and for whom]

## Target Users
[Primary user persona]

## Core Features (MVP Scope)
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]
...

## Tech Stack
- **Framework**: Next.js 14+ (App Router)
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth
- **Styling**: Tailwind CSS
- **Hosting**: Vercel
- **Additional**: [any integrations]

## Data Model (Initial)
[List main entities and relationships]

## Authentication
- Type: [chosen auth type]
- Providers: [if social login]

## Third-party Services
- [Service 1]: [purpose]
- [Service 2]: [purpose]

## Design Direction
- Style: [chosen style]
- Key considerations: [notes]

## Out of Scope (v1)
[Features explicitly NOT in MVP]

## Success Metrics
[How we'll know MVP is successful]

## Next Steps
1. Run `/mvp-scaffold` to generate project structure
2. Set up Supabase project
3. Configure Vercel deployment
4. Begin feature development
```

## Phase 3: Recommendations

After creating the brief, provide:

1. **Estimated complexity**: Simple / Medium / Complex
2. **Suggested project structure** based on features
3. **Supabase tables** needed (high-level)
4. **Recommended order** for building features
5. **Potential risks** or technical challenges

## Important Notes

- Keep scope MINIMAL - push back on feature creep
- Default to built-in Supabase features over custom solutions
- Prioritize features that validate the core hypothesis
- Suggest what can be manual/admin-only in v1

When complete, remind the user they can run `/mvp-scaffold $ARGUMENTS.project_name` to generate the project.
