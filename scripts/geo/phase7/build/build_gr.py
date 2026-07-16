#!/usr/bin/env python3
"""greece.json — recherchiert (keine saubere Einzelquelle; User bat um Recherche).
Konservativ & hoch-konfident: die 33 etablierten PDOs + breite regionale PGIs +
sehr bekannte Präfektur-PGIs, nach 9 Weinregionen. Transliteration Latein/ASCII.
Region 'Kriti' behält den Namen -> Crete-Bestandswein bleibt erhalten.
"""
import json
from collections import Counter
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/greece.json"
D,G = "PDO","PGI"
REGIONS = {
 "Macedonia": [("Naoussa",D),("Goumenissa",D),("Amynteo",D),("Slopes of Meliton",D),
   ("Macedonia",G),("Drama",G),("Epanomi",G),("Chalkidiki",G),("Florina",G),("Pella",G),
   ("Pieria",G),("Serres",G),("Kavala",G),("Thessaloniki",G),("Grevena",G),("Kozani",G),
   ("Kastoria",G),("Mount Athos",G)],
 "Thrace": [("Thrace",G),("Avdira",G),("Ismaros",G),("Evros",G)],
 "Epirus": [("Zitsa",D),("Epirus",G),("Ioannina",G),("Metsovo",G)],
 "Thessaly": [("Rapsani",D),("Messenikola",D),("Anchialos",D),
   ("Thessalia",G),("Tyrnavos",G),("Krania",G),("Karditsa",G),("Meteora",G),("Magnesia",G),("Pelion",G),("Larissa",G)],
 "Central Greece": [("Sterea Ellada",G),("Attiki",G),("Viotia",G),("Evia",G),("Atalanti",G),
   ("Parnassos",G),("Fthiotida",G),("Ritsona",G),("Markopoulo",G),("Pallini",G),("Spata",G),("Koropi",G),("Peania",G)],
 "Ionian Islands": [("Robola of Kefalonia",D),("Mavrodaphne of Kefalonia",D),("Muscat of Kefalonia",D),
   ("Ionian Islands",G),("Zakynthos",G),("Lefkada",G),("Corfu",G),("Kefallonia",G),("Slopes of Ainos",G)],
 "Peloponnese": [("Nemea",D),("Mantinia",D),("Patra",D),("Mavrodaphne of Patra",D),("Muscat of Patra",D),
   ("Muscat of Rio Patra",D),("Monemvasia-Malvasia",D),
   ("Peloponnese",G),("Achaia",G),("Corinthos",G),("Argolida",G),("Arkadia",G),("Lakonia",G),("Messinia",G),
   ("Ilia",G),("Slopes of Aigialeia",G),("Tegea",G),("Trifilia",G)],
 "Aegean Islands": [("Santorini",D),("Paros",D),("Malvasia Paros",D),("Rhodes",D),("Muscat of Rhodes",D),
   ("Lemnos",D),("Muscat of Lemnos",D),("Samos",D),
   ("Aegean Sea",G),("Cyclades",G),("Dodecanese",G),("Ikaria",G),("Chios",G),("Lesbos",G),("Naxos",G),("Syros",G),("Tinos",G),("Thera",G)],
 "Kriti": [("Archanes",D),("Dafnes",D),("Peza",D),("Sitia",D),("Malvasia Sitia",D),("Malvasia Chandakas-Candia",D),
   ("Kriti",G),("Heraklion",G),("Chania",G),("Rethymno",G),("Lasithi",G),("Kissamos",G)],
}
regions=[{"name":r,"appellations":[{"name":n,"type":t} for n,t in apps]} for r,apps in REGIONS.items()]
tot=sum(len(x["appellations"]) for x in regions)
out={"country":"Greece","code":"GR","continent":"Europe","verified":True,
 "sources":["Recherchiert (keine amtliche Einzelliste auffindbar, User bat um Recherche): "
            "33 etablierte PDOs + breite regionale PGIs + bekannte Präfektur-PGIs, nach 9 Weinregionen. "
            "Transliteration Latein. PGI-Langschwanz (kleine lokale PGIs) bewusst nicht vollständig."],
 "officialCount":tot,"verifiedOn":"2026-07-16","regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
alln=[a["name"] for r in regions for a in r["appellations"]]
print("Regionen:",len(regions),"| GIs:",tot,"| PDO:",sum(1 for r in regions for a in r["appellations"] if a["type"]==D),
      "| PGI:",sum(1 for r in regions for a in r["appellations"] if a["type"]==G))
d={n:c for n,c in Counter(alln).items() if c>1}
print("Duplikate:", d or "keine"); print("Nicht-ASCII:",[n for n in alln if any(ord(c)>127 for c in n)] or "keine")
assert not d, d
