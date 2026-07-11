-- Geo-Hygiene-Fix (see docs/REBUILD_PLAN.md Anhang D, 2026-07-11)
-- Mirrors the cleanup applied to data/geography/*.json for the already-seeded
-- prod DB. Idempotent and no-op-safe on an empty DB (local `db reset` runs
-- migrations BEFORE seed.sql, which already contains the clean data).
--
-- 1. rename regions/sub_regions/appellations (apostrophes, accents, prefixes)
-- 2. consolidate per-sub-region duplicate copies onto ONE region-level row
--    (re-pointing wine FKs first), lift country-wide ones to country level
-- 3. delete the bogus 'IGP Vin de Pays d'Oc' (was wrongly under Beaujolais;
--    wines re-pointed to the real Languedoc 'Pays d'Oc')
-- 4. fix types: 'Vin de France' is not AOC; Swiss 'AOC Valais' etc. -> 'AOC'
-- 5. wines.classification: drop tokens that merely repeat the linked
--    appellation's type (user-approved data cleanup)

begin;

-- ── 1. renames ───────────────────────────────────────────────────────────────
update public.regions set name = 'Hawke''s Bay' where name = 'Hawke’s Bay';
update public.regions set name = 'Valle d''Aosta' where name = 'Valle d’Aosta';
update public.sub_regions set name = 'Cantons de l''Est' where name = 'Cantons de l’Est';
update public.sub_regions set name = 'Cotes de l''Orbe' where name = 'Cotes de l’Orbe';
update public.sub_regions set name = 'Terra d''Otranto' where name = 'Terra d’Otranto';
update public.sub_regions set name = 'Valle d''Aosta' where name = 'Valle d’Aosta';
update public.appellations set name = 'Barbera d''Alba' where name = 'Barbera d’Alba';
update public.appellations set name = 'Barbera d''Asti' where name = 'Barbera d’Asti';
update public.appellations set name = 'Beni M''Tir' where name = 'Beni M’Tir';
update public.appellations set name = 'Brachetto d''Acqui' where name = 'Brachetto d’Acqui';
update public.appellations set name = 'Cantons de l''Est' where name = 'Cantons de l’Est';
update public.appellations set name = 'Coteaux d''Aix-en-Provence' where name = 'Coteaux d’Aix-en-Provence';
update public.appellations set name = 'Cotes de l''Orbe' where name = 'Cotes de l’Orbe';
update public.appellations set name = 'Cremant d''Alsace' where name = 'Cremant d’Alsace';
update public.appellations set name = 'Dolcetto d''Alba' where name = 'Dolcetto d’Alba';
update public.appellations set name = 'Hawke''s Bay' where name = 'Hawke’s Bay';
update public.appellations set name = 'L''Etoile' where name = 'L’Etoile';
update public.appellations set name = 'Montepulciano d''Abruzzo' where name = 'Montepulciano d’Abruzzo';
update public.appellations set name = 'Montepulciano d''Abruzzo Colline Teramane' where name = 'Montepulciano d’Abruzzo Colline Teramane';
update public.appellations set name = 'Moscato d''Asti' where name = 'Moscato d’Asti';
update public.appellations set name = 'Nebbiolo d''Alba' where name = 'Nebbiolo d’Alba';
update public.appellations set name = 'Negroamaro di Terra d''Otranto' where name = 'Negroamaro di Terra d’Otranto';
update public.appellations set name = 'Trebbiano d''Abruzzo' where name = 'Trebbiano d’Abruzzo';
update public.appellations set name = 'Valle d''Aosta' where name = 'Valle d’Aosta';
update public.appellations set name = 'Alsace' where name = 'AOC Alsace';
update public.appellations set name = 'Bordeaux' where name = 'AOC Bordeaux';
update public.appellations set name = 'Bourgogne' where name = 'AOC Bourgogne';
update public.appellations set name = 'Champagne' where name = 'AOC Champagne';
update public.appellations set name = 'Cotes du Rhone' where name = 'AOC Cotes du Rhone';
update public.appellations set name = 'Cotes d''Auvergne' where name = 'Côtes d''Auvergne';
update public.appellations set name = 'Atlantique' where name = 'IGP Atlantique';
update public.appellations set name = 'Comtes Tolosan' where name = 'IGP Comtes Tolosan';
update public.appellations set name = 'Mediterranee' where name = 'IGP Mediterranee';
update public.appellations set name = 'Pays d''Oc' where name = 'IGP Pays d''Oc';
update public.appellations set name = 'Val de Loire' where name = 'IGP Val de Loire';
update public.appellations set name = 'Larnaka' where name = 'PGI Larnaka';
update public.appellations set name = 'Lefkosia' where name = 'PGI Lefkosia';
update public.appellations set name = 'Lemesos' where name = 'PGI Lemesos';
update public.appellations set name = 'Pafos' where name = 'PGI Pafos';
update public.appellations set name = 'Saint-Pourcain' where name = 'Saint-Pourçain';

-- ── 2. consolidations (survivor -> re-point wines -> drop copies) ───────────

-- France > Champagne: 'Champagne' (AOC)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Champagne', 'AOC', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'France' and r.name = 'Champagne'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Champagne');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'France' and r.name = 'Champagne'
   and surv.level = 'region' and surv.name = 'Champagne'
   and copy.level = 'sub_region' and copy.name = 'Champagne' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'France' and r.name = 'Champagne'
   and a.level = 'sub_region' and a.name = 'Champagne';

-- Germany > Mosel: 'Mosel' (Pradikatswein)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mosel', 'Pradikatswein', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Germany' and r.name = 'Mosel'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Mosel');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Germany' and r.name = 'Mosel'
   and surv.level = 'region' and surv.name = 'Mosel'
   and copy.level = 'sub_region' and copy.name = 'Mosel' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Germany' and r.name = 'Mosel'
   and a.level = 'sub_region' and a.name = 'Mosel';

-- Germany > Baden: 'Baden' (Pradikatswein)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Baden', 'Pradikatswein', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Germany' and r.name = 'Baden'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Baden');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Germany' and r.name = 'Baden'
   and surv.level = 'region' and surv.name = 'Baden'
   and copy.level = 'sub_region' and copy.name = 'Baden' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Germany' and r.name = 'Baden'
   and a.level = 'sub_region' and a.name = 'Baden';

-- New Zealand > Marlborough: 'Marlborough' (GI)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marlborough', 'GI', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'New Zealand' and r.name = 'Marlborough'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Marlborough');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'New Zealand' and r.name = 'Marlborough'
   and surv.level = 'region' and surv.name = 'Marlborough'
   and copy.level = 'sub_region' and copy.name = 'Marlborough' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'New Zealand' and r.name = 'Marlborough'
   and a.level = 'sub_region' and a.name = 'Marlborough';

-- New Zealand > Hawke's Bay: 'Hawke's Bay' (GI)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hawke''s Bay', 'GI', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'New Zealand' and r.name = 'Hawke''s Bay'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Hawke''s Bay');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'New Zealand' and r.name = 'Hawke''s Bay'
   and surv.level = 'region' and surv.name = 'Hawke''s Bay'
   and copy.level = 'sub_region' and copy.name = 'Hawke''s Bay' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'New Zealand' and r.name = 'Hawke''s Bay'
   and a.level = 'sub_region' and a.name = 'Hawke''s Bay';

-- New Zealand > Central Otago: 'Central Otago' (GI)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Otago', 'GI', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'New Zealand' and r.name = 'Central Otago'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Central Otago');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'New Zealand' and r.name = 'Central Otago'
   and surv.level = 'region' and surv.name = 'Central Otago'
   and copy.level = 'sub_region' and copy.name = 'Central Otago' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'New Zealand' and r.name = 'Central Otago'
   and a.level = 'sub_region' and a.name = 'Central Otago';

-- New Zealand > Canterbury: 'Canterbury' (GI)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canterbury', 'GI', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'New Zealand' and r.name = 'Canterbury'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Canterbury');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'New Zealand' and r.name = 'Canterbury'
   and surv.level = 'region' and surv.name = 'Canterbury'
   and copy.level = 'sub_region' and copy.name = 'Canterbury' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'New Zealand' and r.name = 'Canterbury'
   and a.level = 'sub_region' and a.name = 'Canterbury';

-- New Zealand > Nelson: 'Nelson' (GI)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nelson', 'GI', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'New Zealand' and r.name = 'Nelson'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Nelson');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'New Zealand' and r.name = 'Nelson'
   and surv.level = 'region' and surv.name = 'Nelson'
   and copy.level = 'sub_region' and copy.name = 'Nelson' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'New Zealand' and r.name = 'Nelson'
   and a.level = 'sub_region' and a.name = 'Nelson';

-- New Zealand > Auckland: 'Auckland' (GI)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Auckland', 'GI', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'New Zealand' and r.name = 'Auckland'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Auckland');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'New Zealand' and r.name = 'Auckland'
   and surv.level = 'region' and surv.name = 'Auckland'
   and copy.level = 'sub_region' and copy.name = 'Auckland' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'New Zealand' and r.name = 'Auckland'
   and a.level = 'sub_region' and a.name = 'Auckland';

-- Portugal > Douro: 'Douro' (DOC)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Douro', 'DOC', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Portugal' and r.name = 'Douro'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Douro');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Portugal' and r.name = 'Douro'
   and surv.level = 'region' and surv.name = 'Douro'
   and copy.level = 'sub_region' and copy.name = 'Douro' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Portugal' and r.name = 'Douro'
   and a.level = 'sub_region' and a.name = 'Douro';

-- Portugal > Vinho Verde: 'Vinho Verde' (DOC)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Verde', 'DOC', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Portugal' and r.name = 'Vinho Verde'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Vinho Verde');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Portugal' and r.name = 'Vinho Verde'
   and surv.level = 'region' and surv.name = 'Vinho Verde'
   and copy.level = 'sub_region' and copy.name = 'Vinho Verde' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Portugal' and r.name = 'Vinho Verde'
   and a.level = 'sub_region' and a.name = 'Vinho Verde';

-- Spain > Rioja: 'Rioja' (DOCa)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rioja', 'DOCa', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Spain' and r.name = 'Rioja'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Rioja');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Spain' and r.name = 'Rioja'
   and surv.level = 'region' and surv.name = 'Rioja'
   and copy.level = 'sub_region' and copy.name = 'Rioja' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Spain' and r.name = 'Rioja'
   and a.level = 'sub_region' and a.name = 'Rioja';

-- Switzerland > Valais: 'Valais' (AOC)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valais', 'AOC', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Switzerland' and r.name = 'Valais'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Valais');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Switzerland' and r.name = 'Valais'
   and surv.level = 'region' and surv.name = 'Valais'
   and copy.level = 'sub_region' and copy.name = 'Valais' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Switzerland' and r.name = 'Valais'
   and a.level = 'sub_region' and a.name = 'Valais';

-- Switzerland > Genève: 'Geneve' (AOC)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Geneve', 'AOC', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Switzerland' and r.name = 'Genève'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Geneve');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Switzerland' and r.name = 'Genève'
   and surv.level = 'region' and surv.name = 'Geneve'
   and copy.level = 'sub_region' and copy.name = 'Geneve' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Switzerland' and r.name = 'Genève'
   and a.level = 'sub_region' and a.name = 'Geneve';

-- Switzerland > Ticino: 'Ticino' (DOC)
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ticino', 'DOC', 0
  from public.regions r join public.countries c on c.id = r.country_id
 where c.name = 'Switzerland' and r.name = 'Ticino'
   and not exists (select 1 from public.appellations a
                    where a.level = 'region' and a.region_id = r.id and a.name = 'Ticino');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv
  join public.regions r on r.id = surv.region_id
  join public.countries c on c.id = r.country_id,
       public.appellations copy
  join public.sub_regions s on s.id = copy.sub_region_id
 where c.name = 'Switzerland' and r.name = 'Ticino'
   and surv.level = 'region' and surv.name = 'Ticino'
   and copy.level = 'sub_region' and copy.name = 'Ticino' and s.region_id = r.id
   and w.appellation_id = copy.id;
delete from public.appellations a
 using public.sub_regions s, public.regions r, public.countries c
 where a.sub_region_id = s.id and s.region_id = r.id and r.country_id = c.id
   and c.name = 'Switzerland' and r.name = 'Ticino'
   and a.level = 'sub_region' and a.name = 'Ticino';

-- England & Wales: 'English Wine' -> country level
insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'English Wine', 'PGI', 0
  from public.countries c
 where c.name = 'England & Wales'
   and not exists (select 1 from public.appellations a
                    where a.level = 'country' and a.country_id = c.id and a.name = 'English Wine');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv, public.appellations copy
 where surv.level = 'country' and surv.name = 'English Wine'
   and copy.name = 'English Wine' and copy.id <> surv.id
   and w.appellation_id = copy.id;
delete from public.appellations where name = 'English Wine' and level <> 'country';

-- Australia: 'South Eastern Australia' -> country level
insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'South Eastern Australia', 'Broad GI', 0
  from public.countries c
 where c.name = 'Australia'
   and not exists (select 1 from public.appellations a
                    where a.level = 'country' and a.country_id = c.id and a.name = 'South Eastern Australia');
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv, public.appellations copy
 where surv.level = 'country' and surv.name = 'South Eastern Australia'
   and copy.name = 'South Eastern Australia' and copy.id <> surv.id
   and w.appellation_id = copy.id;
delete from public.appellations where name = 'South Eastern Australia' and level <> 'country';

-- ── 3. bogus entry: 'IGP Vin de Pays d'Oc' was never a Beaujolais IGP ────────
update public.wines w
   set appellation_id = surv.id
  from public.appellations surv, public.appellations bogus
 where surv.name = 'Pays d''Oc' and surv.level = 'region'
   and bogus.name = 'IGP Vin de Pays d''Oc'
   and w.appellation_id = bogus.id;
delete from public.appellations where name = 'IGP Vin de Pays d''Oc';

-- ── 4. type fixes ─────────────────────────────────────────────────────────────
update public.appellations set type = null  where level = 'country' and name = 'Vin de France' and type = 'AOC';
update public.appellations set type = 'AOC' where type like 'AOC %';
update public.appellations set type = 'DOC' where type = 'DOC Ticino';

-- ── 5. wines.classification: drop redundancy with linked appellation type ────
-- 'AOC, Grand Cru' + appellation type AOC -> 'Grand Cru'
update public.wines w
   set classification = btrim(substring(w.classification from char_length(a.type) + 2))
  from public.appellations a
 where a.id = w.appellation_id
   and a.type is not null and w.classification is not null
   and lower(w.classification) like lower(a.type) || ',%';
-- 'AOC' + appellation type AOC -> null
update public.wines w
   set classification = null
  from public.appellations a
 where a.id = w.appellation_id
   and w.classification is not null
   and lower(btrim(w.classification)) = lower(coalesce(a.type, ''));
update public.wines set classification = null where btrim(coalesce(classification, '')) = '';

commit;
