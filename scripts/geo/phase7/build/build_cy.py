#!/usr/bin/env python3
"""cyprus.json aus der offiziellen GI-Liste (User) neu bauen: 7 PDO + 4 PGI = 11.
Region = Weindistrikt in griechischer Transliteration (Lemesos/Pafos/Larnaka/
Lefkosia) — so bleiben die Bestandsweine (Region+Appellation 'Pafos') erhalten.
PGI-Distrikt = gleichnamige Appellation. En-Dash -> '-'.
"""
import json
from collections import Counter
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/cyprus.json"

REGIONS = {
 "Lemesos": [("Lemesos","PGI"),("Krasohoria Lemesou","PDO"),
             ("Krasohoria Lemesou - Afames","PDO"),("Krasohoria Lemesou - Laona","PDO"),
             ("Commandaria","PDO"),("Pitsilia","PDO")],
 "Pafos": [("Pafos","PGI"),("Vouni Panayia - Ambelitis","PDO"),("Laona Akama","PDO")],
 "Larnaka": [("Larnaka","PGI")],
 "Lefkosia": [("Lefkosia","PGI")],
}
regions = [{"name": r, "appellations": [{"name": n, "type": t} for n, t in apps]}
           for r, apps in REGIONS.items()]
tot = sum(len(r["appellations"]) for r in regions)
out = {"country":"Cyprus","code":"CY","continent":"Asia","verified":True,
 "sources":["Offizielle zypriotische Wein-GI-Liste (User, 2026): 7 PDO + 4 PGI. "
            "Region = Weindistrikt (griech. Transliteration); PGI-Distrikte als gleichnamige Appellation."],
 "officialCount":tot,"verifiedOn":"2026-07-16","regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
alln=[a["name"] for r in regions for a in r["appellations"]]
print("Regionen:",len(regions),"| GIs:",tot,"(Soll 11) | PDO:",
      sum(1 for r in regions for a in r["appellations"] if a["type"]=="PDO"),
      "| PGI:",sum(1 for r in regions for a in r["appellations"] if a["type"]=="PGI"))
print("Duplikate:",{n:c for n,c in Counter(alln).items() if c>1} or "keine")
print("Nicht-ASCII:",[n for n in alln if any(ord(c)>127 for c in n)] or "keine")
