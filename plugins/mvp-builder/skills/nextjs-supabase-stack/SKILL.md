---
description: Next.js + Supabase + Vercel MVP stack best practices and patterns
globs:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/supabase/**"
---

# Next.js + Supabase MVP Stack

Best practices for building MVPs with Next.js, Supabase, and Vercel.

## Project Structure

```
src/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Auth route group (no layout)
│   │   ├── login/
│   │   └── signup/
│   ├── (dashboard)/       # Protected route group
│   │   ├── layout.tsx     # Shared dashboard layout
│   │   └── dashboard/
│   ├── api/               # API routes
│   ├── layout.tsx         # Root layout
│   └── page.tsx           # Home page
├── components/
│   ├── ui/                # Reusable UI components
│   └── [feature]/         # Feature-specific components
├── lib/
│   ├── supabase/          # Supabase clients
│   └── utils.ts           # Utility functions
├── hooks/                 # Custom React hooks
├── types/                 # TypeScript types
│   └── database.ts        # Supabase generated types
└── middleware.ts          # Auth middleware
```

## Data Fetching Patterns

### Server Components (Preferred)
```typescript
// Runs on server, no client JS shipped
export default async function Page() {
  const supabase = await createClient();
  const { data } = await supabase.from("items").select();
  return <ItemList items={data} />;
}
```

### Server Actions (Mutations)
```typescript
"use server";

export async function createItem(formData: FormData) {
  const supabase = await createClient();
  await supabase.from("items").insert({
    title: formData.get("title"),
  });
  revalidatePath("/items");
}
```

### Client Components (Interactive)
```typescript
"use client";
// Only when you need:
// - Event handlers
// - useState/useEffect
// - Browser APIs
// - Real-time subscriptions
```

## Authentication Flow

### Middleware (Session Refresh)
```typescript
// src/middleware.ts
export async function middleware(request: NextRequest) {
  return await updateSession(request);
}
```

### Protected Routes
```typescript
// In page or layout
const { data: { user } } = await supabase.auth.getUser();
if (!user) redirect("/login");
```

### Login Form
```typescript
const { error } = await supabase.auth.signInWithPassword({
  email,
  password,
});
if (error) throw error;
router.push("/dashboard");
router.refresh(); // Important: refresh server components
```

## Component Patterns

### Form with Server Action
```typescript
<form action={serverAction}>
  <input name="field" />
  <SubmitButton />
</form>

// SubmitButton.tsx
"use client";
import { useFormStatus } from "react-dom";

function SubmitButton() {
  const { pending } = useFormStatus();
  return <button disabled={pending}>
    {pending ? "Saving..." : "Save"}
  </button>;
}
```

### Optimistic Updates
```typescript
"use client";
import { useOptimistic } from "react";

function ItemList({ items }) {
  const [optimisticItems, addOptimistic] = useOptimistic(
    items,
    (state, newItem) => [...state, newItem]
  );

  async function handleAdd(formData) {
    addOptimistic({ id: "temp", title: formData.get("title") });
    await createItem(formData);
  }

  return /* ... */;
}
```

## Styling Guidelines

### Tailwind Best Practices
```typescript
// Use cn() for conditional classes
import { cn } from "@/lib/utils";

<button className={cn(
  "px-4 py-2 rounded",
  variant === "primary" && "bg-zinc-900 text-white",
  variant === "secondary" && "bg-zinc-100",
  disabled && "opacity-50 cursor-not-allowed"
)} />
```

### Responsive Design
```typescript
// Mobile-first approach
<div className="
  p-4          // Base (mobile)
  md:p-6       // Medium screens
  lg:p-8       // Large screens
">
```

## Error Handling

### API Routes
```typescript
export async function POST(request: Request) {
  try {
    // ... logic
    return Response.json({ success: true });
  } catch (error) {
    console.error(error);
    return Response.json(
      { error: "Something went wrong" },
      { status: 500 }
    );
  }
}
```

### Server Actions
```typescript
"use server";

export async function createItem(formData: FormData) {
  const supabase = await createClient();

  const { error } = await supabase
    .from("items")
    .insert({ title: formData.get("title") });

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/items");
  return { success: true };
}
```

### Error Boundaries
```typescript
// app/items/error.tsx
"use client";

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return (
    <div className="p-4 bg-red-50 rounded">
      <h2>Something went wrong</h2>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

## Performance Tips

### Image Optimization
```typescript
import Image from "next/image";

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority // For above-the-fold images
/>
```

### Dynamic Imports
```typescript
import dynamic from "next/dynamic";

const HeavyComponent = dynamic(
  () => import("./HeavyComponent"),
  { loading: () => <Skeleton /> }
);
```

### Caching
```typescript
// Revalidate every hour
export const revalidate = 3600;

// Or on-demand
import { revalidatePath, revalidateTag } from "next/cache";
revalidatePath("/items");
```

## Security Checklist

- [ ] RLS enabled on all Supabase tables
- [ ] Environment variables not exposed to client (no NEXT_PUBLIC_ for secrets)
- [ ] Input validation on server actions
- [ ] Rate limiting on auth endpoints
- [ ] CSRF protection (built into Server Actions)
- [ ] Proper error messages (don't leak internal info)

## Deployment Checklist

- [ ] Environment variables set in Vercel
- [ ] Supabase URL Configuration updated with production domain
- [ ] Database migrations pushed
- [ ] Types regenerated
- [ ] Build passes locally
- [ ] Auth redirects work
