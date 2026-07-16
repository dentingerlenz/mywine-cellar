-- Phase 7: Poland auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Poland-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/poland.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Poland'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Poland' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Poland' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Poland' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Dolny Śląsk', 0 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolny Śląsk', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Dolny Śląsk';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Lubuskie', 1 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lubuskie', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Lubuskie';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zielona Góra', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Lubuskie';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Małopolska', 2 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Małopolska', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Małopolska';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jurajski', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Małopolska';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Małopolski Przełom Wisły', 'PGI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Małopolska';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Podkarpacie', 3 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Podkarpacie', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Podkarpacie';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jasielski', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Podkarpacie';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Podgórzański', 'PGI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Podkarpacie';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Świętokrzyskie', 4 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Świętokrzyskie', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Świętokrzyskie';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sandomiersko-Świętokrzyski', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Świętokrzyskie';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Zachodniopomorskie', 5 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zachodniopomorskie', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Zachodniopomorskie';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Szczecin-Gorzowski', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Zachodniopomorskie';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Mazowieckie', 6 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mazowieckie', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Mazowieckie';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Warka', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Mazowieckie';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Wielkopolska', 7 from public.countries c where c.name='Poland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wielkopolska', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Poland' and r.name='Wielkopolska';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Poland' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Poland' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Poland'
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
