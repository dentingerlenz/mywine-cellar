-- Phase 7: Italien auf die offiziellen MASAF-Register umstellen (Prod).
-- Ersetzt die alten Italy-Appellationen/-Regionen durch den verifizierten 522er-
-- Satz (flach auf Regionsebene, data/geography/italy.json). Wein-FKs per Namens-
-- abgleich erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB (Italy-Country fehlt zur Migrationszeit; Seed baut neu).

begin;

create temp table _it_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w
  join public.countries it on it.id = w.country_id and it.name = 'Italy'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;

-- alte Italy-Geo loeschen (Appellationen -> Sub-Regionen -> Regionen)
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'Italy' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id)
        or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'Italy' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c
 where c.name = 'Italy' and r.country_id = c.id;

-- neue Italy-Geo (Regionen + Appellationen, flach)
insert into public.regions (country_id, name, sort_order)
select c.id, 'Piemonte', 0 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alba', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Albugnano', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alta Langa', 'DOCG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Asti', 'DOCG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbaresco', 'DOCG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera d''Alba', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera d''Asti', 'DOCG', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera del Monferrato', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbera del Monferrato Superiore', 'DOCG', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barolo', 'DOCG', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Boca', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Brachetto d''Acqui Acqui', 'DOCG', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bramaterra', 'DOC', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calosso', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canavese', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Canelli', 'DOCG', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carema', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cisterna d''Asti', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Tortonesi', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collina Torinese', 'DOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Novaresi', 'DOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Saluzzesi', 'DOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cortese dell''Alto Monferrato', 'DOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Coste della Sesia', 'DOC', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dogliani', 'DOCG', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto d''Acqui', 'DOC', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto d''Alba', 'DOC', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto d''Asti', 'DOC', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto di Diano d''Alba', 'DOCG', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto di Ovada', 'DOC', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dolcetto di Ovada Superiore', 'DOCG', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Erbaluce di Caluso', 'DOCG', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fara', 'DOC', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Freisa d''Asti', 'DOC', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Freisa di Chieri', 'DOC', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gabiano', 'DOC', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gattinara', 'DOCG', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gavi', 'DOCG', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ghemme', 'DOCG', 38
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grignolino d''Asti', 'DOC', 39
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grignolino del Monferrato Casalese', 'DOC', 40
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Langhe', 'DOC', 41
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lessona', 'DOC', 42
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Loazzolo', 'DOC', 43
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia di Casorzo', 'DOC', 44
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia di Castelnuovo Don Bosco', 'DOC', 45
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monferrato', 'DOC', 46
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nebbiolo d''Alba', 'DOC', 47
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nizza', 'DOCG', 48
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piemonte', 'DOC', 49
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pinerolese', 'DOC', 50
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Roero', 'DOCG', 51
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rubino di Cantavenna', 'DOC', 52
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ruche di Castagnole Monferrato', 'DOCG', 53
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sizzano', 'DOC', 54
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Strevi', 'DOC', 55
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Alfieri', 'DOCG', 56
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valli Ossolane', 'DOC', 57
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valsusa', 'DOC', 58
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verduno Pelaverga', 'DOC', 59
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Piemonte';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Valle d''Aosta', 1 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle d''Aosta Vallee d''Aoste', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Valle d''Aosta';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Lombardia', 2 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alpi Retiche', 'IGT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alto Mincio', 'IGT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Benaco Bresciano', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bergamasca', 'IGT', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bonarda dell''Oltrepo Pavese', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Botticino', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Buttafuoco dell''Oltrepo Pavese', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Capriano del Colle', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casteggio', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cellatica', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collina del Milanese', 'IGT', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Curtefranca', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Franciacorta', 'DOCG', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Garda', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Garda Colli Mantovani', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco Mantovano', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lugana', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montenetto di Brescia', 'IGT', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Scanzo', 'DOCG', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oltrepo Pavese', 'DOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oltrepo Pavese metodo classico', 'DOCG', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Oltrepo Pavese Pinot grigio', 'DOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pinot nero dell''Oltrepo Pavese', 'DOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Provincia di Mantova', 'IGT', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Provincia di Pavia', 'IGT', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Quistello', 'IGT', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riviera del Garda Classico', 'DOC', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ronchi di Brescia', 'IGT', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ronchi Varesini', 'IGT', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Valtellina', 'DOC', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sabbioneta', 'IGT', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Colombano al Lambro', 'DOC', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Martino della Battaglia', 'DOC', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sangue di Giuda dell''Oltrepo Pavese', 'DOC', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sebino', 'IGT', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sforzato di Valtellina', 'DOCG', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre del Colleoni', 'DOC', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Lariane', 'IGT', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valcalepio', 'DOC', 38
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valcamonica', 'IGT', 39
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valtellina Superiore', 'DOCG', 40
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lombardia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Trentino-Alto Adige', 3 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alto Adige', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casteller', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lago di Caldaro', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mitterberg', 'IGT', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Teroldego Rotaliano', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trentino', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trento', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdadige', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdadige Terradeiforti', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vallagarina', 'IGT', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vigneti delle Dolomiti', 'IGT', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Trentino-Alto Adige';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Veneto', 4 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Amarone della Valpolicella', 'DOCG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arcole', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Asolo Montello', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Asolo Prosecco', 'DOCG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bagnoli di Sopra', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bagnoli Friularo', 'DOCG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bardolino', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bardolino Superiore', 'DOCG', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Breganze', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Berici', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Conegliano', 'DOCG', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Euganei', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Euganei Fior d''Arancio', 'DOCG', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Trevigiani', 'IGT', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Conegliano Valdobbiadene Prosecco', 'DOCG', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Conselvano', 'IGT', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Corti Benedettine del Padovano', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Custoza', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gambellara', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lessini Durello', 'DOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marca Trevigiana', 'IGT', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Merlara', 'DOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montello Rosso', 'DOCG', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monti Lessini', 'DOC', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piave', 'DOC', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Piave Malanotte', 'DOCG', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Recioto della Valpolicella', 'DOCG', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Recioto di Gambellara', 'DOCG', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Recioto di Soave', 'DOCG', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riviera del Brenta', 'DOC', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Soave', 'DOC', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Soave Superiore', 'DOCG', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valpolicella', 'DOC', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valpolicella Ripasso', 'DOC', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Veneto', 'IGT', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Veneto Orientale', 'IGT', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Venezia', 'DOC', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verona', 'IGT', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vicenza', 'DOC', 38
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vigneti della Serenissima', 'DOC', 39
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Veneto';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Friuli-Venezia Giulia', 5 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alto Livenza', 'IGT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carso', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Orientali del Friuli Picolit', 'DOCG', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Collio Goriziano', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'delle Venezie', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Annia', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Aquileia', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Colli Orientali', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Grave', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Isonzo', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Friuli Latisana', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lison', 'DOCG', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lison-Pramaggiore', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Prosecco', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ramandolo', 'DOCG', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosazzo', 'DOCG', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trevenezie', 'IGT', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Venezia Giulia', 'IGT', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Friuli-Venezia Giulia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Liguria', 6 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cinque Terre', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Luni', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline del Genovesato', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline di Levanto', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Savonesi', 'IGT', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Golfo del Tigullio - Portofino', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Liguria di Levante', 'IGT', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ormeasco di Pornassio', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riviera Ligure di Ponente', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rossese di Dolceacqua', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terrazze dell''Imperiese', 'IGT', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val Polcevera', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Liguria';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Emilia-Romagna', 7 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bosco Eliceo', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castelfranco Emilia', 'IGT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Bolognesi', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Bolognesi Pignoletto', 'DOCG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli d''Imola', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Faenza', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Parma', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Scandiano e di Canossa', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Piacentini', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Romagna centrale', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Emilia dell''Emilia', 'IGT', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Emilia-Romagna', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Forli', 'IGT', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fortana del Taro', 'IGT', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gutturnio', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco di Sorbara', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco Grasparossa di Castelvetro', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lambrusco Salamino di Santa Croce', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Modena', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ortrugo dei Colli Piacentini', 'DOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ravenna', 'IGT', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Reggiano', 'DOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Reno', 'DOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rimini', 'DOC', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Romagna', 'DOC', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Romagna Albana', 'DOCG', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rubicone', 'IGT', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sillaro', 'IGT', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Veleja', 'IGT', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val Tidone', 'IGT', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Emilia-Romagna';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Toscana', 8 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alta Valle della Greve', 'IGT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ansonica Costa dell''Argentario', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barco Reale di Carmignano', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco dell''Empolese', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco di Pitigliano', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bolgheri', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bolgheri Sassicaia', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Brunello di Montalcino', 'DOCG', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Candia dei Colli Apuani', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Capalbio', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carmignano', 'DOCG', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chianti', 'DOCG', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Chianti Classico', 'DOCG', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli dell''Etruria Centrale', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli della Toscana centrale', 'IGT', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Lucchesi', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cortona', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa Toscana', 'IGT', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elba', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Elba Aleatico Passito', 'DOCG', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grance Senesi', 'DOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Maremma toscana', 'DOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecarlo', 'DOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecastelli', 'IGT', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecucco', 'DOC', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecucco Sangiovese', 'DOCG', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monteregio di Massa Marittima', 'DOC', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montescudaio', 'DOC', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Morellino di Scansano', 'DOCG', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscadello di Montalcino', 'DOC', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Orcia', 'DOC', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Parrina', 'DOC', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pomino', 'DOC', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Montalcino', 'DOC', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Montepulciano', 'DOC', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Gimignano', 'DOC', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Torpe', 'DOC', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sant''Antimo', 'DOC', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sovana', 'DOC', 38
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Suvereto', 'DOCG', 39
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terratico di Bibbona', 'DOC', 40
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Casole', 'DOC', 41
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Pisa', 'DOC', 42
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Toscano Toscana', 'IGT', 43
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val d''Arbia', 'DOC', 44
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val d''Arno di Sopra', 'DOC', 45
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Cornia', 'DOC', 46
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Cornia Rosso', 'DOCG', 47
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Magra', 'IGT', 48
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdichiana toscana', 'DOC', 49
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdinievole', 'DOC', 50
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vernaccia di San Gimignano', 'DOCG', 51
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo del Chianti', 'DOC', 52
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo del Chianti Classico', 'DOC', 53
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo di Carmignano', 'DOC', 54
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vin Santo di Montepulciano', 'DOC', 55
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vino Nobile di Montepulciano', 'DOCG', 56
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Toscana';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Umbria', 9 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Allerona', 'IGT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Amelia', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Assisi', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bettona', 'IGT', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cannara', 'IGT', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Altotiberini', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli del Trasimeno', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Martani', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Perugini', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lago di Corbara', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montefalco', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montefalco Sagrantino', 'DOCG', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Narni', 'IGT', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso Orvietano', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Spello', 'IGT', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Spoleto', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Todi', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Torgiano', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Torgiano Rosso Riserva', 'DOCG', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Umbria', 'IGT', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Umbria';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Marche', 10 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianchello del Metauro', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castelli di Jesi Verdicchio Riserva', 'DOCG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Maceratesi', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Pesaresi', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Conero', 'DOCG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Esino', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Falerio', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'I Terreni di Sanseverino', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lacrima di Morro d''Alba', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marche', 'IGT', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Offida', 'DOCG', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pergola', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso Conero', 'DOC', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso Piceno', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Ginesio', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Serrapetrona', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Offida', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verdicchio dei Castelli di Jesi', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verdicchio di Matelica', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Verdicchio di Matelica Riserva', 'DOCG', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vernaccia di Serrapetrona', 'DOCG', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Marche';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Lazio', 11 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aleatico di Gradoli', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Anagni', 'IGT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aprilia', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Atina', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bianco Capena', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cannellino di Frascati', 'DOCG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castelli Romani', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cerveteri', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cesanese del Piglio', 'DOCG', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cesanese di Affile', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cesanese di Olevano Romano', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Circeo', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Civitella d''Agliano', 'IGT', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Albani', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Cimini', 'IGT', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli della Sabina', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Etruschi Viterbesi', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli Lanuvini', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cori', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa Etrusco Romana', 'IGT', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Est! Est!! Est!!! di Montefiascone', 'DOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Frascati', 'DOC', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Frascati Superiore', 'DOCG', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Frusinate', 'IGT', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Genazzano', 'DOC', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lazio', 'IGT', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marino', 'DOC', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montecompatri Colonna', 'DOC', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Terracina', 'DOC', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nettuno', 'DOC', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Orvieto', 'DOC', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Roma', 'DOC', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tarquinia', 'DOC', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Velletri', 'DOC', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vignanello', 'DOC', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Zagarolo', 'DOC', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Lazio';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Abruzzo', 12 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Abruzzo', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casauria', 'DOCG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cerasuolo d''Abruzzo', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Controguerra', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montepulciano d''Abruzzo', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Montepulciano d''Abruzzo Colline Teramane', 'DOCG', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ortona', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Abruzzesi', 'IGT', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Aquilane', 'IGT', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Tollesi Tullum', 'DOCG', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trebbiano d''Abruzzo', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Villamagna', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Abruzzo';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Molise', 13 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Biferno', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Molise';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Molise', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Molise';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Osco Terre degli Osci', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Molise';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pentro di Isernia', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Molise';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rotae', 'IGT', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Molise';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tintilia del Molise', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Molise';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Campania', 14 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aglianico del Taburno', 'DOCG', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aversa', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Benevento Beneventano', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campania', 'IGT', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campi Flegrei', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Capri', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Casavecchia di Pontelatone', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel San Lorenzo', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Catalanesca del Monte Somma', 'IGT', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cilento', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli di Salerno', 'IGT', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa d''Amalfi', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Dugenta', 'IGT', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Epomeo', 'IGT', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Falanghina del Sannio', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Falerno del Massico', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fiano di Avellino', 'DOCG', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Galluccio', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Greco di Tufo', 'DOCG', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Irpinia', 'DOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ischia', 'DOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Paestum', 'IGT', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Penisola Sorrentina', 'DOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pompeiano', 'IGT', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Roccamonfina', 'IGT', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sannio', 'DOC', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Taurasi', 'DOCG', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre del Volturno', 'IGT', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vesuvio', 'DOC', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Campania';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Basilicata', 15 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aglianico del Vulture', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Basilicata';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aglianico del Vulture Superiore', 'DOCG', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Basilicata';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Basilicata', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Basilicata';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Grottino di Roccanova', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Basilicata';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Matera', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Basilicata';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre dell''Alta Val d''Agri', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Basilicata';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Calabria', 16 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arghilla', 'IGT', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Bivongi', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Calabria', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ciro', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ciro Classico', 'DOCG', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Costa Viola', 'IGT', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Greco di Bianco', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lamezia', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lipuda', 'IGT', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Locride', 'IGT', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Melissa', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Palizzi', 'IGT', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pellaro', 'IGT', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'S. Anna di Isola Capo Rizzuto', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Savuto', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Scavigna', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Scilla', 'IGT', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre di Cosenza', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Val di Neto', 'IGT', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valdamato', 'IGT', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Calabria';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Puglia', 17 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Aleatico di Puglia', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alezio', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barletta', 'DOC', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Brindisi', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cacc''e mmitte di Lucera', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte Bombino Nero', 'DOCG', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte Nero di Troia Riserva', 'DOCG', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Castel del Monte Rosso Riserva', 'DOCG', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colline Joniche Tarantine', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Copertino', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Daunia', 'IGT', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Galatina', 'DOC', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gioia del Colle', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Gravina', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Leverano', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Lizzano', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Locorotondo', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Martina Franca', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Matino', 'DOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Trani', 'DOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Murgia', 'IGT', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nardo', 'DOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Negroamaro di Terra d''Otranto', 'DOC', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Orta Nova', 'DOC', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ostuni', 'DOC', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Primitivo di Manduria', 'DOC', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Primitivo di Manduria Dolce Naturale', 'DOCG', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Puglia', 'IGT', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Rosso di Cerignola', 'DOC', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salento', 'IGT', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salice Salentino', 'DOC', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'San Severo', 'DOC', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Squinzano', 'DOC', 33
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tarantino', 'IGT', 34
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tavoliere delle Puglie', 'DOC', 35
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terra d''Otranto', 'DOC', 36
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle d''Itria', 'IGT', 37
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Puglia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Sicilia', 18 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alcamo', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Avola', 'IGT', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Camarro', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cerasuolo di Vittoria', 'DOCG', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Contea di Sclafani', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Contessa Entellina', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Delia Nivolelli', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Eloro', 'DOC', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Erice', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Etna', 'DOC', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Faro', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Fontanarossa di Cerda', 'IGT', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia delle Lipari', 'DOC', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mamertino di Milazzo', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marsala', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Menfi', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monreale', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Noto', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Pantelleria', 'DOC', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Riesi', 'DOC', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salaparuta', 'DOC', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Salina', 'IGT', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sambuca di Sicilia', 'DOC', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Santa Margherita di Belice', 'DOC', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sciacca', 'DOC', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sicilia', 'DOC', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Siracusa', 'DOC', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Terre Siciliane', 'IGT', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle Belice', 'IGT', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vittoria', 'DOC', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sicilia';
insert into public.regions (country_id, name, sort_order)
select c.id, 'Sardegna', 19 from public.countries c where c.name='Italy';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Alghero', 'DOC', 0
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Arborea', 'DOC', 1
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Barbagia', 'IGT', 2
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cagliari', 'DOC', 3
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Campidano di Terralba', 'DOC', 4
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Cannonau di Sardegna', 'DOC', 5
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Carignano del Sulcis', 'DOC', 6
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Colli del Limbara', 'IGT', 7
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Giro di Cagliari', 'DOC', 8
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Isola dei Nuraghi', 'IGT', 9
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Malvasia di Bosa', 'DOC', 10
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Mandrolisai', 'DOC', 11
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Marmilla', 'IGT', 12
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Monica di Sardegna', 'DOC', 13
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Sardegna', 'DOC', 14
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Moscato di Sorso-Sennori', 'DOC', 15
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nasco di Cagliari', 'DOC', 16
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nuragus di Cagliari', 'DOC', 17
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Nurra', 'IGT', 18
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Ogliastra', 'IGT', 19
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Parteolla', 'IGT', 20
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Planargia', 'IGT', 21
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Provincia di Nuoro', 'IGT', 22
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Romangia', 'IGT', 23
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sardegna Semidano', 'DOC', 24
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Sibiola', 'IGT', 25
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Tharros', 'IGT', 26
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Trexenta', 'IGT', 27
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valle del Tirso', 'IGT', 28
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Valli di Porto Pino', 'IGT', 29
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vermentino di Gallura', 'DOCG', 30
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vermentino di Sardegna', 'DOC', 31
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';
insert into public.appellations (level, region_id, name, type, sort_order)
select 'region', r.id, 'Vernaccia di Oristano', 'DOC', 32
 from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name='Sardegna';

-- Wein-Zuordnungen wiederherstellen
-- 1) alte Appellation (Name ueberlebt)
update public.wines w set appellation_id = na.id
  from _it_cap cap
  join public.appellations na on na.name = cap.app_name
  join public.countries c on c.name='Italy' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and cap.app_name is not null;
-- 2) alte Sub-Region, die jetzt eine Appellation ist (z.B. Etna, Alto Adige)
update public.wines w set appellation_id = na.id
  from _it_cap cap
  join public.appellations na on na.name = cap.sub_name
  join public.countries c on c.name='Italy' and (na.country_id=c.id or na.region_id in (select r.id from public.regions r where r.country_id=c.id))
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
-- 3) Region (Name ueberlebt)
update public.wines w set region_id = nr.id
  from _it_cap cap
  join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Italy'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;

commit;
