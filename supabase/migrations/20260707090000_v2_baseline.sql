-- ═══════════════════════════════════════════════════════════════════════════
-- v2 BASELINE — sauberer Neuaufbau gemäß docs/REBUILD_PLAN.md (Abschnitt 4)
--
-- ACHTUNG vor dem Live-Deploy (Phase 4, erst nach User-Sign-off):
--   1. Phase 0 muss abgeschlossen sein (Datenexport liegt in backup/).
--   2. Dieses Script DROPPT das komplette v1-Schema inkl. Daten.
--   3. Die alte Migrationshistorie liegt in supabase/migrations_v1/ (nur Referenz).
--      Auf dem Live-Projekt ggf. `supabase migration repair` nötig, oder das
--      Script einmalig über den SQL-Editor einspielen.
--   4. auth.users und storage.objects bleiben unangetastet.
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 0. v1-Schema entfernen ──────────────────────────────────────────────────

drop table if exists public.drinking_log cascade;
drop table if exists public.people cascade;
drop table if exists public.wines cascade;
drop table if exists public.wine_appellations cascade;
drop table if exists public.wine_sub_regions cascade;
drop table if exists public.wine_regions cascade;
drop table if exists public.wine_countries cascade;
drop table if exists public.wine_colours cascade;
-- profiles wurde in v1 manuell im Dashboard angelegt (Schema-Drift):
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user() cascade;
drop table if exists public.profiles cascade;
drop function if exists public.set_updated_at() cascade;

-- ─── 1. Generische Helper ────────────────────────────────────────────────────

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.generate_invite_code()
returns text
language sql
volatile
as $$
  select upper(substring(md5(random()::text || clock_timestamp()::text), 1, 8))
$$;

-- ─── 2. Identität & Mitgliedschaft ───────────────────────────────────────────

create table public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  display_name  text,
  email         text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1))
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Bestehende Auth-User nachziehen (die Familie ist ja schon registriert):
insert into public.profiles (id, email, display_name)
select id, email, split_part(email, '@', 1)
from auth.users
on conflict (id) do nothing;

