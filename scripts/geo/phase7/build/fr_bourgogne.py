#!/usr/bin/env python3
"""Frankreich/Burgund gegen INAO/Register vervollständigen (Phase 7 #1b).

Quellen: en.wikipedia.org/wiki/List_of_Burgundy_Grands_Crus + /Burgundy_wine.
Max. Tiefe: alle Dorf-AOCs + 32 Grand Crus (eigene AOCs, type 'Grand Cru') +
7 Chablis-Grand-Cru-Climats. Einzelne 1er-Cru-Climats bewusst (noch) nicht —
die deckt das Feld Classification='1er Cru' + Location ab (offene Kurationsfrage).
ASCII-Schreibweise. Ersetzt NUR die Bourgogne-Region.
"""
import json

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/france.json"
d = json.load(open(P))
A, GC = "AOC", "Grand Cru"

def apps(names, t=A):
    return [{"name": n, "type": t} for n in names]

bourgogne = {
    "name": "Bourgogne",
    "appellations": apps([
        "Bourgogne", "Bourgogne Aligote", "Coteaux Bourguignons", "Cremant de Bourgogne",
        "Bourgogne Hautes Cotes de Nuits", "Bourgogne Hautes Cotes de Beaune",
        "Bourgogne Cote Chalonnaise",
    ]),
    "subRegions": [
        {"name": "Chablis", "appellations":
            apps(["Petit Chablis", "Chablis", "Chablis Premier Cru", "Chablis Grand Cru",
                  "Irancy", "Saint-Bris"])
            + apps(["Blanchot", "Bougros", "Les Clos", "Grenouilles", "Preuses",
                    "Valmur", "Vaudesir"], GC)},
        {"name": "Cote de Nuits", "appellations":
            apps(["Marsannay", "Fixin", "Gevrey-Chambertin", "Morey-Saint-Denis",
                  "Chambolle-Musigny", "Vougeot", "Vosne-Romanee", "Nuits-Saint-Georges",
                  "Cote de Nuits-Villages"])
            + apps(["Chambertin", "Chambertin-Clos de Beze", "Chapelle-Chambertin",
                    "Charmes-Chambertin", "Griotte-Chambertin", "Latricieres-Chambertin",
                    "Mazis-Chambertin", "Mazoyeres-Chambertin", "Ruchottes-Chambertin",
                    "Clos de la Roche", "Clos des Lambrays", "Clos de Tart", "Clos Saint-Denis",
                    "Bonnes-Mares", "Musigny", "Clos de Vougeot", "Echezeaux", "Grands Echezeaux",
                    "La Grande Rue", "La Romanee", "La Tache", "Richebourg", "Romanee-Conti",
                    "Romanee-Saint-Vivant"], GC)},
        {"name": "Cote de Beaune", "appellations":
            apps(["Ladoix", "Aloxe-Corton", "Pernand-Vergelesses", "Savigny-les-Beaune",
                  "Chorey-les-Beaune", "Beaune", "Pommard", "Volnay", "Monthelie",
                  "Auxey-Duresses", "Saint-Romain", "Meursault", "Puligny-Montrachet",
                  "Chassagne-Montrachet", "Saint-Aubin", "Santenay", "Maranges",
                  "Cote de Beaune", "Cote de Beaune-Villages"])
            + apps(["Corton", "Corton-Charlemagne", "Charlemagne", "Montrachet",
                    "Chevalier-Montrachet", "Batard-Montrachet", "Bienvenues-Batard-Montrachet",
                    "Criots-Batard-Montrachet"], GC)},
        {"name": "Cote Chalonnaise", "appellations":
            apps(["Bouzeron", "Rully", "Mercurey", "Givry", "Montagny"])},
        {"name": "Maconnais", "appellations":
            apps(["Macon", "Macon-Villages", "Pouilly-Fuisse", "Pouilly-Loche",
                  "Pouilly-Vinzelles", "Saint-Veran", "Vire-Clesse"])},
    ],
}

regions = d["regions"]
idx = next(i for i, r in enumerate(regions) if r["name"] == "Bourgogne")
old = regions[idx]
regions[idx] = bourgogne

ordered = {k: d[k] for k in ("country", "code", "continent", "verified", "sources",
                             "officialCount", "verifiedOn", "appellations", "regions") if k in d}
open(P, "w").write(json.dumps(ordered, indent=2, ensure_ascii=False) + "\n")

cnt = lambda r: len(r.get("appellations") or []) + sum(len(s.get("appellations") or []) for s in r.get("subRegions") or [])
print(f"Bourgogne: {cnt(old)} -> {cnt(bourgogne)} Appellationen")
