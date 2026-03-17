---
name: nextjs-supabase-stack
description: Next.js + Supabase + Vercel MVP stack best practices and patterns
globs:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/supabase/**"
---

# Next.js + Supabase MVP Stack

Non-obvious patterns and gotchas for building MVPs with Next.js, Supabase, and Vercel.

**Reference templates:** See `references/` folder for copy-paste Supabase client setup and middleware templates.

## Project Structure

```
src/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Auth route group
│   ├── (dashboard)/       # Protected route group
│   └── api/               # API routes
├── components/
│   ├── ui/                # shadcn/ui components
│   └── [feature]/         # Feature-specific
├── lib/
│   └── supabase/          # Server + browser clients (see references/)
├── types/
│   └── database.ts        # Generated: npx supabase gen types typescript
└── middleware.ts           # Session refresh (see references/)
```

## Critical Setup Steps

1. **Supabase client**: Use `@supabase/ssr` (NOT `@supabase/auth-helpers-nextjs` — deprecated). See `references/supabase-client-setup.ts`.
2. **Middleware**: MUST call `supabase.auth.getUser()` to refresh session. Without this, auth silently breaks after token expiry. See `references/middleware-template.ts`.
3. **Type generation**: `npx supabase gen types typescript --project-id YOUR_PROJECT_ID > src/types/database.ts` — run after every migration.
4. **RLS policies**: Enable on EVERY table before going to production. Test with anon key to verify.

## Auth Patterns

### Protected pages
```typescript
const { data: { user } } = await supabase.auth.getUser();
if (!user) redirect("/login");
```
Use `getUser()` not `getSession()` — `getSession()` reads from cookie without server validation.

### After login, call `router.refresh()`
```typescript
router.push("/dashboard");
router.refresh(); // Force Server Components to re-render with new auth state
```

## Gotchas

- **`.local` TLD emails are rejected** by Supabase cloud auth signup — use `.com` or `.test` emails for testing.
- **Auto-confirm users** in dev: signup via anon key, then `PUT /auth/v1/admin/users/{id}` with `{"email_confirm":true}` using service role key.
- **`supabase db push` uses linked project** automatically — do NOT pass `--project-ref` flag (it doesn't exist).
- **`@supabase/auth-helpers-nextjs` is deprecated** — use `@supabase/ssr` instead. Many tutorials still reference the old package.
- **Middleware must call `getUser()`** — if you only call `getSession()`, tokens expire silently and users get logged out randomly.
- **`cookies()` is async in Next.js 16** — use `await cookies()` in the Supabase server client.
- **RLS + service role key bypasses all policies** — never expose service role key to the browser (no `NEXT_PUBLIC_` prefix).
- **Supabase local dev requires Docker/OrbStack running** — only one instance at a time on default ports (54321/54322).
- **For multiple local projects**, configure port offsets in `supabase/config.toml`.
- **Schema SQL files must order tables by FK dependencies** — create referenced tables first.
- **Real-time subscriptions in Server Components don't work** — use a Client Component wrapper with `useEffect`.

## Security Checklist

- [ ] RLS enabled on ALL Supabase tables
- [ ] Service role key NOT exposed to client
- [ ] `getUser()` used instead of `getSession()` for auth checks
- [ ] Input validation on Server Actions
- [ ] `.env*.local` in `.gitignore`
