#!/usr/bin/env python3
"""Italien-Prod-Migration: alte ~121 Italy-Appellationen/-Subs durch den offiziellen
522er-Satz ersetzen (flach auf Regionsebene). Wein-Erhalt per Namensabgleich:
Appellation > (alte Sub-Region, die jetzt Appellation ist) > Region. country bleibt.
No-op-sicher auf frischer DB. Italien hat KEINE Sub-Regionen mehr.
"""
import json
ROOT = "/Users/lenzdentinger/Documents/mywine-cellar-v2"
d = json.load(open(f"{ROOT}/data/geography/italy.json"))
Q = lambda s: "'" + s.replace("'", "''") + "'"

L = ["""-- Phase 7: Italien auf die offiziellen MASAF-Register umstellen (Prod).
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

-- neue Italy-Geo (Regionen + Appellationen, flach)"""]

for ci, a in enumerate(d.get("appellations") or []):
    t = a.get("type"); L.append(
        f"insert into public.appellations (level, country_id, name, type, sort_order)\n"
        f"select 'country', c.id, {Q(a['name'])}, {('null' if t is None else Q(t))}, {ci}\n"
        f" from public.countries c where c.name='Italy';")
for ri, r in enumerate(d["regions"]):
    L.append(f"insert into public.regions (country_id, name, sort_order)\n"
             f"select c.id, {Q(r['name'])}, {ri} from public.countries c where c.name='Italy';")
    for ai, a in enumerate(r.get("appellations") or []):
        t = a.get("type")
        L.append(f"insert into public.appellations (level, region_id, name, type, sort_order)\n"
                 f"select 'region', r.id, {Q(a['name'])}, {('null' if t is None else Q(t))}, {ai}\n"
                 f" from public.regions r join public.countries c on c.id=r.country_id where c.name='Italy' and r.name={Q(r['name'])};")

# Wein-Erhalt (Italy-scoped)
it_app_join = ("join public.countries c on c.name='Italy' and (na.country_id=c.id or "
               "na.region_id in (select r.id from public.regions r where r.country_id=c.id))")
L.append(f"""
-- Wein-Zuordnungen wiederherstellen
-- 1) alte Appellation (Name ueberlebt)
update public.wines w set appellation_id = na.id
  from _it_cap cap
  join public.appellations na on na.name = cap.app_name
  {it_app_join}
 where w.id = cap.wine_id and cap.app_name is not null;
-- 2) alte Sub-Region, die jetzt eine Appellation ist (z.B. Etna, Alto Adige)
update public.wines w set appellation_id = na.id
  from _it_cap cap
  join public.appellations na on na.name = cap.sub_name
  {it_app_join}
 where w.id = cap.wine_id and w.appellation_id is null and cap.sub_name is not null;
-- 3) Region (Name ueberlebt)
update public.wines w set region_id = nr.id
  from _it_cap cap
  join public.regions nr on nr.name = cap.region_name
  join public.countries c on c.id = nr.country_id and c.name='Italy'
 where w.id = cap.wine_id and w.appellation_id is null and cap.region_name is not null;

commit;""")

out = f"{ROOT}/supabase/migrations/20260714100000_geo_p7_italy.sql"
open(out, "w").write("\n".join(L) + "\n")
print("geschrieben:", out, f"({len(L)} Statements)")
