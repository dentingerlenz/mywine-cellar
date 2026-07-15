-- Phase 7: Oesterreich auf das offizielle DAC-System umstellen (Prod).
-- Ersetzt die alten AT-Appellationen/-Regionen durch den verifizierten 27er-Satz
-- (flach, data/geography/austria.json). Wein-FKs per Namensabgleich:
-- Appellation > alte Sub-Region (jetzt Appellation) > Region. No-op-sicher frisch.

begin;
create temp table _at_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Austria'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Austria' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Austria' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Austria' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Niederösterreich', 0 from public.countries c where c.name='Austria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Niederösterreich', 'Qualitätswein', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wachau', 'DAC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kremstal', 'DAC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kamptal', 'DAC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Traisental', 'DAC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wagram', 'DAC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Weinviertel', 'DAC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carnuntum', 'DAC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thermenregion', 'DAC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Niederösterreich';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Burgenland', 1 from public.countries c where c.name='Austria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Burgenland', 'Qualitätswein', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Burgenland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Neusiedlersee', 'DAC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Burgenland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Leithaberg', 'DAC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Burgenland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosalia', 'DAC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Burgenland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mittelburgenland', 'DAC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Burgenland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eisenberg', 'DAC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Burgenland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ruster Ausbruch', 'DAC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Burgenland';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Steiermark', 2 from public.countries c where c.name='Austria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Steiermark', 'Qualitätswein', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Steiermark';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vulkanland Steiermark', 'DAC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Steiermark';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Südsteiermark', 'DAC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Steiermark';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Weststeiermark', 'DAC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Steiermark';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Wien', 3 from public.countries c where c.name='Austria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wien', 'Qualitätswein', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Wien';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wiener Gemischter Satz', 'DAC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Wien';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Bergland', 4 from public.countries c where c.name='Austria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kärnten', 'Qualitätswein', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Bergland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oberösterreich', 'Qualitätswein', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Bergland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tirol', 'Qualitätswein', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Bergland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vorarlberg', 'Qualitätswein', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Bergland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salzburg', 'Qualitätswein', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Austria' and r.name='Bergland';

update public.wines w set appellation_id = na.id from _at_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Austria' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _at_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Austria' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _at_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Austria'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
commit;
