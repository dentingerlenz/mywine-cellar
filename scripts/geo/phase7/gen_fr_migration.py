#!/usr/bin/env python3
"""Generiert die Frankreich-Prod-Migration: alte ~155 France-Appellationen durch
die neuen 351 (INAO) ersetzen, bestehende Wein-Verknuepfungen per Namensabgleich
erhalten. No-op-sicher auf frischer DB (France-Country existiert dort zur
Migrationszeit noch nicht -> alle Lookups treffen 0 Zeilen, Seed macht die Arbeit).
"""
import json
ROOT = "/Users/lenzdentinger/Documents/mywine-cellar-v2"
d = json.load(open(f"{ROOT}/data/geography/france.json"))
Q = lambda s: "'" + s.replace("'", "''") + "'"

# Sub-Region-Umbenennungen alt->neu (fuer Wein-Erhalt)
SUB_RENAME = {"Aveyron": "Lot & Aveyron", "Lot": "Lot & Aveyron", "Madiran": "Gascogne & Bearn"}

L = []
L.append("""-- Phase 7: Frankreich auf die offizielle INAO-Liste umstellen (Prod).
-- Ersetzt die alten France-Appellationen/-Regionen durch den verifizierten Satz
-- (data/geography/france.json). Bestehende France-Wein-FKs werden per Namens-
-- abgleich erhalten (Appellation > Sub-Region > Region; Sub-Umbenennungen gemappt).
-- No-op-sicher auf frischer DB: dort existiert die France-Country zur Migrations-
-- zeit noch nicht, alle Country-Lookups treffen 0 Zeilen; das Seed baut France neu.

begin;

-- 0. Bestehende France-Wein-Zuordnungen (Namen) sichern
create temp table _fr_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w
  join public.countries fr on fr.id = w.country_id and fr.name = 'France'
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;

-- 1. Alte France-Geo loeschen (Appellationen -> Sub-Regionen -> Regionen).
--    wines-FKs werden dabei per ON DELETE SET NULL geleert (country_id bleibt).
delete from public.appellations a using public.regions r, public.countries c
 where c.name = 'France' and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id)
        or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = 'France' and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c
 where c.name = 'France' and r.country_id = c.id;

-- 2. Neue France-Geo einfuegen (aus france.json).""")

def region_insert(rname, ri):
    return (f"insert into public.regions (country_id, name, sort_order)\n"
            f"select c.id, {Q(rname)}, {ri} from public.countries c where c.name = 'France';")

def sub_insert(rname, sname, si):
    return (f"insert into public.sub_regions (region_id, name, sort_order)\n"
            f"select r.id, {Q(sname)}, {si} from public.regions r join public.countries c on c.id=r.country_id\n"
            f" where c.name='France' and r.name={Q(rname)};")

def app_country(name, typ, o):
    return (f"insert into public.appellations (level, country_id, name, type, sort_order)\n"
            f"select 'country', c.id, {Q(name)}, {('null' if typ is None else Q(typ))}, {o}\n"
            f" from public.countries c where c.name='France';")

def app_region(rname, name, typ, o):
    return (f"insert into public.appellations (level, region_id, name, type, sort_order)\n"
            f"select 'region', r.id, {Q(name)}, {('null' if typ is None else Q(typ))}, {o}\n"
            f" from public.regions r join public.countries c on c.id=r.country_id where c.name='France' and r.name={Q(rname)};")

def app_sub(rname, sname, name, typ, o):
    return (f"insert into public.appellations (level, sub_region_id, name, type, sort_order)\n"
            f"select 'sub_region', s.id, {Q(name)}, {('null' if typ is None else Q(typ))}, {o}\n"
            f" from public.sub_regions s join public.regions r on r.id=s.region_id join public.countries c on c.id=r.country_id\n"
            f" where c.name='France' and r.name={Q(rname)} and s.name={Q(sname)};")

# country-level appellations
for ai, a in enumerate(d.get("appellations") or []):
    L.append(app_country(a["name"], a.get("type"), ai))
# regions
for ri, r in enumerate(d["regions"]):
    L.append(region_insert(r["name"], ri))
    for ai, a in enumerate(r.get("appellations") or []):
        L.append(app_region(r["name"], a["name"], a.get("type"), ai))
    for si, s in enumerate(r.get("subRegions") or []):
        L.append(sub_insert(r["name"], s["name"], si))
        for ai, a in enumerate(s.get("appellations") or []):
            L.append(app_sub(r["name"], s["name"], a["name"], a.get("type"), ai))

# 3. Wein-Erhalt per Namensabgleich (France-scoped)
fr_join = ("join public.countries c on c.name='France' and (na.country_id=c.id or "
           "na.region_id in (select r.id from public.regions r where r.country_id=c.id) or "
           "na.sub_region_id in (select s.id from public.sub_regions s join public.regions r on r.id=s.region_id where r.country_id=c.id))")
case_sub = "case cap.sub_name " + " ".join(f"when {Q(k)} then {Q(v)}" for k,v in SUB_RENAME.items()) + " else cap.sub_name end"
L.append(f"""
-- 3. Wein-Zuordnungen wiederherstellen (Prioritaet Appellation > Sub > Region)
update public.wines w set appellation_id = na.id
  from _fr_cap cap
  join public.appellations na on na.name = cap.app_name
  {fr_join}
 where w.id = cap.wine_id and cap.app_name is not null;

update public.wines w set sub_region_id = ns.id
  from _fr_cap cap
  join public.sub_regions ns on ns.name = ({case_sub})
  join public.regions r on r.id = ns.region_id
  join public.countries c on c.id = r.country_id and c.name='France'
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;

update public.wines w set region_id = nr.id
  from _fr_cap cap
  join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='France'
 where w.id = cap.wine_id and w.appellation_id is null and w.sub_region_id is null
   and cap.region_name is not null;

commit;""")

out = f"{ROOT}/supabase/migrations/20260714090000_geo_p7_france.sql"
open(out, "w").write("\n".join(L) + "\n")
print("geschrieben:", out, f"({len(L)} Statements)")
