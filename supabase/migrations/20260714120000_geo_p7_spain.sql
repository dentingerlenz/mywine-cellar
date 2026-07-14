-- Phase 7: Spanien auf das offizielle MAPA-Register umstellen (Prod).
-- Ersetzt die alten ES-Appellationen/-Regionen durch den verifizierten
-- 149er-Satz (flach, data/geography/spain.json). Wein-FKs per Namensabgleich:
-- Appellation > alte Sub-Region (jetzt Appellation) > Region. No-op-sicher frisch.

begin;
create temp table _es_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Spain'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Spain' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Spain' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Spain' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Rioja', 0 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rioja', 'DOCa', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valles de Sadacia', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Rioja';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Pais Vasco', 1 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arabako Txakolina', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Pais Vasco';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bizkaiko Txakolina', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Pais Vasco';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Getariako Txakolina', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Pais Vasco';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Navarra', 2 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, '3 Riberas', 'VdlT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Navarra';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bolandin', 'VP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Navarra';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Navarra', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Navarra';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pago de Arinzano', 'VP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Navarra';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pago de Otazu', 'VP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Navarra';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Prado de Irache', 'VP', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Navarra';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribera del Queiles', 'VdlT', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Navarra';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Aragon', 3 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ayles', 'VP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bajo Aragon', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calatayud', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campo de Borja', 'DO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carinena', 'DO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribera del Gallego - Cinco Villas', 'VdlT', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribera del Jiloca', 'VdlT', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Somontano', 'DO', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Urbezo', 'DO', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdejalon', 'VdlT', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Cinca', 'VdlT', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Aragon';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Cataluna', 4 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alella', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cataluna', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cava', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Conca de Barbera', 'DO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costers del Segre', 'DO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Emporda', 'DO', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montsant', 'DO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Penedes', 'DO', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pla de Bages', 'DO', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Priorat', 'DOCa', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tarragona', 'DO', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terra Alta', 'DO', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cataluna';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Castilla y Leon', 5 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Abadia Retuerta', 'VP', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arlanza', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arribes', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bierzo', 'DO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castilla y Leon', 'VdlT', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cebreros', 'VC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cigales', 'DO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dehesa Penalba', 'VP', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Leon', 'DO', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribera del Duero', 'DO', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rueda', 'DO', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sierra de Salamanca', 'VC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tierra del Vino de Zamora', 'DO', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Toro', 'DO', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Uruena', 'VP', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valles de Benavente', 'VC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valtiendas', 'VC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla y Leon';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Castilla-La Mancha', 6 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Almansa', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calzadilla', 'VP', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campo de Calatrava', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campo de La Guardia', 'VP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casa del Blanco', 'VP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castilla', 'VdlT', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dehesa del Carrizal', 'VP', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dominio de Valdepusa', 'VP', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'El Vicario', 'VP', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Finca Elez', 'VP', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Guijoso', 'VP', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Jaraba', 'VP', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Mancha', 'DO', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Los Cerrillos', 'VP', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Manchuela', 'DO', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mentrida', 'DO', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mondejar', 'DO', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pago Florentino', 'VP', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribera del Jucar', 'DO', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rio Negro', 'VP', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosalejo', 'VP', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ucles', 'DO', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdepenas', 'DO', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vallegarcia', 'VP', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Castilla-La Mancha';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Madrid', 7 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinos de Madrid', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Madrid';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Valencia', 8 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alicante', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castello', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chozas Carrascal', 'VP', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'El Terrerazo', 'VP', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Los Balagueses', 'VP', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tharsys', 'VP', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Utiel-Requena', 'DO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valencia', 'DO', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vera de Estenas', 'VP', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Valencia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Murcia', 9 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bullas', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Murcia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campo de Cartagena', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Murcia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jumilla', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Murcia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Murcia', 'VdlT', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Murcia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Yecla', 'DO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Murcia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Galicia', 10 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbanza e Iria', 'VdlT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Betanzos', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monterrei', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rias Baixas', 'DO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribeira Sacra', 'DO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribeiras do Morrazo', 'VdlT', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribeiro', 'DO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terras do Navia', 'VdlT', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdeorras', 'DO', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Mino-Ourense', 'VdlT', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Galicia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Asturias', 11 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cangas', 'VC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Asturias';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Cantabria', 12 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa de Cantabria', 'VdlT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cantabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Liebana', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Cantabria';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Extremadura', 13 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Extremadura', 'VdlT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Extremadura';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribera del Guadiana', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Extremadura';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Andalucia', 14 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Altiplano de Sierra Nevada', 'VdlT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bailen', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cadiz', 'VdlT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Condado de Huelva', 'DO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cordoba', 'VdlT', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cumbres del Guadalfeo', 'VdlT', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Desierto de Almeria', 'VdlT', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Granada', 'DO', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jerez-Xeres-Sherry', 'DO', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Laderas del Genil', 'VdlT', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Laujar-Alpujarra', 'VdlT', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lebrija', 'VC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Los Palacios', 'VdlT', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malaga', 'DO', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Manzanilla-Sanlucar de Barrameda', 'DO', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montilla-Moriles', 'DO', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Norte de Almeria', 'VdlT', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ribera del Andarax', 'VdlT', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sierra Norte de Sevilla', 'VdlT', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sierra Sur de Jaen', 'VdlT', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sierras de Las Estancias y Los Filabres', 'VdlT', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sierras de Malaga', 'DO', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Torreperogil', 'VdlT', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Villaviciosa de Cordoba', 'VdlT', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Andalucia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Islas Baleares', 15 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Binissalem', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Formentera', 'VdlT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ibiza', 'VdlT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Illes Balears', 'VdlT', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Isla de Menorca', 'VdlT', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mallorca', 'VdlT', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pla i Llevant', 'DO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Serra de Tramuntana-Costa Nord', 'VdlT', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Baleares';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Islas Canarias', 16 from public.countries c where c.name='Spain';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Abona', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'El Hierro', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gran Canaria', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Islas Canarias', 'VC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Gomera', 'DO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Palma', 'DO', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lanzarote', 'DO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tacoronte-Acentejo', 'DO', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Guimar', 'DO', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de la Orotava', 'DO', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ycoden-Daute-Isora', 'DO', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Spain' and r.name='Islas Canarias';

update public.wines w set appellation_id = na.id from _es_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Spain' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _es_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Spain' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _es_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Spain'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
commit;
