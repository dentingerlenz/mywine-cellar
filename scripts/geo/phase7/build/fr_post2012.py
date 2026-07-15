#!/usr/bin/env python3
"""Frankreich: Änderungen seit der INAO-2012-Liste einpflegen (vom User geliefert).
Nur eigenständige AOCs werden als Appellation aufgenommen; 1er-Cru- und DGC-
Sub-Klassifizierungen laufen weiter übers Classification-Feld.
"""
import json
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/france.json"
d = json.load(open(P))

# (Region, SubRegion oder None, [neue AOC-Namen])
ADD = [
    ("Languedoc-Roussillon", "Languedoc", [
        "Blanquette de Limoux",        # vom User gewünscht (fehlte in der 2012-Liste)
        "Pic Saint-Loup",              # 2016, eigenständig aus AOC Languedoc
        "Terrasses du Larzac",         # 2014
        "La Clape",                    # 2015
        "Montpeyroux",                 # 2026, Cru du Languedoc
        "Sable de Camargue",           # 2023, von IGP zu AOC
    ]),
    ("Vallee du Rhone", "Rhone Sud", ["Cairanne"]),      # 2016, Cru
    ("Bourgogne", "Chablis", ["Vezelay"]),               # 2017, Village-AOC (Yonne)
    ("Auvergne", None, ["Correze"]),                     # 2017, eigenständige AOC (Zentralfrankreich)
]

def region(name): return next(r for r in d["regions"] if r["name"] == name)
added = []
for rname, sname, names in ADD:
    r = region(rname)
    if sname is None:
        target = r.setdefault("appellations", [])
    else:
        s = next(x for x in r["subRegions"] if x["name"] == sname)
        target = s.setdefault("appellations", [])
    existing = {a["name"] for a in target}
    for n in names:
        if n in existing:
            print(f"  schon vorhanden: {n}"); continue
        target.append({"name": n, "type": "AOC"}); added.append(f"{rname}/{sname or '-'}: {n}")

# officialCount hochsetzen (2012-Liste 309 + eigenständige Nachträge)
aoc_count = sum(1 for r in d["regions"] for a in (r.get("appellations") or []) if a["type"] != "IGP") \
          + sum(1 for r in d["regions"] for s in (r.get("subRegions") or []) for a in (s.get("appellations") or []) if a["type"] != "IGP")
d["officialCount"] = aoc_count
d["sources"] = ["INAO Liste des AOC vins (MAJ 26.01.2012)",
                "INAO Liste des IGP vins (MAJ 26.01.2014)",
                "Post-2012-Nachtraege (INAO/EUR-Lex, vom Nutzer geliefert 2026-07)"]

ordered = {k: d[k] for k in ("country","code","continent","verified","sources",
                             "officialCount","verifiedOn","appellations","regions") if k in d}
open(P, "w").write(json.dumps(ordered, indent=2, ensure_ascii=False) + "\n")
print("Hinzugefügt:", *added, sep="\n  ")
print(f"neuer officialCount (AOC): {aoc_count}")
