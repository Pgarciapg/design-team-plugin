---
description: Scaffold a new Next.js + Supabase MVP project with best practices baked in
arguments:
  - name: project_name
    description: Name of the project (used for folder name)
    required: true
  - name: skip_install
    description: Skip npm install (useful for CI)
    required: false
---

# MVP Scaffold

You are scaffolding a new MVP project with the standard tech stack.

## Project: $ARGUMENTS.project_name

## Pre-flight Checks

1. Check if PROJECT_BRIEF.md exists in current directory
   - If yes, read it and use the requirements
   - If no, ask user for basic requirements or suggest running `/mvp-kickoff` first

2. Check if target directory already exists
   - If yes, ask user how to proceed (overwrite, different name, cancel)

## Step 1: Create Next.js Project

Run:
```bash
npx create-next-app@latest $ARGUMENTS.project_name --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-npm
```

Wait for completion before proceeding.

## Step 2: Install Dependencies

```bash
cd $ARGUMENTS.project_name && npm install @supabase/supabase-js @supabase/ssr lucide-react clsx tailwind-merge
```

Dev dependencies:
```bash
npm install -D @types/node prettier prettier-plugin-tailwindcss
```

## Step 3: Create Project Structure

Create these directories:
```
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   └── signup/
│   ├── (dashboard)/
│   │   └── dashboard/
│   ├── api/
│   └── globals.css
├── components/
│   ├── ui/
│   └── layout/
├── lib/
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── server.ts
│   │   └── middleware.ts
│   └── utils.ts
├── hooks/
├── types/
│   └── database.ts
└── middleware.ts
```

## Step 4: Create Core Files

### lib/utils.ts
```typescript
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

### lib/supabase/client.ts
```typescript
import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
```

### lib/supabase/server.ts
```typescript
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            );
          } catch {
            // The `setAll` method was called from a Server Component.
            // This can be ignored if you have middleware refreshing sessions.
          }
        },
      },
    }
  );
}
```

### lib/supabase/middleware.ts
```typescript
import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          );
          supabaseResponse = NextResponse.next({
            request,
          });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          );
        },
      },
    }
  );

  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Protect dashboard routes
  if (!user && request.nextUrl.pathname.startsWith("/dashboard")) {
    const url = request.nextUrl.clone();
    url.pathname = "/login";
    return NextResponse.redirect(url);
  }

  return supabaseResponse;
}
```

### src/middleware.ts
```typescript
import { type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

export async function middleware(request: NextRequest) {
  return await updateSession(request);
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
```

### types/database.ts
```typescript
export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

// Generate with: npx supabase gen types typescript --project-id YOUR_PROJECT_ID > src/types/database.ts
export interface Database {
  public: {
    Tables: {
      // Your tables will be generated here
    };
    Views: {};
    Functions: {};
    Enums: {};
  };
}
```

### .env.local.example
```
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

### .prettierrc
```json
{
  "semi": true,
  "singleQuote": false,
  "tabWidth": 2,
  "trailingComma": "es5",
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

## Step 5: Create Basic UI Components

### components/ui/button.tsx
```typescript
import { cn } from "@/lib/utils";
import { ButtonHTMLAttributes, forwardRef } from "react";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "ghost" | "danger";
  size?: "sm" | "md" | "lg";
}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = "primary", size = "md", ...props }, ref) => {
    return (
      <button
        ref={ref}
        className={cn(
          "inline-flex items-center justify-center rounded-lg font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
          {
            "bg-zinc-900 text-white hover:bg-zinc-800": variant === "primary",
            "bg-zinc-100 text-zinc-900 hover:bg-zinc-200": variant === "secondary",
            "hover:bg-zinc-100": variant === "ghost",
            "bg-red-600 text-white hover:bg-red-700": variant === "danger",
          },
          {
            "h-8 px-3 text-sm": size === "sm",
            "h-10 px-4 text-sm": size === "md",
            "h-12 px-6 text-base": size === "lg",
          },
          className
        )}
        {...props}
      />
    );
  }
);
Button.displayName = "Button";

export { Button };
```

### components/ui/input.tsx
```typescript
import { cn } from "@/lib/utils";
import { InputHTMLAttributes, forwardRef } from "react";

