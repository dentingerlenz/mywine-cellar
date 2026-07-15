#!/usr/bin/env python3
"""Wiederverwendbarer Prod-Migrations-Generator für ein "flaches" Land (Phase 7).

Erzeugt eine Migration, die die bestehenden Appellationen/Regionen/Sub-Regionen
EINES Landes durch den verifizierten, flachen Satz aus data/geography/<datei>.json
ersetzt und dabei bestehende Wein-FKs per Namensabgleich erhält:
   Appellation (Name überlebt) > alte Sub-Region, die jetzt Appellation ist > Region.
country_id wird nie geleert. No-op-sicher auf frischer DB (Country existiert dort
zur Migrationszeit noch nicht → alle Lookups treffen 0 Zeilen; das Seed baut neu).

So wurden Italien (20260714100000), Schweiz (…110000), Spanien (…120000) und
Österreich (…130000) erzeugt. Für Länder MIT Sub-Regionen (wie Frankreich) siehe
gen_fr_migration.py.

Aufruf:
  python3 gen_flat_migration.py <Country> <json-basename> <YYYYMMDDHHMMSS> [suffix]
Beispiel:
  python3 gen_flat_migration.py Germany germany 20260715090000 geo_p7_germany
"""
import json, sys, os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
Q = lambda s: "'" + s.replace("'", "''") + "'"

def main():
    if len(sys.argv) < 4:
        print(__doc__); sys.exit(1)
    country, basename, ts = sys.argv[1], sys.argv[2], sys.argv[3]
    suffix = sys.argv[4] if len(sys.argv) > 4 else f"geo_p7_{basename}"
    d = json.load(open(f"{ROOT}/data/geography/{basename}.json"))
    CN = Q(country)
    L = [f"""-- Phase 7: {country} auf das offizielle Register umstellen (Prod).
-- Ersetzt die alten {country}-Appellationen/-Regionen durch den verifizierten,
-- flachen Satz (data/geography/{basename}.json). Wein-FKs per Namensabgleich
-- erhalten: Appellation > alte Sub-Region (jetzt Appellation) > Region.
-- No-op-sicher auf frischer DB.

begin;
create temp table _mig_cap on commit drop as
select w.id as wine_id, reg.name as region_name, sr.name as sub_name, ap.name as app_name
  from public.wines w join public.countries co on co.id = w.country_id and co.name = {CN}
  left join public.regions reg on reg.id = w.region_id
  left join public.sub_regions sr on sr.id = w.sub_region_id
  left join public.appellations ap on ap.id = w.appellation_id;
delete from public.appellations a using public.regions r, public.countries c
 where c.name = {CN} and r.country_id = c.id
   and (a.region_id = r.id or a.sub_region_id in (select s.id from public.sub_regions s where s.region_id = r.id) or a.country_id = c.id);
delete from public.sub_regions s using public.regions r, public.countries c
 where c.name = {CN} and s.region_id = r.id and r.country_id = c.id;
delete from public.regions r using public.countries c where c.name = {CN} and r.country_id = c.id;
"""]
    ty = lambda t: "null" if t is None else Q(t)
    for ci, a in enumerate(d.get("appellations") or []):
        L.append(f"insert into public.appellations (level, country_id, name, type, sort_order)\n"
                 f"select 'country', c.id, {Q(a['name'])}, {ty(a.get('type'))}, {ci} from public.countries c where c.name={CN};")
    for ri, r in enumerate(d["regions"]):
        L.append(f"insert into public.regions (country_id, name, sort_order)\n"
                 f"select c.id, {Q(r['name'])}, {ri} from public.countries c where c.name={CN};")
        for ai, a in enumerate(r.get("appellations") or []):
            L.append(f"insert into public.appellations (level, region_id, name, type, sort_order)\n"
                     f"select 'region', r.id, {Q(a['name'])}, {ty(a.get('type'))}, {ai}\n"
                     f" from public.regions r join public.countries c on c.id=r.country_id where c.name={CN} and r.name={Q(r['name'])};")
    J = (f"join public.countries c on c.name={CN} and (na.country_id=c.id or "
         f"na.region_id in (select r.id from public.regions r where r.country_id=c.id))")
    L.append(f"""
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.app_name {J}
 where w.id = cap.wine_id and cap.app_name is not null;
update public.wines w set appellation_id = na.id from _mig_cap cap join public.appellations na on na.name = cap.sub_name {J}
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
update public.wines w set region_id = nr.id from _mig_cap cap join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name={CN}
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;
commit;""")
    out = f"{ROOT}/supabase/migrations/{ts}_{suffix}.sql"
    open(out, "w").write("\n".join(L) + "\n")
    print("geschrieben:", out)

if __name__ == "__main__":
    main()
