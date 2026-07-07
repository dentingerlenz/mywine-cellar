-- ═══════════════════════════════════════════════════════════════════════
-- GENERIERT von scripts/geo/build-seed.js — NICHT von Hand editieren!
-- Quelle: data/geography/*.json  ·  Neu erzeugen: npm run geo:build
-- Stand: 2026-07-07 · 51 Länder
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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mascara', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Algeria' and r.name = 'Mascara'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Mascara', 'AOIG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Algeria' and r.name = 'Mascara' and s.name = 'Mascara'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Mascara' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tlemcen', 1 from public.countries c where c.name = 'Algeria'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tlemcen', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Algeria' and r.name = 'Tlemcen'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Tlemcen', 'AOIG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Algeria' and r.name = 'Tlemcen' and s.name = 'Tlemcen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux de Tlemcen' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Miliana', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Algeria' and r.name = 'Miliana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Zaccar', 'AOIG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Algeria' and r.name = 'Miliana' and s.name = 'Miliana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Zaccar' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Argentina ─────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Argentina', 'AR', 'Americas', 1)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vino de Argentina', 'National', 0
from public.countries c where c.name = 'Argentina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de Argentina' and a.level = 'country' and a.country_id = c.id);

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
select 'country', c.id, 'Australian Wine', 'National', 0
from public.countries c where c.name = 'Australia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Australian Wine' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'South Australia', 0 from public.countries c where c.name = 'Australia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South Eastern Australia', 'Broad GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'South Australia'
  and not exists (select 1 from public.appellations a
    where a.name = 'South Eastern Australia' and a.level = 'region' and a.region_id = r.id);

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

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South Eastern Australia', 'Broad GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'Victoria'
  and not exists (select 1 from public.appellations a
    where a.name = 'South Eastern Australia' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Western Australia', 'Broad GI', 0
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

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South Eastern Australia', 'Broad GI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Australia' and r.name = 'New South Wales'
  and not exists (select 1 from public.appellations a
    where a.name = 'South Eastern Australia' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Tasmania', 'Broad GI', 0
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
select 'sub_region', s.id, 'Wachau', 'Qualitätswein', 0
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
select 'sub_region', s.id, 'Thermenregion', 'Qualitätswein', 0
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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wien', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Austria' and r.name = 'Wien'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Wien', 'DAC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Wien' and s.name = 'Wien'
  and not exists (select 1 from public.appellations a
    where a.name = 'Wien' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'sub_region', s.id, 'Rust Ausbruch', 'Pradikat', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Austria' and r.name = 'Burgenland' and s.name = 'Rust'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rust Ausbruch' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Trpezno Vino', 'Table', 0
from public.countries c where c.name = 'Bulgaria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trpezno Vino' and a.level = 'country' and a.country_id = c.id);

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
select r.id, 'Cantons de l’Est', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Canada' and r.name = 'Quebec'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cantons de l’Est', 'Appellation Quebec', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Canada' and r.name = 'Quebec' and s.name = 'Cantons de l’Est'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cantons de l’Est' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vino de Chile', 'National', 0
from public.countries c where c.name = 'Chile'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de Chile' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Aconcagua', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Chile' and r.name = 'Aconcagua'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aconcagua', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Chile' and r.name = 'Aconcagua' and s.name = 'Aconcagua'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aconcagua' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Casablanca', 1
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
select r.id, 'San Antonio', 2
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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Putao Jiu', 'National', 0
from public.countries c where c.name = 'China'
  and not exists (select 1 from public.appellations a
    where a.name = 'Putao Jiu' and a.level = 'country' and a.country_id = c.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Stolno Vino', 'Table', 0
from public.countries c where c.name = 'Croatia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stolno Vino' and a.level = 'country' and a.country_id = c.id);

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
select 'region', r.id, 'PGI Pafos', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Pafos'
  and not exists (select 1 from public.appellations a
    where a.name = 'PGI Pafos' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'PGI Lemesos', 'PGI', 2
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Lemesos'
  and not exists (select 1 from public.appellations a
    where a.name = 'PGI Lemesos' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Larnaka', 2 from public.countries c where c.name = 'Cyprus'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'PGI Larnaka', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Larnaka'
  and not exists (select 1 from public.appellations a
    where a.name = 'PGI Larnaka' and a.level = 'region' and a.region_id = r.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lefkosia', 3 from public.countries c where c.name = 'Cyprus'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'PGI Lefkosia', 'PGI', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Cyprus' and r.name = 'Lefkosia'
  and not exists (select 1 from public.appellations a
    where a.name = 'PGI Lefkosia' and a.level = 'region' and a.region_id = r.id);

-- ── Czech Republic ────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Czech Republic', 'CZ', 'Europe', 14)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Stolni Vino', 'Table', 0
from public.countries c where c.name = 'Czech Republic'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stolni Vino' and a.level = 'country' and a.country_id = c.id);

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
select 'country', c.id, 'English Wine / Welsh Wine', 'National', 0
from public.countries c where c.name = 'England & Wales'
  and not exists (select 1 from public.appellations a
    where a.name = 'English Wine / Welsh Wine' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kent', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'Kent'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'English Wine', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'England & Wales' and r.name = 'Kent' and s.name = 'Kent'
  and not exists (select 1 from public.appellations a
    where a.name = 'English Wine' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hampshire', 2 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Hampshire', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'Hampshire'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'English Wine', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'England & Wales' and r.name = 'Hampshire' and s.name = 'Hampshire'
  and not exists (select 1 from public.appellations a
    where a.name = 'English Wine' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'East Anglia', 3 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Essex / Suffolk / Norfolk', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'East Anglia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'English Wine', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'England & Wales' and r.name = 'East Anglia' and s.name = 'Essex / Suffolk / Norfolk'
  and not exists (select 1 from public.appellations a
    where a.name = 'English Wine' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Wales', 4 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wales', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'Wales'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Welsh Wine', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'England & Wales' and r.name = 'Wales' and s.name = 'Wales'
  and not exists (select 1 from public.appellations a
    where a.name = 'Welsh Wine' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'South-West', 5 from public.countries c where c.name = 'England & Wales'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cornwall & Devon', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'England & Wales' and r.name = 'South-West'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'English Wine', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'England & Wales' and r.name = 'South-West' and s.name = 'Cornwall & Devon'
  and not exists (select 1 from public.appellations a
    where a.name = 'English Wine' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'country', c.id, 'Vin de France', 'AOC', 0
from public.countries c where c.name = 'France'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin de France' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Bordeaux', 0 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'AOC Bordeaux', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'AOC Bordeaux' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGP Atlantique', 'IGP', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGP Atlantique' and a.level = 'region' and a.region_id = r.id);

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
select 'sub_region', s.id, 'Pauillac', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pauillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Margaux', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Margaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Julien', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Julien' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Estephe', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Estephe' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moulis-en-Medoc', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moulis-en-Medoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Listrac-Medoc', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Listrac-Medoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Haut-Medoc', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haut-Medoc', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Haut-Medoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Haut-Medoc' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Graves', 2
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
select 'sub_region', s.id, 'Pessac-Leognan', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Graves'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pessac-Leognan' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sauternes', 3
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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Saint-Emilion', 4
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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pomerol', 5
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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Fronsac', 6
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
select r.id, 'Bourg', 7
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
select r.id, 'Blaye', 8
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bordeaux'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blaye Cotes de Bordeaux', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bordeaux' and s.name = 'Blaye'
  and not exists (select 1 from public.appellations a
    where a.name = 'Blaye Cotes de Bordeaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Entre-Deux-Mers', 9
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

insert into public.regions (country_id, name, sort_order)
select c.id, 'Bourgogne', 1 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'AOC Bourgogne', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne'
  and not exists (select 1 from public.appellations a
    where a.name = 'AOC Bourgogne' and a.level = 'region' and a.region_id = r.id);

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
select 'sub_region', s.id, 'Chablis Premier Cru', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chablis Premier Cru' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chablis Grand Cru', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Chablis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chablis Grand Cru' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Nuits', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gevrey-Chambertin', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gevrey-Chambertin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Morey-Saint-Denis', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Morey-Saint-Denis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chambolle-Musigny', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chambolle-Musigny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vougeot', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vougeot' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vosne-Romanee', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vosne-Romanee' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nuits-Saint-Georges', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Nuits'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nuits-Saint-Georges' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Beaune', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aloxe-Corton', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aloxe-Corton' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beaune', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beaune' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pommard', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pommard' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Volnay', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Volnay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Meursault', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Meursault' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Puligny-Montrachet', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Puligny-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chassagne-Montrachet', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote de Beaune'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chassagne-Montrachet' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote Chalonnaise', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mercurey', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mercurey' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Givry', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Givry' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rully', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rully' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montagny', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montagny' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bouzeron', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Cote Chalonnaise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bouzeron' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'sub_region', s.id, 'Macon-Villages', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Macon-Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Fuisse', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pouilly-Fuisse' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Veran', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Veran' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Viire-Clesse', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Maconnais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Viire-Clesse' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Regional', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Bourgogne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bourgogne', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Regional'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgogne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bourgogne Aligote', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Bourgogne' and s.name = 'Regional'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgogne Aligote' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Champagne', 2 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'AOC Champagne', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne'
  and not exists (select 1 from public.appellations a
    where a.name = 'AOC Champagne' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montagne de Reims', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Champagne', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne' and s.name = 'Montagne de Reims'
  and not exists (select 1 from public.appellations a
    where a.name = 'Champagne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vallee de la Marne', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Champagne', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne' and s.name = 'Vallee de la Marne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Champagne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote des Blancs', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Champagne', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne' and s.name = 'Cote des Blancs'
  and not exists (select 1 from public.appellations a
    where a.name = 'Champagne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Sezanne', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Champagne', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne' and s.name = 'Cote de Sezanne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Champagne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Aube (Cote des Bar)', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Champagne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Champagne', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Champagne' and s.name = 'Aube (Cote des Bar)'
  and not exists (select 1 from public.appellations a
    where a.name = 'Champagne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Alsace', 3 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'AOC Alsace', 'AOC', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace'
  and not exists (select 1 from public.appellations a
    where a.name = 'AOC Alsace' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alsace', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Alsace'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alsace', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace' and s.name = 'Alsace'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alsace' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alsace Grand Cru', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace' and s.name = 'Alsace'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alsace Grand Cru' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant d’Alsace', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Alsace' and s.name = 'Alsace'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant d’Alsace' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vallee du Rhone', 4 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGP Mediterranee', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGP Mediterranee' and a.level = 'region' and a.region_id = r.id);

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'AOC Cotes du Rhone', 'AOC', 1
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'AOC Cotes du Rhone' and a.level = 'region' and a.region_id = r.id);

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
select 'sub_region', s.id, 'Beaumes-de-Venise', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beaumes-de-Venise' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rasteau', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rasteau' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lirac', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lirac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tavel', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tavel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Luberon', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Luberon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ventoux', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ventoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grignan-les-Adhemar', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Grignan-les-Adhemar' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Rhone', 'AOC', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Rhone' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Rhone Villages', 'AOC', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee du Rhone' and s.name = 'Rhone Sud'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Rhone Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vallee de la Loire', 5 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGP Val de Loire', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGP Val de Loire' and a.level = 'region' and a.region_id = r.id);

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
select 'sub_region', s.id, 'Muscadet Sevre-et-Maine', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscadet Sevre-et-Maine' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet Coteaux de la Loire', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Pays Nantais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscadet Coteaux de la Loire' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'sub_region', s.id, 'Saumur', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saumur' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savennieres', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savennieres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Layon', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux du Layon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Quarts de Chaume', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Quarts de Chaume' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bonnezeaux', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Anjou-Saumur'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bonnezeaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Touraine', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Vallee de la Loire'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chinon', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chinon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bourgueil', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bourgueil' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Nicolas-de-Bourgueil', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Nicolas-de-Bourgueil' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vouvray', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vouvray' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montlouis-sur-Loire', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Touraine'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montlouis-sur-Loire' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'sub_region', s.id, 'Menetou-Salon', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Menetou-Salon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Quincy', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Quincy' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Reuilly', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Vallee de la Loire' and s.name = 'Centre-Loire'
  and not exists (select 1 from public.appellations a
    where a.name = 'Reuilly' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Provence', 6 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGP Mediterranee', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGP Mediterranee' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Provence', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Provence'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux d’Aix-en-Provence', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence' and s.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux d’Aix-en-Provence' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Les Baux-de-Provence', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence' and s.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Les Baux-de-Provence' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Provence', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence' and s.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de Provence' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bandol', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence' and s.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bandol' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cassis', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence' and s.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cassis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Palette', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence' and s.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Palette' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux Varois en Provence', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Provence' and s.name = 'Provence'
  and not exists (select 1 from public.appellations a
    where a.name = 'Coteaux Varois en Provence' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Languedoc-Roussillon', 7 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGP Pays d''Oc', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGP Pays d''Oc' and a.level = 'region' and a.region_id = r.id);

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
select 'sub_region', s.id, 'Minervois', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Minervois' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corbieres', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Corbieres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Chinian', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Chinian' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Faugeres', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Faugeres' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fitou', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fitou' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Limoux', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Limoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blanquette de Limoux', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Blanquette de Limoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant de Limoux', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Languedoc'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cremant de Limoux' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'sub_region', s.id, 'Banyuls', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Banyuls' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Collioure', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Collioure' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maury', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maury' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rivesaltes', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rivesaltes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Rivesaltes', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Languedoc-Roussillon' and s.name = 'Roussillon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Muscat de Rivesaltes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sud-Ouest', 8 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGP Comtes Tolosan', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGP Comtes Tolosan' and a.level = 'region' and a.region_id = r.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lot', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cahors', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Lot'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cahors' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tarn', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gaillac', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Tarn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gaillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Madiran', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Madiran', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Madiran'
  and not exists (select 1 from public.appellations a
    where a.name = 'Madiran' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Jurancon', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Jurancon', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Jurancon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Jurancon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pays Basque', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Irouleguy', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Pays Basque'
  and not exists (select 1 from public.appellations a
    where a.name = 'Irouleguy' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Aveyron', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Sud-Ouest'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marcillac', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Sud-Ouest' and s.name = 'Aveyron'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marcillac' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Savoie & Jura', 9 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Savoie', 0
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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Jura', 1
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
select 'sub_region', s.id, 'L’Etoile', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'L’Etoile' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Jura', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Savoie & Jura' and s.name = 'Jura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes du Jura' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Beaujolais', 10 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGP Vin de Pays d''Oc', 'IGP', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGP Vin de Pays d''Oc' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Beaujolais', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Beaujolais'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beaujolais', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beaujolais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beaujolais-Villages', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beaujolais-Villages' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Beaujolais Crus', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Beaujolais'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moulin-a-Vent', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moulin-a-Vent' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fleurie', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fleurie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Morgon', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Morgon' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Brouilly', 'AOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brouilly' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Brouilly', 'AOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cote de Brouilly' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Julienas', 'AOC', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Julienas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Amour', 'AOC', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saint-Amour' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chenas', 'AOC', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chenas' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Regnie', 'AOC', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Regnie' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chiroubles', 'AOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Beaujolais' and s.name = 'Beaujolais Crus'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chiroubles' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Corse', 11 from public.countries c where c.name = 'France'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Corse', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'France' and r.name = 'Corse'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Patrimonio', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse' and s.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Patrimonio' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ajaccio', 'AOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse' and s.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ajaccio' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vin de Corse', 'AOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'France' and r.name = 'Corse' and s.name = 'Corse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin de Corse' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Georgia ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Georgia', 'GE', 'Europe', 19)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Magrada Ghvino', 'Table', 0
from public.countries c where c.name = 'Georgia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Magrada Ghvino' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Imereti', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Georgia' and r.name = 'Imereti'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Imereti', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Imereti' and s.name = 'Imereti'
  and not exists (select 1 from public.appellations a
    where a.name = 'Imereti' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Kartli', 3 from public.countries c where c.name = 'Georgia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kartli', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Georgia' and r.name = 'Kartli'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Kartli', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Kartli' and s.name = 'Kartli'
  and not exists (select 1 from public.appellations a
    where a.name = 'Kartli' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Adjara', 4 from public.countries c where c.name = 'Georgia'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Adjara', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Georgia' and r.name = 'Adjara'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Adjara', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Georgia' and r.name = 'Adjara' and s.name = 'Adjara'
  and not exists (select 1 from public.appellations a
    where a.name = 'Adjara' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mittelmosel', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mosel', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mosel' and s.name = 'Mittelmosel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mosel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Saar', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mosel', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mosel' and s.name = 'Saar'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mosel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ruwer', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mosel', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mosel' and s.name = 'Ruwer'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mosel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Terrassenmosel', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mosel'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mosel', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mosel' and s.name = 'Terrassenmosel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mosel' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rheingau', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Rheingau'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rheingau', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Rheingau' and s.name = 'Rheingau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rheingau' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rheinhessen', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Rheinhessen'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rheinhessen', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Rheinhessen' and s.name = 'Rheinhessen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rheinhessen' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pfalz', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Pfalz'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pfalz', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Pfalz' and s.name = 'Pfalz'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pfalz' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Nahe', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Nahe'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nahe', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Nahe' and s.name = 'Nahe'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nahe' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Franken', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Franken'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Franken', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Franken' and s.name = 'Franken'
  and not exists (select 1 from public.appellations a
    where a.name = 'Franken' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Kaiserstuhl', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Baden', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Baden' and s.name = 'Kaiserstuhl'
  and not exists (select 1 from public.appellations a
    where a.name = 'Baden' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Markgraflerland', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Baden', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Baden' and s.name = 'Markgraflerland'
  and not exists (select 1 from public.appellations a
    where a.name = 'Baden' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ortenau', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Baden', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Baden' and s.name = 'Ortenau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Baden' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Breisgau', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Baden'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Baden', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Baden' and s.name = 'Breisgau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Baden' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Württemberg', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Württemberg'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Württemberg', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Württemberg' and s.name = 'Württemberg'
  and not exists (select 1 from public.appellations a
    where a.name = 'Württemberg' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Mittelrhein', 8 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mittelrhein', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Mittelrhein'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mittelrhein', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Mittelrhein' and s.name = 'Mittelrhein'
  and not exists (select 1 from public.appellations a
    where a.name = 'Mittelrhein' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ahr', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Ahr'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ahr', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Ahr' and s.name = 'Ahr'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ahr' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Saale-Unstrut', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Saale-Unstrut'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saale-Unstrut', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Saale-Unstrut' and s.name = 'Saale-Unstrut'
  and not exists (select 1 from public.appellations a
    where a.name = 'Saale-Unstrut' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sachsen', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Sachsen'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sachsen', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Sachsen' and s.name = 'Sachsen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sachsen' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hessische Bergstrasse', 12 from public.countries c where c.name = 'Germany'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Hessische Bergstrasse', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Germany' and r.name = 'Hessische Bergstrasse'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hessische Bergstrasse', 'Pradikatswein', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Germany' and r.name = 'Hessische Bergstrasse' and s.name = 'Hessische Bergstrasse'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hessische Bergstrasse' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Greece ────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Greece', 'GR', 'Europe', 21)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Epitrapezios Oinos', 'Table', 0
from public.countries c where c.name = 'Greece'
  and not exists (select 1 from public.appellations a
    where a.name = 'Epitrapezios Oinos' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Attiki', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Greece' and r.name = 'Attiki'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savatiano', 'PDO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Greece' and r.name = 'Attiki' and s.name = 'Attiki'
  and not exists (select 1 from public.appellations a
    where a.name = 'Savatiano' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Bortermelo Orszag', 'Table', 0
from public.countries c where c.name = 'Hungary'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bortermelo Orszag' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Eger', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Eger'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Egri Bikaver', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Eger' and s.name = 'Eger'
  and not exists (select 1 from public.appellations a
    where a.name = 'Egri Bikaver' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Villany', 2 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Villany', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Villany'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Villany', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Villany' and s.name = 'Villany'
  and not exists (select 1 from public.appellations a
    where a.name = 'Villany' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Szekszard', 3 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Szekszard', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Szekszard'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Szekszard', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Szekszard' and s.name = 'Szekszard'
  and not exists (select 1 from public.appellations a
    where a.name = 'Szekszard' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Somlo', 4 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Somlo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Somlo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Somlo', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Somlo' and s.name = 'Somlo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Somlo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Badacsony', 5 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Badacsony', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Badacsony'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Badacsony', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Badacsony' and s.name = 'Badacsony'
  and not exists (select 1 from public.appellations a
    where a.name = 'Badacsony' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Balatonfured-Csopak', 6 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Balatonfured-Csopak', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Balatonfured-Csopak'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Balatonfured-Csopak', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Balatonfured-Csopak' and s.name = 'Balatonfured-Csopak'
  and not exists (select 1 from public.appellations a
    where a.name = 'Balatonfured-Csopak' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Matra', 7 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Matra', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Matra'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Matra', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Matra' and s.name = 'Matra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Matra' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Etyek-Buda', 8 from public.countries c where c.name = 'Hungary'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Etyek-Buda', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Hungary' and r.name = 'Etyek-Buda'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Etyek-Buda', 'OEM', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Hungary' and r.name = 'Etyek-Buda' and s.name = 'Etyek-Buda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Etyek-Buda' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vino d''Italia', 'IGT', 0
from public.countries c where c.name = 'Italy'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino d''Italia' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Piemonte', 0 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Langhe Fantasia', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Langhe Fantasia' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Piemonte', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Piemonte'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Barolo', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barolo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Barbaresco', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbaresco' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Barbera d’Asti', 'DOCG', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbera d’Asti' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Barbera d’Alba', 'DOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Barbera d’Alba' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dolcetto d’Alba', 'DOC', 4
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dolcetto d’Alba' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moscato d’Asti', 'DOCG', 5
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Moscato d’Asti' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Asti Spumante', 'DOCG', 6
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Asti Spumante' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gavi', 'DOCG', 7
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gavi' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Roero', 'DOCG', 8
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Roero' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Langhe', 'DOC', 9
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Langhe' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nebbiolo d’Alba', 'DOC', 10
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nebbiolo d’Alba' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dogliani', 'DOCG', 11
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dogliani' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ghemme', 'DOCG', 12
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ghemme' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gattinara', 'DOCG', 13
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gattinara' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Brachetto d’Acqui', 'DOCG', 14
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Piemonte' and s.name = 'Piemonte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brachetto d’Acqui' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valle d’Aosta', 1 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valle d’Aosta', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Valle d’Aosta'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valle d’Aosta', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Valle d’Aosta' and s.name = 'Valle d’Aosta'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valle d’Aosta' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lombardia', 2 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Lombardia', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Lombardia' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lombardia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Lombardia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Franciacorta', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia' and s.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Franciacorta' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lugana', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia' and s.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lugana' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Oltrepo Pavese', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia' and s.name = 'Lombardia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Oltrepo Pavese' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valtellina', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Lombardia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valtellina Superiore', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia' and s.name = 'Valtellina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valtellina Superiore' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sforzato di Valtellina', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lombardia' and s.name = 'Valtellina'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sforzato di Valtellina' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Trentino-Alto Adige', 3 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Delle Venezie', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Delle Venezie' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alto Adige', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alto Adige', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige' and s.name = 'Alto Adige'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alto Adige' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Trentino', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Trentino-Alto Adige'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Trentino', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige' and s.name = 'Trentino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trentino' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Teroldego Rotaliano', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige' and s.name = 'Trentino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Teroldego Rotaliano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Trento', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Trentino-Alto Adige' and s.name = 'Trentino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trento' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Veneto', 4 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Delle Venezie', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Delle Venezie' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valpolicella', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Veneto'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Amarone della Valpolicella', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Valpolicella'
  and not exists (select 1 from public.appellations a
    where a.name = 'Amarone della Valpolicella' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valpolicella', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Valpolicella'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valpolicella' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valpolicella Ripasso', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Valpolicella'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valpolicella Ripasso' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Recioto della Valpolicella', 'DOCG', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Valpolicella'
  and not exists (select 1 from public.appellations a
    where a.name = 'Recioto della Valpolicella' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Soave', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Veneto'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Soave', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Soave'
  and not exists (select 1 from public.appellations a
    where a.name = 'Soave' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Soave Classico', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Soave'
  and not exists (select 1 from public.appellations a
    where a.name = 'Soave Classico' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Recioto di Soave', 'DOCG', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Soave'
  and not exists (select 1 from public.appellations a
    where a.name = 'Recioto di Soave' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Garda', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Veneto'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bardolino', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Garda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bardolino' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Prosecco', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Veneto'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Conegliano Valdobbiadene Prosecco Superiore', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Prosecco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Conegliano Valdobbiadene Prosecco Superiore' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Prosecco', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Veneto' and s.name = 'Prosecco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Prosecco' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Friuli-Venezia Giulia', 5 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Delle Venezie', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Delle Venezie' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Collio', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Collio Goriziano', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia' and s.name = 'Collio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Collio Goriziano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Colli Orientali', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Colli Orientali del Friuli', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia' and s.name = 'Colli Orientali'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Orientali del Friuli' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ramandolo', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia' and s.name = 'Colli Orientali'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ramandolo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Isonzo', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Friuli Isonzo', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia' and s.name = 'Isonzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Isonzo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Grave', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Friuli Grave', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Friuli-Venezia Giulia' and s.name = 'Grave'
  and not exists (select 1 from public.appellations a
    where a.name = 'Friuli Grave' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Liguria', 6 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Liguria', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Liguria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cinque Terre', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria' and s.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cinque Terre' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Riviera Ligure di Ponente', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Liguria' and s.name = 'Liguria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Riviera Ligure di Ponente' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Toscana', 7 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Toscana', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Toscana' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montalcino', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Toscana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Brunello di Montalcino', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Montalcino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Brunello di Montalcino' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rosso di Montalcino', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Montalcino'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso di Montalcino' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Chianti', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Toscana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chianti', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Chianti'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chianti' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chianti Classico', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Chianti'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chianti Classico' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vin Santo del Chianti Classico', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Chianti'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin Santo del Chianti Classico' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montepulciano', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Toscana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vino Nobile di Montepulciano', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Montepulciano'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino Nobile di Montepulciano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maremma', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Toscana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Morellino di Scansano', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Maremma'
  and not exists (select 1 from public.appellations a
    where a.name = 'Morellino di Scansano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maremma Toscana', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Maremma'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maremma Toscana' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'San Gimignano', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Toscana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vernaccia di San Gimignano', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'San Gimignano'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vernaccia di San Gimignano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bolgheri', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Toscana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bolgheri', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Bolgheri'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bolgheri' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bolgheri Sassicaia', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Bolgheri'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bolgheri Sassicaia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Carmignano', 6
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Toscana'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Carmignano', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Toscana' and s.name = 'Carmignano'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carmignano' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Umbria', 8 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Umbria', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Umbria' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montefalco', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Umbria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sagrantino di Montefalco', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria' and s.name = 'Montefalco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sagrantino di Montefalco' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montefalco Rosso', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria' and s.name = 'Montefalco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montefalco Rosso' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Orvieto', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Umbria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Orvieto', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria' and s.name = 'Orvieto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Orvieto' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Torgiano', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Umbria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Torgiano Rosso Riserva', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Umbria' and s.name = 'Torgiano'
  and not exists (select 1 from public.appellations a
    where a.name = 'Torgiano Rosso Riserva' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Marche', 9 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Marche', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Marche' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Castelli di Jesi', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Marche'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Verdicchio dei Castelli di Jesi', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche' and s.name = 'Castelli di Jesi'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verdicchio dei Castelli di Jesi' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Verdicchio dei Castelli di Jesi Classico Superiore', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche' and s.name = 'Castelli di Jesi'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verdicchio dei Castelli di Jesi Classico Superiore' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Matelica', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Marche'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Verdicchio di Matelica', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche' and s.name = 'Matelica'
  and not exists (select 1 from public.appellations a
    where a.name = 'Verdicchio di Matelica' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Conero', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Marche'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rosso Conero', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche' and s.name = 'Conero'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rosso Conero' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Offida', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Marche'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Offida', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Marche' and s.name = 'Offida'
  and not exists (select 1 from public.appellations a
    where a.name = 'Offida' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Abruzzo', 10 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Terre di Chieti', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Terre di Chieti' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Abruzzo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Abruzzo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montepulciano d’Abruzzo', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo' and s.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montepulciano d’Abruzzo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montepulciano d’Abruzzo Colline Teramane', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo' and s.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montepulciano d’Abruzzo Colline Teramane' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Trebbiano d’Abruzzo', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Abruzzo' and s.name = 'Abruzzo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Trebbiano d’Abruzzo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Molise', 11 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Molise', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Molise'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tintilia del Molise', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Molise' and s.name = 'Molise'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tintilia del Molise' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lazio', 12 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Lazio', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Lazio' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Castelli Romani', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Lazio'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Frascati', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio' and s.name = 'Castelli Romani'
  and not exists (select 1 from public.appellations a
    where a.name = 'Frascati' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Frascati Superiore', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio' and s.name = 'Castelli Romani'
  and not exists (select 1 from public.appellations a
    where a.name = 'Frascati Superiore' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montefiascone', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Lazio'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Est! Est!! Est!!! di Montefiascone', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio' and s.name = 'Montefiascone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Est! Est!! Est!!! di Montefiascone' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ciociaria', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Lazio'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cesanese del Piglio', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Lazio' and s.name = 'Ciociaria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cesanese del Piglio' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Campania', 13 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Campania', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Campania' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Irpinia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Campania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Taurasi', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania' and s.name = 'Irpinia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Taurasi' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fiano di Avellino', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania' and s.name = 'Irpinia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fiano di Avellino' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Greco di Tufo', 'DOCG', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania' and s.name = 'Irpinia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Greco di Tufo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Campi Flegrei', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Campania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Campi Flegrei', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania' and s.name = 'Campi Flegrei'
  and not exists (select 1 from public.appellations a
    where a.name = 'Campi Flegrei' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sannio', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Campania'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sannio', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Campania' and s.name = 'Sannio'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sannio' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Basilicata', 14 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Basilicata', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Basilicata' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vulture', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Basilicata'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aglianico del Vulture', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata' and s.name = 'Vulture'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aglianico del Vulture' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aglianico del Vulture Superiore', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Basilicata' and s.name = 'Vulture'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aglianico del Vulture Superiore' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Calabria', 15 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Calabria', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Calabria' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ciro', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Calabria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ciro', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria' and s.name = 'Ciro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ciro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cosenza', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Calabria'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Terre di Cosenza', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Calabria' and s.name = 'Cosenza'
  and not exists (select 1 from public.appellations a
    where a.name = 'Terre di Cosenza' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Puglia', 16 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Puglia', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Puglia' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Manduria', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Puglia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Primitivo di Manduria', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia' and s.name = 'Manduria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Primitivo di Manduria' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Primitivo di Manduria Dolce Naturale', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia' and s.name = 'Manduria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Primitivo di Manduria Dolce Naturale' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Salento', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Puglia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Salice Salentino', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia' and s.name = 'Salento'
  and not exists (select 1 from public.appellations a
    where a.name = 'Salice Salentino' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Castel del Monte', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Puglia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Castel del Monte', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia' and s.name = 'Castel del Monte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castel del Monte' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Castel del Monte Bombino Nero', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia' and s.name = 'Castel del Monte'
  and not exists (select 1 from public.appellations a
    where a.name = 'Castel del Monte Bombino Nero' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Terra d’Otranto', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Puglia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Negroamaro di Terra d’Otranto', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia' and s.name = 'Terra d’Otranto'
  and not exists (select 1 from public.appellations a
    where a.name = 'Negroamaro di Terra d’Otranto' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gioia del Colle', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Puglia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gioia del Colle', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Puglia' and s.name = 'Gioia del Colle'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gioia del Colle' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sicilia', 17 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Terre Siciliane', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Terre Siciliane' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Etna', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sicilia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Etna', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia' and s.name = 'Etna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Etna' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Trapani', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sicilia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marsala', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia' and s.name = 'Trapani'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marsala' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pantelleria', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sicilia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Passito di Pantelleria', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia' and s.name = 'Pantelleria'
  and not exists (select 1 from public.appellations a
    where a.name = 'Passito di Pantelleria' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Ragusa', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sicilia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cerasuolo di Vittoria', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia' and s.name = 'Ragusa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cerasuolo di Vittoria' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sicilia', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sicilia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sicilia', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sicilia' and s.name = 'Sicilia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sicilia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Sardegna', 18 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Isola dei Nuraghi', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Isola dei Nuraghi' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sardegna', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sardegna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cannonau di Sardegna', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna' and s.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cannonau di Sardegna' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vermentino di Sardegna', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna' and s.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vermentino di Sardegna' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monica di Sardegna', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna' and s.name = 'Sardegna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Monica di Sardegna' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gallura', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sardegna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vermentino di Gallura', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna' and s.name = 'Gallura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vermentino di Gallura' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sulcis', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sardegna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Carignano del Sulcis', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna' and s.name = 'Sulcis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Carignano del Sulcis' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Planargia', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Sardegna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Malvasia di Bosa', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Sardegna' and s.name = 'Planargia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Malvasia di Bosa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Emilia-Romagna', 19 from public.countries c where c.name = 'Italy'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'IGT Emilia', 'IGT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'IGT Emilia' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Modena', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Emilia-Romagna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lambrusco di Sorbara', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna' and s.name = 'Modena'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lambrusco di Sorbara' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lambrusco Grasparossa di Castelvetro', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna' and s.name = 'Modena'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lambrusco Grasparossa di Castelvetro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lambrusco Salamino di Santa Croce', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna' and s.name = 'Modena'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lambrusco Salamino di Santa Croce' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Romagna', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Emilia-Romagna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sangiovese di Romagna', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna' and s.name = 'Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Sangiovese di Romagna' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Albana di Romagna', 'DOCG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna' and s.name = 'Romagna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Albana di Romagna' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bologna', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Italy' and r.name = 'Emilia-Romagna'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Colli Bolognesi Pignoletto', 'DOCG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Italy' and r.name = 'Emilia-Romagna' and s.name = 'Bologna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colli Bolognesi Pignoletto' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Japan ─────────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Japan', 'JP', 'Asia', 26)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Japanese Wine', 'National', 0
from public.countries c where c.name = 'Japan'
  and not exists (select 1 from public.appellations a
    where a.name = 'Japanese Wine' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Guanajuato', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Mexico' and r.name = 'Guanajuato'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Guanajuato', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Mexico' and r.name = 'Guanajuato' and s.name = 'Guanajuato'
  and not exists (select 1 from public.appellations a
    where a.name = 'Guanajuato' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── Moldova ───────────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('Moldova', 'MD', 'Europe', 31)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vin de masa', 'Table', 0
from public.countries c where c.name = 'Moldova'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin de masa' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Codru', 0 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Codru', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Moldova' and r.name = 'Codru'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Codru', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Codru' and s.name = 'Codru'
  and not exists (select 1 from public.appellations a
    where a.name = 'Codru' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valul lui Traian', 1 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valul lui Traian', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Moldova' and r.name = 'Valul lui Traian'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valul lui Traian', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Valul lui Traian' and s.name = 'Valul lui Traian'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valul lui Traian' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Stefan Voda', 2 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Stefan Voda', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Moldova' and r.name = 'Stefan Voda'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Stefan Voda', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Stefan Voda' and s.name = 'Stefan Voda'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stefan Voda' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Balti', 3 from public.countries c where c.name = 'Moldova'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Balti', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Moldova' and r.name = 'Balti'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Balti', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Moldova' and r.name = 'Balti' and s.name = 'Balti'
  and not exists (select 1 from public.appellations a
    where a.name = 'Balti' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'sub_region', s.id, 'Beni M’Tir', 'AOG', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Morocco' and r.name = 'Meknes-Fes' and s.name = 'Meknes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Beni M’Tir' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'New Zealand Wine', 'National', 0
from public.countries c where c.name = 'New Zealand'
  and not exists (select 1 from public.appellations a
    where a.name = 'New Zealand Wine' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wairau Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Marlborough'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marlborough', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Marlborough' and s.name = 'Wairau Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marlborough' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Awatere Valley', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Marlborough'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marlborough', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Marlborough' and s.name = 'Awatere Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marlborough' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Southern Valleys', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Marlborough'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marlborough', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Marlborough' and s.name = 'Southern Valleys'
  and not exists (select 1 from public.appellations a
    where a.name = 'Marlborough' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Hawke’s Bay', 1 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gimblett Gravels', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Hawke’s Bay'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hawke’s Bay', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Hawke’s Bay' and s.name = 'Gimblett Gravels'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hawke’s Bay' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bridge Pa Triangle', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Hawke’s Bay'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hawke’s Bay', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Hawke’s Bay' and s.name = 'Bridge Pa Triangle'
  and not exists (select 1 from public.appellations a
    where a.name = 'Hawke’s Bay' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bannockburn', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Central Otago', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago' and s.name = 'Bannockburn'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cromwell Basin', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Central Otago', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago' and s.name = 'Cromwell Basin'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gibbston', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Central Otago', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago' and s.name = 'Gibbston'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Wanaka', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Central Otago', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago' and s.name = 'Wanaka'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bendigo', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Central Otago', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago' and s.name = 'Bendigo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alexandra', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Central Otago'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Central Otago', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Central Otago' and s.name = 'Alexandra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Central Otago' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Canterbury', 3 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Waipara Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Canterbury'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Canterbury', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Canterbury' and s.name = 'Waipara Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canterbury' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Christchurch Plains', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Canterbury'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Canterbury', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Canterbury' and s.name = 'Christchurch Plains'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canterbury' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Waimea Plains', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Nelson'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nelson', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Nelson' and s.name = 'Waimea Plains'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nelson' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Moutere Hills', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Nelson'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nelson', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Nelson' and s.name = 'Moutere Hills'
  and not exists (select 1 from public.appellations a
    where a.name = 'Nelson' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Waitaki Valley', 6 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Waitaki Valley', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Waitaki Valley'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Waitaki Valley', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Waitaki Valley' and s.name = 'Waitaki Valley'
  and not exists (select 1 from public.appellations a
    where a.name = 'Waitaki Valley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Gisborne', 7 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gisborne', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Gisborne'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gisborne', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Gisborne' and s.name = 'Gisborne'
  and not exists (select 1 from public.appellations a
    where a.name = 'Gisborne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Auckland', 8 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Waiheke Island', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Auckland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Auckland', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Auckland' and s.name = 'Waiheke Island'
  and not exists (select 1 from public.appellations a
    where a.name = 'Auckland' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Henderson', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Auckland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Auckland', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Auckland' and s.name = 'Henderson'
  and not exists (select 1 from public.appellations a
    where a.name = 'Auckland' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Matakana', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Auckland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Auckland', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Auckland' and s.name = 'Matakana'
  and not exists (select 1 from public.appellations a
    where a.name = 'Auckland' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Northland', 9 from public.countries c where c.name = 'New Zealand'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Northland', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'New Zealand' and r.name = 'Northland'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Northland', 'GI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'New Zealand' and r.name = 'Northland' and s.name = 'Northland'
  and not exists (select 1 from public.appellations a
    where a.name = 'Northland' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'region', r.id, 'Vinho Regional Transmontano', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Douro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Transmontano' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Douro Superior', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Douro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Douro', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Douro' and s.name = 'Douro Superior'
  and not exists (select 1 from public.appellations a
    where a.name = 'Douro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cima Corgo', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Douro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Douro', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Douro' and s.name = 'Cima Corgo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Douro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Baixo Corgo', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Douro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Douro', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Douro' and s.name = 'Baixo Corgo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Douro' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Douro', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Douro'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vinho do Porto', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Douro' and s.name = 'Douro'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho do Porto' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vinho Verde', 1 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Regional Minho', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Vinho Verde'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Minho' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Minho', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Vinho Verde'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vinho Verde', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Vinho Verde' and s.name = 'Minho'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Verde' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Moncao e Melgaco', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Vinho Verde'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vinho Verde', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Vinho Verde' and s.name = 'Moncao e Melgaco'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Verde' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Dao', 2 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Regional Beiras', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Dao'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Beiras' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Dao', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Dao'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dao', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Dao' and s.name = 'Dao'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dao' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Bairrada', 3 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Regional Beiras', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Bairrada'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Beiras' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bairrada', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Bairrada'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bairrada', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Bairrada' and s.name = 'Bairrada'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bairrada' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Alentejo', 4 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Regional Alentejano', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Alentejo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Alentejano' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Alentejo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Alentejo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Alentejo', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Alentejo' and s.name = 'Alentejo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Alentejo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Peninsula de Setubal', 5 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Regional Peninsula de Setubal', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Peninsula de Setubal'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Peninsula de Setubal' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Vinho Regional Lisboa', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Lisboa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Lisboa' and a.level = 'region' and a.region_id = r.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lisboa', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Lisboa'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lisboa', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Lisboa' and s.name = 'Lisboa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lisboa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Tejo', 7 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Regional Tejo', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Tejo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Tejo' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tejo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Tejo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tejo', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Tejo' and s.name = 'Tejo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tejo' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Algarve', 8 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Regional Algarve', 'Vinho Regional', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho Regional Algarve' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Algarve', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Algarve'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lagos', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve' and s.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lagos' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Portimao', 'DOC', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve' and s.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Portimao' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lagoa', 'DOC', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve' and s.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lagoa' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tavira', 'DOC', 3
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Algarve' and s.name = 'Algarve'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tavira' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Tras-os-Montes', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Tras-os-Montes'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tras-os-Montes', 'IG', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Tras-os-Montes' and s.name = 'Tras-os-Montes'
  and not exists (select 1 from public.appellations a
    where a.name = 'Tras-os-Montes' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Madeira', 11 from public.countries c where c.name = 'Portugal'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Madeira', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Portugal' and r.name = 'Madeira'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vinho da Madeira', 'DOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Portugal' and r.name = 'Madeira' and s.name = 'Madeira'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vinho da Madeira' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Fruska Gora', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Serbia' and r.name = 'Fruska Gora'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fruska Gora', 'KGP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Serbia' and r.name = 'Fruska Gora' and s.name = 'Fruska Gora'
  and not exists (select 1 from public.appellations a
    where a.name = 'Fruska Gora' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Stolove Vino', 'Table', 0
from public.countries c where c.name = 'Slovakia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Stolove Vino' and a.level = 'country' and a.country_id = c.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Namizno Vino', 'Table', 0
from public.countries c where c.name = 'Slovenia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Namizno Vino' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'KwaZulu-Natal', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'South Africa' and r.name = 'KwaZulu-Natal'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'KwaZulu-Natal', 'WO Geographical Unit', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'South Africa' and r.name = 'KwaZulu-Natal' and s.name = 'KwaZulu-Natal'
  and not exists (select 1 from public.appellations a
    where a.name = 'KwaZulu-Natal' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'region', r.id, 'Vino de la Tierra Castilla', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Rioja'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Castilla' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rioja Alta', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Rioja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rioja', 'DOCa', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Rioja' and s.name = 'Rioja Alta'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rioja' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rioja Alavesa', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Rioja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rioja', 'DOCa', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Rioja' and s.name = 'Rioja Alavesa'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rioja' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rioja Oriental', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Rioja'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rioja', 'DOCa', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Rioja' and s.name = 'Rioja Oriental'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rioja' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Priorat', 1 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Priorat', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Priorat'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Priorat', 'DOCa', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Priorat' and s.name = 'Priorat'
  and not exists (select 1 from public.appellations a
    where a.name = 'Priorat' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Cataluna', 2 from public.countries c where c.name = 'Spain'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vino de la Tierra Cataluna', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Cataluna'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Cataluna' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Vino de la Tierra Barbanza e Iria', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Galicia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Barbanza e Iria' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Vino de la Tierra Castilla y Leon', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla y Leon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Castilla y Leon' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Vino de la Tierra Castilla-La Mancha', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Castilla-La Mancha'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Castilla-La Mancha' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Vino de la Tierra Valencia', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Valencia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Valencia' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Valencia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Valencia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valencia', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Valencia' and s.name = 'Valencia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valencia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Utiel-Requena', 1
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
select r.id, 'Alicante', 2
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
select 'region', r.id, 'Vino de la Tierra Bajo Aragon', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Aragon'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Bajo Aragon' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Vino de la Tierra Navarra', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Navarra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Navarra' and a.level = 'region' and a.region_id = r.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Navarra', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Spain' and r.name = 'Navarra'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Navarra', 'DO', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Navarra' and s.name = 'Navarra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Navarra' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pago de Arinzano', 'VP', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Navarra' and s.name = 'Navarra'
  and not exists (select 1 from public.appellations a
    where a.name = 'Pago de Arinzano' and a.level = 'sub_region' and a.sub_region_id = s.id);

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
select 'region', r.id, 'Vino de la Tierra Extremadura', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Extremadura'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Extremadura' and a.level = 'region' and a.region_id = r.id);

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
select 'region', r.id, 'Vino de la Tierra Cadiz', 'VdlT', 0
from public.regions r
  join public.countries c on c.id = r.country_id
  where c.name = 'Spain' and r.name = 'Andalucia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vino de la Tierra Cadiz' and a.level = 'region' and a.region_id = r.id);

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

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vin de Table / Tafelwein', 'Tafelwein', 0
from public.countries c where c.name = 'Switzerland'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vin de Table / Tafelwein' and a.level = 'country' and a.country_id = c.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valais', 0 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sion & Zentralwallis', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Valais'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valais', 'AOC Valais', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Valais' and s.name = 'Sion & Zentralwallis'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Leytron / Chamoson / Fully', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Valais'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valais', 'AOC Valais', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Valais' and s.name = 'Leytron / Chamoson / Fully'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Visperterminen', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Valais'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valais', 'AOC Valais', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Valais' and s.name = 'Visperterminen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Valais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Vaud', 1 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'La Cote', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Vaud'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Cote', 'AOC Vaud', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'La Cote'
  and not exists (select 1 from public.appellations a
    where a.name = 'La Cote' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lavaux', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Vaud'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lavaux', 'AOC Vaud', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Lavaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Lavaux' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Dezaley', 'AOC Vaud', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Lavaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Dezaley' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Calamin', 'AOC Vaud', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Lavaux'
  and not exists (select 1 from public.appellations a
    where a.name = 'Calamin' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Chablais', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Vaud'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chablais', 'AOC Vaud', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Chablais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Chablais' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Yvorne', 'AOC Vaud', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Chablais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Yvorne' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aigle', 'AOC Vaud', 2
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Chablais'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aigle' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cotes de l’Orbe', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Vaud'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de l’Orbe', 'AOC Vaud', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Cotes de l’Orbe'
  and not exists (select 1 from public.appellations a
    where a.name = 'Cotes de l’Orbe' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bonvillars', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Vaud'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bonvillars', 'AOC Vaud', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Bonvillars'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bonvillars' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vully (vaudois)', 5
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Vaud'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vully', 'AOC Vaud', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Vaud' and s.name = 'Vully (vaudois)'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vully' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Genève', 2 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Mandement', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Genève'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Geneve', 'AOC Geneve', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Genève' and s.name = 'Mandement'
  and not exists (select 1 from public.appellations a
    where a.name = 'Geneve' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Arve-et-Lac', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Genève'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Geneve', 'AOC Geneve', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Genève' and s.name = 'Arve-et-Lac'
  and not exists (select 1 from public.appellations a
    where a.name = 'Geneve' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Arve-et-Rhone', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Genève'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Geneve', 'AOC Geneve', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Genève' and s.name = 'Arve-et-Rhone'
  and not exists (select 1 from public.appellations a
    where a.name = 'Geneve' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Drei Seen', 3 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Neuchâtel', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Drei Seen'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Neuchatel', 'AOC Neuchatel', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Drei Seen' and s.name = 'Neuchâtel'
  and not exists (select 1 from public.appellations a
    where a.name = 'Neuchatel' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vully (fribourgeois)', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Drei Seen'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vully', 'AOC Fribourg', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Drei Seen' and s.name = 'Vully (fribourgeois)'
  and not exists (select 1 from public.appellations a
    where a.name = 'Vully' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bielersee', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Drei Seen'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bielersee', 'AOC', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Drei Seen' and s.name = 'Bielersee'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bielersee' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Deutschschweiz', 4 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Zürich', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zurich', 'AOC Zurich', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz' and s.name = 'Zürich'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zurich' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zürichsee', 'AOC Zurich', 1
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz' and s.name = 'Zürich'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zürichsee' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Schaffhausen', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Schaffhausen', 'AOC Schaffhausen', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz' and s.name = 'Schaffhausen'
  and not exists (select 1 from public.appellations a
    where a.name = 'Schaffhausen' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Thurgau', 2
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Thurgau', 'AOC Thurgau', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz' and s.name = 'Thurgau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Thurgau' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Aargau', 3
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aargau', 'AOC Aargau', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz' and s.name = 'Aargau'
  and not exists (select 1 from public.appellations a
    where a.name = 'Aargau' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Graubünden', 4
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Deutschschweiz'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bündner Herrschaft', 'AOC Graubünden', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Deutschschweiz' and s.name = 'Graubünden'
  and not exists (select 1 from public.appellations a
    where a.name = 'Bündner Herrschaft' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Ticino', 5 from public.countries c where c.name = 'Switzerland'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sopraceneri', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Ticino'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ticino', 'DOC Ticino', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Ticino' and s.name = 'Sopraceneri'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ticino' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sottoceneri', 1
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Switzerland' and r.name = 'Ticino'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ticino', 'DOC Ticino', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Switzerland' and r.name = 'Ticino' and s.name = 'Sottoceneri'
  and not exists (select 1 from public.appellations a
    where a.name = 'Ticino' and a.level = 'sub_region' and a.sub_region_id = s.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Zakarpattia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Ukraine' and r.name = 'Zakarpattia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Zakarpattia', 'PGI', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Ukraine' and r.name = 'Zakarpattia' and s.name = 'Zakarpattia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Zakarpattia' and a.level = 'sub_region' and a.sub_region_id = s.id);

-- ── United States ─────────────────────────────────────────────────────
insert into public.countries (name, code, continent, sort_order)
values ('United States', 'US', 'Americas', 49)
on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'American Wine', 'National', 0
from public.countries c where c.name = 'United States'
  and not exists (select 1 from public.appellations a
    where a.name = 'American Wine' and a.level = 'country' and a.country_id = c.id);

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

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Canelones', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Uruguay' and r.name = 'Canelones'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Canelones', 'DOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Canelones' and s.name = 'Canelones'
  and not exists (select 1 from public.appellations a
    where a.name = 'Canelones' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Maldonado', 1 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maldonado', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Uruguay' and r.name = 'Maldonado'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maldonado', 'DOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Maldonado' and s.name = 'Maldonado'
  and not exists (select 1 from public.appellations a
    where a.name = 'Maldonado' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Colonia', 2 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Colonia', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Uruguay' and r.name = 'Colonia'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Colonia', 'DOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Colonia' and s.name = 'Colonia'
  and not exists (select 1 from public.appellations a
    where a.name = 'Colonia' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rivera', 3 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rivera', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Uruguay' and r.name = 'Rivera'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rivera', 'DOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Rivera' and s.name = 'Rivera'
  and not exists (select 1 from public.appellations a
    where a.name = 'Rivera' and a.level = 'sub_region' and a.sub_region_id = s.id);

insert into public.regions (country_id, name, sort_order)
select c.id, 'Montevideo', 4 from public.countries c where c.name = 'Uruguay'
on conflict (country_id, name) do update set sort_order = excluded.sort_order;

insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montevideo', 0
from public.regions r join public.countries c on c.id = r.country_id
where c.name = 'Uruguay' and r.name = 'Montevideo'
on conflict (region_id, name) do update set sort_order = excluded.sort_order;

insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montevideo', 'DOP', 0
from public.sub_regions s
  join public.regions r on r.id = s.region_id
  join public.countries c on c.id = r.country_id
  where c.name = 'Uruguay' and r.name = 'Montevideo' and s.name = 'Montevideo'
  and not exists (select 1 from public.appellations a
    where a.name = 'Montevideo' and a.level = 'sub_region' and a.sub_region_id = s.id);

commit;
