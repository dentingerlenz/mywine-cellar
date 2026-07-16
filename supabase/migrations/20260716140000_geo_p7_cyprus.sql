-- Phase 7: Cyprus auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Cyprus-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/cyprus.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Cyprus'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Cyprus' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Cyprus' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Cyprus' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Lemesos', 0 from public.countries c where c.name='Cyprus';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lemesos', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Lemesos';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Krasohoria Lemesou', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Lemesos';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Krasohoria Lemesou - Afames', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Lemesos';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Krasohoria Lemesou - Laona', 'PDO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Lemesos';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Commandaria', 'PDO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Lemesos';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pitsilia', 'PDO', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Lemesos';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Pafos', 1 from public.countries c where c.name='Cyprus';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pafos', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Pafos';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vouni Panayia - Ambelitis', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Pafos';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Laona Akama', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Pafos';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Larnaka', 2 from public.countries c where c.name='Cyprus';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Larnaka', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Larnaka';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Lefkosia', 3 from public.countries c where c.name='Cyprus';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lefkosia', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Cyprus' and r.name='Lefkosia';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Cyprus' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Cyprus' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Cyprus'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
-- Erhalt: alte Sub-Region ohne passende neue Appellation ins Freitextfeld "location"
-- (nur wenn leer und != zugewiesener Appellationsname). Aendert nur "location" -> der
-- geo-Ancestor-Trigger (country/region/sub/appellation) feuert NICHT.
update public.wines w set location = cap.sub_name
  from _mig_cap cap
 where w.id = cap.wine_id and cap.sub_name is not null
   and (w.location is null or btrim(w.location) = '')
   and cap.sub_name is distinct from coalesce((select a.name from public.appellations a where a.id = w.appellation_id), '');
commit;
