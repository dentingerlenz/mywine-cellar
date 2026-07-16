-- Phase 7: Germany auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Germany-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/germany.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Germany'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Germany' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Germany' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Germany' and r.country_id = c.id;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Deutscher Wein', 'Tafelwein', 0 from public.countries c where c.name='Germany';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Mosel', 0 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mosel', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bernkastel', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Burg Cochem', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moseltor', 'Bereich', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Obermosel', 'Bereich', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ruwertal', 'Bereich', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Saar', 'Bereich', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Landwein der Mosel', 'Landwein', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mosel';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Rheingau', 1 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheingau', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheingau';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Johannisberg', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheingau';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheingauer Landwein', 'Landwein', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheingau';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Rheinhessen', 2 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheinhessen', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheinhessen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bingen', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheinhessen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nierstein', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheinhessen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wonnegau', 'Bereich', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheinhessen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rheinischer Landwein', 'Landwein', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Rheinhessen';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Pfalz', 3 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pfalz', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Pfalz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mittelhaardt-Deutsche Weinstrasse', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Pfalz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Südliche Weinstrasse', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Pfalz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pfälzer Landwein', 'Landwein', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Pfalz';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Nahe', 4 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nahe', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Nahe';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nahetal', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Nahe';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nahegauer Landwein', 'Landwein', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Nahe';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Franken', 5 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Franken', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Franken';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maindreieck', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Franken';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mainviereck', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Franken';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Steigerwald', 'Bereich', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Franken';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fränkischer Landwein', 'Landwein', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Franken';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Baden', 6 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Baden', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Badische Bergstrasse', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bodensee', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Breisgau', 'Bereich', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kaiserstuhl', 'Bereich', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kraichgau', 'Bereich', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Markgräflerland', 'Bereich', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ortenau', 'Bereich', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tauberfranken', 'Bereich', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tuniberg', 'Bereich', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Badischer Landwein', 'Landwein', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Baden';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Württemberg', 7 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Württemberg', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bayerischer Bodensee', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kocher-Jagst-Tauber', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oberer Neckar', 'Bereich', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Remstal-Stuttgart', 'Bereich', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Württembergischer Bodensee', 'Bereich', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Württembergisch Unterland', 'Bereich', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Schwäbischer Landwein', 'Landwein', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Württemberg';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Mittelrhein', 8 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mittelrhein', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mittelrhein';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Loreley', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mittelrhein';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Siebengebirge', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Mittelrhein';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Ahr', 9 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ahr', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Ahr';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Walporzheim/Ahrtal', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Ahr';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ahrtaler Landwein', 'Landwein', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Ahr';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Saale-Unstrut', 10 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Saale-Unstrut', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Saale-Unstrut';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Schloss Neuenburg', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Saale-Unstrut';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thüringen', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Saale-Unstrut';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mitteldeutscher Landwein', 'Landwein', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Saale-Unstrut';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Sachsen', 11 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sachsen', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Sachsen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dresden', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Sachsen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elstertal', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Sachsen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Meissen', 'Bereich', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Sachsen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sächsischer Landwein', 'Landwein', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Sachsen';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Hessische Bergstrasse', 12 from public.countries c where c.name='Germany';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hessische Bergstrasse', 'Anbaugebiet', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Hessische Bergstrasse';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Starkenburg', 'Bereich', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Hessische Bergstrasse';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Umstadt', 'Bereich', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Germany' and r.name='Hessische Bergstrasse';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Germany' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Germany' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Germany'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
-- Deutschland-spezifisch: informelle Sub-Regionen (z. B. Mittelmosel, Terrassenmosel)
-- sind keine offiziellen Bereiche und existieren im neuen Satz nicht mehr. Damit die
-- Info nicht verloren geht, den alten Sub-Namen ins Freitextfeld "location" übernehmen
-- (nur wenn dort noch nichts steht und der Wein keine passende Appellation erhielt).
update public.wines w set location = cap.sub_name
  from _mig_cap cap
 where w.id = cap.wine_id and cap.sub_name is not null and w.appellation_id is null
   and (w.location is null or btrim(w.location) = '');
commit;
