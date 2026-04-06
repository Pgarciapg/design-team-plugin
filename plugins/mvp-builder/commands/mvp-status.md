---
description: Check MVP project status - dependencies, env vars, deployment, and health
---

# MVP Status

Check the health and status of your MVP project.

## Checks to Perform

### 1. Project Structure
Verify expected files exist:
- [ ] `package.json`
- [ ] `next.config.ts` or `next.config.mjs`
- [ ] `src/lib/supabase/client.ts`
- [ ] `src/lib/supabase/server.ts`
- [ ] `src/proxy.ts` (Next.js 16) — flag if `src/middleware.ts` exists instead
- [ ] `.env.local`

### 2. Dependencies
Check package.json for required dependencies:
- [ ] `next` (16+)
- [ ] `@supabase/supabase-js`
- [ ] `@supabase/ssr`
- [ ] `tailwindcss`

Flag if deprecated packages are present:
- `@supabase/auth-helpers-nextjs` — replace with `@supabase/ssr`
- `@vercel/postgres` — replace with `@neondatabase/serverless`
- `@vercel/kv` — replace with `@upstash/redis`

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

### 4. CSS Import Order
Check `src/app/globals.css`:
- [ ] Any `@import url(...)` statements come BEFORE `@tailwind` directives
- [ ] Light-mode fix present if needed: `@custom-variant dark (&:is(.dark *));`

Wrong order causes silent styling failures.

### 5. TypeScript
Run type check:
```bash
npx tsc --noEmit
```

Report any type errors.

### 6. Import Verification
Check for untracked files that are imported by tracked files:
```bash
git status
```
- Flag any untracked files that might be imported by committed code
- This catches the "uncommitted imports crash production" bug

### 7. Build Status
```bash
npm run build
```

Report success or list errors. If build fails, check for:
- `.next/dev/lock` file (delete if present — leftover from crash)
- Missing environment variables
- TypeScript errors

### 8. Supabase Connection
Check if Supabase is accessible (if env vars are set):
- Try to connect
- Report connection status

### 9. Git Status
```bash
git status
```
- Uncommitted changes
- Current branch
- Commits ahead/behind remote

### 10. Vercel Deployment (if linked)
```bash
vercel ls 2>/dev/null
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
Next.js: [version] (should be 16+)
Node: [version]

Structure:        [pass] Complete / [warn] Missing proxy.ts / [fail] Missing files
Dependencies:     [pass] Up to date / [warn] X packages outdated / [fail] Deprecated packages found
Environment:      [pass] Configured / [fail] Missing variables
CSS Order:        [pass] Correct / [warn] Import order issue / [warn] No light-mode fix
TypeScript:       [pass] No errors / [fail] X errors
Imports:          [pass] All tracked / [warn] Untracked files found
Build:            [pass] Passes / [fail] Build failed
Supabase:         [pass] Connected / [fail] Connection failed
Git:              [pass] Clean / [warn] X uncommitted changes
Deployment:       [pass] Live at [url] / [info] Not deployed

Issues Found:
- [List any issues]

Recommendations:
- [Actionable suggestions]
```

## Quick Fixes

If issues are found, offer to fix them:

1. **middleware.ts instead of proxy.ts**: Rename to proxy.ts (Next.js 16 migration)
2. **Deprecated packages**: Replace with modern equivalents
3. **Missing dependencies**: `npm install [package]`
4. **Outdated packages**: `npm update`
5. **Type errors**: Navigate to file and explain fix
6. **Missing env vars**: Guide to create/update .env.local
7. **CSS import order**: Reorder directives in globals.css
8. **Uncommitted changes**: Offer to create commit
9. **Build lock file**: Delete `.next/dev/lock`
10. **Untracked imports**: Stage and commit missing files

## Post-Check Reminder

After fixing any issues, remind user:
- Run `npm run dev` and click through the UI to verify everything works
- Don't just check that it builds — actually test the experience
- Navigate the full user flow (login, dashboard, features)
