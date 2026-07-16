#!/usr/bin/env python3
"""hungary.json aus der offiziellen ungarischen GI-Liste (kormany.hu PDF, User) —
Abschnitt III BORÁSZATI TERMÉKEK = 38 Wein-GIs (OEM=PDO, OFJ=PGI). Die Liste ist
flach; Regionsgruppierung = die 6 offiziellen ungarischen Weinregionen (borrégió).
Ungarische Diakritika bleiben (wie deutsche Umlaute). Adjektiv-Varianten (Badacsonyi)
weggelassen, Grundform verwendet.
"""
import json
from collections import Counter
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/hungary.json"
O, F = "OEM", "OFJ"
REGIONS = {
 "Balaton": [("Badacsony",O),("Balatonboglár",O),("Balaton-felvidék",O),("Balatonfüred-Csopak",O),
             ("Csopak",O),("Káli",O),("Nagy-Somló",O),("Somló",O),("Tihany",O),("Zala",O),
             ("Balaton",F),("Balatonmelléki",F)],
 "Duna": [("Csongrád",O),("Duna",O),("Hajós-Baja",O),("Izsáki Arany Sárfehér",O),("Kunság",O),
          ("Monor",O),("Soltvadkerti",O),("Duna-Tisza közi",F)],
 "Eger": [("Bükk",O),("Debrői Hárslevelű",O),("Eger",O),("Mátra",O),("Felső-Magyarország",F)],
 "Pannon": [("Pannon",O),("Pécs",O),("Szekszárd",O),("Tolna",O),("Villány",O)],
 "Sopron": [("Etyek-Buda",O),("Mór",O),("Neszmély",O),("Pannonhalma",O),("Sopron",O),("Dunántúl",F)],
 "Tokaj": [("Tokaj",O),("Zemplén",F)],
}
regions=[{"name":r,"appellations":[{"name":n,"type":t} for n,t in apps]} for r,apps in REGIONS.items()]
tot=sum(len(r["appellations"]) for r in regions)
out={"country":"Hungary","code":"HU","continent":"Europe","verified":True,
 "sources":["Ungarisches GI-Register (kormany.hu / Szellemi Tulajdon Nemzeti Hivatala, User-PDF): "
            "38 Wein-GIs (32 OEM/PDO + 6 OFJ/PGI). Regionsgruppierung = 6 offizielle ungarische "
            "Weinregionen (borrégió); Diakritika bleiben, Adjektivform weggelassen."],
 "officialCount":tot,"verifiedOn":"2026-07-16","regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
alln=[a["name"] for r in regions for a in r["appellations"]]
print("Regionen:",len(regions),"| GIs:",tot,"(Soll 38) | OEM:",
      sum(1 for r in regions for a in r["appellations"] if a["type"]==O),"| OFJ:",
      sum(1 for r in regions for a in r["appellations"] if a["type"]==F))
print("Duplikate:",{n:c for n,c in Counter(alln).items() if c>1} or "keine")
assert tot==38
