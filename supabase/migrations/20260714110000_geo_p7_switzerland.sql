-- Phase 7: Schweiz auf das offizielle eidg. AOC-Register umstellen (Prod).
-- Ersetzt die alten CH-Appellationen/-Regionen durch den verifizierten 63er-Satz
-- (flach auf Regionsebene, data/geography/switzerland.json). Wein-FKs per Namens-
-- abgleich erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;

create temp table _ch_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w
  join public.countries co on co.id = w.country_id and co.name = 'Switzerland'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;

delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Switzerland' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id)
        or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Switzerland' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c
 where c.name = 'Switzerland' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Valais', 0 from public.countries c where c.name='Switzerland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valais', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Valais';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Vaud', 1 from public.countries c where c.name='Switzerland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vaud', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chablais', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lavaux', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Cote', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes-de-l''Orbe', 'AOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bonvillars', 'AOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dezaley', 'AOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dezaley-Marsens', 'AOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calamin', 'AOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Vaud';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Geneve', 2 from public.countries c where c.name='Switzerland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Geneve', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Chevrens', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Landecy', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Lully', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Choulex', 'AOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chateau de Collex', 'AOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Bossy', 'AOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de la vigne blanche', 'AOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux de Dardagny', 'AOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Genthod', 'AOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chateau du Crest', 'AOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mandement de Jussy', 'AOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grand Carraz', 'AOC', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Domaine de l''Abbaye', 'AOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cotes de Russin', 'AOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau des Baillets', 'AOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Bourdigny', 'AOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Choully', 'AOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteau de Peissy', 'AOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coteaux de Peney', 'AOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chateau de Choully', 'AOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rougemont', 'AOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Feuillee', 'AOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Geneve';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Drei Seen', 3 from public.countries c where c.name='Switzerland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Neuchatel', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Drei Seen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bielersee', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Drei Seen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cheyres', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Drei Seen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vully', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Drei Seen';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Ticino', 4 from public.countries c where c.name='Switzerland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ticino', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Ticino';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso del Ticino', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Ticino';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco del Ticino', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Ticino';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosato del Ticino', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Ticino';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Deutschschweiz', 5 from public.countries c where c.name='Switzerland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aargau', 'AOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Appenzell Innerrhoden', 'AOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Appenzell Ausserrhoden', 'AOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bern', 'AOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thunersee', 'AOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Basel-Landschaft', 'AOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Basel-Stadt', 'AOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Glarus', 'AOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Graubünden', 'AOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jura', 'AOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Luzern', 'AOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nidwalden', 'AOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Obwalden', 'AOC', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'St. Gallen', 'AOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Schaffhausen', 'AOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Solothurn', 'AOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Schwyz', 'AOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thurgau', 'AOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Uri', 'AOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zug', 'AOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zürich', 'AOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zürichsee', 'AOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Switzerland' and r.name='Deutschschweiz';

update public.wines w set appellation_id = na.id
  from _ch_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Switzerland' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id
  from _ch_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Switzerland' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id
  from _ch_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Switzerland'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;

commit;
