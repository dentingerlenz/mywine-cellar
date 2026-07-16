-- Phase 7: United States auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten United States-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/united-states.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'United States'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'United States' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'United States' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'United States' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'California', 0 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Adelaida District', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alexander Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alta Mesa', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Anderson Valley', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alisos Canyon', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Antelope Valley of the California High Desert', 'AVA', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arroyo Grande Valley', 'AVA', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arroyo Seco', 'AVA', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Atlas Peak', 'AVA', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ballard Canyon', 'AVA', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ben Lomond Mountain', 'AVA', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Benmore Valley', 'AVA', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bennett Valley', 'AVA', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Big Valley District-Lake County', 'AVA', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Borden Ranch', 'AVA', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'California Shenandoah Valley', 'AVA', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calistoga', 'AVA', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Capay Valley', 'AVA', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carmel Valley', 'AVA', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Coast', 'AVA', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chalk Hill', 'AVA', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chalone', 'AVA', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chiles Valley', 'AVA', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cienega Valley', 'AVA', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Clarksburg', 'AVA', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Clear Lake', 'AVA', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Clements Hills', 'AVA', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cole Ranch', 'AVA', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Comptche', 'AVA', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Contra Costa', 'AVA', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coombsville', 'AVA', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cosumnes River', 'AVA', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Covelo', 'AVA', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Creston District', 'AVA', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Crystal Springs of Napa Valley', 'AVA', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cucamonga Valley', 'AVA', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Diablo Grande', 'AVA', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Diamond Mountain District', 'AVA', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dos Rios', 'AVA', 38
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dry Creek Valley', 'AVA', 39
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dunnigan Hills', 'AVA', 40
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eagle Peak Mendocino County', 'AVA', 41
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Edna Valley', 'AVA', 42
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'El Dorado', 'AVA', 43
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'El Pomar District', 'AVA', 44
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fair Play', 'AVA', 45
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fiddletown', 'AVA', 46
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fort Ross-Seaview', 'AVA', 47
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fountaingrove District', 'AVA', 48
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gabilan Mountains', 'AVA', 49
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Green Valley of Russian River Valley', 'AVA', 50
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Guenoc Valley', 'AVA', 51
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hames Valley', 'AVA', 52
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Happy Canyon of Santa Barbara', 'AVA', 53
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'High Valley', 'AVA', 54
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Howell Mountain', 'AVA', 55
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Inwood Valley', 'AVA', 56
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jahant', 'AVA', 57
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kelsey Bench-Lake County', 'AVA', 58
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Knights Valley', 'AVA', 59
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lamorinda', 'AVA', 60
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Leona Valley', 'AVA', 61
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lime Kiln Valley', 'AVA', 62
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Livermore Valley', 'AVA', 63
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lodi', 'AVA', 64
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Long Valley-Lake County', 'AVA', 65
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Los Carneros', 'AVA', 66
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Los Olivos District', 'AVA', 67
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Madera', 'AVA', 68
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malibu Coast', 'AVA', 69
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malibu-Newton Canyon', 'AVA', 70
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Manton Valley', 'AVA', 71
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mendocino', 'AVA', 72
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mendocino Ridge', 'AVA', 73
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Merritt Island', 'AVA', 74
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'McDowell Valley', 'AVA', 75
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mokelumne River', 'AVA', 76
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monterey', 'AVA', 77
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moon Mountain District Sonoma County', 'AVA', 78
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mt. Harlan', 'AVA', 79
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mt. Veeder', 'AVA', 80
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Napa Valley', 'AVA', 81
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'North Coast', 'AVA', 82
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'North Yuba', 'AVA', 83
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Northern Sonoma', 'AVA', 84
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oak Knoll District of Napa Valley', 'AVA', 85
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oakville', 'AVA', 86
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pacheco Pass', 'AVA', 87
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paicines', 'AVA', 88
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Palos Verdes Peninsula', 'AVA', 89
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paso Robles', 'AVA', 90
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paso Robles Estrella District', 'AVA', 91
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paso Robles Geneseo District', 'AVA', 92
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paso Robles Highlands District', 'AVA', 93
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paso Robles Willow Creek District', 'AVA', 94
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paulsell Valley', 'AVA', 95
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Petaluma Gap', 'AVA', 96
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pine Mountain-Cloverdale Peak', 'AVA', 97
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Potter Valley', 'AVA', 98
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ramona Valley', 'AVA', 99
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Red Hills Lake County', 'AVA', 100
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Redwood Valley', 'AVA', 101
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'River Junction', 'AVA', 102
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rockpile', 'AVA', 103
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Russian River Valley', 'AVA', 104
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rutherford', 'AVA', 105
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Saddle Rock-Malibu', 'AVA', 106
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salado Creek', 'AVA', 107
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Antonio Valley', 'AVA', 108
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Benito', 'AVA', 109
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Bernabe', 'AVA', 110
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Francisco Bay', 'AVA', 111
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Juan Creek', 'AVA', 112
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Luis Obispo Coast', 'AVA', 113
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Luis Rey', 'AVA', 114
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Lucas', 'AVA', 115
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Miguel District', 'AVA', 116
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Pasqual Valley', 'AVA', 117
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Ysidro District', 'AVA', 118
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Clara Valley', 'AVA', 119
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Cruz Mountains', 'AVA', 120
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Lucia Highlands', 'AVA', 121
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Margarita Ranch', 'AVA', 122
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Maria Valley', 'AVA', 123
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Ynez Valley', 'AVA', 124
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Seiad Valley', 'AVA', 125
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sierra Foothills', 'AVA', 126
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sierra Pelona Valley', 'AVA', 127
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sloughhouse', 'AVA', 128
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Solano County Green Valley', 'AVA', 129
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sonoma Coast', 'AVA', 130
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sonoma Mountain', 'AVA', 131
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sonoma Valley', 'AVA', 132
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South Coast', 'AVA', 133
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Spring Mountain District', 'AVA', 134
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Squaw Valley-Miramonte', 'AVA', 135
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'St. Helena', 'AVA', 136
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sta. Rita Hills', 'AVA', 137
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Stags Leap District', 'AVA', 138
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Suisun Valley', 'AVA', 139
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tehachapi Mountains', 'AVA', 140
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Temecula Valley', 'AVA', 141
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Templeton Gap District', 'AVA', 142
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tracy Hills', 'AVA', 143
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trinity Lakes', 'AVA', 144
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Lake Valley', 'AVA', 145
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'West Sonoma Coast', 'AVA', 146
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wild Horse Valley', 'AVA', 147
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Willow Creek', 'AVA', 148
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Winters Highlands', 'AVA', 149
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'York Mountain', 'AVA', 150
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yorkville Highlands', 'AVA', 151
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yountville', 'AVA', 152
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yucaipa Valley', 'AVA', 153
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='California';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Oregon', 1 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Applegate Valley', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chehalem Mountains', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dundee Hills', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elkton Oregon', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eola-Amity Hills', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Laurelwood District', 'AVA', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lower Long Tom', 'AVA', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'McMinnville', 'AVA', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mt. Pisgah, Polk County, Oregon', 'AVA', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Red Hill Douglas County Oregon', 'AVA', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribbon Ridge', 'AVA', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'The Rocks District of Milton-Freewater', 'AVA', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rogue Valley', 'AVA', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Southern Oregon', 'AVA', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tualatin Hills', 'AVA', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Umpqua Valley', 'AVA', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Van Duzer Corridor', 'AVA', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Willamette Valley', 'AVA', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yamhill-Carlton', 'AVA', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Oregon';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Washington', 2 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ancient Lakes of Columbia Valley', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beverly, Washington', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Candy Mountain', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goose Gap', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Horse Heaven Hills', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lake Chelan', 'AVA', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Naches Heights', 'AVA', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Puget Sound', 'AVA', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rattlesnake Hills', 'AVA', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Red Mountain', 'AVA', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rocky Reach', 'AVA', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Royal Slope', 'AVA', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Snipes Mountain', 'AVA', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'The Burn of Columbia Valley', 'AVA', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wahluke Slope', 'AVA', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'White Bluffs', 'AVA', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yakima Valley', 'AVA', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Columbia Gorge', 'AVA', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Columbia Valley', 'AVA', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Walla Walla Valley', 'AVA', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Washington';
insert into public.regions (country_id, name, sort_order)
select c.id, 'New York', 3 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cayuga Lake', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Champlain Valley of New York', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Finger Lakes', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hudson River Region', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Long Island', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Niagara Escarpment', 'AVA', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'North Fork of Long Island', 'AVA', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Seneca Lake', 'AVA', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'The Hamptons, Long Island', 'AVA', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Hudson', 'AVA', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lake Erie', 'AVA', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New York';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Virginia', 4 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Middleburg Virginia', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monticello', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'North Fork of Roanoke', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Northern Neck George Washington Birthplace', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rocky Knob', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Virginia''s Eastern Shore', 'AVA', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Virginia Peninsula', 'AVA', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Shenandoah Valley', 'AVA', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Virginia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Texas', 5 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bell Mountain', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Texas';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Escondido Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Texas';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fredericksburg in the Texas Hill Country', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Texas';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Texas Davis Mountains', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Texas';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Texas High Plains', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Texas';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Texas Hill Country', 'AVA', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Texas';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Texoma', 'AVA', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Texas';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Idaho', 6 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eagle Foothills', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Idaho';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lewis-Clark Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Idaho';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Snake River Valley', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Idaho';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Michigan', 7 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fennville', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Michigan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lake Michigan Shore', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Michigan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Leelanau Peninsula', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Michigan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Old Mission Peninsula', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Michigan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tip of the Mitt', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Michigan';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Missouri', 8 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Augusta', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Missouri';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hermann', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Missouri';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ozark Highlands', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Missouri';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ozark Mountain', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Missouri';
insert into public.regions (country_id, name, sort_order)
select c.id, 'New Mexico', 9 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Middle Rio Grande Valley', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New Mexico';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mimbres Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New Mexico';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mesilla Valley', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New Mexico';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Colorado', 10 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grand Valley', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Colorado';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'West Elks', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Colorado';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Arizona', 11 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sonoita', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Arizona';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verde Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Arizona';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Willcox', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Arizona';
insert into public.regions (country_id, name, sort_order)
select c.id, 'North Carolina', 12 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Crest of the Blue Ridge Henderson County', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='North Carolina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Haw River Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='North Carolina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Swan Creek', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='North Carolina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tryon Foothills', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='North Carolina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yadkin Valley', 'AVA', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='North Carolina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Appalachian High Country', 'AVA', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='North Carolina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Hiwassee Highlands', 'AVA', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='North Carolina';
insert into public.regions (country_id, name, sort_order)
select c.id, 'New Jersey', 13 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cape May Peninsula', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New Jersey';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Outer Coastal Plain', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New Jersey';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Warren Hills', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New Jersey';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Delaware Valley', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='New Jersey';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Pennsylvania', 14 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lancaster Valley', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Pennsylvania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lehigh Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Pennsylvania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cumberland Valley', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Pennsylvania';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Ohio', 15 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grand River Valley', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Ohio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Isle St. George', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Ohio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Loramie Creek', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Ohio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ohio River Valley', 'AVA', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Ohio';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Maryland', 16 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Catoctin', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Maryland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Linganore', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Maryland';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Massachusetts', 17 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Martha''s Vineyard', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Massachusetts';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nashoba Valley', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Massachusetts';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Southeastern New England', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Massachusetts';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Connecticut', 18 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eastern Connecticut Highlands', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Connecticut';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Western Connecticut Highlands', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Connecticut';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Tennessee', 19 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nine Lakes of East Tennessee', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Tennessee';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Cumberland', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Tennessee';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Arkansas', 20 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Altus', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Arkansas';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arkansas Mountain', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Arkansas';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Georgia', 21 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dahlonega Plateau', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Georgia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Hawaii', 22 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ulupalakua', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Hawaii';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Illinois', 23 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Shawnee Hills', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Illinois';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Indiana', 24 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Indiana Uplands', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Indiana';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Iowa', 25 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Loess Hills District', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Iowa';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Minnesota', 26 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alexandria Lakes', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Minnesota';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Mississippi', 27 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mississippi Delta', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Mississippi';
insert into public.regions (country_id, name, sort_order)
select c.id, 'West Virginia', 28 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kanawha River Valley', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='West Virginia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Wisconsin', 29 from public.countries c where c.name='United States';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lake Wisconsin', 'AVA', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Wisconsin';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wisconsin Ledge', 'AVA', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Wisconsin';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Mississippi River Valley', 'AVA', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='United States' and r.name='Wisconsin';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='United States' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='United States' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='United States'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
-- USA-spezifisch: alte Sub-Regionen ohne passende neue AVA ins Freitextfeld "location"
-- übernehmen (nur wenn dort leer und ≠ zugewiesener Appellation) — verlustfrei, wie bei
-- DE/NZ/PT. (Ändert nur "location" → geo-Ancestor-Trigger feuert nicht.)
update public.wines w set location = cap.sub_name
  from _mig_cap cap
 where w.id = cap.wine_id and cap.sub_name is not null
   and (w.location is null or btrim(w.location) = '')
   and cap.sub_name is distinct from coalesce((select a.name from public.appellations a where a.id = w.appellation_id), '');
commit;
