-- KOLUÇOLAK TARIM: kullanıcı başına tek JSON kayıt tablosu
-- Supabase Dashboard > SQL Editor > New query bölümünde tamamını çalıştır.
create table if not exists public.user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.user_data enable row level security;
revoke all on table public.user_data from anon;
grant select, insert, update, delete on table public.user_data to authenticated;
drop policy if exists "Users can read own data" on public.user_data;
drop policy if exists "Users can insert own data" on public.user_data;
drop policy if exists "Users can update own data" on public.user_data;
drop policy if exists "Users can delete own data" on public.user_data;
create policy "Users can read own data" on public.user_data for select to authenticated using (auth.uid() = user_id);
create policy "Users can insert own data" on public.user_data for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can update own data" on public.user_data for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete own data" on public.user_data for delete to authenticated using (auth.uid() = user_id);
alter table public.user_data replica identity full;
alter publication supabase_realtime add table public.user_data;
