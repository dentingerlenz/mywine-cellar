-- Phase 7: South Africa auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten South Africa-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/south-africa.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'South Africa'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'South Africa' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'South Africa' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'South Africa' and r.country_id = c.id;

insert into public.appellations (level, country_id, name, type, sort_order)
select 'country', c.id, 'Wine of Origin', 'WO', 0 from public.countries c where c.name='South Africa';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Western Cape', 0 from public.countries c where c.name='South Africa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Western Cape', 'WO Geographical Unit', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coastal Region', 'WO Region', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cape South Coast', 'WO Region', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Breede River Valley', 'WO Region', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Klein Karoo', 'WO Region', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Olifants River', 'WO Region', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cape Agulhas', 'WO District', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elgin', 'WO District', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lower Duivenhoks River', 'WO District', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Overberg', 'WO District', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Plettenberg Bay', 'WO District', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Swellendam', 'WO District', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Walker Bay', 'WO District', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Still Bay', 'WO District', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cape Town', 'WO District', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Darling', 'WO District', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Franschhoek', 'WO District', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lutzville Valley', 'WO District', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paarl', 'WO District', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Stellenbosch', 'WO District', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Swartland', 'WO District', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tulbagh', 'WO District', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Wellington', 'WO District', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Breedekloof', 'WO District', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Robertson', 'WO District', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Worcester', 'WO District', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calitzdorp', 'WO District', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Langeberg-Garcia', 'WO District', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Citrusdal Mountain', 'WO District', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Citrusdal Valley', 'WO District', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ceres Plateau', 'WO District', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Prince Albert', 'WO District', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elim', 'WO Ward', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elandskloof', 'WO Ward', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Greyton', 'WO Ward', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Klein River', 'WO Ward', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Shaw''s Mountain', 'WO Ward', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Theewater', 'WO Ward', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Buffeljags', 'WO Ward', 38
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malgas', 'WO Ward', 39
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Stormsvlei', 'WO Ward', 40
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bot River', 'WO Ward', 41
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hemel-en-Aarde Ridge', 'WO Ward', 42
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hemel-en-Aarde Valley', 'WO Ward', 43
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sunday''s Glen', 'WO Ward', 44
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Springfontein Rim', 'WO Ward', 45
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Stanford Foothills', 'WO Ward', 46
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Hemel-en-Aarde Valley', 'WO Ward', 47
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goukou River Valley', 'WO Ward', 48
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Herbertsdale', 'WO Ward', 49
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Napier', 'WO Ward', 50
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Constantia', 'WO Ward', 51
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Durbanville', 'WO Ward', 52
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hout Bay', 'WO Ward', 53
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Philadelphia', 'WO Ward', 54
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Groenekloof', 'WO Ward', 55
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Koekenaap', 'WO Ward', 56
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Agter-Paarl', 'WO Ward', 57
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Simonsberg-Paarl', 'WO Ward', 58
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Voor-Paardeberg', 'WO Ward', 59
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Banghoek', 'WO Ward', 60
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bottelary', 'WO Ward', 61
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Devon Valley', 'WO Ward', 62
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jonkershoek Valley', 'WO Ward', 63
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Papegaaiberg', 'WO Ward', 64
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Polkadraai Hills', 'WO Ward', 65
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Simonsberg-Stellenbosch', 'WO Ward', 66
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vlottenburg', 'WO Ward', 67
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malmesbury', 'WO Ward', 68
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paardeberg', 'WO Ward', 69
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paardeberg South', 'WO Ward', 70
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piket-Bo-Berg', 'WO Ward', 71
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Porseleinberg', 'WO Ward', 72
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riebeekberg', 'WO Ward', 73
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riebeeksrivier', 'WO Ward', 74
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'St Helena Bay', 'WO Ward', 75
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Blouvlei', 'WO Ward', 76
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bovlei', 'WO Ward', 77
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Groenberg', 'WO Ward', 78
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Limietberg', 'WO Ward', 79
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mid-Berg River', 'WO Ward', 80
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bamboes Bay', 'WO Ward', 81
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lamberts Bay', 'WO Ward', 82
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goudini', 'WO Ward', 83
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Slanghoek', 'WO Ward', 84
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Agterkliphoogte', 'WO Ward', 85
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ashton', 'WO Ward', 86
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Boesmansrivier', 'WO Ward', 87
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bonnievale', 'WO Ward', 88
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eilandia', 'WO Ward', 89
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goedemoed', 'WO Ward', 90
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goree', 'WO Ward', 91
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goudmyn', 'WO Ward', 92
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hoopsrivier', 'WO Ward', 93
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Klaasvoogds', 'WO Ward', 94
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Le Chasseur', 'WO Ward', 95
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'McGregor', 'WO Ward', 96
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinkrivier', 'WO Ward', 97
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zandrivier', 'WO Ward', 98
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hex River Valley', 'WO Ward', 99
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Keeromsberg', 'WO Ward', 100
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moordkuil', 'WO Ward', 101
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nuy', 'WO Ward', 102
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rooikrans', 'WO Ward', 103
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Scherpenheuvel', 'WO Ward', 104
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Stettyn', 'WO Ward', 105
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Groenfontein', 'WO Ward', 106
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cango Valley', 'WO Ward', 107
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Koo Plateau', 'WO Ward', 108
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montagu', 'WO Ward', 109
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Outeniqua', 'WO Ward', 110
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tradouw', 'WO Ward', 111
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tradouw Highlands', 'WO Ward', 112
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upper Langkloof', 'WO Ward', 113
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piekenierskloof', 'WO Ward', 114
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Spruitdrift', 'WO Ward', 115
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vredendal', 'WO Ward', 116
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ceres', 'WO Ward', 117
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kweekvallei', 'WO Ward', 118
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Prince Albert Valley', 'WO Ward', 119
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Swartberg', 'WO Ward', 120
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nieuwoudtville', 'WO Ward', 121
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cederberg', 'WO Ward', 122
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Leipoldtville-Sandveld', 'WO Ward', 123
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Western Cape';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Northern Cape', 1 from public.countries c where c.name='South Africa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Northern Cape', 'WO Geographical Unit', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Karoo-Hoogland', 'WO Region', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sutherland-Karoo', 'WO District', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Douglas', 'WO District', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Groblershoop', 'WO Ward', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grootdrink', 'WO Ward', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kakamas', 'WO Ward', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Keimoes', 'WO Ward', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Upington', 'WO Ward', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hartswater', 'WO Ward', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Prieska', 'WO Ward', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Northern Cape';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Eastern Cape', 2 from public.countries c where c.name='South Africa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eastern Cape', 'WO Geographical Unit', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Eastern Cape';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'St Francis Bay', 'WO Ward', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Eastern Cape';
insert into public.regions (country_id, name, sort_order)
select c.id, 'KwaZulu-Natal', 3 from public.countries c where c.name='South Africa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'KwaZulu-Natal', 'WO Geographical Unit', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='KwaZulu-Natal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Central Drakensberg', 'WO District', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='KwaZulu-Natal';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lions River', 'WO District', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='KwaZulu-Natal';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Free State', 4 from public.countries c where c.name='South Africa';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Free State', 'WO Geographical Unit', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Free State';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rietrivier FS', 'WO Ward', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='South Africa' and r.name='Free State';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='South Africa' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='South Africa' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='South Africa'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
-- SA-spezifisch: alte Sub-Regionen (Districts/Wards) ohne passende neue Appellation
-- ins Freitextfeld "location" übernehmen (nur wenn leer und ≠ zugewiesener Appellation).
-- Elgin & Co. matchen als neue Appellation und werden regulär aufgewertet; dies ist
-- das Sicherheitsnetz für nicht-gematchte. (Ändert nur "location" → kein geo-Trigger.)
update public.wines w set location = cap.sub_name
  from _mig_cap cap
 where w.id = cap.wine_id and cap.sub_name is not null
   and (w.location is null or btrim(w.location) = '')
   and cap.sub_name is distinct from coalesce((select a.name from public.appellations a where a.id = w.appellation_id), '');
commit;
