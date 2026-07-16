-- Phase 7: Portugal auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Portugal-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/portugal.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Portugal'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Portugal' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Portugal' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Portugal' and r.country_id = c.id;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Vinho', 'Vinho', 0 from public.countries c where c.name='Portugal';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Minho', 0 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Minho', 'IGP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Minho';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinho Verde', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Minho';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Douro', 1 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Douro', 'DOP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Douro';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Porto', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Douro';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Duriense', 'IGP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Douro';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Tras-os-Montes', 2 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tras-os-Montes', 'DOP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Tras-os-Montes';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Transmontano', 'IGP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Tras-os-Montes';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Beiras', 3 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dao', 'DOP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bairrada', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beira Interior', 'DOP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lafoes', 'DOP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tavora-Varosa', 'DOP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beira Atlantico', 'IGP', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terras da Beira', 'IGP', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terras do Dao', 'IGP', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terras de Cister', 'IGP', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Beiras';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Lisboa', 4 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lisboa', 'IGP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alenquer', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arruda', 'DOP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bucelas', 'DOP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carcavelos', 'DOP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colares', 'DOP', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Encostas d''Aire', 'DOP', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Obidos', 'DOP', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Torres Vedras', 'DOP', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Lisboa';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Tejo', 5 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Do Tejo', 'DOP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Tejo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tejo', 'IGP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Tejo';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Peninsula de Setubal', 6 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Setubal', 'DOP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Peninsula de Setubal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Palmela', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Peninsula de Setubal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peninsula de Setubal', 'IGP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Peninsula de Setubal';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Alentejo', 7 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alentejo', 'DOP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Alentejo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alentejano', 'IGP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Alentejo';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Algarve', 8 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Algarve', 'IGP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Algarve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lagoa', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Algarve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lagos', 'DOP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Algarve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Portimao', 'DOP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Algarve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tavira', 'DOP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Algarve';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Madeira', 9 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Madeira', 'DOP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Madeira';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Madeirense', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Madeira';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terras Madeirenses', 'IGP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Madeira';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Acores', 10 from public.countries c where c.name='Portugal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Acores', 'IGP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Acores';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Biscoitos', 'DOP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Acores';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Graciosa', 'DOP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Acores';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pico', 'DOP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Portugal' and r.name='Acores';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Portugal' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Portugal' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Portugal'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
-- Portugal-spezifisch: informelle Douro-Unterzonen ohne eigene DOP/IGP (Douro
-- Superior, Cima Corgo, Baixo Corgo) existieren im neuen Satz nicht mehr. Den alten
-- Sub-Namen ins Freitextfeld "location" übernehmen — AUCH wenn der Wein seine
-- Appellation behalten hat (z. B. DOP Douro), sofern der Sub-Name davon abweicht und
-- location leer ist. (Nur "location" wird geändert → der geo-Ancestor-Trigger, der
-- auf country/region/sub/appellation feuert, wird NICHT ausgelöst.)
update public.wines w set location = cap.sub_name
  from _mig_cap cap
 where w.id = cap.wine_id and cap.sub_name is not null
   and (w.location is null or btrim(w.location) = '')
   and cap.sub_name is distinct from coalesce((select a.name from public.appellations a where a.id = w.appellation_id), '');
commit;