const Input = forwardRef<HTMLInputElement, InputHTMLAttributes<HTMLInputElement>>(
  ({ className, type, ...props }, ref) => {
    return (
      <input
        type={type}
        className={cn(
          "flex h-10 w-full rounded-lg border border-zinc-200 bg-white px-3 py-2 text-sm ring-offset-white file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-zinc-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-950 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
          className
        )}
        ref={ref}
        {...props}
      />
    );
  }
);
Input.displayName = "Input";

export { Input };
```

## Step 6: Create Auth Pages

### app/(auth)/login/page.tsx
```typescript
import { LoginForm } from "./login-form";

export default function LoginPage() {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="w-full max-w-sm space-y-6 p-4">
        <div className="space-y-2 text-center">
          <h1 className="text-2xl font-bold">Welcome back</h1>
          <p className="text-zinc-500">Sign in to your account</p>
        </div>
        <LoginForm />
      </div>
    </div>
  );
}
```

### app/(auth)/login/login-form.tsx
```typescript
"use client";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export function LoginForm() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const supabase = createClient();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setError(error.message);
      setLoading(false);
      return;
    }

    router.push("/dashboard");
    router.refresh();
  };

  return (
    <form onSubmit={handleLogin} className="space-y-4">
      <div className="space-y-2">
        <Input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
      </div>
      <div className="space-y-2">
        <Input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
      </div>
      {error && <p className="text-sm text-red-600">{error}</p>}
      <Button type="submit" className="w-full" disabled={loading}>
        {loading ? "Signing in..." : "Sign in"}
      </Button>
    </form>
  );
}
```

## Step 7: Create Dashboard Layout

### app/(dashboard)/layout.tsx
```typescript
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  return (
    <div className="min-h-screen bg-zinc-50">
      <header className="border-b bg-white">
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-4">
          <h1 className="text-lg font-semibold">Dashboard</h1>
          <form action="/api/auth/signout" method="POST">
            <button type="submit" className="text-sm text-zinc-500 hover:text-zinc-900">
              Sign out
            </button>
          </form>
        </div>
      </header>
      <main className="mx-auto max-w-7xl p-4">{children}</main>
    </div>
  );
}
```

### app/(dashboard)/dashboard/page.tsx
```typescript
import { createClient } from "@/lib/supabase/server";

export default async function DashboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold">Welcome back!</h2>
        <p className="text-zinc-500">{user?.email}</p>
      </div>

      <div className="rounded-lg border bg-white p-6">
        <p className="text-zinc-500">Your dashboard content goes here.</p>
      </div>
    </div>
  );
}
```

### app/api/auth/signout/route.ts
```typescript
import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function POST() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  return NextResponse.redirect(new URL("/login", process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000"));
}
```

## Step 8: Update Home Page

### app/page.tsx
```typescript
import { Button } from "@/components/ui/button";
import Link from "next/link";

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-6 p-4">
      <h1 className="text-4xl font-bold">$ARGUMENTS.project_name</h1>
      <p className="text-zinc-500">Your MVP starts here.</p>
      <div className="flex gap-4">
        <Button asChild>
          <Link href="/login">Sign in</Link>
        </Button>
        <Button variant="secondary" asChild>
          <Link href="/signup">Sign up</Link>
        </Button>
      </div>
    </div>
  );
}
```

## Step 9: Final Setup Instructions

After scaffold completes, display:

```
✓ Project scaffolded successfully!

Next steps:

1. Set up Supabase:
   - Go to https://supabase.com/dashboard
   - Create new project
   - Copy URL and anon key to .env.local

2. Configure environment:
   cp .env.local.example .env.local
   # Add your Supabase credentials

3. Enable auth in Supabase:
   - Go to Authentication > Providers
   - Enable Email provider (or others as needed)

4. Start development:
   npm run dev

5. When ready to deploy:
   /mvp-ship

Useful commands:
- /mvp-db          Generate Supabase migrations
- /mvp-ship        Deploy to Vercel
- /mvp-status      Check project status
```

## Important Notes

- All files use TypeScript strict mode
- Tailwind is configured with the default theme
- Supabase SSR is set up for both client and server components
- Middleware handles auth session refresh
- Protected routes redirect to login
