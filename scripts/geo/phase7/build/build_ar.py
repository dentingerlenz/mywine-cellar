#!/usr/bin/env python3
"""argentina.json aus dem offiziellen INV-Register (User-PDF, gob.ar) neu bauen.
Region = Provinz, Appellation = IG/DOC flach. Multi-provinziell (Cuyo, Patagonia,
Valle de Uco, Valles Calchaquies, Valles del Famatina, Distrito Medrano) am
Primärstandort. Spanisch -> ASCII. Namen, die in 2 Provinzen vorkommen (Rivadavia,
San Carlos, San Martin), mit '(Provinz)' disambiguiert. Lujan de Cuyo & San Rafael
= DOC. Keine Bestandsweine -> keine Erhaltungsbedingung.
"""
import json
from collections import Counter, defaultdict
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/argentina.json"
SP = "/private/tmp/claude-501/-Users-lenzdentinger-Documents-mywine-cellar-v2/8b86d295-2bfa-4790-8251-55808d78edc6/scratchpad"

data = json.load(open(f"{SP}/ar_parsed.json"))
# manuell fehlende (multi-provinziell, im Parser ohne Provinz)
data.setdefault("Patagonia", []).append(["Patagonia","IG"])
data.setdefault("Salta", []).append(["Valles Calchaquies","IG"])
# DOC-Korrekturen
DOC = {"Lujan de Cuyo","San Rafael"}

# In-Land-Duplikate finden (gleicher Name in >1 Provinz)
prov_of = defaultdict(set)
for pv, apps in data.items():
    for nm, ty in apps: prov_of[nm].add(pv)
dups = {nm for nm, pvs in prov_of.items() if len(pvs) > 1}

regions = []
seen = set()
for pv in sorted(data):
    apps = []
    for nm, ty in data[pv]:
        name = f"{nm} ({pv})" if nm in dups else nm
        if name in seen:  # exakte Dublette (z. B. IG+DOC gleiche Provinz) überspringen
            continue
        seen.add(name)
        t = "DOC" if nm in DOC else ty
        apps.append({"name": name, "type": t})
    regions.append({"name": pv, "appellations": sorted(apps, key=lambda a: a["name"])})

total = sum(len(r["appellations"]) for r in regions)
out = {"country":"Argentina","code":"AR","continent":"Americas","verified":True,
 "sources":["INV — Indicaciones Geograficas y Denominaciones de Origen reconocidas de la Republica "
            "Argentina (offizielles PDF, gob.ar, User 2026): IG + 2 DOC. Region = Provinz, flach; "
            "multi-provinzielle IG am Primärstandort; Spanisch -> ASCII."],
 "officialCount":total,"verifiedOn":"2026-07-16","regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")

alln=[a["name"] for r in regions for a in r["appellations"]]
print("Provinzen:",len(regions),"| Appellationen:",total)
print("  IG:",sum(1 for r in regions for a in r["appellations"] if a["type"]=="IG"),
      "| DOC:",sum(1 for r in regions for a in r["appellations"] if a["type"]=="DOC"))
print("Disambiguiert:",sorted(dups))
d={n:c for n,c in Counter(alln).items() if c>1}
print("Duplikate:", d or "keine")
print("Nicht-ASCII:",[n for n in alln if any(ord(c)>127 for c in n)] or "keine")
assert not d, f"Duplikate: {d}"
