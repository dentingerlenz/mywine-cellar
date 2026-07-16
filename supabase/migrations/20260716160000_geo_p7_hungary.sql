-- Phase 7: Hungary auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Hungary-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/hungary.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Hungary'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Hungary' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Hungary' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Hungary' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Balaton', 0 from public.countries c where c.name='Hungary';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Badacsony', 'OEM', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Balatonboglár', 'OEM', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Balaton-felvidék', 'OEM', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Balatonfüred-Csopak', 'OEM', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Csopak', 'OEM', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Káli', 'OEM', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nagy-Somló', 'OEM', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Somló', 'OEM', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tihany', 'OEM', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zala', 'OEM', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Balaton', 'OFJ', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Balatonmelléki', 'OFJ', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Balaton';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Duna', 1 from public.countries c where c.name='Hungary';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Csongrád', 'OEM', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Duna', 'OEM', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hajós-Baja', 'OEM', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Izsáki Arany Sárfehér', 'OEM', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kunság', 'OEM', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monor', 'OEM', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Soltvadkerti', 'OEM', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Duna-Tisza közi', 'OFJ', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Duna';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Eger', 2 from public.countries c where c.name='Hungary';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bükk', 'OEM', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Eger';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Debrői Hárslevelű', 'OEM', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Eger';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eger', 'OEM', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Eger';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mátra', 'OEM', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Eger';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Felső-Magyarország', 'OFJ', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Eger';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Pannon', 3 from public.countries c where c.name='Hungary';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pannon', 'OEM', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Pannon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pécs', 'OEM', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Pannon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Szekszárd', 'OEM', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Pannon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tolna', 'OEM', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Pannon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Villány', 'OEM', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Pannon';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Sopron', 4 from public.countries c where c.name='Hungary';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Etyek-Buda', 'OEM', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Sopron';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mór', 'OEM', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Sopron';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Neszmély', 'OEM', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Sopron';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pannonhalma', 'OEM', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Sopron';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sopron', 'OEM', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Sopron';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dunántúl', 'OFJ', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Sopron';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Tokaj', 5 from public.countries c where c.name='Hungary';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tokaj', 'OEM', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Tokaj';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zemplén', 'OFJ', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Hungary' and r.name='Tokaj';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Hungary' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Hungary' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Hungary'
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
