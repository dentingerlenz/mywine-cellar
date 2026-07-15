#!/usr/bin/env python3
"""switzerland.json aus dem offiziellen eidg. AOC-Register (BLW/OFAG, 1.1.2026)
neu bauen. 63 AOCs, den 6 Schweizer Weinregionen zugeordnet (flach, alle 'AOC').
Frz. Akzente -> ASCII, deutsche Umlaute bleiben. Intercantonale AOCs (Vully,
Zuerichsee) je einmal. Untergeordnete Lagen/Gemeinden (Yvorne, Aigle, Fendant...)
sind KEINE eigenen AOCs -> Classification/Location.
"""
import json

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/switzerland.json"
REGIONS = {
 "Valais": ["Valais"],
 "Vaud": ["Vaud","Chablais","Lavaux","La Cote","Cotes-de-l'Orbe","Bonvillars",
          "Dezaley","Dezaley-Marsens","Calamin"],
 "Geneve": ["Geneve","Coteau de Chevrens","Cotes de Landecy","Coteau de Lully",
            "Coteau de Choulex","Chateau de Collex","Coteau de Bossy","Coteau de la vigne blanche",
            "Coteaux de Dardagny","Coteau de Genthod","Chateau du Crest","Mandement de Jussy",
            "Grand Carraz","Domaine de l'Abbaye","Cotes de Russin","Coteau des Baillets",
            "Coteau de Bourdigny","Coteau de Choully","Coteau de Peissy","Coteaux de Peney",
            "Chateau de Choully","Rougemont","La Feuillee"],
 "Drei Seen": ["Neuchatel","Bielersee","Cheyres","Vully"],
 "Ticino": ["Ticino","Rosso del Ticino","Bianco del Ticino","Rosato del Ticino"],
 "Deutschschweiz": ["Aargau","Appenzell Innerrhoden","Appenzell Ausserrhoden","Bern","Thunersee",
                    "Basel-Landschaft","Basel-Stadt","Glarus","Graubünden","Jura","Luzern",
                    "Nidwalden","Obwalden","St. Gallen","Schaffhausen","Solothurn","Schwyz",
                    "Thurgau","Uri","Zug","Zürich","Zürichsee"],
}
base = json.load(open(P))
regions = [{"name": rn, "appellations": [{"name": n, "type": "AOC"} for n in apps]}
           for rn, apps in REGIONS.items()]
total = sum(len(a) for a in REGIONS.values())
out = {"country":"Switzerland","code":base.get("code","CH"),"continent":base.get("continent","Europe"),
 "verified":True,
 "sources":["BLW/OFAG Schweizerisches Verzeichnis der kontrollierten Ursprungsbezeichnungen (AOC), Stand 1.1.2026"],
 "officialCount":total,"verifiedOn":"2026-07-14","regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
# Duplikat-Check
from collections import Counter
alln=Counter(n for a in REGIONS.values() for n in a)
print("Total AOCs:", total, "| Duplikate:", {n:c for n,c in alln.items() if c>1} or "keine")
for rn,a in REGIONS.items(): print(f"   {rn}: {len(a)}")
