-- 3/A Dijital Derslik · güvenli başlangıç şeması
-- Supabase SQL Editor'da yalnızca projeyi bağlayıp inceledikten sonra uygulanmalıdır.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check(role in ('teacher','student')),
  display_name text not null,
  student_code text unique,
  avatar_path text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.lessons (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subject text not null,
  outcome text not null,
  week_start date not null,
  explanation text not null default '',
  video_url text,
  published boolean not null default false,
  author_id uuid not null references public.profiles(id),
  created_at timestamptz not null default now()
);
create table if not exists public.activities (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  ordinal integer not null default 0,
  kind text not null check(kind in ('match','drag','true_false','multiple_choice','reasoning')),
  prompt text not null,
  content jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
create table if not exists public.progress (
  student_id uuid not null references public.profiles(id) on delete cascade,
  activity_id uuid not null references public.activities(id) on delete cascade,
  status text not null default 'started' check(status in ('started','completed')),
  score integer not null default 0 check(score between 0 and 100),
  attempts integer not null default 0 check(attempts >= 0),
  updated_at timestamptz not null default now(),
  primary key (student_id, activity_id)
);
create index if not exists idx_lessons_week on public.lessons(week_start);
create index if not exists idx_activities_lesson on public.activities(lesson_id,ordinal);
create index if not exists idx_progress_student on public.progress(student_id);

create or replace function public.is_teacher()
returns boolean language sql stable security definer set search_path = ''
as $$select exists (select 1 from public.profiles p where p.id = (select auth.uid()) and p.role='teacher' and p.active=true)$$;

alter table public.profiles enable row level security;
alter table public.lessons enable row level security;
alter table public.activities enable row level security;
alter table public.progress enable row level security;

-- Profiller kendilerine veya yetkili öğretmene görünür.
create policy "profiles_read" on public.profiles for select to authenticated
using (id=(select auth.uid()) or (select public.is_teacher()));
-- Öğretmen profili veya rol ataması istemciden değiştirilemez.
create policy "lessons_read" on public.lessons for select to authenticated
using (published or (select public.is_teacher()));
create policy "lessons_create" on public.lessons for insert to authenticated
with check ((select public.is_teacher()) and author_id=(select auth.uid()));
create policy "lessons_update" on public.lessons for update to authenticated
using ((select public.is_teacher())) with check ((select public.is_teacher()));
create policy "lessons_delete" on public.lessons for delete to authenticated
using ((select public.is_teacher()));
create policy "activities_read" on public.activities for select to authenticated
using ((select public.is_teacher()) or exists (
 select 1 from public.lessons l where l.id=lesson_id and l.published
));
create policy "activities_create" on public.activities for insert to authenticated
with check ((select public.is_teacher()));
create policy "activities_update" on public.activities for update to authenticated
using ((select public.is_teacher())) with check ((select public.is_teacher()));
create policy "activities_delete" on public.activities for delete to authenticated
using ((select public.is_teacher()));
create policy "progress_read" on public.progress for select to authenticated
using (student_id=(select auth.uid()) or (select public.is_teacher()));
create policy "progress_insert" on public.progress for insert to authenticated
with check (student_id=(select auth.uid()) and exists (
 select 1 from public.activities a join public.lessons l on l.id=a.lesson_id
 where a.id=activity_id and l.published
));
create policy "progress_update" on public.progress for update to authenticated
using (student_id=(select auth.uid()))
with check (student_id=(select auth.uid()));

-- Güvenlik notu: puanlar istemci tarafından yazılabildiğinden gerçek sınav
-- puanlaması için sunucu tarafında doğrulamalı RPC/Edge Function gerekir.
-- İlk öğretmen hesabı yalnızca güvenilir yönetim ortamından oluşturulmalıdır.
-- Öğrenci hesaplarını oluşturmak/şifre sıfırlamak için service_role anahtarı
-- KESİNLİKLE GitHub Pages / tarayıcı koduna eklenmemelidir.
