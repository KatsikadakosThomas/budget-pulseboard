<!-- LOVABLE:BEGIN -->
> [!IMPORTANT]
> This project is connected to [Lovable](https://lovable.dev). Avoid rewriting
> published git history — force pushing, or rebasing/amending/squashing commits
> that are already pushed — as it rewrites history on Lovable's side and the
> user will likely lose their project history.
>
> Commits you push to the connected branch sync back to Lovable and show up in
> the editor, so keep the branch in a working state.
<!-- LOVABLE:END -->

## Technical notes

- This project was remixed without the original `supabase/migrations/` history; the live backend schema exists but drifts from the code's expectations. Apply all schema changes through the database migration tool (never `run_sql` for schema), and after any remix, verify the live schema matches what RPCs expect (e.g. `create_organization` inserts `organizations.slug`).
- The signup → profile chain requires the `on_auth_user_created` trigger on `auth.users` calling `public.handle_new_user()`. If profiles stay empty after signup, check that trigger first (restored in migration `repair_remix_slug_and_signup_trigger`).
- Email confirmation is required (auto-confirm off) on this backend; the auth page handles the "check your email" path. See README "Known gaps" for password reset / invite email gaps.