create table public.cellars (
  id           uuid primary key default gen_random_uuid(),
  name         text not null,
  invite_code  text not null unique default public.generate_invite_code(),
  created_by   uuid references public.profiles(id) on delete set null,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create trigger set_cellars_updated_at
  before update on public.cellars
  for each row execute function public.set_updated_at();

create table public.cellar_members (
  cellar_id   uuid not null references public.cellars(id) on delete cascade,
  user_id     uuid not null references public.profiles(id) on delete cascade,
  role        text not null default 'member' check (role in ('owner', 'member')),
  created_at  timestamptz not null default now(),
  primary key (cellar_id, user_id),
  unique (user_id)          -- Entscheidung E3: genau EIN Keller pro User
);

-- Kern-Helper: der (einzige) Keller des eingeloggten Users.
-- SECURITY DEFINER, damit RLS-Policies ihn ohne Rekursion nutzen können.
create or replace function public.current_cellar_id()
returns uuid
language sql
stable
security definer set search_path = public
as $$
  select cellar_id from public.cellar_members where user_id = auth.uid()
$$;

create or replace function public.current_member_role()
returns text
language sql
stable
security definer set search_path = public
as $$
  select role from public.cellar_members where user_id = auth.uid()
$$;

-- ─── 3. Geografie-Referenz (global, gehört niemandem) ────────────────────────

create table public.countries (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  code        text,                       -- ISO 3166-1 alpha-2
  continent   text,
  sort_order  int not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table public.regions (
  id          uuid primary key default gen_random_uuid(),
  country_id  uuid not null references public.countries(id) on delete cascade,
  name        text not null,
  sort_order  int not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (country_id, name)
);

create table public.sub_regions (
  id          uuid primary key default gen_random_uuid(),
  region_id   uuid not null references public.regions(id) on delete cascade,
  name        text not null,
  sort_order  int not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (region_id, name)
);

create table public.appellations (
  id             uuid primary key default gen_random_uuid(),
  level          text not null check (level in ('country', 'region', 'sub_region')),
  country_id     uuid references public.countries(id)   on delete cascade,
  region_id      uuid references public.regions(id)     on delete cascade,
  sub_region_id  uuid references public.sub_regions(id) on delete cascade,
  name           text not null,
  type           text,          -- AOC, AOP, DOCG, DOC, DO, DOCa, AVA, GI, WO, DAC, …
  sort_order     int not null default 0,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  -- Genau EIN Parent, passend zum Level:
  check (
    (level = 'country'    and country_id is not null and region_id is null     and sub_region_id is null) or
    (level = 'region'     and region_id  is not null and country_id is null    and sub_region_id is null) or
    (level = 'sub_region' and sub_region_id is not null and country_id is null and region_id is null)
  )
);

-- Keine Duplikate am selben Aufhängepunkt:
create unique index appellations_unique_per_parent
  on public.appellations (
    name,
    level,
    coalesce(country_id,    '00000000-0000-0000-0000-000000000000'::uuid),
    coalesce(region_id,     '00000000-0000-0000-0000-000000000000'::uuid),
    coalesce(sub_region_id, '00000000-0000-0000-0000-000000000000'::uuid)
  );

create trigger set_countries_updated_at    before update on public.countries    for each row execute function public.set_updated_at();
create trigger set_regions_updated_at     before update on public.regions      for each row execute function public.set_updated_at();
create trigger set_sub_regions_updated_at before update on public.sub_regions  for each row execute function public.set_updated_at();
create trigger set_appellations_updated_at before update on public.appellations for each row execute function public.set_updated_at();

-- ─── 4. Kellerdaten ──────────────────────────────────────────────────────────

create table public.wine_colours (
  id            uuid primary key default gen_random_uuid(),
  cellar_id     uuid not null references public.cellars(id) on delete cascade,
  name          text not null,          -- Slug, Key fürs eingebaute Styling
  display_name  text not null,
  -- Weinart steuert die weinart-spezifischen Formularfelder (Jahrgang/NV/
  -- Basisjahr/Dosage vs. Reifeangabe). Custom-Farben starten als 'still'.
  kind          text not null default 'still'
                  check (kind in ('still', 'sparkling', 'sweet_fortified')),
  sort_order    int not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (cellar_id, name)
);

create trigger set_wine_colours_updated_at
  before update on public.wine_colours
  for each row execute function public.set_updated_at();

-- Jeder neue Keller startet mit den 6 Standard-Farbkategorien:
create or replace function public.seed_cellar_defaults()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.wine_colours (cellar_id, name, display_name, kind, sort_order) values
    (new.id, 'sparkling',         'Sparkling',           'sparkling',       0),
    (new.id, 'white',             'White',               'still',           1),
    (new.id, 'red',               'Red',                 'still',           2),
    (new.id, 'rose',              'Rosé',                'still',           3),
    (new.id, 'orange',            'Orange',              'still',           4),
    (new.id, 'dessert_fortified', 'Dessert / Fortified', 'sweet_fortified', 5);
  return new;
end;
$$;

create trigger seed_cellar_defaults_on_insert
  after insert on public.cellars
  for each row execute function public.seed_cellar_defaults();

create table public.wines (
  id                 uuid primary key default gen_random_uuid(),
  cellar_id          uuid not null references public.cellars(id) on delete cascade,
  created_by         uuid references public.profiles(id) on delete set null,
  -- Identität
  producer           text,
  name               text,               -- v1: `description` (Cuvée-/Weinname)
  -- Jahrgang als Zahl (Stillweine / echte Jahrgangsweine). NV-Schaumweine und
  -- Solera-/Reifeweine lassen vintage NULL und nutzen die drei Felder darunter.
  vintage            int check (vintage is null or (vintage between 1800 and 2100)),
  is_non_vintage     boolean not null default false,
  base_vintage       int check (base_vintage is null or (base_vintage between 1800 and 2100)),
  aging_indication   text,               -- Süß/Likör: '~25 years', 'Solera 2013+', 'VORS', '3 Puttonyos'
  colour_id          uuid references public.wine_colours(id) on delete set null,
  variety            text,
  classification     text,               -- Qualitätsstufe: AOC, DOCG, VDP.Grosse Lage, GG, Grand Cru, DAC …
  -- Kennzahlen
  size_ml            int check (size_ml is null or size_ml > 0),   -- v1: cl (integer)
  alcohol_pct        numeric check (alcohol_pct is null or (alcohol_pct >= 0 and alcohol_pct < 100)),
  residual_sugar_gl  numeric check (residual_sugar_gl is null or residual_sugar_gl >= 0),
  dosage_level       text,               -- Schaumwein-Stufe: Brut Nature, Extra Brut, Brut, Extra Dry, Sec, Demi-Sec, Doux
  dosage_gl          numeric check (dosage_gl is null or dosage_gl >= 0),
  -- Schaumwein (optional): Monat/Jahr als Datum (Tag = 01). Differenz = Zeit auf der Hefe.
  tirage_date        date,               -- Fülldatum / Beginn Hefelager
  disgorgement_date  date,               -- Dégorgement / Ende Hefelager
  -- Geografie: FKs + Freitext-`location` für Orte ohne offizielle Appellation.
  country_id         uuid references public.countries(id)    on delete set null,
  region_id          uuid references public.regions(id)      on delete set null,
  sub_region_id      uuid references public.sub_regions(id)  on delete set null,
  appellation_id     uuid references public.appellations(id) on delete set null,
  location           text,               -- Dorf/Lage/Cru, wenn keine eigene AOC (z. B. Ambonnay)
  -- Freitexte
  terroir_notes      text,               -- v1: ausbau_terroir
  notes              text,
  -- Verwaltung
  occasion           text check (occasion in ('anytime', 'special', 'lay_down', 'top')),
  quantity           int not null default 1 check (quantity >= 0),
  price_chf          numeric check (price_chf is null or price_chf >= 0),
  purchased_from     text,
  ready_from         int check (ready_from is null or (ready_from between 1800 and 2200)),
  drink_by           int check (drink_by is null or (drink_by between 1800 and 2200)),
  rating             int check (rating is null or (rating between 1 and 5)),
  storage_location   text,               -- V1 (Backlog): z. B. „Regal B / Fach 3"
  label_photo_path   text,               -- Storage-Pfad, nicht volle URL
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

create trigger set_wines_updated_at
  before update on public.wines
  for each row execute function public.set_updated_at();

-- Geo-Konsistenz: aus der tiefsten gesetzten Ebene die Vorfahren ableiten.
create or replace function public.wines_fill_geo_ancestors()
returns trigger
language plpgsql
as $$
declare
  v_level text;
  v_country uuid;
  v_region uuid;
  v_sub uuid;
begin
  if new.appellation_id is not null then
    select a.level, a.country_id, a.region_id, a.sub_region_id
      into v_level, v_country, v_region, v_sub
      from public.appellations a where a.id = new.appellation_id;
    if v_level = 'sub_region' then
      new.sub_region_id := v_sub;
    elsif v_level = 'region' then
      new.region_id := v_region;
    elsif v_level = 'country' then
      new.country_id := v_country;
    end if;
  end if;
  if new.sub_region_id is not null then
    select s.region_id into new.region_id
      from public.sub_regions s where s.id = new.sub_region_id;
  end if;
  if new.region_id is not null then
    select r.country_id into new.country_id
      from public.regions r where r.id = new.region_id;
  end if;
  return new;
end;
$$;

create trigger wines_fill_geo_ancestors_trg
  before insert or update of country_id, region_id, sub_region_id, appellation_id
  on public.wines
  for each row execute function public.wines_fill_geo_ancestors();

create table public.people (
  id          uuid primary key default gen_random_uuid(),
  cellar_id   uuid not null references public.cellars(id) on delete cascade,
  name        text not null,
  avatar      text,
  created_at  timestamptz not null default now()
);

create table public.drinking_log (
  id          uuid primary key default gen_random_uuid(),
  cellar_id   uuid not null references public.cellars(id) on delete cascade,
  wine_id     uuid references public.wines(id) on delete set null,
  wine_label  text,               -- Snapshot „Producer — Name Vintage" beim Öffnen
  date        date not null default current_date,
  note        text,
  rating      int check (rating is null or (rating between 1 and 5)),  -- V6
  opened_by   uuid references public.profiles(id) on delete set null,
  created_at  timestamptz not null default now()
);

create table public.drinking_log_people (
  log_id     uuid not null references public.drinking_log(id) on delete cascade,
  person_id  uuid not null references public.people(id)       on delete cascade,
  primary key (log_id, person_id)
);

-- ─── 5. Indexe ───────────────────────────────────────────────────────────────

create index idx_wines_cellar          on public.wines (cellar_id);
create index idx_wines_cellar_colour   on public.wines (cellar_id, colour_id);
create index idx_wines_country         on public.wines (country_id);
create index idx_wines_region          on public.wines (region_id);
create index idx_wines_sub_region      on public.wines (sub_region_id);
create index idx_wines_appellation     on public.wines (appellation_id);
create index idx_regions_country       on public.regions (country_id, sort_order);
create index idx_sub_regions_region    on public.sub_regions (region_id, sort_order);
create index idx_appellations_country  on public.appellations (country_id);
create index idx_appellations_region   on public.appellations (region_id);
create index idx_appellations_sub      on public.appellations (sub_region_id);
create index idx_wine_colours_cellar   on public.wine_colours (cellar_id, sort_order);
create index idx_people_cellar         on public.people (cellar_id);
create index idx_drinking_log_cellar   on public.drinking_log (cellar_id, date desc);
create index idx_drinking_log_wine     on public.drinking_log (wine_id);
create index idx_cellar_members_cellar on public.cellar_members (cellar_id);

-- ─── 5b. Grants ──────────────────────────────────────────────────────────────
-- RLS entscheidet, WELCHE Zeilen eine Rolle sieht; GRANT entscheidet, ob die
-- Rolle die Tabelle überhaupt anfassen darf. Ohne diese Grants bekäme JEDER
-- eingeloggte User „permission denied" auf allen Tabellen. Spiegelt die
-- Standard-Grants, die Supabase für neue public-Objekte vergibt — hier explizit,
-- damit das Schema unabhängig von Default-Privilege-Magie reproduzierbar ist.
grant usage on schema public to anon, authenticated, service_role;
grant all on all tables    in schema public to anon, authenticated, service_role;
grant all on all routines  in schema public to anon, authenticated, service_role;
grant all on all sequences in schema public to anon, authenticated, service_role;

-- ─── 6. RLS ──────────────────────────────────────────────────────────────────

alter table public.profiles            enable row level security;
alter table public.cellars             enable row level security;
alter table public.cellar_members      enable row level security;
alter table public.countries           enable row level security;
alter table public.regions             enable row level security;
alter table public.sub_regions         enable row level security;
alter table public.appellations        enable row level security;
alter table public.wine_colours        enable row level security;
alter table public.wines               enable row level security;
alter table public.people              enable row level security;
alter table public.drinking_log        enable row level security;
alter table public.drinking_log_people enable row level security;

-- profiles: eigenes Profil + Profile der Keller-Mitglieder (für Mitglieder-UI)
create policy "profiles_select" on public.profiles for select to authenticated
  using (
    id = auth.uid()
    or exists (
      select 1 from public.cellar_members cm
      where cm.user_id = profiles.id
        and cm.cellar_id = public.current_cellar_id()
    )
  );
create policy "profiles_update_own" on public.profiles for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- cellars: sehen als Mitglied; ändern als Owner; Anlegen NUR via RPC
create policy "cellars_select" on public.cellars for select to authenticated
  using (id = public.current_cellar_id());
create policy "cellars_update_owner" on public.cellars for update to authenticated
  using (id = public.current_cellar_id() and public.current_member_role() = 'owner')
  with check (id = public.current_cellar_id());

-- cellar_members: Mitglieder sehen einander; Owner entfernt andere;
-- Nicht-Owner dürfen selbst austreten; Beitritt NUR via RPC
create policy "members_select" on public.cellar_members for select to authenticated
  using (cellar_id = public.current_cellar_id());
create policy "members_delete" on public.cellar_members for delete to authenticated
  using (
    cellar_id = public.current_cellar_id()
    and (
      (public.current_member_role() = 'owner' and user_id <> auth.uid())
      or (user_id = auth.uid() and role <> 'owner')
    )
  );

-- Geo-Referenz: lesen + pflegen für alle authentifizierten User (Familien-Pragmatik)
create policy "countries_select" on public.countries for select to authenticated using (true);
create policy "countries_write"  on public.countries for insert to authenticated with check (true);
create policy "countries_update" on public.countries for update to authenticated using (true);
create policy "countries_delete" on public.countries for delete to authenticated using (true);

create policy "regions_select" on public.regions for select to authenticated using (true);
create policy "regions_write"  on public.regions for insert to authenticated with check (true);
create policy "regions_update" on public.regions for update to authenticated using (true);
create policy "regions_delete" on public.regions for delete to authenticated using (true);

create policy "sub_regions_select" on public.sub_regions for select to authenticated using (true);
create policy "sub_regions_write"  on public.sub_regions for insert to authenticated with check (true);
create policy "sub_regions_update" on public.sub_regions for update to authenticated using (true);
create policy "sub_regions_delete" on public.sub_regions for delete to authenticated using (true);

create policy "appellations_select" on public.appellations for select to authenticated using (true);
create policy "appellations_write"  on public.appellations for insert to authenticated with check (true);
create policy "appellations_update" on public.appellations for update to authenticated using (true);
create policy "appellations_delete" on public.appellations for delete to authenticated using (true);

-- Keller-Daten: alles über die Mitgliedschaft
create policy "wine_colours_all" on public.wine_colours for all to authenticated
  using (cellar_id = public.current_cellar_id())
  with check (cellar_id = public.current_cellar_id());

create policy "wines_all" on public.wines for all to authenticated
  using (cellar_id = public.current_cellar_id())
  with check (cellar_id = public.current_cellar_id());

create policy "people_all" on public.people for all to authenticated
  using (cellar_id = public.current_cellar_id())
  with check (cellar_id = public.current_cellar_id());

create policy "drinking_log_all" on public.drinking_log for all to authenticated
  using (cellar_id = public.current_cellar_id())
  with check (cellar_id = public.current_cellar_id());

create policy "drinking_log_people_all" on public.drinking_log_people for all to authenticated
  using (
    exists (
      select 1 from public.drinking_log dl
      where dl.id = log_id and dl.cellar_id = public.current_cellar_id()
    )
  )
  with check (
    exists (
      select 1 from public.drinking_log dl
      where dl.id = log_id and dl.cellar_id = public.current_cellar_id()
    )
  );

-- ─── 7. RPCs (Onboarding & Utilities) ────────────────────────────────────────

create or replace function public.create_cellar(p_name text)
returns uuid
language plpgsql
security definer set search_path = public
as $$
declare
  v_cellar uuid;
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Cellar name is required';
  end if;
  if exists (select 1 from public.cellar_members where user_id = auth.uid()) then
    raise exception 'You are already a member of a cellar';
  end if;
  insert into public.cellars (name, created_by)
  values (trim(p_name), auth.uid())
  returning id into v_cellar;
  insert into public.cellar_members (cellar_id, user_id, role)
  values (v_cellar, auth.uid(), 'owner');
  return v_cellar;
end;
$$;

create or replace function public.join_cellar(p_invite_code text)
returns uuid
language plpgsql
security definer set search_path = public
as $$
declare
  v_cellar uuid;
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  if exists (select 1 from public.cellar_members where user_id = auth.uid()) then
    raise exception 'You are already a member of a cellar';
  end if;
  select id into v_cellar
  from public.cellars
  where invite_code = upper(trim(p_invite_code));
  if v_cellar is null then
    raise exception 'Invalid invite code';
  end if;
  insert into public.cellar_members (cellar_id, user_id, role)
  values (v_cellar, auth.uid(), 'member');
  return v_cellar;
end;
$$;

create or replace function public.regenerate_invite_code()
returns text
language plpgsql
security definer set search_path = public
as $$
declare
  v_code text;
begin
  if public.current_member_role() is distinct from 'owner' then
    raise exception 'Only the owner can regenerate the invite code';
  end if;
  update public.cellars
  set invite_code = public.generate_invite_code()
  where id = public.current_cellar_id()
  returning invite_code into v_code;
  return v_code;
end;
$$;

-- Batch-Reorder (ersetzt N Einzel-UPDATEs der v1-App).
-- SECURITY INVOKER: RLS der Zieltabelle gilt ganz normal.
create or replace function public.reorder_rows(p_table text, p_ids uuid[])
returns void
language plpgsql
as $$
begin
  if p_table not in ('countries', 'regions', 'sub_regions', 'appellations', 'wine_colours') then
    raise exception 'Table % is not reorderable', p_table;
  end if;
  execute format(
    'update public.%I t
       set sort_order = s.ord
      from (select unnest($1) as id, generate_subscripts($1, 1) - 1 as ord) s
     where t.id = s.id',
    p_table
  ) using p_ids;
end;
$$;

-- ─── 8. Storage (Bucket + Policies) ──────────────────────────────────────────

insert into storage.buckets (id, name, public)
values ('wine-photos', 'wine-photos', true)
on conflict (id) do nothing;

-- Alte user-basierte Policies ersetzen durch cellar-basierte:
drop policy if exists "Wine photos are publicly readable"        on storage.objects;
drop policy if exists "Users can upload their own wine photos"   on storage.objects;
drop policy if exists "Users can update their own wine photos"   on storage.objects;
drop policy if exists "Users can delete their own wine photos"   on storage.objects;

create policy "wine_photos_public_read" on storage.objects for select
  using (bucket_id = 'wine-photos');

-- Neue Uploads landen unter {cellar_id}/… ; Alt-Objekte unter {user_id}/…
-- bleiben liegen und sind weiterhin öffentlich lesbar.
create policy "wine_photos_member_insert" on storage.objects for insert to authenticated
  with check (
    bucket_id = 'wine-photos'
    and (storage.foldername(name))[1] = public.current_cellar_id()::text
  );
create policy "wine_photos_member_update" on storage.objects for update to authenticated
  using (
    bucket_id = 'wine-photos'
    and (storage.foldername(name))[1] = public.current_cellar_id()::text
  );
create policy "wine_photos_member_delete" on storage.objects for delete to authenticated
  using (
    bucket_id = 'wine-photos'
    and (storage.foldername(name))[1] = public.current_cellar_id()::text
  );
