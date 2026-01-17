---
description: Check MVP project status - dependencies, env vars, deployment, and health
---

# MVP Status

Check the health and status of your MVP project.

## Checks to Perform

### 1. Project Structure
Verify expected files exist:
- [ ] `package.json`
- [ ] `next.config.mjs` or `next.config.js`
- [ ] `src/lib/supabase/client.ts`
- [ ] `src/lib/supabase/server.ts`
- [ ] `src/middleware.ts`
- [ ] `.env.local`

### 2. Dependencies
Check package.json for required dependencies:
- [ ] `next` (14+)
- [ ] `@supabase/supabase-js`
- [ ] `@supabase/ssr`
- [ ] `tailwindcss`

Run:
```bash
npm outdated
```

Flag any major version updates available.

### 3. Environment Variables
Check .env.local contains:
- [ ] `NEXT_PUBLIC_SUPABASE_URL`
- [ ] `NEXT_PUBLIC_SUPABASE_ANON_KEY`

Verify they're not empty/placeholder values.

### 4. TypeScript
Run type check:
```bash
npx tsc --noEmit
```

Report any type errors.

### 5. Build Status
```bash
npm run build
```

Report success or list errors.

### 6. Supabase Connection
Check if Supabase is accessible (if env vars are set):
- Try to connect
- Report connection status

### 7. Git Status
```bash
git status
```
- Uncommitted changes
- Current branch
- Commits ahead/behind remote

### 8. Vercel Deployment (if linked)
```bash
vercel ls
```
- Last deployment status
- Deployment URL
- Any failed deployments

## Status Report Format

Display a clear status report:

```
MVP Status Report
================

Project: [name from package.json]
Version: [version]

Structure:        ✓ Complete
Dependencies:     ✓ Up to date (or ⚠ X packages outdated)
Environment:      ✓ Configured (or ✗ Missing variables)
TypeScript:       ✓ No errors (or ✗ X errors)
Build:            ✓ Passes (or ✗ Build failed)
Supabase:         ✓ Connected (or ✗ Connection failed)
Git:              ✓ Clean (or ⚠ X uncommitted changes)
Deployment:       ✓ Live at [url] (or ○ Not deployed)

Issues Found:
- [List any issues]

Recommendations:
- [Actionable suggestions]
```

## Quick Fixes

If issues are found, offer to fix them:

1. **Missing dependencies**: `npm install [package]`
2. **Outdated packages**: `npm update`
3. **Type errors**: Navigate to file and explain fix
4. **Missing env vars**: Guide to create/update .env.local
5. **Uncommitted changes**: Offer to create commit
