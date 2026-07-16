#!/usr/bin/env python3
"""germany.json aus dem offiziellen deutschen Weinrecht neu bauen (Phase 7).

Quelle (recherchiert — kein einzelnes amtliches PDF; Struktur ist stabil im
Weingesetz/Weinverordnung + Deutsches Weininstitut verankert):
  - 13 bestimmte Anbaugebiete (g.U.)  -> Typ "Anbaugebiet"
  - 41 Bereiche (Districts) je Gebiet -> Typ "Bereich"
  - Landwein (g.g.A.) je Gebiet        -> Typ "Landwein"
  - Deutscher Wein (Tafelwein, national) -> Typ "Tafelwein"

Bewusst NICHT erfasst: Grosslagen und Einzellagen (Weinbergslagen). Die konkrete
Lage steht im Weinnamen bzw. im Freitextfeld "Location". Die VDP-Klassifikation
(VDP.Grosse Lage, VDP.Erste Lage, VDP.Ortswein, VDP.Gutswein, Grosses Gewächs)
ist KEINE Geografie -> sie ist im Formularfeld "Classification" wählbar.

Flach wie IT/CH/ES/AT (Region = Anbaugebiet, Appellationen direkt darunter, keine
Sub-Regionen). Deutsche Umlaute bleiben (ö/ä/ü); ß -> ss; gerade Apostrophe.
"""
import json
from collections import Counter

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/germany.json"

# (Anbaugebiet, [Bereiche...], Landwein-g.g.A. oder None)
REGIONS = [
    ("Mosel",
     ["Bernkastel", "Burg Cochem", "Moseltor", "Obermosel", "Ruwertal", "Saar"],
     "Landwein der Mosel"),
    ("Rheingau",
     ["Johannisberg"],
     "Rheingauer Landwein"),
    ("Rheinhessen",
     ["Bingen", "Nierstein", "Wonnegau"],
     "Rheinischer Landwein"),
    ("Pfalz",
     ["Mittelhaardt-Deutsche Weinstrasse", "Südliche Weinstrasse"],
     "Pfälzer Landwein"),
    ("Nahe",
     ["Nahetal"],
     "Nahegauer Landwein"),
    ("Franken",
     ["Maindreieck", "Mainviereck", "Steigerwald"],
     "Fränkischer Landwein"),
    ("Baden",
     ["Badische Bergstrasse", "Bodensee", "Breisgau", "Kaiserstuhl", "Kraichgau",
      "Markgräflerland", "Ortenau", "Tauberfranken", "Tuniberg"],
     "Badischer Landwein"),
    ("Württemberg",
     ["Bayerischer Bodensee", "Kocher-Jagst-Tauber", "Oberer Neckar",
      "Remstal-Stuttgart", "Württembergischer Bodensee", "Württembergisch Unterland"],
     "Schwäbischer Landwein"),
    ("Mittelrhein",
     ["Loreley", "Siebengebirge"],
     None),
    ("Ahr",
     ["Walporzheim/Ahrtal"],
     "Ahrtaler Landwein"),
    ("Saale-Unstrut",
     ["Schloss Neuenburg", "Thüringen"],
     "Mitteldeutscher Landwein"),
    ("Sachsen",
     ["Dresden", "Elstertal", "Meissen"],
     "Sächsischer Landwein"),
    ("Hessische Bergstrasse",
     ["Starkenburg", "Umstadt"],
     None),
]

regions = []
n_ang = n_ber = n_lw = 0
for name, bereiche, landwein in REGIONS:
    apps = [{"name": name, "type": "Anbaugebiet"}]
    n_ang += 1
    for b in bereiche:
        apps.append({"name": b, "type": "Bereich"})
        n_ber += 1
    if landwein:
        apps.append({"name": landwein, "type": "Landwein"})
        n_lw += 1
    regions.append({"name": name, "appellations": apps})

out = {
    "country": "Germany",
    "code": "DE",
    "continent": "Europe",
    "verified": True,
    "sources": [
        "Deutsches Weingesetz / Weinverordnung: 13 bestimmte Anbaugebiete (g.U.) "
        "+ 41 Bereiche; Landwein (g.g.A.) je Gebiet; Deutscher Wein (national). "
        "Einzellagen/Grosslagen bewusst als Freitext (Location); VDP-Stufen im "
        "Classification-Feld. Recherchiert 2026-07 (Deutsches Weininstitut)."
    ],
    "officialCount": n_ang + n_ber,  # 13 Anbaugebiete + 41 Bereiche = 54 (g.U.-Gerüst)
    "verifiedOn": "2026-07-15",
    "appellations": [{"name": "Deutscher Wein", "type": "Tafelwein"}],
    "regions": regions,
}
open(P, "w").write(json.dumps(out, indent=2, ensure_ascii=False) + "\n")

total_apps = 1 + n_ang + n_ber + n_lw
print(f"Anbaugebiete: {n_ang} | Bereiche: {n_ber} | Landweine: {n_lw} "
      f"| + Deutscher Wein = {total_apps} Appellationen")
print(f"officialCount (g.U.): {n_ang + n_ber}")
# In-Land-Duplikat-Check (muss leer sein)
alln = [a["name"] for r in regions for a in r["appellations"]] + ["Deutscher Wein"]
dups = {n: c for n, c in Counter(alln).items() if c > 1}
print("Duplikate:", dups or "keine")
