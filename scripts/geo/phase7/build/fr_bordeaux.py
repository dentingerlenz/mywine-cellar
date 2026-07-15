#!/usr/bin/env python3
"""Frankreich/Bordeaux gegen INAO-Register vervollständigen (Phase 7 #1a).

Quellen: en.wikipedia.org/wiki/Bordeaux_wine_regions + jamesflewellen.com
(definitive list). ASCII-Schreibweise (frz. Diakritika weg, wie im Datensatz).
Ersetzt NUR die Bordeaux-Region; Rest der Datei unangetastet.
"""
import json

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/france.json"
d = json.load(open(P))

AOC = "AOC"
IGP = "IGP"

bordeaux = {
    "name": "Bordeaux",
    "appellations": [
        {"name": "Bordeaux", "type": AOC},
        {"name": "Bordeaux Superieur", "type": AOC},
        {"name": "Bordeaux Clairet", "type": AOC},
        {"name": "Bordeaux Rose", "type": AOC},
        {"name": "Cremant de Bordeaux", "type": AOC},
        {"name": "Atlantique", "type": IGP},
    ],
    "subRegions": [
        {"name": "Medoc", "appellations": [
            {"name": "Medoc", "type": AOC},
            {"name": "Haut-Medoc", "type": AOC},
            {"name": "Saint-Estephe", "type": AOC},
            {"name": "Pauillac", "type": AOC},
            {"name": "Saint-Julien", "type": AOC},
            {"name": "Listrac-Medoc", "type": AOC},
            {"name": "Moulis-en-Medoc", "type": AOC},
            {"name": "Margaux", "type": AOC},
        ]},
        {"name": "Graves", "appellations": [
            {"name": "Graves", "type": AOC},
            {"name": "Graves Superieures", "type": AOC},
            {"name": "Pessac-Leognan", "type": AOC},
        ]},
        {"name": "Sauternes", "appellations": [
            {"name": "Sauternes", "type": AOC},
            {"name": "Barsac", "type": AOC},
            {"name": "Cerons", "type": AOC},
        ]},
        {"name": "Saint-Emilion", "appellations": [
            {"name": "Saint-Emilion", "type": AOC},
            {"name": "Saint-Emilion Grand Cru", "type": AOC},
            {"name": "Montagne-Saint-Emilion", "type": AOC},
            {"name": "Saint-Georges-Saint-Emilion", "type": AOC},
            {"name": "Lussac-Saint-Emilion", "type": AOC},
            {"name": "Puisseguin-Saint-Emilion", "type": AOC},
        ]},
        {"name": "Pomerol", "appellations": [
            {"name": "Pomerol", "type": AOC},
            {"name": "Lalande-de-Pomerol", "type": AOC},
        ]},
        {"name": "Fronsac", "appellations": [
            {"name": "Fronsac", "type": AOC},
            {"name": "Canon-Fronsac", "type": AOC},
        ]},
        {"name": "Bourg", "appellations": [
            {"name": "Cotes de Bourg", "type": AOC},
        ]},
        {"name": "Blaye", "appellations": [
            {"name": "Blaye", "type": AOC},
            {"name": "Blaye Cotes de Bordeaux", "type": AOC},
        ]},
        {"name": "Cotes de Bordeaux", "appellations": [
            {"name": "Cotes de Bordeaux", "type": AOC},
            {"name": "Castillon Cotes de Bordeaux", "type": AOC},
            {"name": "Francs Cotes de Bordeaux", "type": AOC},
            {"name": "Cadillac Cotes de Bordeaux", "type": AOC},
            {"name": "Sainte-Foy Cotes de Bordeaux", "type": AOC},
        ]},
        {"name": "Entre-Deux-Mers", "appellations": [
            {"name": "Entre-Deux-Mers", "type": AOC},
            {"name": "Entre-Deux-Mers Haut-Benauge", "type": AOC},
            {"name": "Graves de Vayres", "type": AOC},
            {"name": "Cadillac", "type": AOC},
            {"name": "Loupiac", "type": AOC},
            {"name": "Sainte-Croix-du-Mont", "type": AOC},
            {"name": "Premieres Cotes de Bordeaux", "type": AOC},
            {"name": "Cotes de Bordeaux Saint-Macaire", "type": AOC},
        ]},
    ],
}

regions = d["regions"]
idx = next(i for i, r in enumerate(regions) if r["name"] == "Bordeaux")
old = regions[idx]
regions[idx] = bordeaux

# Datei mit gleicher Formatierung + Schlüsselreihenfolge zurückschreiben
ordered = {k: d[k] for k in ("country", "code", "continent", "verified", "sources",
                             "officialCount", "verifiedOn", "appellations", "regions") if k in d}
open(P, "w").write(json.dumps(ordered, indent=2, ensure_ascii=False) + "\n")

def count(r):
    return len(r.get("appellations") or []) + sum(len(s.get("appellations") or []) for s in r.get("subRegions") or [])
print(f"Bordeaux: {count(old)} -> {count(bordeaux)} Appellationen")
print(f"Sub-Regionen: {len(old.get('subRegions') or [])} -> {len(bordeaux['subRegions'])}")
