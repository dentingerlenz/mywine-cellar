-- Phase 7: Frankreich auf die offizielle INAO-Liste umstellen (Prod).
-- Ersetzt die alten France-Appellationen/-Regionen durch den verifizierten Satz
-- (data/geography/france.json). Bestehende France-Wein-FKs werden per Namens-
-- abgleich erhalten (Appellation > Sub-Region > Region; Sub-Umbenennungen gemappt).
-- No-op-sicher auf frischer DB: dort existiert die France-Country zur Migrations-
-- zeit noch nicht, alle Country-Lookups treffen 0 Zeilen; das Seed baut France neu.

begin;

-- 0. Bestehende France-Wein-Zuordnungen (Namen) sichern
create temp table _fr_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w
  join public.countries fr on fr.id = w.country_id and fr.name = 'France'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;

-- 1. Alte France-Geo loeschen (Appellationen -> Sub-Regionen -> Regionen).
--    wines-FKs werden dabei per ON DELETE SET NULL geleert (country_id bleibt).
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'France' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id)
        or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'France' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c
 where c.name = 'France' and r.country_id = c.id;

-- 2. Neue France-Geo einfuegen (aus france.json).
insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vin de France', null, 0
 from public.countries c where c.name='France';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Bordeaux', 0 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bordeaux', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bordeaux Superieur', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Bordeaux', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant de Bordeaux', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Atlantique', 'IGP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bordeaux';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Medoc', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Medoc', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haut-Medoc', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Estephe', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pauillac', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Julien', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Listrac-Medoc', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moulis-en-Medoc', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Margaux', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Medoc';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Graves', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Graves', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Graves';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Graves Superieures', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Graves';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pessac-Leognan', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Graves';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Sauternes', 2 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sauternes', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Sauternes';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Barsac', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Sauternes';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cerons', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Sauternes';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Saint-Emilion', 3 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Emilion', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Saint-Emilion';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Emilion Grand Cru', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Saint-Emilion';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montagne-Saint-Emilion', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Saint-Emilion';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Georges-Saint-Emilion', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Saint-Emilion';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lussac-Saint-Emilion', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Saint-Emilion';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Puisseguin-Saint-Emilion', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Saint-Emilion';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pomerol', 4 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pomerol', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Pomerol';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lalande-de-Pomerol', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Pomerol';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Fronsac', 5 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fronsac', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Fronsac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Canon-Fronsac', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Fronsac';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bourg', 6 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Bourg', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Bourg';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Blaye', 7 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blaye', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Blaye';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Blaye', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Blaye';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Entre-Deux-Mers', 8 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Entre-Deux-Mers', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Graves de Vayres', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cadillac', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Loupiac', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sainte-Croix-du-Mont', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Premieres Cotes de Bordeaux', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sainte-Foy-Bordeaux', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Bordeaux Saint-Macaire', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bordeaux' and s.name='Entre-Deux-Mers';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Sud-Ouest', 1 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Comte Tolosan', 'IGP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Gascogne', 'IGP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes du Tarn', 'IGP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes du Lot', 'IGP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Perigord', 'IGP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Landes', 'IGP', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Agenais', 'IGP', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gers', 'IGP', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Sud-Ouest';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bergerac', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bergerac', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Bergerac', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monbazillac', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pecharmant', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montravel', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Montravel', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haut-Montravel', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saussignac', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rosette', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Bergerac';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Garonne', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Duras', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Garonne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Marmandais', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Garonne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Buzet', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Garonne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Brulhois', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Garonne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Sardos', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Garonne';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lot & Aveyron', 2 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cahors', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Lot & Aveyron';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Quercy', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Lot & Aveyron';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marcillac', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Lot & Aveyron';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Millau', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Lot & Aveyron';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Entraygues et le Fel', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Lot & Aveyron';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Estaing', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Lot & Aveyron';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gaillac & Fronton', 3 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gaillac', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gaillac & Fronton';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gaillac Premieres Cotes', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gaillac & Fronton';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fronton', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gaillac & Fronton';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Gascogne & Bearn', 4 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Madiran', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pacherenc du Vic-Bilh', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bearn', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Mont', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tursan', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Jurancon', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Irouleguy', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Floc de Gascogne', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Sud-Ouest' and s.name='Gascogne & Bearn';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Bourgogne', 2 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne Aligote', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne Mousseux', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bourgogne Passe-Tout-Grains', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux Bourguignons', 'AOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant de Bourgogne', 'AOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Bourgogne';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Chablis', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Petit Chablis', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Chablis';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chablis', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Chablis';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chablis Grand Cru', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Chablis';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Irancy', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Chablis';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Bris', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Chablis';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vezelay', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Chablis';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Nuits', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Marsannay', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fixin', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gevrey-Chambertin', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Morey-Saint-Denis', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chambolle-Musigny', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vougeot', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vosne-Romanee', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Nuits-Saint-Georges', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Nuits-Villages', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chambertin', 'Grand Cru', 9
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chambertin-Clos de Beze', 'Grand Cru', 10
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chapelle-Chambertin', 'Grand Cru', 11
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Charmes-Chambertin', 'Grand Cru', 12
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Griotte-Chambertin', 'Grand Cru', 13
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Latricieres-Chambertin', 'Grand Cru', 14
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mazis-Chambertin', 'Grand Cru', 15
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mazoyeres-Chambertin', 'Grand Cru', 16
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ruchottes-Chambertin', 'Grand Cru', 17
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos de la Roche', 'Grand Cru', 18
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos des Lambrays', 'Grand Cru', 19
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos de Tart', 'Grand Cru', 20
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos Saint-Denis', 'Grand Cru', 21
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bonnes-Mares', 'Grand Cru', 22
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Musigny', 'Grand Cru', 23
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clos de Vougeot', 'Grand Cru', 24
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Echezeaux', 'Grand Cru', 25
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grands-Echezeaux', 'Grand Cru', 26
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Grande Rue', 'Grand Cru', 27
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Romanee', 'Grand Cru', 28
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Tache', 'Grand Cru', 29
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Richebourg', 'Grand Cru', 30
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Romanee-Conti', 'Grand Cru', 31
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Romanee-Saint-Vivant', 'Grand Cru', 32
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Nuits';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Beaune', 2 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ladoix', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Aloxe-Corton', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pernand-Vergelesses', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savigny-les-Beaune', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chorey-les-Beaune', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beaune', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pommard', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Volnay', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Monthelie', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Auxey-Duresses', 'AOC', 9
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Romain', 'AOC', 10
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Meursault', 'AOC', 11
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blagny', 'AOC', 12
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Puligny-Montrachet', 'AOC', 13
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chassagne-Montrachet', 'AOC', 14
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Aubin', 'AOC', 15
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Santenay', 'AOC', 16
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maranges', 'AOC', 17
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Beaune', 'AOC', 18
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Beaune-Villages', 'AOC', 19
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corton', 'Grand Cru', 20
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corton-Charlemagne', 'Grand Cru', 21
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Charlemagne', 'Grand Cru', 22
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montrachet', 'Grand Cru', 23
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chevalier-Montrachet', 'Grand Cru', 24
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Batard-Montrachet', 'Grand Cru', 25
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bienvenues Batard-Montrachet', 'Grand Cru', 26
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Criots-Batard-Montrachet', 'Grand Cru', 27
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote de Beaune';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote Chalonnaise', 3 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bouzeron', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote Chalonnaise';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rully', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote Chalonnaise';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Mercurey', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote Chalonnaise';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Givry', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote Chalonnaise';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montagny', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Cote Chalonnaise';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Maconnais', 4 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Macon', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Maconnais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Fuisse', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Maconnais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Loche', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Maconnais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Vinzelles', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Maconnais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Veran', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Maconnais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vire-Clesse', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Bourgogne' and s.name='Maconnais';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Beaujolais', 3 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beaujolais', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Beaujolais';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Crus du Beaujolais', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Brouilly', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chenas', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chiroubles', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote de Brouilly', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fleurie', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Julienas', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Morgon', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moulin-a-Vent', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Regnie', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Amour', 'AOC', 9
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Crus du Beaujolais';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lyonnais & Forez', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Lyonnais', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Lyonnais & Forez';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Forez', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Lyonnais & Forez';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote Roannaise', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Beaujolais' and s.name='Lyonnais & Forez';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Savoie & Jura', 4 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Franche-Comte', 'IGP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Savoie & Jura';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Jura', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Arbois', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateau-Chalon', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'L''Etoile', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Jura', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant du Jura', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Macvin du Jura', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Jura';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Savoie', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vin de Savoie', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Savoie';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Roussette de Savoie', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Savoie';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Seyssel', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Savoie';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Bugey', 2 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bugey', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Bugey';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Roussette du Bugey', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Savoie & Jura' and s.name='Bugey';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Champagne', 5 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Champagne', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Champagne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux Champenois', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Champagne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rose des Riceys', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Champagne';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Montagne de Reims', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Champagne';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Vallee de la Marne', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Champagne';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote des Blancs', 2 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Champagne';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Cote de Sezanne', 3 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Champagne';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Aube (Cote des Bar)', 4 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Champagne';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Alsace', 6 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alsace', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Alsace';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant d''Alsace', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Alsace';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alsace Grand Cru', 'Grand Cru', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Alsace';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Lorraine', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Alsace';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Moselle', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Alsace' and s.name='Lorraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes de Toul', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Alsace' and s.name='Lorraine';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Vallee de la Loire', 7 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cremant de Loire', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee de la Loire';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rose de Loire', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee de la Loire';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val de Loire', 'IGP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee de la Loire';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Pays Nantais', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Pays Nantais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet Sevre et Maine', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Pays Nantais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet Coteaux de la Loire', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Pays Nantais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscadet Cotes de Grandlieu', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Pays Nantais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gros Plant du Pays Nantais', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Pays Nantais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux d''Ancenis', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Pays Nantais';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fiefs Vendeens', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Pays Nantais';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Anjou-Saumur', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou Coteaux de la Loire', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou Villages', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Anjou Villages Brissac', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savennieres', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savennieres Coulee de Serrant', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Savennieres Roche aux Moines', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Layon', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de l''Aubance', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bonnezeaux', 'AOC', 9
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Quarts de Chaume', 'AOC', 10
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rose d''Anjou', 'AOC', 11
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cabernet d''Anjou', 'AOC', 12
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saumur', 'AOC', 13
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saumur-Champigny', 'AOC', 14
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Saumur', 'AOC', 15
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cabernet de Saumur', 'AOC', 16
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Anjou-Saumur';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Touraine', 2 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Touraine', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Touraine Noble Joue', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vouvray', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montlouis-sur-Loire', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chinon', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Bourgueil', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Nicolas-de-Bourgueil', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cheverny', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cour-Cheverny', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Jasnieres', 'AOC', 9
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Loir', 'AOC', 10
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Vendomois', 'AOC', 11
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Valencay', 'AOC', 12
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateaumeillant', 'AOC', 13
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Haut-Poitou', 'AOC', 14
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Orleans', 'AOC', 15
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Orleans-Clery', 'AOC', 16
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Touraine';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Centre-Loire', 3 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sancerre', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Centre-Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-Fume', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Centre-Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pouilly-sur-Loire', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Centre-Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Menetou-Salon', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Centre-Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Quincy', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Centre-Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Reuilly', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Centre-Loire';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux du Giennois', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee de la Loire' and s.name='Centre-Loire';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Auvergne', 8 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes d''Auvergne', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Auvergne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Saint-Pourcain', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Auvergne';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Correze', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Auvergne';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Vallee du Rhone', 9 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes du Rhone', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mediterranee', 'IGP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Comtes Rhodaniens', 'IGP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collines Rhodaniennes', 'IGP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ardeche', 'IGP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Drome', 'IGP', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vaucluse', 'IGP', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Vallee du Rhone';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rhone Nord', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cote-Rotie', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Condrieu', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateau-Grillet', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Joseph', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Crozes-Hermitage', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Hermitage', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cornas', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Peray', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Nord';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Rhone Sud', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chateauneuf-du-Pape', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Gigondas', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vacqueyras', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Vinsobres', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Beaumes de Venise', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Beaumes-de-Venise', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rasteau', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Lirac', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Tavel', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Luberon', 'AOC', 9
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Ventoux', 'AOC', 10
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grignan-les-Adhemar', 'AOC', 11
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Vivarais', 'AOC', 12
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pierrevert', 'AOC', 13
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Rhone Villages', 'AOC', 14
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cairanne', 'AOC', 15
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Rhone Sud';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Diois', 2 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clairette de Die', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Diois';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant de Die', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Diois';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Coteaux de Die', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Diois';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Chatillon-en-Diois', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Vallee du Rhone' and s.name='Diois';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Languedoc-Roussillon', 10 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pays d''Oc', 'IGP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pays d''Herault', 'IGP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes Catalanes', 'IGP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cevennes', 'IGP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gard', 'IGP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cote Vermeille', 'IGP', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aude', 'IGP', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Languedoc', 0 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Languedoc', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clairette du Languedoc', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Clairette de Bellegarde', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Picpoul de Pinet', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cabardes', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Malepere', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Minervois', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Minervois-La Liviniere', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corbieres', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Corbieres-Boutenac', 'AOC', 9
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Saint-Chinian', 'AOC', 10
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Faugeres', 'AOC', 11
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Fitou', 'AOC', 12
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Limoux', 'AOC', 13
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cremant de Limoux', 'AOC', 14
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Costieres de Nimes', 'AOC', 15
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Duche d''Uzes', 'AOC', 16
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Frontignan', 'AOC', 17
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Lunel', 'AOC', 18
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Mireval', 'AOC', 19
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Saint-Jean-de-Minervois', 'AOC', 20
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Blanquette de Limoux', 'AOC', 21
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Pic Saint-Loup', 'AOC', 22
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Terrasses du Larzac', 'AOC', 23
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'La Clape', 'AOC', 24
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Montpeyroux', 'AOC', 25
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Sable de Camargue', 'AOC', 26
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Languedoc';
insert into public.sub_regions (region_id, name, sort_order)
select r.id, 'Roussillon', 1 from public.regions r join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Roussillon', 'AOC', 0
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Cotes du Roussillon Villages', 'AOC', 1
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Collioure', 'AOC', 2
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Banyuls', 'AOC', 3
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Banyuls grand cru', 'AOC', 4
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Maury', 'AOC', 5
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Rivesaltes', 'AOC', 6
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Muscat de Rivesaltes', 'AOC', 7
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.appellations (level, sub_region_id, name, type, sort_order)
select 'sub_region', s.id, 'Grand Roussillon', 'AOC', 8
 from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id
 where c.name='France' and r.name='Languedoc-Roussillon' and s.name='Roussillon';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Provence', 11 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux d''Aix-en-Provence', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Les Baux de Provence', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Provence', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bandol', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cassis', 'AOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Palette', 'AOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux Varois en Provence', 'AOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bellet', 'AOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mediterranee', 'IGP', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Var', 'IGP', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bouches-du-Rhone', 'IGP', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alpilles', 'IGP', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maures', 'IGP', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mont Caume', 'IGP', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Provence';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Corse', 12 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin de Corse', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Corse';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ajaccio', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Corse';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Patrimonio', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Corse';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Muscat du Cap Corse', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Corse';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ile de Beaute', 'IGP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Corse';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Charentes', 13 from public.countries c where c.name = 'France';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pineau des Charentes', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Charentes';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Charentais', 'IGP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name='Charentes';

-- 3. Wein-Zuordnungen wiederherstellen (Prioritaet Appellation > Sub > Region)
update public.wines w set appellation_id = na.id
  from _fr_cap cap
  join public.appellations na on na.name = cap.app_name
  join public.countries c on c.name='France' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id) or na.sub_region_id in (select s.id from public.sub_regions s join public.regions r on r.id=s.region_id where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;

update public.wines w set sub_region_id = ns.id
  from _fr_cap cap
  join public.sub_regions ns on ns.name = (case cap.sub_name when 'Aveyron' then 'Lot & Aveyron' when 'Lot' then 'Lot & Aveyron' when 'Madiran' then 'Gascogne & Bearn' else cap.sub_name end)
  join public.regions r on r.id = ns.region_id
  join public.countries c on c.id = r.country_id and c.name='France'
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;

update public.wines w set region_id = nr.id
  from _fr_cap cap
  join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='France'
 where w.id = cap.wine_id and w.appellation_id is null and w.sub_region_id is null
   and cap.region_name is not null;

commit;
