#!/usr/bin/env python3
"""One-off converter: v1 SQL geography seeds → data/geography/*.json

Reads the three v1 seed migrations (archived in supabase/migrations_v1/) and
emits one JSON file per country in the format defined in docs/REBUILD_PLAN.md
§5.2. Kept in the repo for provenance; the JSON files are the source of truth
from now on and are edited directly (never re-run this over hand-edited data
without checking the diff).

Usage: python3 scripts/geo/convert-v1-seeds.py
"""

import json
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
V1 = ROOT / "supabase" / "migrations_v1"
OUT = ROOT / "data" / "geography"

BIG_SEED = V1 / "20260509204510_788fd724-0a4a-4b70-9f75-eb540edaea25.sql"
WORLD_SEED = V1 / "20260510082239_387955e6-bd1f-4a39-a689-d29c528eec0c.sql"
LEVELS_SEED = V1 / "20260511114749_efad5f72-0d85-425f-986b-300a782e54b3.sql"

ISO = {
    "France": "FR", "Italy": "IT", "Spain": "ES", "Portugal": "PT",
    "Germany": "DE", "Austria": "AT", "Switzerland": "CH", "Greece": "GR",
    "Hungary": "HU", "Romania": "RO", "Bulgaria": "BG", "Croatia": "HR",
    "Slovenia": "SI", "Slovakia": "SK", "Czech Republic": "CZ",
    "England & Wales": "GB", "Luxembourg": "LU", "Belgium": "BE",
    "Netherlands": "NL", "Ukraine": "UA", "Moldova": "MD", "Georgia": "GE",
    "Armenia": "AM", "Azerbaijan": "AZ", "Turkey": "TR", "Serbia": "RS",
    "United States": "US", "Canada": "CA", "Mexico": "MX",
    "Argentina": "AR", "Chile": "CL", "Brazil": "BR", "Uruguay": "UY",
    "Australia": "AU", "New Zealand": "NZ", "South Africa": "ZA",
    "Israel": "IL", "Lebanon": "LB", "Japan": "JP", "China": "CN",
    "India": "IN", "Thailand": "TH", "Myanmar": "MM", "Morocco": "MA",
    "Algeria": "DZ", "Tunisia": "TN", "Kenya": "KE", "Ethiopia": "ET",
    "Cyprus": "CY", "Poland": "PL", "Denmark": "DK",
}

# 'text' with '' as escaped quote
S = r"'((?:[^']|'')*)'"


def unq(s: str) -> str:
    return s.replace("''", "'")


def slugify(name: str) -> str:
    s = unicodedata.normalize("NFKD", name).encode("ascii", "ignore").decode()
    s = re.sub(r"[^a-zA-Z0-9]+", "-", s).strip("-").lower()
    return s


# country name -> {country, code, continent, appellations: [], regions: OrderedDict}
countries = {}


def get_country(name, continent=None):
    c = countries.setdefault(
        name,
        {"country": name, "code": ISO.get(name), "continent": continent,
         "appellations": [], "_regions": {}},
    )
    if continent and not c["continent"]:
        c["continent"] = continent
    return c


def get_region(country, name):
    return country["_regions"].setdefault(
        name, {"name": name, "appellations": [], "_subs": {}}
    )


def get_sub(region, name):
    return region["_subs"].setdefault(name, {"name": name, "appellations": []})


def add_app(bucket, name, atype):
    if not any(a["name"] == name for a in bucket):
        bucket.append({"name": name, "type": atype})


# ── 1. Big seed: state machine over sequential INSERTs ──────────────────────
re_country = re.compile(
    rf"INSERT INTO public\.wine_countries \(user_id, name, continent, sort_order\) "
    rf"VALUES \(v_user_id, {S}, {S}, \d+\)")
re_region = re.compile(
    rf"INSERT INTO public\.wine_regions \(user_id, country_id, name, sort_order\) "
    rf"VALUES \(v_user_id, v_country_id, {S}, \d+\)")
