---
name: nextjs-supabase-stack
description: Next.js 16 + Supabase + Tailwind v4 + shadcn/ui MVP stack best practices, gotchas, and patterns
globs:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/supabase/**"
---

# Next.js 16 + Supabase MVP Stack

Non-obvious patterns and gotchas for building MVPs with Next.js 16, Supabase, Tailwind v4, and Vercel.

**Reference templates:** See `references/` folder for copy-paste Supabase client setup and proxy templates.

## Project Structure

```
src/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Auth route group
│   ├── (dashboard)/       # Protected route group
│   └── api/               # API routes (only for public APIs/webhooks)
├── components/
│   ├── ui/                # shadcn/ui components (never build raw controls)
│   └── [feature]/         # Feature-specific
├── lib/
│   └── supabase/          # Server + browser clients (see references/)
├── hooks/
├── types/
│   └── database.ts        # Generated: npx supabase gen types typescript --linked
└── proxy.ts               # Next.js 16 session refresh (NOT middleware.ts)
```

## Critical Setup Steps

1. **Supabase client**: Use `@supabase/ssr` (NOT `@supabase/auth-helpers-nextjs` — deprecated). See `references/supabase-client-setup.ts`.
2. **Proxy**: Use `proxy.ts` (NOT `middleware.ts` — Next.js 16 rename). Place at `src/proxy.ts` with --src-dir. MUST call `supabase.auth.getUser()` to refresh session. See `references/proxy-template.ts`.
3. **Type generation**: `npx supabase gen types typescript --linked > src/types/database.ts` — run after every migration.
4. **RLS policies**: Enable on EVERY table before going to production. Test with anon key to verify.
5. **Tailwind v4 light-mode**: Add `@custom-variant dark (&:is(.dark *));` to globals.css to prevent macOS dark mode from activating Tailwind dark utilities.
6. **CSS import order**: `@import url(...)` statements MUST come BEFORE `@tailwind` directives. Wrong order = silent styling failures.

## Next.js 16 Patterns

### Async Request APIs (Breaking Change)
```typescript
// All request APIs are async in Next.js 16
const cookieStore = await cookies();
const headersList = await headers();
const { id } = await params;
const { query } = await searchParams;
```

### Server Actions for Mutations (Default)
```typescript
"use server";
// Use Server Actions for data mutations, NOT Route Handlers
// Route Handlers are only for public APIs and webhooks
```

### Cache Components
```typescript
"use cache";
// Replaces PPR for mixing static and dynamic content
// Best of both worlds: static shell + dynamic parts
```

### Proxy (replaces middleware.ts)
```typescript
// src/proxy.ts — runs on Node.js runtime (not Edge)
// Full Node.js API access — can use ORMs, node:* modules
```

## Auth Patterns

### Protected pages
```typescript
const { data: { user } } = await supabase.auth.getUser();
if (!user) redirect("/login");
```
Use `getUser()` not `getSession()` — `getSession()` reads from cookie without server validation, causing silent auth failures after token expiry.

### After login, call `router.refresh()`
```typescript
router.push("/dashboard");
router.refresh(); // Force Server Components to re-render with new auth state
```

## UI Stack

### Component Priority
1. **shadcn/ui** — all standard controls (Button, Input, Card, Dialog, Table, etc.)
2. **Tremor** — charts, analytics, dashboards
3. **Motion** — animations, transitions, gestures
4. **Phosphor Icons** — 9000+ icons with 6 weight variants

Never build raw HTML buttons, inputs, or card layouts when shadcn/ui has the primitive.

## Gotchas

### Supabase
- **`.local` TLD emails are rejected** by Supabase cloud auth signup — use `.com` or `.test` emails for testing.
- **Auto-confirm users** in dev: signup via anon key, then `PUT /auth/v1/admin/users/{id}` with `{"email_confirm":true}` using service role key.
- **`supabase db push` uses linked project** automatically — do NOT pass `--project-ref` flag (it doesn't exist on db push).
- **`@supabase/auth-helpers-nextjs` is deprecated** — use `@supabase/ssr` instead. Many tutorials still reference the old package.
- **Proxy must call `getUser()`** — if you only call `getSession()`, tokens expire silently and users get logged out randomly.
- **`cookies()` is async in Next.js 16** — use `await cookies()` in the Supabase server client.
- **RLS + service role key bypasses all policies** — never expose service role key to the browser (no `NEXT_PUBLIC_` prefix).
- **Supabase local dev requires Docker/OrbStack running** — only one instance at a time on default ports (54321/54322).
- **For multiple local projects**, configure port offsets in `supabase/config.toml`.
- **Schema SQL files must order tables by FK dependencies** — create referenced tables first.
- **Real-time subscriptions in Server Components don't work** — use a Client Component wrapper with `useEffect`.

### Next.js / Vercel Deployment
- **Uncommitted imports crash production silently** — build passes locally because the file exists, but Vercel only deploys committed files. Always verify new imports are tracked: `git show HEAD:<file>`.
- **`.next/dev/lock` must be deleted** when restarting after crash — otherwise dev server hangs.
- **Directory names with spaces**: `vercel link` needs `--project kebab-name`.
- **Setting env vars on Vercel**: Use `printf 'value' | vercel env add VAR_NAME production` — the `--yes` flag does NOT work on `vercel env add`.
- **Deprecated packages**: `@vercel/postgres` → `@neondatabase/serverless`, `@vercel/kv` → `@upstash/redis`.

### CSS / Tailwind v4
- **CSS import order matters**: `@import url(...)` MUST come before `@tailwind base/components/utilities`. Wrong order causes silent styling failures.
- **macOS dark mode interference**: Tailwind v4 uses `prefers-color-scheme` by default. For light-mode projects, add `@custom-variant dark (&:is(.dark *));` to globals.css.

### Cherry-Picking
- **Grep for table refs before cherry-picking** from feature branches. If the diff references tables that only exist on the feature branch, the cherry-pick will cause cascading `PGRST205` errors.
- **Multi-tenant schema changes must be backward-compatible** — nullable columns first, backfill, then constraints.

## AI Integration (When Needed)

- **Default to AI Gateway** — use `model: 'provider/model'` strings (e.g., `'anthropic/claude-sonnet-4.6'`). No API keys needed on Vercel (OIDC auth).
- **Set up**: `vercel link` → enable AI Gateway in dashboard → `vercel env pull` for OIDC credentials.
- **Install**: `npm install ai @ai-sdk/react` for AI features.
- **UI**: Use AI Elements (`npx ai-elements`) for chat interfaces — never render AI text as raw `{text}`.
- **Streaming**: `streamText` + `toUIMessageStreamResponse()` on server, `useChat` with `DefaultChatTransport` on client.

## Security Checklist

- [ ] RLS enabled on ALL Supabase tables
- [ ] Service role key NOT exposed to client
- [ ] `getUser()` used instead of `getSession()` for auth checks
- [ ] Input validation on Server Actions
- [ ] `.env*.local` in `.gitignore`
- [ ] All imported files tracked by git (no uncommitted imports)
- [ ] CSS import order correct in globals.css
