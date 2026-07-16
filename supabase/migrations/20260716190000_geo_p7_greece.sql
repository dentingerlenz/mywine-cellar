-- Phase 7: Greece auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Greece-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/greece.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Greece'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Greece' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Greece' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Greece' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Macedonia', 0 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Naoussa', 'PDO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Goumenissa', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Amynteo', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Slopes of Meliton', 'PDO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Macedonia', 'PGI', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Drama', 'PGI', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Epanomi', 'PGI', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chalkidiki', 'PGI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Florina', 'PGI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pella', 'PGI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pieria', 'PGI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Serres', 'PGI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kavala', 'PGI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thessaloniki', 'PGI', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grevena', 'PGI', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kozani', 'PGI', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kastoria', 'PGI', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mount Athos', 'PGI', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Macedonia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Thrace', 1 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thrace', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thrace';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Avdira', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thrace';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ismaros', 'PGI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thrace';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Evros', 'PGI', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thrace';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Epirus', 2 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zitsa', 'PDO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Epirus';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Epirus', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Epirus';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ioannina', 'PGI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Epirus';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Metsovo', 'PGI', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Epirus';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Thessaly', 3 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rapsani', 'PDO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Messenikola', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Anchialos', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thessalia', 'PGI', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tyrnavos', 'PGI', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Krania', 'PGI', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Karditsa', 'PGI', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Meteora', 'PGI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Magnesia', 'PGI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pelion', 'PGI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Larissa', 'PGI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Thessaly';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Central Greece', 4 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sterea Ellada', 'PGI', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Attiki', 'PGI', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Viotia', 'PGI', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Evia', 'PGI', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Atalanti', 'PGI', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Parnassos', 'PGI', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fthiotida', 'PGI', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ritsona', 'PGI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Markopoulo', 'PGI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pallini', 'PGI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Spata', 'PGI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Koropi', 'PGI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peania', 'PGI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Central Greece';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Ionian Islands', 5 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Robola of Kefalonia', 'PDO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mavrodaphne of Kefalonia', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Muscat of Kefalonia', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ionian Islands', 'PGI', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zakynthos', 'PGI', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lefkada', 'PGI', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Corfu', 'PGI', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kefallonia', 'PGI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Slopes of Ainos', 'PGI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Ionian Islands';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Peloponnese', 6 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nemea', 'PDO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mantinia', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Patra', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mavrodaphne of Patra', 'PDO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Muscat of Patra', 'PDO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Muscat of Rio Patra', 'PDO', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monemvasia-Malvasia', 'PDO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peloponnese', 'PGI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Achaia', 'PGI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Corinthos', 'PGI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Argolida', 'PGI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arkadia', 'PGI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lakonia', 'PGI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Messinia', 'PGI', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ilia', 'PGI', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Slopes of Aigialeia', 'PGI', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tegea', 'PGI', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trifilia', 'PGI', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Peloponnese';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Aegean Islands', 7 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santorini', 'PDO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paros', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia Paros', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rhodes', 'PDO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Muscat of Rhodes', 'PDO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lemnos', 'PDO', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Muscat of Lemnos', 'PDO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Samos', 'PDO', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aegean Sea', 'PGI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cyclades', 'PGI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dodecanese', 'PGI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ikaria', 'PGI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chios', 'PGI', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lesbos', 'PGI', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Naxos', 'PGI', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Syros', 'PGI', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tinos', 'PGI', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Thera', 'PGI', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Aegean Islands';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Kriti', 8 from public.countries c where c.name='Greece';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Archanes', 'PDO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dafnes', 'PDO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peza', 'PDO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sitia', 'PDO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia Sitia', 'PDO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia Chandakas-Candia', 'PDO', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kriti', 'PGI', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Heraklion', 'PGI', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chania', 'PGI', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rethymno', 'PGI', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lasithi', 'PGI', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Kissamos', 'PGI', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Greece' and r.name='Kriti';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Greece' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Greece' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Greece'
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
