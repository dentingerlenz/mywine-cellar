#!/usr/bin/env python3
"""Frankreich/Champagne + Rhone gegen Register (Phase 7 #1c).
Quellen: en.wikipedia.org Champagne_(wine_region) + Rhone_wine.
Cru-Dörfer der Champagne = Classification/Location (nicht Appellation).
"""
import json
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/france.json"
d = json.load(open(P))
A, IGP = "AOC", "IGP"
def apps(names, t=A): return [{"name": n, "type": t} for n in names]

champagne = {
    "name": "Champagne",
    "appellations": apps(["Champagne", "Coteaux Champenois", "Rose des Riceys"]),
    "subRegions": [
        {"name": "Montagne de Reims"},
        {"name": "Vallee de la Marne"},
        {"name": "Cote des Blancs"},
        {"name": "Cote de Sezanne"},
        {"name": "Aube (Cote des Bar)"},
    ],
}

rhone = {
    "name": "Vallee du Rhone",
    "appellations": [{"name": "Cotes du Rhone", "type": A}, {"name": "Mediterranee", "type": IGP}],
    "subRegions": [
        {"name": "Rhone Nord", "appellations": apps([
            "Cote-Rotie", "Condrieu", "Chateau-Grillet", "Saint-Joseph",
            "Crozes-Hermitage", "Hermitage", "Cornas", "Saint-Peray"])},
        {"name": "Rhone Sud", "appellations": apps([
            "Chateauneuf-du-Pape", "Gigondas", "Vacqueyras", "Vinsobres", "Cairanne",
            "Beaumes-de-Venise", "Muscat de Beaumes de Venise", "Rasteau", "Lirac", "Tavel",
            "Luberon", "Ventoux", "Costieres de Nimes", "Grignan-les-Adhemar",
            "Cotes du Vivarais", "Duche d'Uzes", "Cotes du Rhone Villages"])},
        {"name": "Diois", "appellations": apps([
            "Clairette de Die", "Cremant de Die", "Chatillon-en-Diois"])},
    ],
}

for region in (champagne, rhone):
    regions = d["regions"]
    idx = next(i for i, r in enumerate(regions) if r["name"] == region["name"])
    old = regions[idx]; regions[idx] = region
    cnt = lambda r: len(r.get("appellations") or []) + sum(len(s.get("appellations") or []) for s in r.get("subRegions") or [])
    print(f"{region['name']}: {cnt(old)} -> {cnt(region)}")

ordered = {k: d[k] for k in ("country", "code", "continent", "verified", "sources",
                             "officialCount", "verifiedOn", "appellations", "regions") if k in d}
open(P, "w").write(json.dumps(ordered, indent=2, ensure_ascii=False) + "\n")
