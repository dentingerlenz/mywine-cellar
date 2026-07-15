#!/usr/bin/env python3
"""italy.json aus den offiziellen MASAF-Listen (DOP 18.03.2026 + IGP 13.05.2026)
neu bauen. Jede DOP/IGP als Appellation unter ihrer Primaerregion (die 20 ital.
Regionen), Typ DOCG/DOC/IGT. Flach auf Regionsebene (konsistent mit FR-Prinzip:
offizielle eigenstaendige Denominationen = Appellation; MGA/Vigna = Classification).
"""
import json
from collections import defaultdict

SCRATCH = "/private/tmp/claude-501/-Users-lenzdentinger-Documents-mywine-cellar-v2/8b86d295-2bfa-4790-8251-55808d78edc6/scratchpad"
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/italy.json"
d = json.load(open(f"{SCRATCH}/it_final.json"))

# Reihenfolge der Regionen (Nord -> Sued, wie bisher grob)
REGION_ORDER = ["Piemonte","Valle d'Aosta","Lombardia","Trentino-Alto Adige","Veneto",
 "Friuli-Venezia Giulia","Liguria","Emilia-Romagna","Toscana","Umbria","Marche","Lazio",
 "Abruzzo","Molise","Campania","Basilicata","Calabria","Puglia","Sicilia","Sardegna"]

byreg = defaultdict(list)
for r in d['dop'] + d['igp']:
    byreg[r['regions'][0]].append((r['name'], r['type']))

# alphabetisch je Region
regions = []
placed = 0
for rname in REGION_ORDER:
    apps = sorted(byreg[rname], key=lambda x: x[0].lower())
    placed += len(apps)
    regions.append({"name": rname, "appellations": [{"name": n, "type": t} for n, t in apps]})

# Länder-Objekt schreiben (Struktur/Reihenfolge wie im Datensatz)
base = json.load(open(P))
out = {
    "country": "Italy", "code": base.get("code", "IT"), "continent": base.get("continent", "Europe"),
    "verified": True,
    "sources": ["MASAF Elenco DOP vini (agg. 18.03.2026)", "MASAF Elenco IGP vini (agg. 13.05.2026)"],
    "officialCount": placed, "verifiedOn": "2026-07-14",
    "regions": regions,
}
open(P, "w").write(json.dumps(out, indent=2, ensure_ascii=False) + "\n")

# Vollständigkeits-Check: jede geparste Appellation platziert?
total = len(d['dop']) + len(d['igp'])
print(f"platziert: {placed} / geparst: {total}  ({'OK' if placed==total else 'FEHLT!'})")
from collections import Counter
tc = Counter(a['type'] for r in regions for a in r['appellations'])
print("Typen:", dict(tc))
print("Regionen:", len(regions))
for r in regions: print(f"   {r['name']}: {len(r['appellations'])}")
