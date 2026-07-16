-- Phase 7: Chile auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten Chile-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/chile.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = 'Chile'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Chile' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Chile' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = 'Chile' and r.country_id = c.id;

insert into public.regions (country_id, name, sort_order)
select c.id, 'Atacama', 0 from public.countries c where c.name='Chile';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Copiapo', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Atacama';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Huasco', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Atacama';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Coquimbo', 1 from public.countries c where c.name='Chile';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Elqui', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Limari', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Choapa', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Serena', 'DO Area', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vicuna', 'DO Area', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paiguano', 'DO Area', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ovalle', 'DO Area', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Punitaqui', 'DO Area', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rio Hurtado', 'DO Area', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salamanca', 'DO Area', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Illapel', 'DO Area', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Coquimbo';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Aconcagua', 2 from public.countries c where c.name='Chile';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Aconcagua', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Casablanca', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de San Antonio', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Marga-Marga', 'DO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Leyda', 'DO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Panquehue', 'DO Area', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Quillota', 'DO Area', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Hijuelas', 'DO Area', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Catemu', 'DO Area', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Llaillay', 'DO Area', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Felipe', 'DO Area', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Maria', 'DO Area', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calle Larga', 'DO Area', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Esteban', 'DO Area', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Juan', 'DO Area', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santo Domingo', 'DO Area', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zapallar', 'DO Area', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cartagena', 'DO Area', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Aconcagua';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Valle Central', 3 from public.countries c where c.name='Chile';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Maipo', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Rapel', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Curico', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Maule', 'DO', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Cachapoal', 'DO', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Colchagua', 'DO', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Teno', 'DO', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Lontue', 'DO', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Claro', 'DO', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Loncomilla', 'DO', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Tutuven', 'DO', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pirque', 'DO Area', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Puente Alto', 'DO Area', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Buin', 'DO Area', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Isla de Maipo', 'DO Area', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Talagante', 'DO Area', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Melipilla', 'DO Area', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maria Pinto', 'DO Area', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colina', 'DO Area', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calera de Tango', 'DO Area', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Til Til', 'DO Area', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lampa', 'DO Area', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rancagua', 'DO Area', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Requinoa', 'DO Area', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peumo', 'DO Area', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Machali', 'DO Area', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coltauco', 'DO Area', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Fernando', 'DO Area', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chimbarongo', 'DO Area', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nancagua', 'DO Area', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Cruz', 'DO Area', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Palmilla', 'DO Area', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Peralillo', 'DO Area', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lolol', 'DO Area', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Litueche', 'DO Area', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'La Estrella', 'DO Area', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paredones', 'DO Area', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pumanque', 'DO Area', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rauco', 'DO Area', 38
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Romeral', 'DO Area', 39
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vichuquen', 'DO Area', 40
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Molina', 'DO Area', 41
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Talca', 'DO Area', 42
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pencahue', 'DO Area', 43
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Clemente', 'DO Area', 44
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Rafael', 'DO Area', 45
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Empedrado', 'DO Area', 46
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Curepto', 'DO Area', 47
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Javier', 'DO Area', 48
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Villa Alegre', 'DO Area', 49
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Parral', 'DO Area', 50
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Linares', 'DO Area', 51
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colbun', 'DO Area', 52
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Longavi', 'DO Area', 53
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Retiro', 'DO Area', 54
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Valle Central';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Sur', 4 from public.countries c where c.name='Chile';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Itata', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Sur';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Bio-Bio', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Sur';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Malleco', 'DO', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Sur';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chillan', 'DO Area', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Sur';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Quillon', 'DO Area', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Sur';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coelemu', 'DO Area', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Sur';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mulchen', 'DO Area', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Sur';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Austral', 5 from public.countries c where c.name='Chile';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Cautin', 'DO', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Austral';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle de Osorno', 'DO', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Chile' and r.name='Austral';

update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name join public.countries c on c.name='Chile' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name join public.countries c on c.name='Chile' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Chile'
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
