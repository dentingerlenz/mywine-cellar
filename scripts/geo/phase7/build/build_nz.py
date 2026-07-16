#!/usr/bin/env python3
"""new-zealand.json aus dem offiziellen IPONZ GI-Register (wine) neu bauen (Phase 7).

Quelle: IPONZ Geographical Indications Register, gefiltert location=NZ / type=wine
(iponz.govt.nz/get-ip/geographical-indications/register). 19 registrierte Wein-GIs
(IP 1004–1028, registriert 2018–2022), im Browser + WebFetch verifiziert:
  10 regionale GIs + 9 lokale GIs (jede lokale GI hängt an ihrer regionalen GI).

Flach modelliert (wie IT/CH/ES/AT/DE): Region = regionale GI, die lokalen GIs als
Geschwister-Appellationen darunter, alle Typ "GI". Nicht-registrierte informelle
Sub-Regionen (Wairau Valley, Southern Valleys, Awatere ...) sind KEINE GI → sie
bleiben Freitext ("Location"), die Migration hängt bestehende solche Sub-Region-
Weine dorthin um. Gerade Apostrophe (Hawke's Bay, nicht Hawke’s).
"""
import json
from collections import Counter

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/new-zealand.json"

# Reihenfolge grob Nord -> Süd. (Region, [lokale GIs...])
REGIONS = [
    ("Northland", []),
    ("Auckland", ["Kumeu", "Matakana", "Waiheke Island"]),
    ("Gisborne", []),
    ("Hawke's Bay", ["Central Hawke's Bay"]),
    ("Wairarapa", ["Gladstone", "Martinborough"]),
    ("Nelson", []),
    ("Marlborough", []),
    ("Canterbury", ["North Canterbury", "Waipara Valley"]),
    ("Waitaki Valley North Otago", []),
    ("Central Otago", ["Bannockburn"]),
]

regions = []
n_reg = n_local = 0
for name, locals_ in REGIONS:
    apps = [{"name": name, "type": "GI"}]           # die regionale GI selbst
    n_reg += 1
    for lg in locals_:
        apps.append({"name": lg, "type": "GI"})     # lokale GI
        n_local += 1
    regions.append({"name": name, "appellations": apps})

total = n_reg + n_local
out = {
    "country": "New Zealand",
    "code": "NZ",
    "continent": "Oceania",
    "verified": True,
    "sources": [
        "IPONZ Geographical Indications Register (wine, New Zealand): 19 registrierte "
        "GIs (10 regionale + 9 lokale), IP 1004–1028, registriert 2018–2022. "
        "iponz.govt.nz/get-ip/geographical-indications/register (Stand 2026-07). "
        "Nicht-registrierte informelle Sub-Regionen bleiben Freitext (Location)."
    ],
    "officialCount": total,
    "verifiedOn": "2026-07-16",
    "regions": regions,
}
open(P, "w").write(json.dumps(out, indent=2, ensure_ascii=False) + "\n")

print(f"Regionale GIs: {n_reg} | Lokale GIs: {n_local} | Summe: {total} (Soll 19)")
alln = [a["name"] for r in regions for a in r["appellations"]]
dups = {n: c for n, c in Counter(alln).items() if c > 1}
print("Duplikate:", dups or "keine")
print("Curly-Apostroph-Check:", "FEHLER" if any("’" in n for n in alln) else "ok")
