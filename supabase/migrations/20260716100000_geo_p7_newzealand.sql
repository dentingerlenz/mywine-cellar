-- Phase 7: New Zealand auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten New Zealand-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/new-zealand.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'New Zealand'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'New Zealand' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'New Zealand' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'New Zealand' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Northland', 0 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Northland', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Northland';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Auckland', 1 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Auckland', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Auckland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kumeu', 'GI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Auckland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Matakana', 'GI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Auckland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Waiheke Island', 'GI', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Auckland';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Gisborne', 2 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gisborne', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Gisborne';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Hawke''s Bay', 3 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hawke''s Bay', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Hawke''s Bay';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Hawke''s Bay', 'GI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Hawke''s Bay';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Wairarapa', 4 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wairarapa', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Wairarapa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gladstone', 'GI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Wairarapa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Martinborough', 'GI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Wairarapa';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Nelson', 5 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nelson', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Nelson';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Marlborough', 6 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marlborough', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Marlborough';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Canterbury', 7 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canterbury', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Canterbury';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'North Canterbury', 'GI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Canterbury';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Waipara Valley', 'GI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Canterbury';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Waitaki Valley North Otago', 8 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Waitaki Valley North Otago', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Waitaki Valley North Otago';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Central Otago', 9 from public.countries c where c.name='New Zealand';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Otago', 'GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Central Otago';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bannockburn', 'GI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='New Zealand' and r.name='Central Otago';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='New Zealand' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='New Zealand' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='New Zealand'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
-- NZ-spezifisch: informelle Sub-Regionen ohne registrierte GI (z. B. Wairau Valley,
-- Southern Valleys, Awatere Valley) existieren im neuen Satz nicht mehr. Den alten
-- Sub-Namen verlustfrei ins Freitextfeld "location" übernehmen (nur wenn dort leer
-- und der Wein keine passende GI-Appellation erhielt, z. B. Bannockburn).
update public.wines w set location = cap.sub_name
  from _mig_cap cap
 where w.id = cap.wine_id and cap.sub_name is not null and w.appellation_id is null
   and (w.location is null or btrim(w.location) = '');
commit;
