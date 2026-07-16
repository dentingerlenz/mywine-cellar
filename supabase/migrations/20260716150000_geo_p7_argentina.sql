-- Phase 7: Argentina auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Argentina-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/argentina.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Argentina'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Argentina' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Argentina' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Argentina' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Buenos Aires', 0 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chapadmalal', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Buenos Aires';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Villa Ventana', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Buenos Aires';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Catamarca', 1 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Belen', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Catamarca';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Catamarca', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Catamarca';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Poman', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Catamarca';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Maria', 'IG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Catamarca';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tinogasta', 'IG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Catamarca';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Chubut', 2 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trevelin', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Chubut';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Cordoba', 3 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colon', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Cordoba';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colonia Caroya', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Cordoba';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cordoba Argentina', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Cordoba';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cruz del Eje', 'IG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Cordoba';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Javier', 'IG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Cordoba';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Cuyo', 4 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cuyo', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Cuyo';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Entre Rios', 5 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Victoria, Entre Rios', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Entre Rios';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Jujuy', 6 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jujuy', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Jujuy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Quebrada de Humahuaca', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Jujuy';
insert into public.regions (country_id, name, sort_order)
select c.id, 'La Rioja', 7 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arauco', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castro Barros', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chilecito', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Famatina', 'IG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Felipe Varela', 'IG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'General Lamadrid', 'IG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Rioja Argentina', 'IG', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Blas de los Sauces', 'IG', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sanagasta', 'IG', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Chanarmuyo', 'IG', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valles del Famatina', 'IG', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vinchina', 'IG', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='La Rioja';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Mendoza', 8 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Agrelo', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barrancas', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canota', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Distrito Medrano', 'IG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'El Paraiso', 'IG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'General Alvear', 'IG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Godoy Cruz', 'IG', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Guaymallen', 'IG', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Junin', 'IG', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Consulta', 'IG', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Paz', 'IG', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Las Compuertas', 'IG', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Las Heras', 'IG', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lavalle', 'IG', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Los Chacayes', 'IG', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lujan de Cuyo', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lunlunta', 'IG', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maipu', 'IG', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mendoza', 'IG', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pampa el Cepillo', 'IG', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paraje Altamira', 'IG', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Reduccion', 'IG', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rivadavia (Mendoza)', 'IG', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Russel', 'IG', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Carlos (Mendoza)', 'IG', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Martin (Mendoza)', 'IG', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Pablo', 'IG', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Rafael', 'DOC', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Rosa', 'IG', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tunuyan', 'IG', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tupungato', 'IG', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Uco', 'IG', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vista Flores', 'IG', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Mendoza';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Neuquen', 9 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Anelo', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Neuquen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Confluencia', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Neuquen';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Neuquen', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Neuquen';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Patagonia', 10 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Patagonia', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Patagonia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Rio Negro', 11 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alto valle de Rio Negro', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Rio Negro';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Avellaneda', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Rio Negro';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'General Conesa', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Rio Negro';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'General Roca', 'IG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Rio Negro';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pichimahuida', 'IG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Rio Negro';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rio Negro', 'IG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Rio Negro';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Salta', 12 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cachi', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Salta';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cafayate', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Salta';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Molinos', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Salta';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salta', 'IG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Salta';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Carlos (Salta)', 'IG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Salta';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valles Calchaquies', 'IG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Salta';
insert into public.regions (country_id, name, sort_order)
select c.id, 'San Juan', 13 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, '25 de Mayo', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, '9 de Julio', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Albardon', 'IG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Angaco', 'IG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barreal', 'IG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calingasta', 'IG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Caucete', 'IG', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chimbas', 'IG', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Iglesia', 'IG', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Jachal', 'IG', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pocito', 'IG', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pozo de los Algarrobos', 'IG', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rawson', 'IG', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rivadavia (San Juan)', 'IG', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Juan', 'IG', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Martin (San Juan)', 'IG', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Lucia', 'IG', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sarmiento', 'IG', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ullum', 'IG', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle Fertil', 'IG', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Zonda', 'IG', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Pedernal', 'IG', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Tulum', 'IG', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zonda', 'IG', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Juan';
insert into public.regions (country_id, name, sort_order)
select c.id, 'San Luis', 14 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Luis', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='San Luis';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Tucuman', 15 from public.countries c where c.name='Argentina';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tafi', 'IG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Tucuman';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tucuman', 'IG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Argentina' and r.name='Tucuman';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Argentina' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Argentina' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Argentina'
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
