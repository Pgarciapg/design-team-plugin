---
description: Deploy MVP to Vercel with production-ready configuration
arguments:
  - name: environment
    description: Deployment environment (preview or production)
    required: false
---

# MVP Ship

Deploy the MVP to Vercel with proper configuration.

## Environment: $ARGUMENTS.environment (default: preview)

## Pre-flight Checks

### 1. Verify Project Structure
- Confirm this is a Next.js project (check for next.config.js/mjs)
- Check for package.json
- Verify .env.local exists with Supabase credentials

### 2. Check for Issues
Run these checks:
```bash
npm run build
```

If build fails, stop and help fix errors before deploying.

### 3. Check Git Status
```bash
git status
```
- If uncommitted changes exist, ask user if they want to commit first
- Suggest meaningful commit message based on changes

## Deployment Steps

### Step 1: Ensure Vercel CLI
Check if Vercel CLI is installed:
```bash
which vercel || npm install -g vercel
```

### Step 2: Link Project (if not linked)
```bash
vercel link
```
Guide user through:
- Select or create Vercel project
- Confirm settings

### Step 3: Set Environment Variables

Check if env vars are set on Vercel:
```bash
vercel env ls
```

If missing, guide user to add:
```bash
vercel env add NEXT_PUBLIC_SUPABASE_URL
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
```

For production, also remind about:
- `NEXT_PUBLIC_SITE_URL` - Set to production domain

### Step 4: Deploy

For preview:
```bash
vercel
```

For production:
```bash
vercel --prod
```

## Post-Deployment Checklist

After successful deployment, display:

```
✓ Deployed successfully!

Deployment URL: [url from vercel output]

Post-deployment checklist:
□ Test login/signup flow
□ Verify Supabase connection works
□ Check all protected routes redirect properly
□ Test on mobile viewport
□ Verify environment variables are working

Supabase configuration:
□ Add deployment URL to Supabase Auth settings:
  - Go to Authentication > URL Configuration
  - Add Site URL: [production url]
  - Add Redirect URLs: [production url]/**

Domain setup (if needed):
□ Add custom domain in Vercel dashboard
□ Update Supabase redirect URLs with custom domain
□ Update NEXT_PUBLIC_SITE_URL env var
```

## Troubleshooting Common Issues

### Build Fails
- Check for TypeScript errors: `npm run build`
- Verify all imports are correct
- Check for missing environment variables

### Auth Not Working
- Verify Supabase URL Configuration includes the deployment URL
- Check redirect URLs in Supabase dashboard
- Ensure cookies are being set properly (check middleware)

### 500 Errors
- Check Vercel function logs
- Verify environment variables are set correctly
- Check Supabase service is running

## Rollback

If something goes wrong:
```bash
vercel rollback
```

Or from dashboard: Vercel Dashboard > Deployments > ... > Rollback

## Next Steps

After first successful deployment:
1. Set up custom domain (if needed)
2. Configure Supabase production settings
3. Set up monitoring/analytics
4. Consider adding error tracking (Sentry)
