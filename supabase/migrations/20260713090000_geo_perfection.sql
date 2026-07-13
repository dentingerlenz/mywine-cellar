-- Geo-Perfektion (Voll-Audit): Struktur- und Datenfehler beheben.
-- Spiegelt data/geography/*.json für die bereits geseedete Prod-DB.
-- ID-erhaltende Moves; Weine werden vor jeder Löschung umgehängt;
-- Pseudo-Einträge werden nur gelöscht, wenn unreferenziert.
-- No-op-sicher auf leerer DB (lokal läuft danach das saubere Seed).

begin;

-- ── 1. Renames ────────────────────────────────────────────────────────────────
update public.appellations set name = 'American' where name = 'American Wine';
update public.appellations set name = 'Ruster Ausbruch' where name = 'Rust Ausbruch';
update public.appellations set name = 'Vire-Clesse' where name = 'Viire-Clesse';
update public.appellations set name = 'Zürich' where name = 'Zurich';
update public.appellations set name = 'Basilicata' where name = 'IGT Basilicata';
update public.appellations set name = 'Calabria' where name = 'IGT Calabria';
update public.appellations set name = 'Campania' where name = 'IGT Campania';
update public.appellations set name = 'Delle Venezie' where name = 'IGT Delle Venezie';
update public.appellations set name = 'Emilia' where name = 'IGT Emilia';
update public.appellations set name = 'Isola dei Nuraghi' where name = 'IGT Isola dei Nuraghi';
update public.appellations set name = 'Lazio' where name = 'IGT Lazio';
update public.appellations set name = 'Lombardia' where name = 'IGT Lombardia';
update public.appellations set name = 'Marche' where name = 'IGT Marche';
update public.appellations set name = 'Puglia' where name = 'IGT Puglia';
update public.appellations set name = 'Terre Siciliane' where name = 'IGT Terre Siciliane';
update public.appellations set name = 'Terre di Chieti' where name = 'IGT Terre di Chieti';
update public.appellations set name = 'Toscana' where name = 'IGT Toscana';
update public.appellations set name = 'Umbria' where name = 'IGT Umbria';
update public.appellations set name = 'Bajo Aragon' where name = 'Vino de la Tierra Bajo Aragon';
update public.appellations set name = 'Barbanza e Iria' where name = 'Vino de la Tierra Barbanza e Iria';
update public.appellations set name = 'Cadiz' where name = 'Vino de la Tierra Cadiz';
update public.appellations set name = 'Castilla y Leon' where name = 'Vino de la Tierra Castilla y Leon';
update public.appellations set name = 'Cataluna' where name = 'Vino de la Tierra Cataluna';
update public.appellations set name = 'Extremadura' where name = 'Vino de la Tierra Extremadura';
update public.appellations set name = substring(name from 16) where name like 'Vinho Regional %' and name <> 'Vinho Regional Transmontano';
update public.sub_regions set name = 'Crus du Beaujolais' where name = 'Beaujolais Crus';
update public.regions set name = 'Geneve' where name = 'Genève';
update public.sub_regions set name = 'Neuchatel' where name = 'Neuchâtel';

-- ── 2. Typ-Fixes ──────────────────────────────────────────────────────────────
update public.appellations set type = 'Anbaugebiet' where type = 'Pradikatswein';
update public.appellations set type = 'GI'          where type = 'Broad GI';
update public.appellations set type = 'VR'          where type = 'Vinho Regional';
update public.appellations set type = 'DAC' where name = 'Wachau';
update public.appellations set type = 'DAC' where name = 'Thermenregion';
update public.appellations set type = 'DAC' where name = 'Ruster Ausbruch';

-- ── 3. Frankreich-Spezialfälle ───────────────────────────────────────────────
-- 3a Bourgogne: Pseudo-Sub 'Regional' auflösen (Aligote hoch, Dup weg)
update public.appellations a
   set level = 'region', region_id = s.region_id, sub_region_id = null
  from public.sub_regions s join public.regions r on r.id = s.region_id
 where a.sub_region_id = s.id and r.name = 'Bourgogne' and s.name = 'Regional'
   and a.name = 'Bourgogne Aligote';
update public.wines w set appellation_id = surv.id
  from public.appellations dup
  join public.sub_regions s on s.id = dup.sub_region_id
  join public.regions r on r.id = s.region_id,
       public.appellations surv
 where r.name = 'Bourgogne' and s.name = 'Regional' and dup.name = 'Bourgogne'
   and surv.level = 'region' and surv.region_id = r.id and surv.name = 'Bourgogne'
   and w.appellation_id = dup.id;
delete from public.appellations a using public.sub_regions s, public.regions r
 where a.sub_region_id = s.id and s.region_id = r.id
   and r.name = 'Bourgogne' and s.name = 'Regional';
delete from public.sub_regions s using public.regions r
 where s.region_id = r.id and r.name = 'Bourgogne' and s.name = 'Regional';

-- 3b Bordeaux: Sub 'Haut-Medoc' geht in Sub 'Medoc' auf (Halbinsel)
update public.appellations a
   set sub_region_id = md.id
  from public.sub_regions hm
  join public.regions r on r.id = hm.region_id and r.name = 'Bordeaux',
       public.sub_regions md
 where hm.name = 'Haut-Medoc' and md.name = 'Medoc' and md.region_id = r.id
   and a.sub_region_id = hm.id;
update public.wines w
   set sub_region_id = md.id
  from public.sub_regions hm
  join public.regions r on r.id = hm.region_id and r.name = 'Bordeaux',
       public.sub_regions md
 where hm.name = 'Haut-Medoc' and md.name = 'Medoc' and md.region_id = r.id
   and w.sub_region_id = hm.id;
delete from public.sub_regions s using public.regions r
 where s.region_id = r.id and r.name = 'Bordeaux' and s.name = 'Haut-Medoc';

-- 3c Vallee du Rhone: Dup 'Cotes du Rhone' in 'Rhone Sud' entfernen
update public.wines w set appellation_id = surv.id
  from public.appellations dup
  join public.sub_regions s on s.id = dup.sub_region_id and s.name = 'Rhone Sud',
       public.appellations surv
  join public.regions r on r.id = surv.region_id and r.name = 'Vallee du Rhone'
 where dup.name = 'Cotes du Rhone' and surv.level = 'region' and surv.name = 'Cotes du Rhone'
   and w.appellation_id = dup.id;
delete from public.appellations a using public.sub_regions s
 where a.sub_region_id = s.id and s.name = 'Rhone Sud' and a.name = 'Cotes du Rhone';

-- ── 4. Eltern-Korrekturen (B4) ────────────────────────────────────────────────
update public.appellations a
   set name = 'Castilla',
       region_id = (select r2.id from public.regions r2
                     join public.countries c2 on c2.id = r2.country_id
                    where c2.name = 'Spain' and r2.name = 'Castilla-La Mancha')
 where a.name in ('Vino de la Tierra Castilla', 'Castilla') and a.level = 'region'
   and a.region_id <> (select r2.id from public.regions r2
                        join public.countries c2 on c2.id = r2.country_id
                       where c2.name = 'Spain' and r2.name = 'Castilla-La Mancha');
update public.appellations a
   set name = 'Transmontano',
       region_id = (select r2.id from public.regions r2
                     join public.countries c2 on c2.id = r2.country_id
                    where c2.name = 'Portugal' and r2.name = 'Tras-os-Montes')
 where a.name in ('Vinho Regional Transmontano', 'Transmontano') and a.level = 'region'
   and a.region_id <> (select r2.id from public.regions r2
                        join public.countries c2 on c2.id = r2.country_id
                       where c2.name = 'Portugal' and r2.name = 'Tras-os-Montes');

-- ── 5. Eponyme Subs global auflösen (Sub heißt wie ihre Region) ──────────────
-- Apps ID-erhaltend auf die Region heben (außer dort existiert der Name schon)
update public.appellations a
   set level = 'region', region_id = s.region_id, sub_region_id = null
  from public.sub_regions s
  join public.regions r on r.id = s.region_id
 where a.sub_region_id = s.id and s.name = r.name
   and not exists (select 1 from public.appellations x
                    where x.level = 'region' and x.region_id = s.region_id and x.name = a.name);
-- Rest sind Duplikate: Weine auf den Regions-Eintrag umhängen, dann löschen
update public.wines w set appellation_id = surv.id
  from public.appellations dup
  join public.sub_regions s on s.id = dup.sub_region_id
  join public.regions r on r.id = s.region_id and s.name = r.name,
       public.appellations surv
 where surv.level = 'region' and surv.region_id = r.id and surv.name = dup.name
   and w.appellation_id = dup.id;
delete from public.appellations a using public.sub_regions s, public.regions r
 where a.sub_region_id = s.id and s.region_id = r.id and s.name = r.name;
delete from public.sub_regions s using public.regions r
 where s.region_id = r.id and s.name = r.name;

-- ── 6. Pseudo-/Falsch-Einträge löschen (nur wenn unreferenziert bzw. umgehängt)
delete from public.appellations a
 where a.name = 'IGT Langhe Fantasia'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
update public.wines w set appellation_id = surv.id
  from public.appellations dead, public.appellations surv
 where dead.name = 'Vino de la Tierra Castilla-La Mancha' and surv.name = 'Castilla' and surv.id <> dead.id
   and w.appellation_id = dead.id;
delete from public.appellations a
 where a.name = 'Vino de la Tierra Castilla-La Mancha'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
update public.wines w set appellation_id = surv.id
  from public.appellations dead, public.appellations surv
 where dead.name = 'Vino de la Tierra Valencia' and surv.name = 'Valencia' and surv.id <> dead.id
   and w.appellation_id = dead.id;
delete from public.appellations a
 where a.name = 'Vino de la Tierra Valencia'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
update public.wines w set appellation_id = surv.id
  from public.appellations dead, public.appellations surv
 where dead.name = 'Vino de la Tierra Navarra' and surv.name = 'Navarra' and surv.id <> dead.id
   and w.appellation_id = dead.id;
delete from public.appellations a
 where a.name = 'Vino de la Tierra Navarra'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Vino de Argentina'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Australian Wine'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Trpezno Vino'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Vino de Chile'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Putao Jiu'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Stolno Vino'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Stolni Vino'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
update public.wines w set appellation_id = surv.id
  from public.appellations dead, public.appellations surv
 where dead.name = 'English Wine / Welsh Wine' and surv.name = 'English Wine' and surv.id <> dead.id
   and w.appellation_id = dead.id;
delete from public.appellations a
 where a.name = 'English Wine / Welsh Wine'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Magrada Ghvino'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Epitrapezios Oinos'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Bortermelo Orszag'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Japanese Wine'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Vin de masa'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'New Zealand Wine'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Stolove Vino'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);
delete from public.appellations a
 where a.name = 'Namizno Vino'
   and not exists (select 1 from public.wines w where w.appellation_id = a.id);


commit;
