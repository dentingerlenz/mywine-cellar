-- Phase 7: Australia auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Australia-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/australia.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Australia'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Australia' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Australia' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Australia' and r.country_id = c.id;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'South Eastern Australia', 'Broad GI', 0 from public.countries c where c.name='Australia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'South Australia', 0 from public.countries c where c.name='Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South Australia', 'State GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Adelaide', 'GI Zone', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barossa', 'GI Zone', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Far North', 'GI Zone', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fleurieu', 'GI Zone', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Limestone Coast', 'GI Zone', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lower Murray', 'GI Zone', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mount Lofty Ranges', 'GI Zone', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'The Peninsulas', 'GI Zone', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barossa Valley', 'GI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eden Valley', 'GI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Southern Flinders Ranges', 'GI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Currency Creek', 'GI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kangaroo Island', 'GI', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Langhorne Creek', 'GI', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'McLaren Vale', 'GI', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Southern Fleurieu', 'GI', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coonawarra', 'GI', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mount Benson', 'GI', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mount Gambier', 'GI', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Padthaway', 'GI', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Robe', 'GI', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wrattonbully', 'GI', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riverland', 'GI', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Adelaide Hills', 'GI', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Adelaide Plains', 'GI', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Clare Valley', 'GI', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'High Eden', 'GI Subregion', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lenswood', 'GI Subregion', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piccadilly Valley', 'GI Subregion', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='South Australia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'New South Wales', 1 from public.countries c where c.name='Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'New South Wales', 'State GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Big Rivers', 'GI Zone', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Ranges', 'GI Zone', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hunter Valley', 'GI Zone', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Northern Rivers', 'GI Zone', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Northern Slopes', 'GI Zone', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South Coast', 'GI Zone', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Southern New South Wales', 'GI Zone', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Western Plains', 'GI Zone', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Murray Darling', 'GI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Perricoota', 'GI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riverina', 'GI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Swan Hill', 'GI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cowra', 'GI', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mudgee', 'GI', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Orange', 'GI', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hunter', 'GI', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hastings River', 'GI', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'New England Australia', 'GI', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Shoalhaven Coast', 'GI', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Southern Highlands', 'GI', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canberra District', 'GI', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gundagai', 'GI', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hilltops', 'GI', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tumbarumba', 'GI', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Broke Fordwich', 'GI Subregion', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pokolbin', 'GI Subregion', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Hunter Valley', 'GI Subregion', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='New South Wales';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Victoria', 2 from public.countries c where c.name='Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Victoria', 'State GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Victoria', 'GI Zone', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gippsland', 'GI Zone', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'North East Victoria', 'GI Zone', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'North West Victoria', 'GI Zone', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Port Phillip', 'GI Zone', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Western Victoria', 'GI Zone', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bendigo', 'GI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goulburn Valley', 'GI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Heathcote', 'GI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Strathbogie Ranges', 'GI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Goulburn', 'GI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alpine Valleys', 'GI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Beechworth', 'GI', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Glenrowan', 'GI', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'King Valley', 'GI', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rutherglen', 'GI', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Geelong', 'GI', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Macedon Ranges', 'GI', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mornington Peninsula', 'GI', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sunbury', 'GI', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yarra Valley', 'GI', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grampians', 'GI', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Henty', 'GI', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pyrenees', 'GI', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nagambie Lakes', 'GI Subregion', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Great Western', 'GI Subregion', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Victoria';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Western Australia', 3 from public.countries c where c.name='Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Western Australia', 'State GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Western Australia', 'GI Zone', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eastern Plains, Inland and North of Western Australia', 'GI Zone', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Greater Perth', 'GI Zone', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South West Australia', 'GI Zone', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'West Australian South East Coastal', 'GI Zone', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peel', 'GI', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Perth Hills', 'GI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Swan District', 'GI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Blackwood Valley', 'GI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Geographe', 'GI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Great Southern', 'GI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Manjimup', 'GI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Margaret River', 'GI', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pemberton', 'GI', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Swan Valley', 'GI Subregion', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Albany', 'GI Subregion', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Denmark', 'GI Subregion', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Frankland River', 'GI Subregion', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mount Barker', 'GI Subregion', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Porongurup', 'GI Subregion', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Western Australia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Queensland', 4 from public.countries c where c.name='Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Queensland', 'State GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Queensland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Granite Belt', 'GI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Queensland';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'South Burnett', 'GI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Queensland';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Tasmania', 5 from public.countries c where c.name='Australia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tasmania', 'State GI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Australia' and r.name='Tasmania';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Australia' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Australia' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Australia'
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
