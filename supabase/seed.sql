-- ═══════════════════════════════════════════════════════════════════════
-- GENERIERT von scripts/geo/build-seed.js — NICHT von Hand editieren!
-- Quelle: data/geography/*.json  ·  Neu erzeugen: npm run geo:build
-- Stand: 2026-07-14 · 51 Länder
-- Idempotent: kann beliebig oft ausgeführt werden.
-- ═══════════════════════════════════════════════════════════════════════

begin;

-- ── Algeria ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Algeria', 'DZ', 'Africa', 0)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Mascara', 0 from public.countries c where c.name = 'Algeria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux de Mascara', 'AOIG', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Algeria' and r.name = 'Mascara'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Mascara' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tlemcen', 1 from public.countries c where c.name = 'Algeria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux de Tlemcen', 'AOIG', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Algeria' and r.name = 'Tlemcen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Tlemcen' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Medea', 2 from public.countries c where c.name = 'Algeria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ain Bessem', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Algeria' and r.name = 'Medea'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ain Bessem-Bouira', 'AOIG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Algeria' and r.name = 'Medea' and s.name = 'Ain Bessem'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ain Bessem-Bouira' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Miliana', 3 from public.countries c where c.name = 'Algeria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux du Zaccar', 'AOIG', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Algeria' and r.name = 'Miliana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Zaccar' and a.level = 'region' and a.region_id = r.id);

-- ── Argentina ─────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Argentina', 'AR', 'Americas', 1)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Mendoza', 0 from public.countries c where c.name = 'Argentina'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mendoza Wine', 'IG', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Mendoza'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mendoza Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lujan de Cuyo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Mendoza'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lujan de Cuyo', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Mendoza' and s.name = 'Lujan de Cuyo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lujan de Cuyo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maipu', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Mendoza'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maipu', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Mendoza' and s.name = 'Maipu'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maipu' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valle de Uco', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Mendoza'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valle de Uco', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Mendoza' and s.name = 'Valle de Uco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle de Uco' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'San Rafael', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Mendoza'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'San Rafael', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Mendoza' and s.name = 'San Rafael'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Rafael' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Este', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Mendoza'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Este de Mendoza', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Mendoza' and s.name = 'Este'
  and not exists (select 1 from public.appellations a
    where a.name = 'Este de Mendoza' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'San Juan', 1 from public.countries c where c.name = 'Argentina'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tulum', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'San Juan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tulum', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'San Juan' and s.name = 'Tulum'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tulum' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ullum', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'San Juan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ullum', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'San Juan' and s.name = 'Ullum'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ullum' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Calingasta', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'San Juan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Calingasta', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'San Juan' and s.name = 'Calingasta'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calingasta' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Salta', 2 from public.countries c where c.name = 'Argentina'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valles Calchaquies', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Salta'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cafayate', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Salta' and s.name = 'Valles Calchaquies'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cafayate' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'La Rioja', 3 from public.countries c where c.name = 'Argentina'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Famatina', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'La Rioja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Famatina', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'La Rioja' and s.name = 'Famatina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Famatina' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Catamarca', 4 from public.countries c where c.name = 'Argentina'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Santa Maria / Fiambala', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Catamarca'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Catamarca', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Catamarca' and s.name = 'Santa Maria / Fiambala'
  and not exists (select 1 from public.appellations a
    where a.name = 'Catamarca' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Patagonia', 5 from public.countries c where c.name = 'Argentina'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Patagonia Wine', 'IG', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Patagonia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Patagonia Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Neuquen', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Patagonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'San Patricio del Chanar', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Patagonia' and s.name = 'Neuquen'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Patricio del Chanar' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rio Negro', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Patagonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alto Valle of Rio Negro', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Patagonia' and s.name = 'Rio Negro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alto Valle of Rio Negro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Chubut', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Argentina' and r.name = 'Patagonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chubut', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Argentina' and r.name = 'Patagonia' and s.name = 'Chubut'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chubut' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Armenia ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Armenia', 'AM', 'Asia', 2)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ararat Valley', 0 from public.countries c where c.name = 'Armenia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Yerevan / Artashat', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Armenia' and r.name = 'Ararat Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ararat', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Armenia' and r.name = 'Ararat Valley' and s.name = 'Yerevan / Artashat'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ararat' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vayots Dzor', 1 from public.countries c where c.name = 'Armenia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Areni', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Armenia' and r.name = 'Vayots Dzor'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Areni', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Armenia' and r.name = 'Vayots Dzor' and s.name = 'Areni'
  and not exists (select 1 from public.appellations a
    where a.name = 'Areni' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tavush', 2 from public.countries c where c.name = 'Armenia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Dilijan / Ijevan', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Armenia' and r.name = 'Tavush'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tavush', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Armenia' and r.name = 'Tavush' and s.name = 'Dilijan / Ijevan'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tavush' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Aragatsotn', 3 from public.countries c where c.name = 'Armenia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Talish / Oshakan', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Armenia' and r.name = 'Aragatsotn'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aragatsotn', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Armenia' and r.name = 'Aragatsotn' and s.name = 'Talish / Oshakan'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aragatsotn' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Australia ─────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Australia', 'AU', 'Oceania', 3)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'South Eastern Australia', 'GI', 0
from public.countries c where c.name = 'Australia'
  and not exists (select 1 from public.appellations a
    where a.name = 'South Eastern Australia' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'South Australia', 0 from public.countries c where c.name = 'Australia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Barossa Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Barossa Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Barossa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barossa Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Eden Valley', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Eden Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Eden Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Eden Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'McLaren Vale', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'McLaren Vale', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'McLaren Vale'
  and not exists (select 1 from public.appellations a
    where a.name = 'McLaren Vale' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Currency Creek', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Currency Creek', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Currency Creek'
  and not exists (select 1 from public.appellations a
    where a.name = 'Currency Creek' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Langhorne Creek', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Langhorne Creek', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Langhorne Creek'
  and not exists (select 1 from public.appellations a
    where a.name = 'Langhorne Creek' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kangaroo Island', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kangaroo Island', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Kangaroo Island'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kangaroo Island' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Adelaide Hills', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Adelaide Hills', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Adelaide Hills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Adelaide Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Clare Valley', 7
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clare Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Clare Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clare Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Coonawarra', 8
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coonawarra', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Coonawarra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coonawarra' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Padthaway', 9
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Padthaway', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Padthaway'
  and not exists (select 1 from public.appellations a
    where a.name = 'Padthaway' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wrattonbully', 10
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Wrattonbully', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Wrattonbully'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wrattonbully' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Robe', 11
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Robe', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Robe'
  and not exists (select 1 from public.appellations a
    where a.name = 'Robe' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mount Benson', 12
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mount Benson', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Mount Benson'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mount Benson' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mount Gambier', 13
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'South Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mount Gambier', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia' and s.name = 'Mount Gambier'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mount Gambier' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Victoria', 1 from public.countries c where c.name = 'Australia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Yarra Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yarra Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Yarra Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yarra Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mornington Peninsula', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mornington Peninsula', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Mornington Peninsula'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mornington Peninsula' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Macedon Ranges', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Macedon Ranges', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Macedon Ranges'
  and not exists (select 1 from public.appellations a
    where a.name = 'Macedon Ranges' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Heathcote', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Heathcote', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Heathcote'
  and not exists (select 1 from public.appellations a
    where a.name = 'Heathcote' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Grampians', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grampians', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Grampians'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grampians' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pyrenees', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pyrenees', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Pyrenees'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pyrenees' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Beechworth', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beechworth', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Beechworth'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beechworth' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rutherglen', 7
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rutherglen', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Rutherglen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rutherglen' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Goulburn Valley', 8
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Goulburn Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'Goulburn Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Goulburn Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'King Valley', 9
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Victoria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'King Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria' and s.name = 'King Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'King Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Western Australia', 2 from public.countries c where c.name = 'Australia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Western Australia', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Western Australia' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Margaret River', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Western Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Margaret River', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Margaret River'
  and not exists (select 1 from public.appellations a
    where a.name = 'Margaret River' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Great Southern', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Western Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Great Southern', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Great Southern'
  and not exists (select 1 from public.appellations a
    where a.name = 'Great Southern' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Albany', 'GI', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Great Southern'
  and not exists (select 1 from public.appellations a
    where a.name = 'Albany' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Denmark', 'GI', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Great Southern'
  and not exists (select 1 from public.appellations a
    where a.name = 'Denmark' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Frankland River', 'GI', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Great Southern'
  and not exists (select 1 from public.appellations a
    where a.name = 'Frankland River' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mount Barker', 'GI', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Great Southern'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mount Barker' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Porongurup', 'GI', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Great Southern'
  and not exists (select 1 from public.appellations a
    where a.name = 'Porongurup' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pemberton', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Western Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pemberton', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Pemberton'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pemberton' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Manjimup', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Western Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Manjimup', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Manjimup'
  and not exists (select 1 from public.appellations a
    where a.name = 'Manjimup' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Swan District', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Western Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Swan District', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Swan District'
  and not exists (select 1 from public.appellations a
    where a.name = 'Swan District' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Perth Hills', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Western Australia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Perth Hills', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Western Australia' and s.name = 'Perth Hills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Perth Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'New South Wales', 3 from public.countries c where c.name = 'Australia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Hunter Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'New South Wales'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hunter Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'New South Wales' and s.name = 'Hunter Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hunter Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mudgee', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'New South Wales'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mudgee', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'New South Wales' and s.name = 'Mudgee'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mudgee' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Orange', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'New South Wales'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Orange', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'New South Wales' and s.name = 'Orange'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orange' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Hilltops', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'New South Wales'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hilltops', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'New South Wales' and s.name = 'Hilltops'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hilltops' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Canberra District', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'New South Wales'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Canberra District', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'New South Wales' and s.name = 'Canberra District'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canberra District' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Riverina', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'New South Wales'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Riverina', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'New South Wales' and s.name = 'Riverina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Riverina' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tasmania', 4 from public.countries c where c.name = 'Australia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tasmania', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Tasmania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tasmania' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tamar Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Tasmania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tamar Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Tasmania' and s.name = 'Tamar Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tamar Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Coal River Valley', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Tasmania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coal River Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Tasmania' and s.name = 'Coal River Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coal River Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'East Coast', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Tasmania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'East Coast Tasmania', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Tasmania' and s.name = 'East Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'East Coast Tasmania' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Queensland', 5 from public.countries c where c.name = 'Australia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Granite Belt', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Queensland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Granite Belt', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Queensland' and s.name = 'Granite Belt'
  and not exists (select 1 from public.appellations a
    where a.name = 'Granite Belt' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'South Burnett', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Australia' and r.name = 'Queensland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'South Burnett', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Queensland' and s.name = 'South Burnett'
  and not exists (select 1 from public.appellations a
    where a.name = 'South Burnett' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Austria ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Austria', 'AT', 'Europe', 4)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Wein', 'Tafelwein', 0
from public.countries c where c.name = 'Austria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wein' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Niederösterreich', 0 from public.countries c where c.name = 'Austria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Niederösterreichischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich'
  and not exists (select 1 from public.appellations a
    where a.name = 'Niederösterreichischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wachau', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Wachau', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Wachau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wachau' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kremstal', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kremstal', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Kremstal'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kremstal' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kamptal', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kamptal', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Kamptal'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kamptal' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Traisental', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Traisental', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Traisental'
  and not exists (select 1 from public.appellations a
    where a.name = 'Traisental' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wagram', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Wagram', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Wagram'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wagram' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Weinviertel', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Weinviertel', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Weinviertel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Weinviertel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Carnuntum', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Carnuntum', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Carnuntum'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carnuntum' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Thermenregion', 7
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Niederösterreich'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Thermenregion', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Niederösterreich' and s.name = 'Thermenregion'
  and not exists (select 1 from public.appellations a
    where a.name = 'Thermenregion' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Wien', 1 from public.countries c where c.name = 'Austria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wiener Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Wien'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wiener Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wien', 'DAC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Wien'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wien' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Burgenland', 2 from public.countries c where c.name = 'Austria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Burgenländischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Burgenland'
  and not exists (select 1 from public.appellations a
    where a.name = 'Burgenländischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Neusiedlersee', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Burgenland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Neusiedlersee', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Burgenland' and s.name = 'Neusiedlersee'
  and not exists (select 1 from public.appellations a
    where a.name = 'Neusiedlersee' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Leithaberg', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Burgenland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Leithaberg', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Burgenland' and s.name = 'Leithaberg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Leithaberg' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Eisenberg', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Burgenland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Eisenberg', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Burgenland' and s.name = 'Eisenberg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Eisenberg' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rosalia', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Burgenland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rosalia', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Burgenland' and s.name = 'Rosalia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosalia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rust', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Burgenland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ruster Ausbruch', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Burgenland' and s.name = 'Rust'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ruster Ausbruch' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Steiermark', 3 from public.countries c where c.name = 'Austria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Steirischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Steiermark'
  and not exists (select 1 from public.appellations a
    where a.name = 'Steirischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Südsteiermark', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Steiermark'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Südsteiermark', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Steiermark' and s.name = 'Südsteiermark'
  and not exists (select 1 from public.appellations a
    where a.name = 'Südsteiermark' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Weststeiermark', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Steiermark'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Weststeiermark', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Steiermark' and s.name = 'Weststeiermark'
  and not exists (select 1 from public.appellations a
    where a.name = 'Weststeiermark' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vulkanland Steiermark', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Steiermark'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vulkanland Steiermark', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Steiermark' and s.name = 'Vulkanland Steiermark'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vulkanland Steiermark' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Azerbaijan ────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Azerbaijan', 'AZ', 'Asia', 5)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ganja-Gazakh', 0 from public.countries c where c.name = 'Azerbaijan'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Shamkhor / Tovuz', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Azerbaijan' and r.name = 'Ganja-Gazakh'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ganja-Gazakh', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Azerbaijan' and r.name = 'Ganja-Gazakh' and s.name = 'Shamkhor / Tovuz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ganja-Gazakh' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Shirvan', 1 from public.countries c where c.name = 'Azerbaijan'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Shamakhy / Goychay', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Azerbaijan' and r.name = 'Shirvan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Shirvan', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Azerbaijan' and r.name = 'Shirvan' and s.name = 'Shamakhy / Goychay'
  and not exists (select 1 from public.appellations a
    where a.name = 'Shirvan' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Belgium ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Belgium', 'BE', 'Europe', 6)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hageland', 0 from public.countries c where c.name = 'Belgium'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Flemish Brabant', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Belgium' and r.name = 'Hageland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hageland', 'AOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Belgium' and r.name = 'Hageland' and s.name = 'Flemish Brabant'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hageland' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Haspengouw', 1 from public.countries c where c.name = 'Belgium'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Limburg & Brabant', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Belgium' and r.name = 'Haspengouw'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haspengouw', 'AOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Belgium' and r.name = 'Haspengouw' and s.name = 'Limburg & Brabant'
  and not exists (select 1 from public.appellations a
    where a.name = 'Haspengouw' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Coteaux de Sambre-et-Meuse', 2 from public.countries c where c.name = 'Belgium'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Namur & Liege', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Belgium' and r.name = 'Coteaux de Sambre-et-Meuse'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Sambre-et-Meuse', 'AOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Belgium' and r.name = 'Coteaux de Sambre-et-Meuse' and s.name = 'Namur & Liege'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Sambre-et-Meuse' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Brazil ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Brazil', 'BR', 'Americas', 7)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rio Grande do Sul', 0 from public.countries c where c.name = 'Brazil'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Serra Gaucha', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Brazil' and r.name = 'Rio Grande do Sul'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vale dos Vinhedos', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Brazil' and r.name = 'Rio Grande do Sul' and s.name = 'Serra Gaucha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vale dos Vinhedos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pinto Bandeira', 'IP', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Brazil' and r.name = 'Rio Grande do Sul' and s.name = 'Serra Gaucha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pinto Bandeira' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Altos Montes', 'IP', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Brazil' and r.name = 'Rio Grande do Sul' and s.name = 'Serra Gaucha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Altos Montes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Campanha', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Brazil' and r.name = 'Rio Grande do Sul'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Campanha Gaucha', 'IP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Brazil' and r.name = 'Rio Grande do Sul' and s.name = 'Campanha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Campanha Gaucha' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Santa Catarina', 1 from public.countries c where c.name = 'Brazil'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Serra Catarinense', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Brazil' and r.name = 'Santa Catarina'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Planalto Catarinense', 'IP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Brazil' and r.name = 'Santa Catarina' and s.name = 'Serra Catarinense'
  and not exists (select 1 from public.appellations a
    where a.name = 'Planalto Catarinense' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Pernambuco / Bahia', 2 from public.countries c where c.name = 'Brazil'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vale do Sao Francisco', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Brazil' and r.name = 'Pernambuco / Bahia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vale do Sao Francisco', 'IP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Brazil' and r.name = 'Pernambuco / Bahia' and s.name = 'Vale do Sao Francisco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vale do Sao Francisco' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Bulgaria ──────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Bulgaria', 'BG', 'Europe', 8)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Dunav Plain', 0 from public.countries c where c.name = 'Bulgaria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Svishtov / Pleven', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Bulgaria' and r.name = 'Dunav Plain'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Danube Plain', 'DGO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Bulgaria' and r.name = 'Dunav Plain' and s.name = 'Svishtov / Pleven'
  and not exists (select 1 from public.appellations a
    where a.name = 'Danube Plain' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Thracian Valley', 1 from public.countries c where c.name = 'Bulgaria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Plovdiv / Stara Zagora', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Bulgaria' and r.name = 'Thracian Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Thracian Valley', 'DGO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Bulgaria' and r.name = 'Thracian Valley' and s.name = 'Plovdiv / Stara Zagora'
  and not exists (select 1 from public.appellations a
    where a.name = 'Thracian Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rose Valley', 2 from public.countries c where c.name = 'Bulgaria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sungurlare / Sliven', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Bulgaria' and r.name = 'Rose Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rose Valley', 'DGO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Bulgaria' and r.name = 'Rose Valley' and s.name = 'Sungurlare / Sliven'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rose Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Black Sea', 3 from public.countries c where c.name = 'Bulgaria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Shumen / Varna / Burgas', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Bulgaria' and r.name = 'Black Sea'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Black Sea', 'DGO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Bulgaria' and r.name = 'Black Sea' and s.name = 'Shumen / Varna / Burgas'
  and not exists (select 1 from public.appellations a
    where a.name = 'Black Sea' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Struma Valley', 4 from public.countries c where c.name = 'Bulgaria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Melnik', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Bulgaria' and r.name = 'Struma Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Struma Valley', 'DGO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Bulgaria' and r.name = 'Struma Valley' and s.name = 'Melnik'
  and not exists (select 1 from public.appellations a
    where a.name = 'Struma Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Canada ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Canada', 'CA', 'Americas', 9)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'British Columbia', 0 from public.countries c where c.name = 'Canada'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Okanagan Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'British Columbia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Okanagan Valley', 'VQA GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'British Columbia' and s.name = 'Okanagan Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Okanagan Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Naramata Bench', 'VQA GI', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'British Columbia' and s.name = 'Okanagan Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Naramata Bench' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Golden Mile Bench', 'VQA GI', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'British Columbia' and s.name = 'Okanagan Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Golden Mile Bench' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Similkameen Valley', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'British Columbia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Similkameen Valley', 'VQA GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'British Columbia' and s.name = 'Similkameen Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Similkameen Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Fraser Valley', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'British Columbia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fraser Valley', 'VQA GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'British Columbia' and s.name = 'Fraser Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fraser Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vancouver Island', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'British Columbia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vancouver Island', 'VQA GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'British Columbia' and s.name = 'Vancouver Island'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vancouver Island' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ontario', 1 from public.countries c where c.name = 'Canada'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Niagara Peninsula', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'Ontario'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Niagara Peninsula', 'VQA GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Ontario' and s.name = 'Niagara Peninsula'
  and not exists (select 1 from public.appellations a
    where a.name = 'Niagara Peninsula' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Niagara-on-the-Lake', 'VQA GI', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Ontario' and s.name = 'Niagara Peninsula'
  and not exists (select 1 from public.appellations a
    where a.name = 'Niagara-on-the-Lake' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beamsville Bench', 'VQA GI', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Ontario' and s.name = 'Niagara Peninsula'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beamsville Bench' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Twenty Mile Bench', 'VQA GI', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Ontario' and s.name = 'Niagara Peninsula'
  and not exists (select 1 from public.appellations a
    where a.name = 'Twenty Mile Bench' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Prince Edward County', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'Ontario'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Prince Edward County', 'VQA GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Ontario' and s.name = 'Prince Edward County'
  and not exists (select 1 from public.appellations a
    where a.name = 'Prince Edward County' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lake Erie North Shore', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'Ontario'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lake Erie North Shore', 'VQA GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Ontario' and s.name = 'Lake Erie North Shore'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lake Erie North Shore' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Quebec', 2 from public.countries c where c.name = 'Canada'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cantons de l''Est', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'Quebec'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cantons de l''Est', 'Appellation Quebec', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Quebec' and s.name = 'Cantons de l''Est'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cantons de l''Est' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Nova Scotia', 3 from public.countries c where c.name = 'Canada'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Annapolis Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'Nova Scotia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Annapolis Valley', 'Nova Scotia GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Nova Scotia' and s.name = 'Annapolis Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Annapolis Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gaspereau Valley', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'Nova Scotia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gaspereau Valley', 'Nova Scotia GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Nova Scotia' and s.name = 'Gaspereau Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gaspereau Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Chile ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Chile', 'CL', 'Americas', 10)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Atacama', 0 from public.countries c where c.name = 'Chile'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Copiapo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Atacama'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Copiapo', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Atacama' and s.name = 'Copiapo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Copiapo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Huasco', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Atacama'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Huasco', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Atacama' and s.name = 'Huasco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Huasco' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Coquimbo', 1 from public.countries c where c.name = 'Chile'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Elqui', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Coquimbo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Elqui', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Coquimbo' and s.name = 'Elqui'
  and not exists (select 1 from public.appellations a
    where a.name = 'Elqui' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Limari', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Coquimbo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Limari', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Coquimbo' and s.name = 'Limari'
  and not exists (select 1 from public.appellations a
    where a.name = 'Limari' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Choapa', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Coquimbo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Choapa', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Coquimbo' and s.name = 'Choapa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Choapa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Aconcagua', 2 from public.countries c where c.name = 'Chile'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aconcagua Wine', 'DO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Aconcagua'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aconcagua Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aconcagua', 'DO', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Aconcagua'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aconcagua' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Casablanca', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Aconcagua'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Casablanca', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Aconcagua' and s.name = 'Casablanca'
  and not exists (select 1 from public.appellations a
    where a.name = 'Casablanca' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'San Antonio', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Aconcagua'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'San Antonio', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Aconcagua' and s.name = 'San Antonio'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Antonio' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Leyda', 'DO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Aconcagua' and s.name = 'San Antonio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Leyda' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valle Central', 3 from public.countries c where c.name = 'Chile'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle Central Wine', 'DO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Valle Central'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle Central Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maipo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Valle Central'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maipo', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Valle Central' and s.name = 'Maipo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maipo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rapel', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Valle Central'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cachapoal', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Valle Central' and s.name = 'Rapel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cachapoal' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Colchagua', 'DO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Valle Central' and s.name = 'Rapel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colchagua' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Curico', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Valle Central'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Curico', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Valle Central' and s.name = 'Curico'
  and not exists (select 1 from public.appellations a
    where a.name = 'Curico' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maule', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Valle Central'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maule', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Valle Central' and s.name = 'Maule'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maule' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sur', 4 from public.countries c where c.name = 'Chile'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Itata', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Sur'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Itata', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Sur' and s.name = 'Itata'
  and not exists (select 1 from public.appellations a
    where a.name = 'Itata' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bio Bio', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Sur'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bio Bio', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Sur' and s.name = 'Bio Bio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bio Bio' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Malleco', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Sur'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Malleco', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Sur' and s.name = 'Malleco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malleco' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── China ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('China', 'CN', 'Asia', 11)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Xinjiang', 0 from public.countries c where c.name = 'China'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Turpan / Yili / Yanqi', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Xinjiang'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Xinjiang', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Xinjiang' and s.name = 'Turpan / Yili / Yanqi'
  and not exists (select 1 from public.appellations a
    where a.name = 'Xinjiang' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ningxia', 1 from public.countries c where c.name = 'China'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Helan Mountain East', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Ningxia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Helan Mountain East Foothills', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Ningxia' and s.name = 'Helan Mountain East'
  and not exists (select 1 from public.appellations a
    where a.name = 'Helan Mountain East Foothills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Shandong', 2 from public.countries c where c.name = 'China'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Penglai / Yantai', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Shandong'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Penglai', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Shandong' and s.name = 'Penglai / Yantai'
  and not exists (select 1 from public.appellations a
    where a.name = 'Penglai' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Changli', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Shandong'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Changli', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Shandong' and s.name = 'Changli'
  and not exists (select 1 from public.appellations a
    where a.name = 'Changli' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hebei', 3 from public.countries c where c.name = 'China'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Huailai / Changli', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Hebei'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Huailai', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Hebei' and s.name = 'Huailai / Changli'
  and not exists (select 1 from public.appellations a
    where a.name = 'Huailai' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Yunnan', 4 from public.countries c where c.name = 'China'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Shangri-La (Deqin)', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Yunnan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Shangri-La', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Yunnan' and s.name = 'Shangri-La (Deqin)'
  and not exists (select 1 from public.appellations a
    where a.name = 'Shangri-La' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mile', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Yunnan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mile', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Yunnan' and s.name = 'Mile'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mile' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Gansu', 5 from public.countries c where c.name = 'China'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Hexi Corridor', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Gansu'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hexi Corridor', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Gansu' and s.name = 'Hexi Corridor'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hexi Corridor' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Shanxi', 6 from public.countries c where c.name = 'China'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Taiyuan', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'China' and r.name = 'Shanxi'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Shanxi', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'China' and r.name = 'Shanxi' and s.name = 'Taiyuan'
  and not exists (select 1 from public.appellations a
    where a.name = 'Shanxi' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Croatia ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Croatia', 'HR', 'Europe', 12)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Primorska', 0 from public.countries c where c.name = 'Croatia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Istra', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Croatia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Istra', 'KPN', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Primorska' and s.name = 'Istra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Istra' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kvarner', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Croatia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kvarner', 'KPN', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Primorska' and s.name = 'Kvarner'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kvarner' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sjeverna Dalmacija', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Croatia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sjeverna Dalmacija', 'KPN', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Primorska' and s.name = 'Sjeverna Dalmacija'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sjeverna Dalmacija' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Srednja i Juzna Dalmacija', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Croatia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dingac', 'KPN', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Primorska' and s.name = 'Srednja i Juzna Dalmacija'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dingac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Postup', 'KPN', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Primorska' and s.name = 'Srednja i Juzna Dalmacija'
  and not exists (select 1 from public.appellations a
    where a.name = 'Postup' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Kontinentalna', 1 from public.countries c where c.name = 'Croatia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Slavonija', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Croatia' and r.name = 'Kontinentalna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Slavonija', 'KPN', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Kontinentalna' and s.name = 'Slavonija'
  and not exists (select 1 from public.appellations a
    where a.name = 'Slavonija' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Podunavlje', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Croatia' and r.name = 'Kontinentalna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Podunavlje', 'KPN', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Kontinentalna' and s.name = 'Podunavlje'
  and not exists (select 1 from public.appellations a
    where a.name = 'Podunavlje' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Plesivica', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Croatia' and r.name = 'Kontinentalna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Plesivica', 'KPN', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Croatia' and r.name = 'Kontinentalna' and s.name = 'Plesivica'
  and not exists (select 1 from public.appellations a
    where a.name = 'Plesivica' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Cyprus ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Cyprus', 'CY', 'Europe', 13)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Pafos', 0 from public.countries c where c.name = 'Cyprus'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pafos', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Pafos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pafos' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Laona Akamas', 'PDO', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Pafos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Laona Akamas' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vouni Panagias – Ampelitis', 'PDO', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Pafos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vouni Panagias – Ampelitis' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lemesos', 1 from public.countries c where c.name = 'Cyprus'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Commandaria', 'PDO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Lemesos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Commandaria' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Krasochoria Lemesou', 'PDO', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Lemesos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Krasochoria Lemesou' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lemesos', 'PGI', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Lemesos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lemesos' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Larnaka', 2 from public.countries c where c.name = 'Cyprus'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Larnaka', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Larnaka'
  and not exists (select 1 from public.appellations a
    where a.name = 'Larnaka' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lefkosia', 3 from public.countries c where c.name = 'Cyprus'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lefkosia', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Lefkosia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lefkosia' and a.level = 'region' and a.region_id = r.id);

-- ── Czech Republic ────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Czech Republic', 'CZ', 'Europe', 14)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Morava', 0 from public.countries c where c.name = 'Czech Republic'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Znojemska', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Czech Republic' and r.name = 'Morava'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Znojemska', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Czech Republic' and r.name = 'Morava' and s.name = 'Znojemska'
  and not exists (select 1 from public.appellations a
    where a.name = 'Znojemska' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mikulovska', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Czech Republic' and r.name = 'Morava'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mikulovska', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Czech Republic' and r.name = 'Morava' and s.name = 'Mikulovska'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mikulovska' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Velkopavlovicka', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Czech Republic' and r.name = 'Morava'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Velkopavlovicka', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Czech Republic' and r.name = 'Morava' and s.name = 'Velkopavlovicka'
  and not exists (select 1 from public.appellations a
    where a.name = 'Velkopavlovicka' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Slovacka', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Czech Republic' and r.name = 'Morava'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Slovacka', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Czech Republic' and r.name = 'Morava' and s.name = 'Slovacka'
  and not exists (select 1 from public.appellations a
    where a.name = 'Slovacka' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Cechy', 1 from public.countries c where c.name = 'Czech Republic'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Melnická', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Czech Republic' and r.name = 'Cechy'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Melnická', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Czech Republic' and r.name = 'Cechy' and s.name = 'Melnická'
  and not exists (select 1 from public.appellations a
    where a.name = 'Melnická' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Litomericka', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Czech Republic' and r.name = 'Cechy'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Litomericka', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Czech Republic' and r.name = 'Cechy' and s.name = 'Litomericka'
  and not exists (select 1 from public.appellations a
    where a.name = 'Litomericka' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Denmark ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Denmark', 'DK', 'Europe', 15)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sjælland', 0 from public.countries c where c.name = 'Denmark'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Jylland', 1 from public.countries c where c.name = 'Denmark'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Fyn', 2 from public.countries c where c.name = 'Denmark'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

-- ── England & Wales ───────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('England & Wales', 'GB', 'Europe', 16)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'English Wine', 'PGI', 0
from public.countries c where c.name = 'England & Wales'
  and not exists (select 1 from public.appellations a
    where a.name = 'English Wine' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sussex', 0 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'West & East Sussex', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'Sussex'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sussex', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'England & Wales' and r.name = 'Sussex' and s.name = 'West & East Sussex'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sussex' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Kent', 1 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hampshire', 2 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'East Anglia', 3 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Essex / Suffolk / Norfolk', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'East Anglia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Wales', 4 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Welsh Wine', 'PDO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'England & Wales' and r.name = 'Wales'
  and not exists (select 1 from public.appellations a
    where a.name = 'Welsh Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'South-West', 5 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cornwall & Devon', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'South-West'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

-- ── Ethiopia ──────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Ethiopia', 'ET', 'Africa', 17)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rift Valley', 0 from public.countries c where c.name = 'Ethiopia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ziway', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Ethiopia' and r.name = 'Rift Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ziway', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Ethiopia' and r.name = 'Rift Valley' and s.name = 'Ziway'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ziway' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── France ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('France', 'FR', 'Europe', 18)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vin de France', null, 0
from public.countries c where c.name = 'France'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin de France' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Bordeaux', 0 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bordeaux', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bordeaux' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bordeaux Superieur', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bordeaux Superieur' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Bordeaux', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Bordeaux' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant de Bordeaux', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant de Bordeaux' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Atlantique', 'IGP', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Atlantique' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Medoc', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Medoc', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Medoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haut-Medoc', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Haut-Medoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Estephe', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Estephe' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pauillac', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pauillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Julien', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Julien' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Listrac-Medoc', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Listrac-Medoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moulis-en-Medoc', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moulis-en-Medoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Margaux', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Margaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Graves', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Graves', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Graves'
  and not exists (select 1 from public.appellations a
    where a.name = 'Graves' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Graves Superieures', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Graves'
  and not exists (select 1 from public.appellations a
    where a.name = 'Graves Superieures' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pessac-Leognan', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Graves'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pessac-Leognan' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sauternes', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sauternes', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Sauternes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sauternes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Barsac', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Sauternes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barsac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cerons', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Sauternes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cerons' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Saint-Emilion', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Emilion', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Saint-Emilion'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Emilion' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Emilion Grand Cru', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Saint-Emilion'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Emilion Grand Cru' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montagne-Saint-Emilion', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Saint-Emilion'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montagne-Saint-Emilion' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Georges-Saint-Emilion', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Saint-Emilion'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Georges-Saint-Emilion' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lussac-Saint-Emilion', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Saint-Emilion'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lussac-Saint-Emilion' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Puisseguin-Saint-Emilion', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Saint-Emilion'
  and not exists (select 1 from public.appellations a
    where a.name = 'Puisseguin-Saint-Emilion' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pomerol', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pomerol', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Pomerol'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pomerol' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lalande-de-Pomerol', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Pomerol'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lalande-de-Pomerol' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Fronsac', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fronsac', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Fronsac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fronsac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Canon-Fronsac', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Fronsac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canon-Fronsac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bourg', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Bourg', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Bourg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Bourg' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Blaye', 7
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blaye', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Blaye'
  and not exists (select 1 from public.appellations a
    where a.name = 'Blaye' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Blaye', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Blaye'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Blaye' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Entre-Deux-Mers', 8
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Entre-Deux-Mers', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Entre-Deux-Mers' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Graves de Vayres', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Graves de Vayres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cadillac', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cadillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Loupiac', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Loupiac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sainte-Croix-du-Mont', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sainte-Croix-du-Mont' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Premieres Cotes de Bordeaux', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Premieres Cotes de Bordeaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sainte-Foy-Bordeaux', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sainte-Foy-Bordeaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Bordeaux Saint-Macaire', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Entre-Deux-Mers'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Bordeaux Saint-Macaire' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sud-Ouest', 1 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Comte Tolosan', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Comte Tolosan' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Gascogne', 'IGP', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Gascogne' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes du Tarn', 'IGP', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Tarn' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes du Lot', 'IGP', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Lot' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Perigord', 'IGP', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Perigord' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Landes', 'IGP', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Landes' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Agenais', 'IGP', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Agenais' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gers', 'IGP', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gers' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bergerac', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bergerac', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bergerac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Bergerac', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Bergerac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monbazillac', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monbazillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pecharmant', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pecharmant' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montravel', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montravel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Montravel', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Montravel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haut-Montravel', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Haut-Montravel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saussignac', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saussignac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rosette', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Bergerac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosette' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Garonne', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Duras', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Garonne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Duras' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Marmandais', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Garonne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Marmandais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Buzet', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Garonne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Buzet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Brulhois', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Garonne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brulhois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Sardos', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Garonne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Sardos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lot & Aveyron', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cahors', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Lot & Aveyron'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cahors' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Quercy', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Lot & Aveyron'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Quercy' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marcillac', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Lot & Aveyron'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marcillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Millau', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Lot & Aveyron'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Millau' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Entraygues et le Fel', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Lot & Aveyron'
  and not exists (select 1 from public.appellations a
    where a.name = 'Entraygues et le Fel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Estaing', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Lot & Aveyron'
  and not exists (select 1 from public.appellations a
    where a.name = 'Estaing' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gaillac & Fronton', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gaillac', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gaillac & Fronton'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gaillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gaillac Premieres Cotes', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gaillac & Fronton'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gaillac Premieres Cotes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fronton', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gaillac & Fronton'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fronton' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gascogne & Bearn', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Madiran', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Madiran' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pacherenc du Vic-Bilh', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pacherenc du Vic-Bilh' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bearn', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bearn' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Mont', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Mont' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tursan', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tursan' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Jurancon', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Jurancon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Irouleguy', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Irouleguy' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Floc de Gascogne', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Gascogne & Bearn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Floc de Gascogne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Bourgogne', 2 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgogne' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne Aligote', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgogne Aligote' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne Mousseux', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgogne Mousseux' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne Passe-Tout-Grains', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgogne Passe-Tout-Grains' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux Bourguignons', 'AOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux Bourguignons' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant de Bourgogne', 'AOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant de Bourgogne' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Chablis', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Petit Chablis', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Petit Chablis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chablis', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chablis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chablis Grand Cru', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chablis Grand Cru' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Irancy', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Irancy' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Bris', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Bris' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vezelay', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vezelay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Nuits', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marsannay', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marsannay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fixin', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fixin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gevrey-Chambertin', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gevrey-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Morey-Saint-Denis', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Morey-Saint-Denis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chambolle-Musigny', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chambolle-Musigny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vougeot', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vougeot' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vosne-Romanee', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vosne-Romanee' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nuits-Saint-Georges', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nuits-Saint-Georges' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Nuits-Villages', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote de Nuits-Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chambertin', 'Grand Cru', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chambertin-Clos de Beze', 'Grand Cru', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chambertin-Clos de Beze' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chapelle-Chambertin', 'Grand Cru', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chapelle-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Charmes-Chambertin', 'Grand Cru', 12
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Charmes-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Griotte-Chambertin', 'Grand Cru', 13
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Griotte-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Latricieres-Chambertin', 'Grand Cru', 14
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Latricieres-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mazis-Chambertin', 'Grand Cru', 15
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mazis-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mazoyeres-Chambertin', 'Grand Cru', 16
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mazoyeres-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ruchottes-Chambertin', 'Grand Cru', 17
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ruchottes-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos de la Roche', 'Grand Cru', 18
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clos de la Roche' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos des Lambrays', 'Grand Cru', 19
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clos des Lambrays' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos de Tart', 'Grand Cru', 20
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clos de Tart' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos Saint-Denis', 'Grand Cru', 21
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clos Saint-Denis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bonnes-Mares', 'Grand Cru', 22
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bonnes-Mares' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Musigny', 'Grand Cru', 23
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Musigny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos de Vougeot', 'Grand Cru', 24
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clos de Vougeot' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Echezeaux', 'Grand Cru', 25
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Echezeaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grands-Echezeaux', 'Grand Cru', 26
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grands-Echezeaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Grande Rue', 'Grand Cru', 27
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Grande Rue' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Romanee', 'Grand Cru', 28
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Romanee' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Tache', 'Grand Cru', 29
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Tache' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Richebourg', 'Grand Cru', 30
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Richebourg' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Romanee-Conti', 'Grand Cru', 31
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Romanee-Conti' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Romanee-Saint-Vivant', 'Grand Cru', 32
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Romanee-Saint-Vivant' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Beaune', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ladoix', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ladoix' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aloxe-Corton', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aloxe-Corton' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pernand-Vergelesses', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pernand-Vergelesses' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savigny-les-Beaune', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savigny-les-Beaune' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chorey-les-Beaune', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chorey-les-Beaune' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beaune', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beaune' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pommard', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pommard' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Volnay', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Volnay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monthelie', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monthelie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Auxey-Duresses', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Auxey-Duresses' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Romain', 'AOC', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Romain' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Meursault', 'AOC', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Meursault' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blagny', 'AOC', 12
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Blagny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Puligny-Montrachet', 'AOC', 13
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Puligny-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chassagne-Montrachet', 'AOC', 14
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chassagne-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Aubin', 'AOC', 15
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Aubin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Santenay', 'AOC', 16
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Santenay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maranges', 'AOC', 17
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maranges' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Beaune', 'AOC', 18
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote de Beaune' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Beaune-Villages', 'AOC', 19
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote de Beaune-Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corton', 'Grand Cru', 20
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Corton' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corton-Charlemagne', 'Grand Cru', 21
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Corton-Charlemagne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Charlemagne', 'Grand Cru', 22
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Charlemagne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montrachet', 'Grand Cru', 23
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chevalier-Montrachet', 'Grand Cru', 24
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chevalier-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Batard-Montrachet', 'Grand Cru', 25
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Batard-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bienvenues Batard-Montrachet', 'Grand Cru', 26
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bienvenues Batard-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Criots-Batard-Montrachet', 'Grand Cru', 27
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Criots-Batard-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote Chalonnaise', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bouzeron', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bouzeron' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rully', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rully' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mercurey', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mercurey' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Givry', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Givry' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montagny', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montagny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maconnais', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Macon', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Macon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Fuisse', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pouilly-Fuisse' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Loche', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pouilly-Loche' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Vinzelles', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pouilly-Vinzelles' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Veran', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Veran' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vire-Clesse', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vire-Clesse' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Beaujolais', 3 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beaujolais', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beaujolais' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Crus du Beaujolais', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Beaujolais'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Brouilly', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brouilly' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chenas', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chenas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chiroubles', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chiroubles' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Brouilly', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote de Brouilly' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fleurie', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fleurie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Julienas', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Julienas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Morgon', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Morgon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moulin-a-Vent', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moulin-a-Vent' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Regnie', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Regnie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Amour', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Crus du Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Amour' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lyonnais & Forez', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Beaujolais'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Lyonnais', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Lyonnais & Forez'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Lyonnais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Forez', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Lyonnais & Forez'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Forez' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote Roannaise', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Lyonnais & Forez'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote Roannaise' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Savoie & Jura', 4 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Franche-Comte', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Franche-Comte' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Jura', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Savoie & Jura'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Arbois', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Arbois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateau-Chalon', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chateau-Chalon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'L''Etoile', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'L''Etoile' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Jura', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Jura' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant du Jura', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant du Jura' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Macvin du Jura', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Macvin du Jura' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Savoie', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Savoie & Jura'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vin de Savoie', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Savoie'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin de Savoie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Roussette de Savoie', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Savoie'
  and not exists (select 1 from public.appellations a
    where a.name = 'Roussette de Savoie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Seyssel', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Savoie'
  and not exists (select 1 from public.appellations a
    where a.name = 'Seyssel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bugey', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Savoie & Jura'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bugey', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Bugey'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bugey' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Roussette du Bugey', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Bugey'
  and not exists (select 1 from public.appellations a
    where a.name = 'Roussette du Bugey' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Champagne', 5 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Champagne', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Champagne' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux Champenois', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux Champenois' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rose des Riceys', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rose des Riceys' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montagne de Reims', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vallee de la Marne', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote des Blancs', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Sezanne', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Aube (Cote des Bar)', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Alsace', 6 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alsace', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alsace' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant d''Alsace', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant d''Alsace' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alsace Grand Cru', 'Grand Cru', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alsace Grand Cru' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lorraine', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Alsace'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moselle', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace' and s.name = 'Lorraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moselle' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Toul', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace' and s.name = 'Lorraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Toul' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vallee de la Loire', 7 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant de Loire', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant de Loire' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rose de Loire', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rose de Loire' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val de Loire', 'IGP', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val de Loire' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pays Nantais', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee de la Loire'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscadet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet Sevre et Maine', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscadet Sevre et Maine' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet Coteaux de la Loire', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscadet Coteaux de la Loire' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet Cotes de Grandlieu', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscadet Cotes de Grandlieu' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gros Plant du Pays Nantais', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gros Plant du Pays Nantais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux d''Ancenis', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux d''Ancenis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fiefs Vendeens', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fiefs Vendeens' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Anjou-Saumur', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee de la Loire'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Anjou' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou Coteaux de la Loire', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Anjou Coteaux de la Loire' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou Villages', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Anjou Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou Villages Brissac', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Anjou Villages Brissac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savennieres', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savennieres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savennieres Coulee de Serrant', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savennieres Coulee de Serrant' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savennieres Roche aux Moines', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savennieres Roche aux Moines' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Layon', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Layon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de l''Aubance', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de l''Aubance' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bonnezeaux', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bonnezeaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Quarts de Chaume', 'AOC', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Quarts de Chaume' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rose d''Anjou', 'AOC', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rose d''Anjou' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cabernet d''Anjou', 'AOC', 12
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cabernet d''Anjou' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saumur', 'AOC', 13
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saumur' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saumur-Champigny', 'AOC', 14
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saumur-Champigny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Saumur', 'AOC', 15
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Saumur' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cabernet de Saumur', 'AOC', 16
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cabernet de Saumur' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Touraine', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee de la Loire'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Touraine', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Touraine' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Touraine Noble Joue', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Touraine Noble Joue' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vouvray', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vouvray' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montlouis-sur-Loire', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montlouis-sur-Loire' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chinon', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chinon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bourgueil', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgueil' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Nicolas-de-Bourgueil', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Nicolas-de-Bourgueil' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cheverny', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cheverny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cour-Cheverny', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cour-Cheverny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Jasnieres', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Jasnieres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Loir', 'AOC', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Loir' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Vendomois', 'AOC', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Vendomois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valencay', 'AOC', 12
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valencay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateaumeillant', 'AOC', 13
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chateaumeillant' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haut-Poitou', 'AOC', 14
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Haut-Poitou' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Orleans', 'AOC', 15
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orleans' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Orleans-Clery', 'AOC', 16
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orleans-Clery' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Centre-Loire', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee de la Loire'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sancerre', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sancerre' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Fume', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pouilly-Fume' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-sur-Loire', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pouilly-sur-Loire' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Menetou-Salon', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Menetou-Salon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Quincy', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Quincy' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Reuilly', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Reuilly' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Giennois', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Giennois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Auvergne', 8 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes d''Auvergne', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Auvergne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes d''Auvergne' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Saint-Pourcain', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Auvergne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Pourcain' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Correze', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Auvergne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Correze' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vallee du Rhone', 9 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes du Rhone', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Rhone' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mediterranee', 'IGP', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mediterranee' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Comtes Rhodaniens', 'IGP', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Comtes Rhodaniens' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collines Rhodaniennes', 'IGP', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Collines Rhodaniennes' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ardeche', 'IGP', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ardeche' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Drome', 'IGP', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Drome' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vaucluse', 'IGP', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vaucluse' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rhone Nord', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee du Rhone'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote-Rotie', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote-Rotie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Condrieu', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Condrieu' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateau-Grillet', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chateau-Grillet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Joseph', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Joseph' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Crozes-Hermitage', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Crozes-Hermitage' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hermitage', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hermitage' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cornas', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cornas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Peray', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Nord'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Peray' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rhone Sud', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee du Rhone'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateauneuf-du-Pape', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chateauneuf-du-Pape' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gigondas', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gigondas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vacqueyras', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vacqueyras' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vinsobres', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinsobres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beaumes de Venise', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beaumes de Venise' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Beaumes-de-Venise', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat de Beaumes-de-Venise' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rasteau', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rasteau' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lirac', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lirac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tavel', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tavel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Luberon', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Luberon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ventoux', 'AOC', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ventoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grignan-les-Adhemar', 'AOC', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grignan-les-Adhemar' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Vivarais', 'AOC', 12
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Vivarais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pierrevert', 'AOC', 13
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pierrevert' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Rhone Villages', 'AOC', 14
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Rhone Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cairanne', 'AOC', 15
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cairanne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Diois', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee du Rhone'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clairette de Die', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Diois'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clairette de Die' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant de Die', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Diois'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant de Die' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Die', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Diois'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Die' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chatillon-en-Diois', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Diois'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chatillon-en-Diois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Languedoc-Roussillon', 10 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pays d''Oc', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pays d''Oc' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pays d''Herault', 'IGP', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pays d''Herault' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes Catalanes', 'IGP', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes Catalanes' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cevennes', 'IGP', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cevennes' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gard', 'IGP', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gard' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cote Vermeille', 'IGP', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote Vermeille' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aude', 'IGP', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aude' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Languedoc', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Languedoc-Roussillon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Languedoc', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Languedoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clairette du Languedoc', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clairette du Languedoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clairette de Bellegarde', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Clairette de Bellegarde' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Picpoul de Pinet', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Picpoul de Pinet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cabardes', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cabardes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Malepere', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malepere' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Minervois', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Minervois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Minervois-La Liviniere', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Minervois-La Liviniere' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corbieres', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Corbieres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corbieres-Boutenac', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Corbieres-Boutenac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Chinian', 'AOC', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Chinian' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Faugeres', 'AOC', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Faugeres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fitou', 'AOC', 12
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fitou' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Limoux', 'AOC', 13
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Limoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant de Limoux', 'AOC', 14
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant de Limoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Costieres de Nimes', 'AOC', 15
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Costieres de Nimes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Duche d''Uzes', 'AOC', 16
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Duche d''Uzes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Frontignan', 'AOC', 17
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat de Frontignan' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Lunel', 'AOC', 18
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat de Lunel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Mireval', 'AOC', 19
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat de Mireval' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Saint-Jean-de-Minervois', 'AOC', 20
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat de Saint-Jean-de-Minervois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blanquette de Limoux', 'AOC', 21
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Blanquette de Limoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pic Saint-Loup', 'AOC', 22
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pic Saint-Loup' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Terrasses du Larzac', 'AOC', 23
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terrasses du Larzac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Clape', 'AOC', 24
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Clape' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montpeyroux', 'AOC', 25
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montpeyroux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sable de Camargue', 'AOC', 26
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sable de Camargue' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Roussillon', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Languedoc-Roussillon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Roussillon', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Roussillon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Roussillon Villages', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Roussillon Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Collioure', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Collioure' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Banyuls', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Banyuls' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Banyuls grand cru', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Banyuls grand cru' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maury', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maury' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rivesaltes', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rivesaltes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Rivesaltes', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat de Rivesaltes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grand Roussillon', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grand Roussillon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Provence', 11 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux d''Aix-en-Provence', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux d''Aix-en-Provence' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Les Baux de Provence', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Les Baux de Provence' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Provence', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Provence' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bandol', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bandol' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cassis', 'AOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cassis' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Palette', 'AOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Palette' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux Varois en Provence', 'AOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux Varois en Provence' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bellet', 'AOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bellet' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mediterranee', 'IGP', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mediterranee' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Var', 'IGP', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Var' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bouches-du-Rhone', 'IGP', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bouches-du-Rhone' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alpilles', 'IGP', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alpilles' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maures', 'IGP', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maures' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mont Caume', 'IGP', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mont Caume' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Corse', 12 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin de Corse', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin de Corse' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ajaccio', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ajaccio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Patrimonio', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Patrimonio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Muscat du Cap Corse', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat du Cap Corse' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ile de Beaute', 'IGP', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ile de Beaute' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Charentes', 13 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pineau des Charentes', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Charentes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pineau des Charentes' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Charentais', 'IGP', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Charentes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Charentais' and a.level = 'region' and a.region_id = r.id);

-- ── Georgia ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Georgia', 'GE', 'Europe', 19)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Kakheti', 0 from public.countries c where c.name = 'Georgia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alazani Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Georgia' and r.name = 'Kakheti'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tsinandali', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Kakheti' and s.name = 'Alazani Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tsinandali' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mukuzani', 'PDO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Kakheti' and s.name = 'Alazani Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mukuzani' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kindzmarauli', 'PDO', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Kakheti' and s.name = 'Alazani Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kindzmarauli' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Akhasheni', 'PDO', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Kakheti' and s.name = 'Alazani Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Akhasheni' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gurjaani', 'PDO', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Kakheti' and s.name = 'Alazani Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gurjaani' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Racha-Lechkhumi', 1 from public.countries c where c.name = 'Georgia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Racha', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Georgia' and r.name = 'Racha-Lechkhumi'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Khvanchkara', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Racha-Lechkhumi' and s.name = 'Racha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Khvanchkara' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Imereti', 2 from public.countries c where c.name = 'Georgia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Imereti', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Imereti'
  and not exists (select 1 from public.appellations a
    where a.name = 'Imereti' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Kartli', 3 from public.countries c where c.name = 'Georgia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kartli', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Kartli'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kartli' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Adjara', 4 from public.countries c where c.name = 'Georgia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Adjara', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Adjara'
  and not exists (select 1 from public.appellations a
    where a.name = 'Adjara' and a.level = 'region' and a.region_id = r.id);

-- ── Germany ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Germany', 'DE', 'Europe', 20)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Deutscher Wein', 'Tafelwein', 0
from public.countries c where c.name = 'Germany'
  and not exists (select 1 from public.appellations a
    where a.name = 'Deutscher Wein' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Mosel', 0 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Landwein der Mosel', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mosel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Landwein der Mosel' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mosel', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mosel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mosel' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mittelmosel', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Saar', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ruwer', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Terrassenmosel', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rheingau', 1 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheingauer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Rheingau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rheingauer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheingau', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Rheingau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rheingau' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rheinhessen', 2 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheinischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Rheinhessen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rheinischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheinhessen', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Rheinhessen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rheinhessen' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Pfalz', 3 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pfälzer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Pfalz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pfälzer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pfalz', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Pfalz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pfalz' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Nahe', 4 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nahegauer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Nahe'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nahegauer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nahe', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Nahe'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nahe' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Franken', 5 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fränkischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Franken'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fränkischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Franken', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Franken'
  and not exists (select 1 from public.appellations a
    where a.name = 'Franken' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Baden', 6 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Badischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Baden'
  and not exists (select 1 from public.appellations a
    where a.name = 'Badischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Baden', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Baden'
  and not exists (select 1 from public.appellations a
    where a.name = 'Baden' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kaiserstuhl', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Markgraflerland', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ortenau', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Breisgau', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Württemberg', 7 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Schwäbischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Württemberg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Schwäbischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Württemberg', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Württemberg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Württemberg' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Mittelrhein', 8 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mittelrhein', 'Anbaugebiet', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mittelrhein'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mittelrhein' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ahr', 9 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ahrer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Ahr'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ahrer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ahr', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Ahr'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ahr' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Saale-Unstrut', 10 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mitteldeutscher Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Saale-Unstrut'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mitteldeutscher Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Saale-Unstrut', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Saale-Unstrut'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saale-Unstrut' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sachsen', 11 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sächsischer Landwein', 'Landwein', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Sachsen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sächsischer Landwein' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sachsen', 'Anbaugebiet', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Sachsen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sachsen' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hessische Bergstrasse', 12 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hessische Bergstrasse', 'Anbaugebiet', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Hessische Bergstrasse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hessische Bergstrasse' and a.level = 'region' and a.region_id = r.id);

-- ── Greece ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Greece', 'GR', 'Europe', 21)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Makedonia', 0 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Naoussa', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Makedonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Naoussa', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Makedonia' and s.name = 'Naoussa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Naoussa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Amyndeon', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Makedonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Amyndeon', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Makedonia' and s.name = 'Amyndeon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Amyndeon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Goumenissa', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Makedonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Goumenissa', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Makedonia' and s.name = 'Goumenissa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Goumenissa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Halkidiki', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Makedonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Meliton', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Makedonia' and s.name = 'Halkidiki'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Meliton' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ipeiros', 1 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ioannina', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Ipeiros'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zitsa', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Ipeiros' and s.name = 'Ioannina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zitsa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Thessalia', 2 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Larissa', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Thessalia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rapsani', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Thessalia' and s.name = 'Larissa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rapsani' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Volos', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Thessalia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anchialos', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Thessalia' and s.name = 'Volos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Anchialos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Attiki', 3 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Savatiano', 'PDO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Attiki'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savatiano' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Peloponnisos', 4 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Korinthia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Peloponnisos'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nemea', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Peloponnisos' and s.name = 'Korinthia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nemea' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Arkadia', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Peloponnisos'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mantinia', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Peloponnisos' and s.name = 'Arkadia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mantinia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Achaia', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Peloponnisos'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Patras', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Peloponnisos' and s.name = 'Achaia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Patras' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mavrodaphne of Patras', 'PDO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Peloponnisos' and s.name = 'Achaia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mavrodaphne of Patras' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Nisia Aigaiou', 5 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Santorini', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Nisia Aigaiou'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Santorini', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Nisia Aigaiou' and s.name = 'Santorini'
  and not exists (select 1 from public.appellations a
    where a.name = 'Santorini' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Limnos', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Nisia Aigaiou'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat of Limnos', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Nisia Aigaiou' and s.name = 'Limnos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat of Limnos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rodos', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Nisia Aigaiou'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rodos', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Nisia Aigaiou' and s.name = 'Rodos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rodos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Samos', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Nisia Aigaiou'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat of Samos', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Nisia Aigaiou' and s.name = 'Samos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat of Samos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ionia Nisia', 6 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kefalonia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Ionia Nisia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Robola of Cephalonia', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Ionia Nisia' and s.name = 'Kefalonia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Robola of Cephalonia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mavrodaphne of Cephalonia', 'PDO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Ionia Nisia' and s.name = 'Kefalonia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mavrodaphne of Cephalonia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lefkada', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Ionia Nisia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lefkada', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Ionia Nisia' and s.name = 'Lefkada'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lefkada' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Kriti', 7 from public.countries c where c.name = 'Greece'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Iraklio', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Kriti'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Archanes', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Kriti' and s.name = 'Iraklio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Archanes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Peza', 'PDO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Kriti' and s.name = 'Iraklio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Peza' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dafnes', 'PDO', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Kriti' and s.name = 'Iraklio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dafnes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lasithi', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Kriti'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sitia', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Kriti' and s.name = 'Lasithi'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sitia' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Hungary ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Hungary', 'HU', 'Europe', 22)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tokaj-Hegyalja', 0 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tokaj', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Tokaj-Hegyalja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tokaj', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Tokaj-Hegyalja' and s.name = 'Tokaj'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tokaj' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Eger', 1 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Egri Bikaver', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Eger'
  and not exists (select 1 from public.appellations a
    where a.name = 'Egri Bikaver' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Villany', 2 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Villany', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Villany'
  and not exists (select 1 from public.appellations a
    where a.name = 'Villany' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Szekszard', 3 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Szekszard', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Szekszard'
  and not exists (select 1 from public.appellations a
    where a.name = 'Szekszard' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Somlo', 4 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Somlo', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Somlo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Somlo' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Badacsony', 5 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Badacsony', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Badacsony'
  and not exists (select 1 from public.appellations a
    where a.name = 'Badacsony' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Balatonfured-Csopak', 6 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Balatonfured-Csopak', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Balatonfured-Csopak'
  and not exists (select 1 from public.appellations a
    where a.name = 'Balatonfured-Csopak' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Matra', 7 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Matra', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Matra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Matra' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Etyek-Buda', 8 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Etyek-Buda', 'OEM', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Etyek-Buda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Etyek-Buda' and a.level = 'region' and a.region_id = r.id);

-- ── India ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('India', 'IN', 'Asia', 23)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Maharashtra', 0 from public.countries c where c.name = 'India'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Nashik', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'India' and r.name = 'Maharashtra'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nashik', 'State GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'India' and r.name = 'Maharashtra' and s.name = 'Nashik'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nashik' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sangli / Baramati', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'India' and r.name = 'Maharashtra'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sangli', 'State GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'India' and r.name = 'Maharashtra' and s.name = 'Sangli / Baramati'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sangli' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Karnataka', 1 from public.countries c where c.name = 'India'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Nandi Hills', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'India' and r.name = 'Karnataka'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nandi Hills', 'State GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'India' and r.name = 'Karnataka' and s.name = 'Nandi Hills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nandi Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Himachal Pradesh', 2 from public.countries c where c.name = 'India'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kullu Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'India' and r.name = 'Himachal Pradesh'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kullu', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'India' and r.name = 'Himachal Pradesh' and s.name = 'Kullu Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kullu' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Israel ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Israel', 'IL', 'Asia', 24)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Galil', 0 from public.countries c where c.name = 'Israel'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Upper Galilee / Golan Heights', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Israel' and r.name = 'Galil'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Galil', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Israel' and r.name = 'Galil' and s.name = 'Upper Galilee / Golan Heights'
  and not exists (select 1 from public.appellations a
    where a.name = 'Galil' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Shomron', 1 from public.countries c where c.name = 'Israel'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Carmel slopes', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Israel' and r.name = 'Shomron'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Shomron', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Israel' and r.name = 'Shomron' and s.name = 'Carmel slopes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Shomron' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Shimshon', 2 from public.countries c where c.name = 'Israel'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Judean foothills', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Israel' and r.name = 'Shimshon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Shimshon', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Israel' and r.name = 'Shimshon' and s.name = 'Judean foothills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Shimshon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Negev', 3 from public.countries c where c.name = 'Israel'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ramat Arad / Mitzpe Ramon', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Israel' and r.name = 'Negev'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Negev', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Israel' and r.name = 'Negev' and s.name = 'Ramat Arad / Mitzpe Ramon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Negev' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Judean Hills', 4 from public.countries c where c.name = 'Israel'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Jerusalem mountains', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Israel' and r.name = 'Judean Hills'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Judean Hills', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Israel' and r.name = 'Judean Hills' and s.name = 'Jerusalem mountains'
  and not exists (select 1 from public.appellations a
    where a.name = 'Judean Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Italy ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Italy', 'IT', 'Europe', 25)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Piemonte', 0 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alba', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Albugnano', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Albugnano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alta Langa', 'DOCG', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alta Langa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Asti', 'DOCG', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Asti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbaresco', 'DOCG', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbaresco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera d''Alba', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbera d''Alba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera d''Asti', 'DOCG', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbera d''Asti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera del Monferrato', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbera del Monferrato' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera del Monferrato Superiore', 'DOCG', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbera del Monferrato Superiore' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barolo', 'DOCG', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barolo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Boca', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Boca' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Brachetto d''Acqui Acqui', 'DOCG', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brachetto d''Acqui Acqui' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bramaterra', 'DOC', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bramaterra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calosso', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calosso' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canavese', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canavese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canelli', 'DOCG', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canelli' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carema', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carema' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cisterna d''Asti', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cisterna d''Asti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Tortonesi', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Tortonesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collina Torinese', 'DOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Collina Torinese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Novaresi', 'DOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colline Novaresi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Saluzzesi', 'DOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colline Saluzzesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cortese dell''Alto Monferrato', 'DOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cortese dell''Alto Monferrato' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coste della Sesia', 'DOC', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coste della Sesia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dogliani', 'DOCG', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dogliani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto d''Acqui', 'DOC', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolcetto d''Acqui' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto d''Alba', 'DOC', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolcetto d''Alba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto d''Asti', 'DOC', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolcetto d''Asti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto di Diano d''Alba', 'DOCG', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolcetto di Diano d''Alba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto di Ovada', 'DOC', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolcetto di Ovada' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto di Ovada Superiore', 'DOCG', 30
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolcetto di Ovada Superiore' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Erbaluce di Caluso', 'DOCG', 31
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Erbaluce di Caluso' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fara', 'DOC', 32
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Freisa d''Asti', 'DOC', 33
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Freisa d''Asti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Freisa di Chieri', 'DOC', 34
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Freisa di Chieri' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gabiano', 'DOC', 35
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gabiano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gattinara', 'DOCG', 36
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gattinara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gavi', 'DOCG', 37
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gavi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ghemme', 'DOCG', 38
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ghemme' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grignolino d''Asti', 'DOC', 39
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grignolino d''Asti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grignolino del Monferrato Casalese', 'DOC', 40
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grignolino del Monferrato Casalese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Langhe', 'DOC', 41
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Langhe' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lessona', 'DOC', 42
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lessona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Loazzolo', 'DOC', 43
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Loazzolo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia di Casorzo', 'DOC', 44
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malvasia di Casorzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia di Castelnuovo Don Bosco', 'DOC', 45
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malvasia di Castelnuovo Don Bosco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monferrato', 'DOC', 46
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monferrato' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nebbiolo d''Alba', 'DOC', 47
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nebbiolo d''Alba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nizza', 'DOCG', 48
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nizza' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piemonte', 'DOC', 49
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Piemonte' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pinerolese', 'DOC', 50
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pinerolese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Roero', 'DOCG', 51
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Roero' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rubino di Cantavenna', 'DOC', 52
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rubino di Cantavenna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ruche di Castagnole Monferrato', 'DOCG', 53
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ruche di Castagnole Monferrato' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sizzano', 'DOC', 54
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sizzano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Strevi', 'DOC', 55
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Strevi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Alfieri', 'DOCG', 56
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre Alfieri' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valli Ossolane', 'DOC', 57
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valli Ossolane' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valsusa', 'DOC', 58
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valsusa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verduno Pelaverga', 'DOC', 59
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verduno Pelaverga' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valle d''Aosta', 1 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle d''Aosta Vallee d''Aoste', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Valle d''Aosta'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle d''Aosta Vallee d''Aoste' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lombardia', 2 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alpi Retiche', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alpi Retiche' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alto Mincio', 'IGT', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alto Mincio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Benaco Bresciano', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Benaco Bresciano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bergamasca', 'IGT', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bergamasca' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bonarda dell''Oltrepo Pavese', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bonarda dell''Oltrepo Pavese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Botticino', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Botticino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Buttafuoco dell''Oltrepo Pavese', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Buttafuoco dell''Oltrepo Pavese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Capriano del Colle', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Capriano del Colle' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casteggio', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Casteggio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cellatica', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cellatica' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collina del Milanese', 'IGT', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Collina del Milanese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Curtefranca', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Curtefranca' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Franciacorta', 'DOCG', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Franciacorta' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Garda', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Garda' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Garda Colli Mantovani', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Garda Colli Mantovani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco Mantovano', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lambrusco Mantovano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lugana', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lugana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montenetto di Brescia', 'IGT', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montenetto di Brescia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Scanzo', 'DOCG', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscato di Scanzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oltrepo Pavese', 'DOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Oltrepo Pavese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oltrepo Pavese metodo classico', 'DOCG', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Oltrepo Pavese metodo classico' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oltrepo Pavese Pinot grigio', 'DOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Oltrepo Pavese Pinot grigio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pinot nero dell''Oltrepo Pavese', 'DOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pinot nero dell''Oltrepo Pavese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Provincia di Mantova', 'IGT', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Provincia di Mantova' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Provincia di Pavia', 'IGT', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Provincia di Pavia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Quistello', 'IGT', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Quistello' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riviera del Garda Classico', 'DOC', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Riviera del Garda Classico' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ronchi di Brescia', 'IGT', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ronchi di Brescia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ronchi Varesini', 'IGT', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ronchi Varesini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Valtellina', 'DOC', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso di Valtellina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sabbioneta', 'IGT', 30
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sabbioneta' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Colombano al Lambro', 'DOC', 31
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Colombano al Lambro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Martino della Battaglia', 'DOC', 32
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Martino della Battaglia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sangue di Giuda dell''Oltrepo Pavese', 'DOC', 33
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sangue di Giuda dell''Oltrepo Pavese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sebino', 'IGT', 34
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sebino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sforzato di Valtellina', 'DOCG', 35
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sforzato di Valtellina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre del Colleoni', 'DOC', 36
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre del Colleoni' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Lariane', 'IGT', 37
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre Lariane' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valcalepio', 'DOC', 38
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valcalepio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valcamonica', 'IGT', 39
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valcamonica' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valtellina Superiore', 'DOCG', 40
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valtellina Superiore' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Trentino-Alto Adige', 3 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alto Adige', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alto Adige' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casteller', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Casteller' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lago di Caldaro', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lago di Caldaro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mitterberg', 'IGT', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mitterberg' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Teroldego Rotaliano', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Teroldego Rotaliano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trentino', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trentino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trento', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trento' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdadige', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valdadige' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdadige Terradeiforti', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valdadige Terradeiforti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vallagarina', 'IGT', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vallagarina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vigneti delle Dolomiti', 'IGT', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vigneti delle Dolomiti' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Veneto', 4 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Amarone della Valpolicella', 'DOCG', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Amarone della Valpolicella' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arcole', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Arcole' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Asolo Montello', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Asolo Montello' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Asolo Prosecco', 'DOCG', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Asolo Prosecco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bagnoli di Sopra', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bagnoli di Sopra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bagnoli Friularo', 'DOCG', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bagnoli Friularo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bardolino', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bardolino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bardolino Superiore', 'DOCG', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bardolino Superiore' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Breganze', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Breganze' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Berici', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Berici' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Conegliano', 'DOCG', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli di Conegliano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Euganei', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Euganei' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Euganei Fior d''Arancio', 'DOCG', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Euganei Fior d''Arancio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Trevigiani', 'IGT', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Trevigiani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Conegliano Valdobbiadene Prosecco', 'DOCG', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Conegliano Valdobbiadene Prosecco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Conselvano', 'IGT', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Conselvano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Corti Benedettine del Padovano', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Corti Benedettine del Padovano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Custoza', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Custoza' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gambellara', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gambellara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lessini Durello', 'DOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lessini Durello' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marca Trevigiana', 'IGT', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marca Trevigiana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Merlara', 'DOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Merlara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montello Rosso', 'DOCG', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montello Rosso' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monti Lessini', 'DOC', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monti Lessini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piave', 'DOC', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Piave' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piave Malanotte', 'DOCG', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Piave Malanotte' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Recioto della Valpolicella', 'DOCG', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Recioto della Valpolicella' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Recioto di Gambellara', 'DOCG', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Recioto di Gambellara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Recioto di Soave', 'DOCG', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Recioto di Soave' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riviera del Brenta', 'DOC', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Riviera del Brenta' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Soave', 'DOC', 30
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Soave' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Soave Superiore', 'DOCG', 31
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Soave Superiore' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valpolicella', 'DOC', 32
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valpolicella' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valpolicella Ripasso', 'DOC', 33
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valpolicella Ripasso' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Veneto', 'IGT', 34
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Veneto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Veneto Orientale', 'IGT', 35
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Veneto Orientale' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Venezia', 'DOC', 36
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Venezia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verona', 'IGT', 37
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vicenza', 'DOC', 38
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vicenza' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vigneti della Serenissima', 'DOC', 39
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vigneti della Serenissima' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Friuli-Venezia Giulia', 5 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alto Livenza', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alto Livenza' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carso', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carso' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Orientali del Friuli Picolit', 'DOCG', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Orientali del Friuli Picolit' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collio Goriziano', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Collio Goriziano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'delle Venezie', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'delle Venezie' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Annia', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Annia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Aquileia', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Aquileia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Colli Orientali', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Colli Orientali' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Grave', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Grave' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Isonzo', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Isonzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Latisana', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Latisana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lison', 'DOCG', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lison' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lison-Pramaggiore', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lison-Pramaggiore' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Prosecco', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Prosecco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ramandolo', 'DOCG', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ramandolo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosazzo', 'DOCG', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosazzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trevenezie', 'IGT', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trevenezie' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Venezia Giulia', 'IGT', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Venezia Giulia' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Liguria', 6 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cinque Terre', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cinque Terre' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Luni', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli di Luni' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline del Genovesato', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colline del Genovesato' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline di Levanto', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colline di Levanto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Savonesi', 'IGT', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colline Savonesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Golfo del Tigullio - Portofino', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Golfo del Tigullio - Portofino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Liguria di Levante', 'IGT', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Liguria di Levante' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ormeasco di Pornassio', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ormeasco di Pornassio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riviera Ligure di Ponente', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Riviera Ligure di Ponente' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rossese di Dolceacqua', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rossese di Dolceacqua' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terrazze dell''Imperiese', 'IGT', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terrazze dell''Imperiese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val Polcevera', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val Polcevera' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Emilia-Romagna', 7 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bosco Eliceo', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bosco Eliceo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castelfranco Emilia', 'IGT', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castelfranco Emilia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Bolognesi', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Bolognesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Bolognesi Pignoletto', 'DOCG', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Bolognesi Pignoletto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli d''Imola', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli d''Imola' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Faenza', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli di Faenza' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Parma', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli di Parma' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Scandiano e di Canossa', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli di Scandiano e di Canossa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Piacentini', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Piacentini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Romagna centrale', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Romagna centrale' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Emilia dell''Emilia', 'IGT', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Emilia dell''Emilia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Emilia-Romagna', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Emilia-Romagna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Forli', 'IGT', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Forli' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fortana del Taro', 'IGT', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fortana del Taro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gutturnio', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gutturnio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco di Sorbara', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lambrusco di Sorbara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco Grasparossa di Castelvetro', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lambrusco Grasparossa di Castelvetro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco Salamino di Santa Croce', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lambrusco Salamino di Santa Croce' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Modena', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Modena' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ortrugo dei Colli Piacentini', 'DOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ortrugo dei Colli Piacentini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ravenna', 'IGT', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ravenna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Reggiano', 'DOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Reggiano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Reno', 'DOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Reno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rimini', 'DOC', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rimini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Romagna', 'DOC', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Romagna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Romagna Albana', 'DOCG', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Romagna Albana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rubicone', 'IGT', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rubicone' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sillaro', 'IGT', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sillaro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Veleja', 'IGT', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre di Veleja' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val Tidone', 'IGT', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val Tidone' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Toscana', 8 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alta Valle della Greve', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alta Valle della Greve' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ansonica Costa dell''Argentario', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ansonica Costa dell''Argentario' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barco Reale di Carmignano', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barco Reale di Carmignano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco dell''Empolese', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bianco dell''Empolese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco di Pitigliano', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bianco di Pitigliano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bolgheri', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bolgheri' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bolgheri Sassicaia', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bolgheri Sassicaia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Brunello di Montalcino', 'DOCG', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brunello di Montalcino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Candia dei Colli Apuani', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Candia dei Colli Apuani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Capalbio', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Capalbio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carmignano', 'DOCG', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carmignano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chianti', 'DOCG', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chianti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chianti Classico', 'DOCG', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chianti Classico' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli dell''Etruria Centrale', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli dell''Etruria Centrale' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli della Toscana centrale', 'IGT', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli della Toscana centrale' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Lucchesi', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colline Lucchesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cortona', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cortona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa Toscana', 'IGT', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Costa Toscana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elba', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Elba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elba Aleatico Passito', 'DOCG', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Elba Aleatico Passito' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grance Senesi', 'DOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grance Senesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maremma toscana', 'DOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maremma toscana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecarlo', 'DOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montecarlo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecastelli', 'IGT', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montecastelli' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecucco', 'DOC', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montecucco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecucco Sangiovese', 'DOCG', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montecucco Sangiovese' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monteregio di Massa Marittima', 'DOC', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monteregio di Massa Marittima' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montescudaio', 'DOC', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montescudaio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Morellino di Scansano', 'DOCG', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Morellino di Scansano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscadello di Montalcino', 'DOC', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscadello di Montalcino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Orcia', 'DOC', 30
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orcia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Parrina', 'DOC', 31
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Parrina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pomino', 'DOC', 32
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pomino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Montalcino', 'DOC', 33
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso di Montalcino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Montepulciano', 'DOC', 34
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso di Montepulciano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Gimignano', 'DOC', 35
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Gimignano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Torpe', 'DOC', 36
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Torpe' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sant''Antimo', 'DOC', 37
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sant''Antimo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sovana', 'DOC', 38
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sovana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Suvereto', 'DOCG', 39
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Suvereto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terratico di Bibbona', 'DOC', 40
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terratico di Bibbona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Casole', 'DOC', 41
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre di Casole' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Pisa', 'DOC', 42
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre di Pisa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Toscano Toscana', 'IGT', 43
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Toscano Toscana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val d''Arbia', 'DOC', 44
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val d''Arbia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val d''Arno di Sopra', 'DOC', 45
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val d''Arno di Sopra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Cornia', 'DOC', 46
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val di Cornia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Cornia Rosso', 'DOCG', 47
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val di Cornia Rosso' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Magra', 'IGT', 48
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val di Magra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdichiana toscana', 'DOC', 49
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valdichiana toscana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdinievole', 'DOC', 50
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valdinievole' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vernaccia di San Gimignano', 'DOCG', 51
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vernaccia di San Gimignano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo del Chianti', 'DOC', 52
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin Santo del Chianti' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo del Chianti Classico', 'DOC', 53
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin Santo del Chianti Classico' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo di Carmignano', 'DOC', 54
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin Santo di Carmignano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo di Montepulciano', 'DOC', 55
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin Santo di Montepulciano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vino Nobile di Montepulciano', 'DOCG', 56
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino Nobile di Montepulciano' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Umbria', 9 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Allerona', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Allerona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Amelia', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Amelia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Assisi', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Assisi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bettona', 'IGT', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bettona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cannara', 'IGT', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cannara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Altotiberini', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Altotiberini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli del Trasimeno', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli del Trasimeno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Martani', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Martani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Perugini', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Perugini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lago di Corbara', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lago di Corbara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montefalco', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montefalco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montefalco Sagrantino', 'DOCG', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montefalco Sagrantino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Narni', 'IGT', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Narni' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso Orvietano', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso Orvietano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Spello', 'IGT', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Spello' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Spoleto', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Spoleto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Todi', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Todi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Torgiano', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Torgiano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Torgiano Rosso Riserva', 'DOCG', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Torgiano Rosso Riserva' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Umbria', 'IGT', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Umbria' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Marche', 10 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianchello del Metauro', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bianchello del Metauro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castelli di Jesi Verdicchio Riserva', 'DOCG', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castelli di Jesi Verdicchio Riserva' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Maceratesi', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Maceratesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Pesaresi', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Pesaresi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Conero', 'DOCG', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Conero' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Esino', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Esino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Falerio', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Falerio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'I Terreni di Sanseverino', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'I Terreni di Sanseverino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lacrima di Morro d''Alba', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lacrima di Morro d''Alba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marche', 'IGT', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marche' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Offida', 'DOCG', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Offida' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pergola', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pergola' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso Conero', 'DOC', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso Conero' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso Piceno', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso Piceno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Ginesio', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Ginesio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Serrapetrona', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Serrapetrona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Offida', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre di Offida' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verdicchio dei Castelli di Jesi', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verdicchio dei Castelli di Jesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verdicchio di Matelica', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verdicchio di Matelica' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verdicchio di Matelica Riserva', 'DOCG', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verdicchio di Matelica Riserva' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vernaccia di Serrapetrona', 'DOCG', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vernaccia di Serrapetrona' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lazio', 11 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aleatico di Gradoli', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aleatico di Gradoli' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Anagni', 'IGT', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Anagni' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aprilia', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aprilia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Atina', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Atina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco Capena', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bianco Capena' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cannellino di Frascati', 'DOCG', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cannellino di Frascati' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castelli Romani', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castelli Romani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cerveteri', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cerveteri' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cesanese del Piglio', 'DOCG', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cesanese del Piglio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cesanese di Affile', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cesanese di Affile' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cesanese di Olevano Romano', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cesanese di Olevano Romano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Circeo', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Circeo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Civitella d''Agliano', 'IGT', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Civitella d''Agliano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Albani', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Albani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Cimini', 'IGT', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Cimini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli della Sabina', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli della Sabina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Etruschi Viterbesi', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Etruschi Viterbesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Lanuvini', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Lanuvini' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cori', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cori' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa Etrusco Romana', 'IGT', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Costa Etrusco Romana' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Est! Est!! Est!!! di Montefiascone', 'DOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Est! Est!! Est!!! di Montefiascone' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Frascati', 'DOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Frascati' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Frascati Superiore', 'DOCG', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Frascati Superiore' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Frusinate', 'IGT', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Frusinate' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Genazzano', 'DOC', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Genazzano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lazio', 'IGT', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lazio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marino', 'DOC', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecompatri Colonna', 'DOC', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montecompatri Colonna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Terracina', 'DOC', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscato di Terracina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nettuno', 'DOC', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nettuno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Orvieto', 'DOC', 30
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orvieto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Roma', 'DOC', 31
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Roma' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tarquinia', 'DOC', 32
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tarquinia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Velletri', 'DOC', 33
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Velletri' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vignanello', 'DOC', 34
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vignanello' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zagarolo', 'DOC', 35
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zagarolo' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Abruzzo', 12 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Abruzzo', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Abruzzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casauria', 'DOCG', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Casauria' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cerasuolo d''Abruzzo', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cerasuolo d''Abruzzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Controguerra', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Controguerra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montepulciano d''Abruzzo', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montepulciano d''Abruzzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montepulciano d''Abruzzo Colline Teramane', 'DOCG', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montepulciano d''Abruzzo Colline Teramane' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ortona', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ortona' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Abruzzesi', 'IGT', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre Abruzzesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Aquilane', 'IGT', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre Aquilane' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Tollesi Tullum', 'DOCG', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre Tollesi Tullum' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trebbiano d''Abruzzo', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trebbiano d''Abruzzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Villamagna', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Villamagna' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Molise', 13 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Biferno', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Molise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Biferno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Molise', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Molise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Molise' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Osco Terre degli Osci', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Molise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Osco Terre degli Osci' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pentro di Isernia', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Molise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pentro di Isernia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rotae', 'IGT', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Molise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rotae' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tintilia del Molise', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Molise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tintilia del Molise' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Campania', 14 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aglianico del Taburno', 'DOCG', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aglianico del Taburno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aversa', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aversa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Benevento Beneventano', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Benevento Beneventano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campania', 'IGT', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Campania' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campi Flegrei', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Campi Flegrei' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Capri', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Capri' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casavecchia di Pontelatone', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Casavecchia di Pontelatone' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel San Lorenzo', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castel San Lorenzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Catalanesca del Monte Somma', 'IGT', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Catalanesca del Monte Somma' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cilento', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cilento' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Salerno', 'IGT', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli di Salerno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa d''Amalfi', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Costa d''Amalfi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dugenta', 'IGT', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dugenta' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Epomeo', 'IGT', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Epomeo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Falanghina del Sannio', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Falanghina del Sannio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Falerno del Massico', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Falerno del Massico' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fiano di Avellino', 'DOCG', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fiano di Avellino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Galluccio', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Galluccio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Greco di Tufo', 'DOCG', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Greco di Tufo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Irpinia', 'DOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Irpinia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ischia', 'DOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ischia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paestum', 'IGT', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Paestum' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Penisola Sorrentina', 'DOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Penisola Sorrentina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pompeiano', 'IGT', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pompeiano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Roccamonfina', 'IGT', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Roccamonfina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sannio', 'DOC', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sannio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Taurasi', 'DOCG', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Taurasi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre del Volturno', 'IGT', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre del Volturno' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vesuvio', 'DOC', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vesuvio' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Basilicata', 15 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aglianico del Vulture', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aglianico del Vulture' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aglianico del Vulture Superiore', 'DOCG', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aglianico del Vulture Superiore' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Basilicata', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata'
  and not exists (select 1 from public.appellations a
    where a.name = 'Basilicata' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grottino di Roccanova', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grottino di Roccanova' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Matera', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata'
  and not exists (select 1 from public.appellations a
    where a.name = 'Matera' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre dell''Alta Val d''Agri', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre dell''Alta Val d''Agri' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Calabria', 16 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arghilla', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Arghilla' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bivongi', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bivongi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calabria', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calabria' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ciro', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ciro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ciro Classico', 'DOCG', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ciro Classico' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa Viola', 'IGT', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Costa Viola' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Greco di Bianco', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Greco di Bianco' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lamezia', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lamezia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lipuda', 'IGT', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lipuda' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Locride', 'IGT', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Locride' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Melissa', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Melissa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Palizzi', 'IGT', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Palizzi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pellaro', 'IGT', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pellaro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'S. Anna di Isola Capo Rizzuto', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'S. Anna di Isola Capo Rizzuto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Savuto', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savuto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Scavigna', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Scavigna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Scilla', 'IGT', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Scilla' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Cosenza', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre di Cosenza' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Neto', 'IGT', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Val di Neto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdamato', 'IGT', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valdamato' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Puglia', 17 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aleatico di Puglia', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aleatico di Puglia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alezio', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alezio' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barletta', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barletta' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Brindisi', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brindisi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cacc''e mmitte di Lucera', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cacc''e mmitte di Lucera' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castel del Monte' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte Bombino Nero', 'DOCG', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castel del Monte Bombino Nero' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte Nero di Troia Riserva', 'DOCG', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castel del Monte Nero di Troia Riserva' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte Rosso Riserva', 'DOCG', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castel del Monte Rosso Riserva' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Joniche Tarantine', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colline Joniche Tarantine' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Copertino', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Copertino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Daunia', 'IGT', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Daunia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Galatina', 'DOC', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Galatina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gioia del Colle', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gioia del Colle' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gravina', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gravina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Leverano', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Leverano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lizzano', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lizzano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Locorotondo', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Locorotondo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Martina Franca', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Martina Franca' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Matino', 'DOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Matino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Trani', 'DOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscato di Trani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Murgia', 'IGT', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Murgia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nardo', 'DOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nardo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Negroamaro di Terra d''Otranto', 'DOC', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Negroamaro di Terra d''Otranto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Orta Nova', 'DOC', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orta Nova' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ostuni', 'DOC', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ostuni' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Primitivo di Manduria', 'DOC', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Primitivo di Manduria' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Primitivo di Manduria Dolce Naturale', 'DOCG', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Primitivo di Manduria Dolce Naturale' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Puglia', 'IGT', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Puglia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Cerignola', 'DOC', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso di Cerignola' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salento', 'IGT', 30
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Salento' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salice Salentino', 'DOC', 31
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Salice Salentino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Severo', 'DOC', 32
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'San Severo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Squinzano', 'DOC', 33
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Squinzano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tarantino', 'IGT', 34
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tarantino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tavoliere delle Puglie', 'DOC', 35
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tavoliere delle Puglie' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terra d''Otranto', 'DOC', 36
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terra d''Otranto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle d''Itria', 'IGT', 37
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle d''Itria' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sicilia', 18 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alcamo', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alcamo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Avola', 'IGT', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Avola' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Camarro', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Camarro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cerasuolo di Vittoria', 'DOCG', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cerasuolo di Vittoria' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Contea di Sclafani', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Contea di Sclafani' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Contessa Entellina', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Contessa Entellina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Delia Nivolelli', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Delia Nivolelli' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eloro', 'DOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Eloro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Erice', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Erice' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Etna', 'DOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Etna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Faro', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Faro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fontanarossa di Cerda', 'IGT', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fontanarossa di Cerda' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia delle Lipari', 'DOC', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malvasia delle Lipari' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mamertino di Milazzo', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mamertino di Milazzo' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marsala', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marsala' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Menfi', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Menfi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monreale', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monreale' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Noto', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Noto' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pantelleria', 'DOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pantelleria' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riesi', 'DOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Riesi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salaparuta', 'DOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Salaparuta' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salina', 'IGT', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Salina' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sambuca di Sicilia', 'DOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sambuca di Sicilia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Margherita di Belice', 'DOC', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Santa Margherita di Belice' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sciacca', 'DOC', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sciacca' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sicilia', 'DOC', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sicilia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Siracusa', 'DOC', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Siracusa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Siciliane', 'IGT', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre Siciliane' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle Belice', 'IGT', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle Belice' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vittoria', 'DOC', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vittoria' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sardegna', 19 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alghero', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alghero' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arborea', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Arborea' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbagia', 'IGT', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbagia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cagliari', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cagliari' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campidano di Terralba', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Campidano di Terralba' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cannonau di Sardegna', 'DOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cannonau di Sardegna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carignano del Sulcis', 'DOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carignano del Sulcis' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli del Limbara', 'IGT', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli del Limbara' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Giro di Cagliari', 'DOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Giro di Cagliari' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Isola dei Nuraghi', 'IGT', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Isola dei Nuraghi' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia di Bosa', 'DOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malvasia di Bosa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mandrolisai', 'DOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mandrolisai' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marmilla', 'IGT', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marmilla' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monica di Sardegna', 'DOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monica di Sardegna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Sardegna', 'DOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscato di Sardegna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Sorso-Sennori', 'DOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscato di Sorso-Sennori' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nasco di Cagliari', 'DOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nasco di Cagliari' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nuragus di Cagliari', 'DOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nuragus di Cagliari' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nurra', 'IGT', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nurra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ogliastra', 'IGT', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ogliastra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Parteolla', 'IGT', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Parteolla' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Planargia', 'IGT', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Planargia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Provincia di Nuoro', 'IGT', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Provincia di Nuoro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Romangia', 'IGT', 23
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Romangia' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sardegna Semidano', 'DOC', 24
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sardegna Semidano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sibiola', 'IGT', 25
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sibiola' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tharros', 'IGT', 26
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tharros' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trexenta', 'IGT', 27
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trexenta' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Tirso', 'IGT', 28
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle del Tirso' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valli di Porto Pino', 'IGT', 29
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valli di Porto Pino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vermentino di Gallura', 'DOCG', 30
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vermentino di Gallura' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vermentino di Sardegna', 'DOC', 31
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vermentino di Sardegna' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vernaccia di Oristano', 'DOC', 32
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vernaccia di Oristano' and a.level = 'region' and a.region_id = r.id);

-- ── Japan ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Japan', 'JP', 'Asia', 26)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Yamanashi', 0 from public.countries c where c.name = 'Japan'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Katsunuma / Isawa', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Japan' and r.name = 'Yamanashi'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yamanashi', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Japan' and r.name = 'Yamanashi' and s.name = 'Katsunuma / Isawa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yamanashi' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Nagano', 1 from public.countries c where c.name = 'Japan'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Chikumagawa / Obuse', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Japan' and r.name = 'Nagano'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nagano', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Japan' and r.name = 'Nagano' and s.name = 'Chikumagawa / Obuse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nagano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hokkaido', 2 from public.countries c where c.name = 'Japan'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Yoichi / Furano', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Japan' and r.name = 'Hokkaido'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hokkaido', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Japan' and r.name = 'Hokkaido' and s.name = 'Yoichi / Furano'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hokkaido' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Yamagata', 3 from public.countries c where c.name = 'Japan'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Takahata / Sagae', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Japan' and r.name = 'Yamagata'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yamagata', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Japan' and r.name = 'Yamagata' and s.name = 'Takahata / Sagae'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yamagata' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Osaka', 4 from public.countries c where c.name = 'Japan'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ikeda', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Japan' and r.name = 'Osaka'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Osaka', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Japan' and r.name = 'Osaka' and s.name = 'Ikeda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Osaka' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Kenya ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Kenya', 'KE', 'Africa', 27)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rift Valley', 0 from public.countries c where c.name = 'Kenya'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Naivasha', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Kenya' and r.name = 'Rift Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lake Naivasha', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Kenya' and r.name = 'Rift Valley' and s.name = 'Naivasha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lake Naivasha' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Lebanon ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Lebanon', 'LB', 'Asia', 28)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Bekaa Valley', 0 from public.countries c where c.name = 'Lebanon'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Zahle / Baalbek', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Lebanon' and r.name = 'Bekaa Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bekaa', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Lebanon' and r.name = 'Bekaa Valley' and s.name = 'Zahle / Baalbek'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bekaa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Mont-Liban', 1 from public.countries c where c.name = 'Lebanon'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kesrouane / Batroun', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Lebanon' and r.name = 'Mont-Liban'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mont-Liban', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Lebanon' and r.name = 'Mont-Liban' and s.name = 'Kesrouane / Batroun'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mont-Liban' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Luxembourg ────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Luxembourg', 'LU', 'Europe', 29)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Moselle Luxembourgeoise', 0 from public.countries c where c.name = 'Luxembourg'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Moselle', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Luxembourg' and r.name = 'Moselle Luxembourgeoise'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moselle Luxembourgeoise', 'AOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Luxembourg' and r.name = 'Moselle Luxembourgeoise' and s.name = 'Moselle'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moselle Luxembourgeoise' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Mexico ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Mexico', 'MX', 'Americas', 30)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Baja California', 0 from public.countries c where c.name = 'Mexico'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valle de Guadalupe', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Mexico' and r.name = 'Baja California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valle de Guadalupe', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Mexico' and r.name = 'Baja California' and s.name = 'Valle de Guadalupe'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle de Guadalupe' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valle de San Vicente', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Mexico' and r.name = 'Baja California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valle de San Vicente', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Mexico' and r.name = 'Baja California' and s.name = 'Valle de San Vicente'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle de San Vicente' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valle de Santo Tomas', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Mexico' and r.name = 'Baja California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valle de Santo Tomas', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Mexico' and r.name = 'Baja California' and s.name = 'Valle de Santo Tomas'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle de Santo Tomas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Coahuila', 1 from public.countries c where c.name = 'Mexico'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Parras de la Fuente', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Mexico' and r.name = 'Coahuila'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Parras de la Fuente', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Mexico' and r.name = 'Coahuila' and s.name = 'Parras de la Fuente'
  and not exists (select 1 from public.appellations a
    where a.name = 'Parras de la Fuente' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Queretaro', 2 from public.countries c where c.name = 'Mexico'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Queretaro Highlands', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Mexico' and r.name = 'Queretaro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Queretaro', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Mexico' and r.name = 'Queretaro' and s.name = 'Queretaro Highlands'
  and not exists (select 1 from public.appellations a
    where a.name = 'Queretaro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Guanajuato', 3 from public.countries c where c.name = 'Mexico'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Guanajuato', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Mexico' and r.name = 'Guanajuato'
  and not exists (select 1 from public.appellations a
    where a.name = 'Guanajuato' and a.level = 'region' and a.region_id = r.id);

-- ── Moldova ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Moldova', 'MD', 'Europe', 31)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Codru', 0 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Codru', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Codru'
  and not exists (select 1 from public.appellations a
    where a.name = 'Codru' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valul lui Traian', 1 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valul lui Traian', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Valul lui Traian'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valul lui Traian' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Stefan Voda', 2 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Stefan Voda', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Stefan Voda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stefan Voda' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Balti', 3 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Balti', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Balti'
  and not exists (select 1 from public.appellations a
    where a.name = 'Balti' and a.level = 'region' and a.region_id = r.id);

-- ── Morocco ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Morocco', 'MA', 'Africa', 32)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Meknes-Fes', 0 from public.countries c where c.name = 'Morocco'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Meknes', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Morocco' and r.name = 'Meknes-Fes'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Guerrouane', 'AOG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Morocco' and r.name = 'Meknes-Fes' and s.name = 'Meknes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Guerrouane' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beni M''Tir', 'AOG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Morocco' and r.name = 'Meknes-Fes' and s.name = 'Meknes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beni M''Tir' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zerhoune', 'AOG', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Morocco' and r.name = 'Meknes-Fes' and s.name = 'Meknes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zerhoune' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sais', 'AOG', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Morocco' and r.name = 'Meknes-Fes' and s.name = 'Meknes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rabat-Casablanca', 1 from public.countries c where c.name = 'Morocco'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gharb / Chaouia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Morocco' and r.name = 'Rabat-Casablanca'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zenata', 'AOG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Morocco' and r.name = 'Rabat-Casablanca' and s.name = 'Gharb / Chaouia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zenata' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Oriental', 2 from public.countries c where c.name = 'Morocco'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Berkane / Angad', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Morocco' and r.name = 'Oriental'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Angad', 'AOG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Morocco' and r.name = 'Oriental' and s.name = 'Berkane / Angad'
  and not exists (select 1 from public.appellations a
    where a.name = 'Angad' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Myanmar ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Myanmar', 'MM', 'Asia', 33)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Shan State', 0 from public.countries c where c.name = 'Myanmar'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Inle Lake / Taunggyi', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Myanmar' and r.name = 'Shan State'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aythaya', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Myanmar' and r.name = 'Shan State' and s.name = 'Inle Lake / Taunggyi'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aythaya' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Netherlands ───────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Netherlands', 'NL', 'Europe', 34)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Zuid-Limburg', 0 from public.countries c where c.name = 'Netherlands'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maas Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Netherlands' and r.name = 'Zuid-Limburg'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zuid-Limburg', 'BGA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Netherlands' and r.name = 'Zuid-Limburg' and s.name = 'Maas Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zuid-Limburg' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── New Zealand ───────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('New Zealand', 'NZ', 'Oceania', 35)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Marlborough', 0 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marlborough Wine', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Marlborough'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marlborough Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marlborough', 'GI', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Marlborough'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marlborough' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wairau Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Marlborough'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Awatere Valley', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Marlborough'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Southern Valleys', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Marlborough'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hawke''s Bay', 1 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hawke''s Bay', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Hawke''s Bay'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hawke''s Bay' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gimblett Gravels', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Hawke''s Bay'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bridge Pa Triangle', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Hawke''s Bay'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Central Otago', 2 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Otago Wine', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Otago', 'GI', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bannockburn', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cromwell Basin', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gibbston', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wanaka', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bendigo', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alexandra', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Canterbury', 3 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canterbury', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Canterbury'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canterbury' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Waipara Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Canterbury'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Christchurch Plains', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Canterbury'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Wairarapa', 4 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Martinborough', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Wairarapa'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Martinborough', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Wairarapa' and s.name = 'Martinborough'
  and not exists (select 1 from public.appellations a
    where a.name = 'Martinborough' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Nelson', 5 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nelson', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Nelson'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nelson' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Waimea Plains', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Nelson'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Moutere Hills', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Nelson'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Waitaki Valley', 6 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Waitaki Valley', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Waitaki Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Waitaki Valley' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Gisborne', 7 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gisborne', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Gisborne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gisborne' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Auckland', 8 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Auckland', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Auckland'
  and not exists (select 1 from public.appellations a
    where a.name = 'Auckland' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Waiheke Island', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Auckland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Henderson', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Auckland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Matakana', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Auckland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Northland', 9 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Northland', 'GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Northland'
  and not exists (select 1 from public.appellations a
    where a.name = 'Northland' and a.level = 'region' and a.region_id = r.id);

-- ── Poland ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Poland', 'PL', 'Europe', 36)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Dolny Śląsk', 0 from public.countries c where c.name = 'Poland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Małopolska', 1 from public.countries c where c.name = 'Poland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Podkarpacie', 2 from public.countries c where c.name = 'Poland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lubuskie', 3 from public.countries c where c.name = 'Poland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

-- ── Portugal ──────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Portugal', 'PT', 'Europe', 37)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vinho', 'Vinho', 0
from public.countries c where c.name = 'Portugal'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Douro', 0 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Douro', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Douro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Douro' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho do Porto', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Douro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho do Porto' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Douro Superior', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Douro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cima Corgo', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Douro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Baixo Corgo', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Douro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vinho Verde', 1 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Minho', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Vinho Verde'
  and not exists (select 1 from public.appellations a
    where a.name = 'Minho' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Verde', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Vinho Verde'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Verde' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Minho', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Vinho Verde'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Moncao e Melgaco', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Vinho Verde'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Dao', 2 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beiras', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Dao'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beiras' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dao', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Dao'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dao' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Bairrada', 3 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beiras', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Bairrada'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beiras' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bairrada', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Bairrada'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bairrada' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Alentejo', 4 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alentejano', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Alentejo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alentejano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alentejo', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Alentejo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alentejo' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Peninsula de Setubal', 5 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peninsula de Setubal', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Peninsula de Setubal'
  and not exists (select 1 from public.appellations a
    where a.name = 'Peninsula de Setubal' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Palmela', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Peninsula de Setubal'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Palmela', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Peninsula de Setubal' and s.name = 'Palmela'
  and not exists (select 1 from public.appellations a
    where a.name = 'Palmela' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Setubal', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Peninsula de Setubal'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moscatel de Setubal', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Peninsula de Setubal' and s.name = 'Setubal'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscatel de Setubal' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Arrabida', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Peninsula de Setubal' and s.name = 'Setubal'
  and not exists (select 1 from public.appellations a
    where a.name = 'Arrabida' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lisboa', 6 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lisboa', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Lisboa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lisboa' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bucelas', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Lisboa'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bucelas', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Lisboa' and s.name = 'Bucelas'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bucelas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Colares', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Lisboa'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Colares', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Lisboa' and s.name = 'Colares'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colares' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Carcavelos', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Lisboa'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Carcavelos', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Lisboa' and s.name = 'Carcavelos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carcavelos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tejo', 7 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tejo', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Tejo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tejo' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Algarve', 8 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Algarve', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Algarve' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lagos', 'DOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lagos' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Portimao', 'DOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Portimao' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lagoa', 'DOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lagoa' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tavira', 'DOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tavira' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Beiras', 9 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Beira Interior', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Beiras'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beira Interior', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Beiras' and s.name = 'Beira Interior'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beira Interior' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tras-os-Montes', 10 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Transmontano', 'VR', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Tras-os-Montes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Transmontano' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tras-os-Montes', 'IG', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Tras-os-Montes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tras-os-Montes' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Madeira', 11 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho da Madeira', 'DOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Madeira'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho da Madeira' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Acores', 12 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pico', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Acores'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pico', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Acores' and s.name = 'Pico'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pico' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Biscoitos', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Acores'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Biscoitos', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Acores' and s.name = 'Biscoitos'
  and not exists (select 1 from public.appellations a
    where a.name = 'Biscoitos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Graciosa', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Acores'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Graciosa', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Acores' and s.name = 'Graciosa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Graciosa' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Romania ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Romania', 'RO', 'Europe', 38)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vin fara Indicatie Geografica', 'Table', 0
from public.countries c where c.name = 'Romania'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin fara Indicatie Geografica' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Moldova', 0 from public.countries c where c.name = 'Romania'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cotnari', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Moldova'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotnari', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Moldova' and s.name = 'Cotnari'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotnari' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Iasi', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Moldova'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Iasi', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Moldova' and s.name = 'Iasi'
  and not exists (select 1 from public.appellations a
    where a.name = 'Iasi' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Husi', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Moldova'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Husi', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Moldova' and s.name = 'Husi'
  and not exists (select 1 from public.appellations a
    where a.name = 'Husi' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Muntenia & Oltenia', 1 from public.countries c where c.name = 'Romania'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Dealu Mare', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Muntenia & Oltenia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dealu Mare', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Muntenia & Oltenia' and s.name = 'Dealu Mare'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dealu Mare' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Dragasani', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Muntenia & Oltenia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dragasani', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Muntenia & Oltenia' and s.name = 'Dragasani'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dragasani' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Dobrogea', 2 from public.countries c where c.name = 'Romania'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Murfatlar', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Dobrogea'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Murfatlar', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Dobrogea' and s.name = 'Murfatlar'
  and not exists (select 1 from public.appellations a
    where a.name = 'Murfatlar' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Transylvania', 3 from public.countries c where c.name = 'Romania'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tarnave', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Transylvania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tarnave', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Transylvania' and s.name = 'Tarnave'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tarnave' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alba Iulia-Aiud', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Transylvania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alba Iulia-Aiud', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Transylvania' and s.name = 'Alba Iulia-Aiud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alba Iulia-Aiud' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Banat', 4 from public.countries c where c.name = 'Romania'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Recas', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Banat'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Recas', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Banat' and s.name = 'Recas'
  and not exists (select 1 from public.appellations a
    where a.name = 'Recas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Crisana & Maramures', 5 from public.countries c where c.name = 'Romania'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mini-Maderat', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Romania' and r.name = 'Crisana & Maramures'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mini-Maderat', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Romania' and r.name = 'Crisana & Maramures' and s.name = 'Mini-Maderat'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mini-Maderat' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Serbia ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Serbia', 'RS', 'Europe', 39)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Fruska Gora', 0 from public.countries c where c.name = 'Serbia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fruska Gora', 'KGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Serbia' and r.name = 'Fruska Gora'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fruska Gora' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Zupa', 1 from public.countries c where c.name = 'Serbia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Zupa Aleksandrovacka', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Serbia' and r.name = 'Zupa'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zupa', 'KGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Serbia' and r.name = 'Zupa' and s.name = 'Zupa Aleksandrovacka'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zupa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Timok', 2 from public.countries c where c.name = 'Serbia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Timoska krajina', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Serbia' and r.name = 'Timok'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Timok', 'KGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Serbia' and r.name = 'Timok' and s.name = 'Timoska krajina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Timok' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Slovakia ──────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Slovakia', 'SK', 'Europe', 40)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Malokarpatska', 0 from public.countries c where c.name = 'Slovakia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Male Karpaty', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovakia' and r.name = 'Malokarpatska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Malokarpatska', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovakia' and r.name = 'Malokarpatska' and s.name = 'Male Karpaty'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malokarpatska' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Juzno-slovenská', 1 from public.countries c where c.name = 'Slovakia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Southern Slovakia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovakia' and r.name = 'Juzno-slovenská'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Juzno-slovenská', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovakia' and r.name = 'Juzno-slovenská' and s.name = 'Southern Slovakia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Juzno-slovenská' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Nitrianska', 2 from public.countries c where c.name = 'Slovakia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Nitra', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovakia' and r.name = 'Nitrianska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nitrianska', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovakia' and r.name = 'Nitrianska' and s.name = 'Nitra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nitrianska' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tokajská', 3 from public.countries c where c.name = 'Slovakia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Slovak Tokaj', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovakia' and r.name = 'Tokajská'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tokajská', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovakia' and r.name = 'Tokajská' and s.name = 'Slovak Tokaj'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tokajská' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Stredoslovenská', 4 from public.countries c where c.name = 'Slovakia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Central Slovakia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovakia' and r.name = 'Stredoslovenská'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Stredoslovenská', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovakia' and r.name = 'Stredoslovenská' and s.name = 'Central Slovakia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stredoslovenská' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Východoslovenská', 5 from public.countries c where c.name = 'Slovakia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Eastern Slovakia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovakia' and r.name = 'Východoslovenská'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Východoslovenská', 'CHOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovakia' and r.name = 'Východoslovenská' and s.name = 'Eastern Slovakia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Východoslovenská' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Slovenia ──────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Slovenia', 'SI', 'Europe', 41)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Primorska', 0 from public.countries c where c.name = 'Slovenia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Goriska Brda', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Goriska Brda', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Primorska' and s.name = 'Goriska Brda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Goriska Brda' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kras', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kras', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Primorska' and s.name = 'Kras'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kras' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Koper', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Koper', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Primorska' and s.name = 'Koper'
  and not exists (select 1 from public.appellations a
    where a.name = 'Koper' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vipavska dolina', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Primorska'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vipavska dolina', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Primorska' and s.name = 'Vipavska dolina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vipavska dolina' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Podravje', 1 from public.countries c where c.name = 'Slovenia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Stajerska Slovenija', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Podravje'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Stajerska Slovenija', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Podravje' and s.name = 'Stajerska Slovenija'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stajerska Slovenija' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Prekmurje', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Podravje'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Prekmurje', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Podravje' and s.name = 'Prekmurje'
  and not exists (select 1 from public.appellations a
    where a.name = 'Prekmurje' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Posavje', 2 from public.countries c where c.name = 'Slovenia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bela Krajina', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Posavje'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bela Krajina', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Posavje' and s.name = 'Bela Krajina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bela Krajina' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bizeljsko-Sremic', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Posavje'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bizeljsko-Sremic', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Posavje' and s.name = 'Bizeljsko-Sremic'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bizeljsko-Sremic' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Dolenjska', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Slovenia' and r.name = 'Posavje'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dolenjska', 'ZGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Slovenia' and r.name = 'Posavje' and s.name = 'Dolenjska'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolenjska' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── South Africa ──────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('South Africa', 'ZA', 'Africa', 42)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Wine of Origin', 'WO', 0
from public.countries c where c.name = 'South Africa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wine of Origin' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Western Cape', 0 from public.countries c where c.name = 'South Africa'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Western Cape', 'WO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape'
  and not exists (select 1 from public.appellations a
    where a.name = 'Western Cape' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Stellenbosch', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Stellenbosch', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Stellenbosch'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stellenbosch' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Franschhoek', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Franschhoek', 'WO Ward', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Franschhoek'
  and not exists (select 1 from public.appellations a
    where a.name = 'Franschhoek' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Paarl', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Paarl', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Paarl'
  and not exists (select 1 from public.appellations a
    where a.name = 'Paarl' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Swartland', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Swartland', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Swartland'
  and not exists (select 1 from public.appellations a
    where a.name = 'Swartland' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Constantia', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Constantia', 'WO Ward', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Constantia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Constantia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Elgin', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Elgin', 'WO Ward', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Elgin'
  and not exists (select 1 from public.appellations a
    where a.name = 'Elgin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Walker Bay', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Walker Bay', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Walker Bay'
  and not exists (select 1 from public.appellations a
    where a.name = 'Walker Bay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hemel-en-Aarde Valley', 'WO Ward', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Walker Bay'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hemel-en-Aarde Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Overberg', 7
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Overberg', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Overberg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Overberg' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Elim', 'WO Ward', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Overberg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Elim' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Robertson', 8
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Robertson', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Robertson'
  and not exists (select 1 from public.appellations a
    where a.name = 'Robertson' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Worcester', 9
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Worcester', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Worcester'
  and not exists (select 1 from public.appellations a
    where a.name = 'Worcester' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Breedekloof', 10
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Western Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Breedekloof', 'WO District', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Western Cape' and s.name = 'Breedekloof'
  and not exists (select 1 from public.appellations a
    where a.name = 'Breedekloof' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Northern Cape', 1 from public.countries c where c.name = 'South Africa'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Orange River', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'Northern Cape'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Orange River', 'WO Region', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'Northern Cape' and s.name = 'Orange River'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orange River' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'KwaZulu-Natal', 2 from public.countries c where c.name = 'South Africa'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'KwaZulu-Natal', 'WO Geographical Unit', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'KwaZulu-Natal'
  and not exists (select 1 from public.appellations a
    where a.name = 'KwaZulu-Natal' and a.level = 'region' and a.region_id = r.id);

-- ── Spain ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Spain', 'ES', 'Europe', 43)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vino de España', 'VdlT', 0
from public.countries c where c.name = 'Spain'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de España' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rioja', 0 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rioja', 'DOCa', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Rioja'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rioja' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rioja Alta', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Rioja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rioja Alavesa', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Rioja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rioja Oriental', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Rioja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Priorat', 1 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Priorat', 'DOCa', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Priorat'
  and not exists (select 1 from public.appellations a
    where a.name = 'Priorat' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Cataluna', 2 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cataluna', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cataluna' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Penedes', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Cataluna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Penedes', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Penedes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Penedes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cava', 'DO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Penedes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cava' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montsant', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Cataluna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montsant', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Montsant'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montsant' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Terra Alta', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Cataluna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Terra Alta', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Terra Alta'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terra Alta' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Costers del Segre', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Cataluna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Costers del Segre', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Costers del Segre'
  and not exists (select 1 from public.appellations a
    where a.name = 'Costers del Segre' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Conca de Barbera', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Cataluna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Conca de Barbera', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Conca de Barbera'
  and not exists (select 1 from public.appellations a
    where a.name = 'Conca de Barbera' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alella', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Cataluna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alella', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Alella'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alella' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tarragona', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Cataluna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tarragona', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna' and s.name = 'Tarragona'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tarragona' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Galicia', 3 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbanza e Iria', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Galicia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbanza e Iria' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rias Baixas', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Galicia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rias Baixas', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Galicia' and s.name = 'Rias Baixas'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rias Baixas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ribeiro', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Galicia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ribeiro', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Galicia' and s.name = 'Ribeiro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ribeiro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ribeira Sacra', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Galicia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ribeira Sacra', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Galicia' and s.name = 'Ribeira Sacra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ribeira Sacra' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Monterrei', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Galicia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monterrei', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Galicia' and s.name = 'Monterrei'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monterrei' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valdeorras', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Galicia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valdeorras', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Galicia' and s.name = 'Valdeorras'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valdeorras' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Castilla y Leon', 4 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castilla y Leon', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castilla y Leon' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ribera del Duero', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla y Leon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ribera del Duero', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon' and s.name = 'Ribera del Duero'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ribera del Duero' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rueda', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla y Leon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rueda', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon' and s.name = 'Rueda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rueda' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Toro', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla y Leon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Toro', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon' and s.name = 'Toro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Toro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bierzo', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla y Leon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bierzo', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon' and s.name = 'Bierzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bierzo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cigales', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla y Leon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cigales', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon' and s.name = 'Cigales'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cigales' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Arribes', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla y Leon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Arribes', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon' and s.name = 'Arribes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Arribes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Castilla-La Mancha', 5 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castilla', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castilla' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'La Mancha', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Mancha', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha' and s.name = 'La Mancha'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Mancha' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valdepenas', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valdepenas', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha' and s.name = 'Valdepenas'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valdepenas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Jumilla', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Jumilla', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha' and s.name = 'Jumilla'
  and not exists (select 1 from public.appellations a
    where a.name = 'Jumilla' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Yecla', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yecla', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha' and s.name = 'Yecla'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yecla' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Almansa', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Almansa', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha' and s.name = 'Almansa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Almansa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Manchuela', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Manchuela', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha' and s.name = 'Manchuela'
  and not exists (select 1 from public.appellations a
    where a.name = 'Manchuela' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ucles', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ucles', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha' and s.name = 'Ucles'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ucles' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valencia', 6 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valencia', 'DO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Valencia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valencia' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Utiel-Requena', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Valencia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Utiel-Requena', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Valencia' and s.name = 'Utiel-Requena'
  and not exists (select 1 from public.appellations a
    where a.name = 'Utiel-Requena' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alicante', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Valencia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alicante', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Valencia' and s.name = 'Alicante'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alicante' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Aragon', 7 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bajo Aragon', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Aragon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bajo Aragon' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Campo de Borja', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Aragon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Campo de Borja', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Aragon' and s.name = 'Campo de Borja'
  and not exists (select 1 from public.appellations a
    where a.name = 'Campo de Borja' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Carinena', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Aragon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Carinena', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Aragon' and s.name = 'Carinena'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carinena' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Calatayud', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Aragon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Calatayud', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Aragon' and s.name = 'Calatayud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calatayud' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Somontano', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Aragon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Somontano', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Aragon' and s.name = 'Somontano'
  and not exists (select 1 from public.appellations a
    where a.name = 'Somontano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Navarra', 8 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Navarra', 'DO', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Navarra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Navarra' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pago de Arinzano', 'VP', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Navarra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pago de Arinzano' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Pais Vasco', 9 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Getaria', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Pais Vasco'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Txakoli de Getaria', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Pais Vasco' and s.name = 'Getaria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Txakoli de Getaria' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bizkaia', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Pais Vasco'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Txakoli de Bizkaia', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Pais Vasco' and s.name = 'Bizkaia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Txakoli de Bizkaia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alava', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Pais Vasco'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Txakoli de Alava', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Pais Vasco' and s.name = 'Alava'
  and not exists (select 1 from public.appellations a
    where a.name = 'Txakoli de Alava' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Extremadura', 10 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Extremadura', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Extremadura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Extremadura' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Guadiana', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Extremadura'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ribera del Guadiana', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Extremadura' and s.name = 'Guadiana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ribera del Guadiana' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Andalucia', 11 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cadiz', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Andalucia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cadiz' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Jerez', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Andalucia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Jerez-Xeres-Sherry', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Andalucia' and s.name = 'Jerez'
  and not exists (select 1 from public.appellations a
    where a.name = 'Jerez-Xeres-Sherry' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sanlucar', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Andalucia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Manzanilla-Sanlucar de Barrameda', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Andalucia' and s.name = 'Sanlucar'
  and not exists (select 1 from public.appellations a
    where a.name = 'Manzanilla-Sanlucar de Barrameda' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montilla', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Andalucia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montilla-Moriles', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Andalucia' and s.name = 'Montilla'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montilla-Moriles' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Malaga', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Andalucia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Malaga', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Andalucia' and s.name = 'Malaga'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malaga' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sierras de Malaga', 'DO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Andalucia' and s.name = 'Malaga'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sierras de Malaga' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Islas Canarias', 12 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'El Hierro', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Islas Canarias'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'El Hierro', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'El Hierro'
  and not exists (select 1 from public.appellations a
    where a.name = 'El Hierro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'La Palma', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Islas Canarias'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Palma', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'La Palma'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Palma' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'La Gomera', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Islas Canarias'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Gomera', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'La Gomera'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Gomera' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tenerife', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Islas Canarias'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Abona', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'Tenerife'
  and not exists (select 1 from public.appellations a
    where a.name = 'Abona' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tacoronte-Acentejo', 'DO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'Tenerife'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tacoronte-Acentejo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valle de Güimar', 'DO', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'Tenerife'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle de Güimar' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valle de la Orotava', 'DO', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'Tenerife'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle de la Orotava' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ycoden-Daute-Isora', 'DO', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'Tenerife'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ycoden-Daute-Isora' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gran Canaria', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Islas Canarias'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gran Canaria', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'Gran Canaria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gran Canaria' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lanzarote', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Islas Canarias'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lanzarote', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Canarias' and s.name = 'Lanzarote'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lanzarote' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Islas Baleares', 13 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mallorca', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Islas Baleares'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Binissalem Mallorca', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Baleares' and s.name = 'Mallorca'
  and not exists (select 1 from public.appellations a
    where a.name = 'Binissalem Mallorca' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pla i Llevant', 'DO', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Islas Baleares' and s.name = 'Mallorca'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pla i Llevant' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Switzerland ───────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Switzerland', 'CH', 'Europe', 44)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valais', 0 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valais', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Valais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valais' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vaud', 1 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vaud', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vaud' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chablais', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chablais' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lavaux', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lavaux' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Cote', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Cote' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes-de-l''Orbe', 'AOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes-de-l''Orbe' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bonvillars', 'AOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bonvillars' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dezaley', 'AOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dezaley' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dezaley-Marsens', 'AOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dezaley-Marsens' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calamin', 'AOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calamin' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Geneve', 2 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Geneve', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Geneve' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Chevrens', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Chevrens' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Landecy', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Landecy' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Lully', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Lully' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Choulex', 'AOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Choulex' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chateau de Collex', 'AOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chateau de Collex' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Bossy', 'AOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Bossy' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de la vigne blanche', 'AOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de la vigne blanche' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux de Dardagny', 'AOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Dardagny' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Genthod', 'AOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Genthod' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chateau du Crest', 'AOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chateau du Crest' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mandement de Jussy', 'AOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mandement de Jussy' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grand Carraz', 'AOC', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grand Carraz' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Domaine de l''Abbaye', 'AOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Domaine de l''Abbaye' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Russin', 'AOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Russin' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau des Baillets', 'AOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau des Baillets' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Bourdigny', 'AOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Bourdigny' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Choully', 'AOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Choully' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Peissy', 'AOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteau de Peissy' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux de Peney', 'AOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Peney' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chateau de Choully', 'AOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chateau de Choully' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rougemont', 'AOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rougemont' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Feuillee', 'AOC', 22
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Geneve'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Feuillee' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Drei Seen', 3 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Neuchatel', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Drei Seen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Neuchatel' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bielersee', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Drei Seen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bielersee' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cheyres', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Drei Seen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cheyres' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vully', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Drei Seen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vully' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ticino', 4 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ticino', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Ticino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ticino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso del Ticino', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Ticino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso del Ticino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco del Ticino', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Ticino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bianco del Ticino' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosato del Ticino', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Ticino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosato del Ticino' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Deutschschweiz', 5 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aargau', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aargau' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Appenzell Innerrhoden', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Appenzell Innerrhoden' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Appenzell Ausserrhoden', 'AOC', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Appenzell Ausserrhoden' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bern', 'AOC', 3
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bern' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thunersee', 'AOC', 4
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Thunersee' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Basel-Landschaft', 'AOC', 5
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Basel-Landschaft' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Basel-Stadt', 'AOC', 6
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Basel-Stadt' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Glarus', 'AOC', 7
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Glarus' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Graubünden', 'AOC', 8
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Graubünden' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jura', 'AOC', 9
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Jura' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Luzern', 'AOC', 10
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Luzern' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nidwalden', 'AOC', 11
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nidwalden' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Obwalden', 'AOC', 12
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Obwalden' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'St. Gallen', 'AOC', 13
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'St. Gallen' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Schaffhausen', 'AOC', 14
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Schaffhausen' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Solothurn', 'AOC', 15
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Solothurn' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Schwyz', 'AOC', 16
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Schwyz' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thurgau', 'AOC', 17
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Thurgau' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Uri', 'AOC', 18
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Uri' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zug', 'AOC', 19
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zug' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zürich', 'AOC', 20
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zürich' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zürichsee', 'AOC', 21
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zürichsee' and a.level = 'region' and a.region_id = r.id);

-- ── Thailand ──────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Thailand', 'TH', 'Asia', 45)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Nakhon Ratchasima', 0 from public.countries c where c.name = 'Thailand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Khao Yai', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Thailand' and r.name = 'Nakhon Ratchasima'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Khao Yai', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Thailand' and r.name = 'Nakhon Ratchasima' and s.name = 'Khao Yai'
  and not exists (select 1 from public.appellations a
    where a.name = 'Khao Yai' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Prachuap Khiri Khan', 1 from public.countries c where c.name = 'Thailand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Hua Hin Hills', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Thailand' and r.name = 'Prachuap Khiri Khan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hua Hin Hills', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Thailand' and r.name = 'Prachuap Khiri Khan' and s.name = 'Hua Hin Hills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hua Hin Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Tunisia ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Tunisia', 'TN', 'Africa', 46)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Cap Bon', 0 from public.countries c where c.name = 'Tunisia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kelibia / Grombalia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Tunisia' and r.name = 'Cap Bon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kelibia', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Tunisia' and r.name = 'Cap Bon' and s.name = 'Kelibia / Grombalia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kelibia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tunis', 1 from public.countries c where c.name = 'Tunisia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mornag', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Tunisia' and r.name = 'Tunis'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mornag', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Tunisia' and r.name = 'Tunis' and s.name = 'Mornag'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mornag' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Medjerda Valley', 2 from public.countries c where c.name = 'Tunisia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tebourba', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Tunisia' and r.name = 'Medjerda Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Tebourba', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Tunisia' and r.name = 'Medjerda Valley' and s.name = 'Tebourba'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Tebourba' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Turkey ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Turkey', 'TR', 'Asia', 47)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Trakya & Marmara', 0 from public.countries c where c.name = 'Turkey'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tekirdag / Bozcaada', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Turkey' and r.name = 'Trakya & Marmara'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Trakya', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Turkey' and r.name = 'Trakya & Marmara' and s.name = 'Tekirdag / Bozcaada'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trakya' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ege', 1 from public.countries c where c.name = 'Turkey'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Izmir / Manisa / Denizli', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Turkey' and r.name = 'Ege'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ege', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Turkey' and r.name = 'Ege' and s.name = 'Izmir / Manisa / Denizli'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ege' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ic Anadolu', 2 from public.countries c where c.name = 'Turkey'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cappadocia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Turkey' and r.name = 'Ic Anadolu'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cappadocia', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Turkey' and r.name = 'Ic Anadolu' and s.name = 'Cappadocia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cappadocia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Dogu Anadolu', 3 from public.countries c where c.name = 'Turkey'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Elazig / Diyarbakir', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Turkey' and r.name = 'Dogu Anadolu'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Elazig', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Turkey' and r.name = 'Dogu Anadolu' and s.name = 'Elazig / Diyarbakir'
  and not exists (select 1 from public.appellations a
    where a.name = 'Elazig' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Güneydogu Anadolu', 4 from public.countries c where c.name = 'Turkey'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gaziantep / Maras', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Turkey' and r.name = 'Güneydogu Anadolu'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Güneydogu Anadolu', null, 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Turkey' and r.name = 'Güneydogu Anadolu' and s.name = 'Gaziantep / Maras'
  and not exists (select 1 from public.appellations a
    where a.name = 'Güneydogu Anadolu' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Ukraine ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Ukraine', 'UA', 'Europe', 48)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Crimea', 0 from public.countries c where c.name = 'Ukraine'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Southern Coast', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Ukraine' and r.name = 'Crimea'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yuzhnyi Bereg', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Ukraine' and r.name = 'Crimea' and s.name = 'Southern Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yuzhnyi Bereg' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sevastopol', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Ukraine' and r.name = 'Crimea'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sevastopol', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Ukraine' and r.name = 'Crimea' and s.name = 'Sevastopol'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sevastopol' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Odessa', 1 from public.countries c where c.name = 'Ukraine'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Shabo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Ukraine' and r.name = 'Odessa'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Shabo', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Ukraine' and r.name = 'Odessa' and s.name = 'Shabo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Shabo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Zakarpattia', 2 from public.countries c where c.name = 'Ukraine'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zakarpattia', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Ukraine' and r.name = 'Zakarpattia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zakarpattia' and a.level = 'region' and a.region_id = r.id);

-- ── United States ─────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('United States', 'US', 'Americas', 49)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'American', 'National', 0
from public.countries c where c.name = 'United States'
  and not exists (select 1 from public.appellations a
    where a.name = 'American' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'California', 0 from public.countries c where c.name = 'United States'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'California Wine', 'State designation', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California'
  and not exists (select 1 from public.appellations a
    where a.name = 'California Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Napa Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Napa Valley', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Napa Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rutherford', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rutherford' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Oakville', 'AVA', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Oakville' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Stags Leap District', 'AVA', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stags Leap District' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Howell Mountain', 'AVA', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Howell Mountain' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mt. Veeder', 'AVA', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mt. Veeder' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Spring Mountain District', 'AVA', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Spring Mountain District' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Atlas Peak', 'AVA', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Atlas Peak' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Calistoga', 'AVA', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calistoga' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Oak Knoll District', 'AVA', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Oak Knoll District' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Carneros', 'AVA', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Napa Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carneros' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sonoma County', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sonoma Coast', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sonoma County'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sonoma Coast' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Russian River Valley', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sonoma County'
  and not exists (select 1 from public.appellations a
    where a.name = 'Russian River Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alexander Valley', 'AVA', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sonoma County'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alexander Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dry Creek Valley', 'AVA', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sonoma County'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dry Creek Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chalk Hill', 'AVA', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sonoma County'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chalk Hill' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Green Valley of Russian River Valley', 'AVA', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sonoma County'
  and not exists (select 1 from public.appellations a
    where a.name = 'Green Valley of Russian River Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Central Coast', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Santa Cruz Mountains', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Santa Cruz Mountains' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monterey', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monterey' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Santa Lucia Highlands', 'AVA', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Santa Lucia Highlands' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Paso Robles', 'AVA', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Paso Robles' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Santa Ynez Valley', 'AVA', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Santa Ynez Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sta. Rita Hills', 'AVA', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sta. Rita Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ballard Canyon', 'AVA', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ballard Canyon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Happy Canyon of Santa Barbara', 'AVA', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Central Coast'
  and not exists (select 1 from public.appellations a
    where a.name = 'Happy Canyon of Santa Barbara' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sierra Foothills', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'El Dorado', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sierra Foothills'
  and not exists (select 1 from public.appellations a
    where a.name = 'El Dorado' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Amador County', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sierra Foothills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Amador County' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Calaveras County', 'AVA', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Sierra Foothills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calaveras County' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Other AVAs', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'California'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Livermore Valley', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Other AVAs'
  and not exists (select 1 from public.appellations a
    where a.name = 'Livermore Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lodi', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Other AVAs'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lodi' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anderson Valley', 'AVA', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Other AVAs'
  and not exists (select 1 from public.appellations a
    where a.name = 'Anderson Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Redwood Valley', 'AVA', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'California' and s.name = 'Other AVAs'
  and not exists (select 1 from public.appellations a
    where a.name = 'Redwood Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Oregon', 1 from public.countries c where c.name = 'United States'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oregon Wine', 'State designation', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Oregon Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Willamette Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Oregon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Willamette Valley', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Willamette Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Willamette Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dundee Hills', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Willamette Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dundee Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chehalem Mountains', 'AVA', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Willamette Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chehalem Mountains' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ribbon Ridge', 'AVA', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Willamette Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ribbon Ridge' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yamhill-Carlton', 'AVA', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Willamette Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yamhill-Carlton' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Eola-Amity Hills', 'AVA', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Willamette Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Eola-Amity Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'McMinnville', 'AVA', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Willamette Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'McMinnville' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Southern Oregon', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Oregon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Umpqua Valley', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Southern Oregon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Umpqua Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rogue Valley', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Southern Oregon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rogue Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Columbia Gorge', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Oregon'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Columbia Gorge', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Oregon' and s.name = 'Columbia Gorge'
  and not exists (select 1 from public.appellations a
    where a.name = 'Columbia Gorge' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Washington State', 2 from public.countries c where c.name = 'United States'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Washington Wine', 'State designation', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State'
  and not exists (select 1 from public.appellations a
    where a.name = 'Washington Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Columbia Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Washington State'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Columbia Valley', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Columbia Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Columbia Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yakima Valley', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Columbia Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yakima Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Red Mountain', 'AVA', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Columbia Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Red Mountain' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Horse Heaven Hills', 'AVA', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Columbia Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Horse Heaven Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rattlesnake Hills', 'AVA', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Columbia Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rattlesnake Hills' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Wahluke Slope', 'AVA', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Columbia Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wahluke Slope' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ancient Lakes', 'AVA', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Columbia Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ancient Lakes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Walla Walla', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Washington State'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Walla Walla Valley', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Washington State' and s.name = 'Walla Walla'
  and not exists (select 1 from public.appellations a
    where a.name = 'Walla Walla Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'New York State', 3 from public.countries c where c.name = 'United States'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'New York Wine', 'State designation', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'New York State'
  and not exists (select 1 from public.appellations a
    where a.name = 'New York Wine' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Finger Lakes', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'New York State'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Finger Lakes', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'New York State' and s.name = 'Finger Lakes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Finger Lakes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Long Island', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'New York State'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'North Fork of Long Island', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'New York State' and s.name = 'Long Island'
  and not exists (select 1 from public.appellations a
    where a.name = 'North Fork of Long Island' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'The Hamptons, Long Island', 'AVA', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'New York State' and s.name = 'Long Island'
  and not exists (select 1 from public.appellations a
    where a.name = 'The Hamptons, Long Island' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Hudson Valley', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'New York State'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hudson River Region', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'New York State' and s.name = 'Hudson Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hudson River Region' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Virginia', 4 from public.countries c where c.name = 'United States'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Central Virginia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Virginia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monticello', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Virginia' and s.name = 'Central Virginia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monticello' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Northern Virginia', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Virginia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Shenandoah Valley', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Virginia' and s.name = 'Northern Virginia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Shenandoah Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Texas', 5 from public.countries c where c.name = 'United States'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Texas Panhandle', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Texas'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Texas High Plains', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Texas' and s.name = 'Texas Panhandle'
  and not exists (select 1 from public.appellations a
    where a.name = 'Texas High Plains' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Central Texas', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Texas'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Texas Hill Country', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Texas' and s.name = 'Central Texas'
  and not exists (select 1 from public.appellations a
    where a.name = 'Texas Hill Country' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Michigan', 6 from public.countries c where c.name = 'United States'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Southwest Michigan', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'United States' and r.name = 'Michigan'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lake Michigan Shore', 'AVA', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'United States' and r.name = 'Michigan' and s.name = 'Southwest Michigan'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lake Michigan Shore' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Uruguay ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Uruguay', 'UY', 'Americas', 50)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Canelones', 0 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canelones', 'DOP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Canelones'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canelones' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Maldonado', 1 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maldonado', 'DOP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Maldonado'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maldonado' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Colonia', 2 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colonia', 'DOP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Colonia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colonia' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rivera', 3 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rivera', 'DOP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Rivera'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rivera' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Montevideo', 4 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montevideo', 'DOP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Montevideo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montevideo' and a.level = 'region' and a.region_id = r.id);

commit;