re_sub = re.compile(
    rf"INSERT INTO public\.wine_sub_regions \(user_id, region_id, name, sort_order\) "
    rf"VALUES \(v_user_id, v_region_id, {S}, \d+\)")
re_app = re.compile(
    rf"INSERT INTO public\.wine_appellations \(user_id, sub_region_id, name, appellation_type, sort_order\) "
    rf"VALUES \(v_user_id, v_sub_id, {S}, (?:{S}|NULL), \d+\)")

cur_country = cur_region = cur_sub = None
for line in BIG_SEED.read_text().splitlines():
    if m := re_country.search(line):
        cur_country = get_country(unq(m.group(1)), unq(m.group(2)))
        cur_region = cur_sub = None
    elif m := re_region.search(line):
        cur_region = get_region(cur_country, unq(m.group(1)))
        cur_sub = None
    elif m := re_sub.search(line):
        cur_sub = get_sub(cur_region, unq(m.group(1)))
    elif m := re_app.search(line):
        atype = unq(m.group(2)) if m.group(2) is not None else None
        add_app(cur_sub["appellations"], unq(m.group(1)), atype)

# ── 2. World seed: 6-field tuples ────────────────────────────────────────────
re_tuple6 = re.compile(
    rf"\({S},{S},{S},{S},(?:{S}|NULL),{S}\)")
in_values = False
for line in WORLD_SEED.read_text().splitlines():
    if "FOR r IN SELECT" in line:
        in_values = True
    if ") AS t(" in line:
        in_values = False
    if in_values and (m := re_tuple6.search(line)):
        continent, country, region, sub, atype, aname = (
            unq(g) if g is not None else None for g in m.groups())
        c = get_country(country, continent)
        r = get_region(c, region)
        s = get_sub(r, sub)
        add_app(s["appellations"], aname, atype)

# ── 3. Levels seed: country-level (3 fields) & region-level (4 fields) ──────
text = LEVELS_SEED.read_text()
country_block = text.split("-- REGION-LEVEL")[0]
region_block = text.split("-- REGION-LEVEL")[1] if "-- REGION-LEVEL" in text else ""

for m in re.finditer(rf"\({S}, {S}, {S}\)", country_block):
    cname, aname, atype = (unq(g) for g in m.groups())
    if cname in countries:  # nur bekannte Länder; Tippfehler nicht mitschleppen
        add_app(countries[cname]["appellations"], aname, atype)

for m in re.finditer(rf"\({S}, {S}, {S}, {S}\)", region_block):
    cname, rname, aname, atype = (unq(g) for g in m.groups())
    if cname in countries and rname in countries[cname]["_regions"]:
        add_app(countries[cname]["_regions"][rname]["appellations"], aname, atype)

# ── 4. Emit JSON files ───────────────────────────────────────────────────────
OUT.mkdir(parents=True, exist_ok=True)
total_apps = 0
for name, c in sorted(countries.items()):
    regions = []
    for r in c["_regions"].values():
        subs = [s for s in r["_subs"].values()]
        regions.append({
            "name": r["name"],
            **({"appellations": r["appellations"]} if r["appellations"] else {}),
            **({"subRegions": subs} if subs else {}),
        })
    doc = {
        "country": c["country"],
        "code": c["code"],
        "continent": c["continent"],
        **({"appellations": c["appellations"]} if c["appellations"] else {}),
        "regions": regions,
    }
    n_apps = (len(c["appellations"])
              + sum(len(r.get("appellations", [])) for r in regions)
              + sum(len(s["appellations"]) for r in regions for s in r.get("subRegions", [])))
    total_apps += n_apps
    path = OUT / f"{slugify(name)}.json"
    path.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n")
    print(f"  {path.name:28s} {len(regions):3d} Regionen, {n_apps:4d} Appellationen")

print(f"\n{len(countries)} Länder, {total_apps} Appellationen gesamt → {OUT}")
