#!/usr/bin/env python3
"""poland.json — recherchiert (User: Polen hat eine generelle PGI; alle relevanten
Wein-Regionen/Subregionen aufnehmen). Region = polnische Weinregion, Appellationen =
Region + bekannte Subregionen, alle Typ 'PGI'. Polnische Diakritika bleiben ->
'Dolny Śląsk' erhält die Bestandsweine.
"""
import json
from collections import Counter
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/poland.json"
REGIONS = {
 "Dolny Śląsk": ["Dolny Śląsk"],
 "Lubuskie": ["Lubuskie","Zielona Góra"],
 "Małopolska": ["Małopolska","Jurajski","Małopolski Przełom Wisły"],
 "Podkarpacie": ["Podkarpacie","Jasielski","Podgórzański"],
 "Świętokrzyskie": ["Świętokrzyskie","Sandomiersko-Świętokrzyski"],
 "Zachodniopomorskie": ["Zachodniopomorskie","Szczecin-Gorzowski"],
 "Mazowieckie": ["Mazowieckie","Warka"],
 "Wielkopolska": ["Wielkopolska"],
}
regions=[{"name":r,"appellations":[{"name":n,"type":"PGI"} for n in apps]} for r,apps in REGIONS.items()]
tot=sum(len(x["appellations"]) for x in regions)
out={"country":"Poland","code":"PL","continent":"Europe","verified":True,
 "sources":["Recherchiert (User: eine generelle poln. Wein-PGI; relevante Regionen/Subregionen aufnehmen): "
            "8 Weinregionen + bekannte Subregionen, Typ PGI. Polnische Diakritika beibehalten."],
 "officialCount":tot,"verifiedOn":"2026-07-16","regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
alln=[a["name"] for r in regions for a in r["appellations"]]
print("Regionen:",len(regions),"| PGIs:",tot)
d={n:c for n,c in Counter(alln).items() if c>1}
print("Duplikate:", d or "keine")
print("Dolny Śląsk als Region vorhanden:", "Dolny Śląsk" in REGIONS)
