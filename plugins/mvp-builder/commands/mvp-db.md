---
description: Manage Supabase database - create tables, generate types, run migrations
arguments:
  - name: action
    description: Action to perform (init, migrate, types, seed, reset)
    required: true
---

# MVP Database Management

Manage your Supabase database for the MVP.

## Action: $ARGUMENTS.action

---

## Action: init

Initialize Supabase in the project.

### Steps:
1. Install Supabase CLI if needed:
```bash
npm install -D supabase
```

2. Initialize Supabase:
```bash
npx supabase init
```

3. Link to remote project:
```bash
npx supabase link --project-ref YOUR_PROJECT_REF
```

Guide user to find project ref in Supabase dashboard URL.

---

## Action: migrate

Create and run database migrations.

### Interactive Migration Builder

Ask user: "What do you need to add to the database?"

Based on response, generate appropriate SQL migration.

### Common Patterns:

#### User Profiles Table
```sql
-- Create profiles table
create table public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email text,
  full_name text,
  avatar_url text,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

-- Enable RLS
alter table public.profiles enable row level security;

-- Policies
create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

#### Generic CRUD Table
```sql
-- Create [table_name] table
create table public.[table_name] (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  [columns],
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

-- Enable RLS
alter table public.[table_name] enable row level security;

-- Policies
create policy "Users can view own [table_name]"
  on public.[table_name] for select
  using (auth.uid() = user_id);

create policy "Users can create own [table_name]"
  on public.[table_name] for insert
  with check (auth.uid() = user_id);

create policy "Users can update own [table_name]"
  on public.[table_name] for update
  using (auth.uid() = user_id);

create policy "Users can delete own [table_name]"
  on public.[table_name] for delete
  using (auth.uid() = user_id);

-- Updated at trigger
create trigger handle_updated_at before update on public.[table_name]
  for each row execute procedure moddatetime (updated_at);
```

### Create Migration File:
```bash
npx supabase migration new [migration_name]
```

Then write SQL to the generated file.

### Push Migration:
```bash
npx supabase db push
```

---

## Action: types

Generate TypeScript types from database schema.

```bash
npx supabase gen types typescript --linked > src/types/database.ts
```

Then show user how to use typed client:

```typescript
import { createClient } from "@/lib/supabase/client";
import { Database } from "@/types/database";

const supabase = createClient<Database>();

// Now fully typed!
const { data } = await supabase
  .from("profiles")
  .select("*")
  .single();
```

---

## Action: seed

Create seed data for development.

### Create seed file:
Create `supabase/seed.sql`:

```sql
-- Seed data for development
-- This runs after migrations

-- Example: Insert test data
-- insert into public.profiles (id, email, full_name)
-- values ('test-uuid', 'test@example.com', 'Test User');
```

Ask user what seed data they need and generate appropriate SQL.

### Run seed:
```bash
npx supabase db reset
```
(This resets DB and runs all migrations + seed)

---

## Action: reset

Reset database to clean state.

⚠️ WARNING: This will delete all data!

Ask for confirmation before proceeding.

```bash
npx supabase db reset
```

This will:
1. Drop all tables
2. Run all migrations
3. Run seed.sql

---

## Quick Reference

| Command | Description |
|---------|-------------|
| `npx supabase start` | Start local Supabase |
| `npx supabase stop` | Stop local Supabase |
| `npx supabase db push` | Push migrations to remote |
| `npx supabase db pull` | Pull schema from remote |
| `npx supabase db reset` | Reset local database |
| `npx supabase gen types typescript --linked` | Generate types |

## Best Practices

1. **Always use RLS** - Enable row level security on all tables
2. **Use UUIDs** - Default to UUID primary keys
3. **Add timestamps** - Include created_at and updated_at
4. **Foreign keys** - Reference auth.users for user ownership
5. **Policies first** - Write RLS policies before any data access code
6. **Type safety** - Regenerate types after schema changes
