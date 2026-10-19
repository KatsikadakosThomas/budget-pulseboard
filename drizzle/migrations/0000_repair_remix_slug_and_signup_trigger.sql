-- Repair migration for the remixed backend.
--
-- The remix carried over the live schema but lost supabase/migrations/ and two
-- pieces of schema that the app code depends on. This migration reapplies them.

-- 1. The `create_organization` RPC inserts a `slug` column that did not exist
--    on `organizations`, so workspace creation failed with 42703.
alter table public.organizations add column if not exists slug text;
create unique index if not exists organizations_slug_key on public.organizations (lower(slug));

-- 2. The `handle_new_user` function existed but was never attached to
--    `auth.users`, so new signups never got a `profiles` row.
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
