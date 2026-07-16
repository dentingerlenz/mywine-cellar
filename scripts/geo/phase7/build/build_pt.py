#!/usr/bin/env python3
"""portugal.json aus dem offiziellen EU-GI-Register eAmbrosia neu bauen (Phase 7).

Quelle: eAmbrosia-Extrakt (User-Datei extracteambrosia-gi.xlsx), gefiltert
Portugal / wine = 44 registrierte GIs (30 PDO + 14 PGI, IP PDO-PT-/PGI-PT-*).
eAmbrosia liefert Name + Typ (PDO->DOP, PGI->IGP) autoritativ, aber KEINE Region;
die Regionszuordnung = etablierte portugiesische Weinregion-Struktur (11 Regionen).

Flach (wie ES/AT/DE/NZ): Region = Weinregion, GIs flach darunter. Romanische
Diakritika -> ASCII (Konvention wie ES/FR), gerade Apostrophe. Mehrsprachige
Alternativnamen auf Kanonform (Madeira, Porto). Regionen "Beiras"/"Douro" existieren
als Namen, damit die Bestandsweine ihre Region behalten (Douro Superior = keine
eigene DOP -> Freitext Location via Migration).
"""
import json, unicodedata
from collections import Counter

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/portugal.json"

def ascii_pt(s):
    # portugiesische Diakritika strippen (ç->c, ã->a, ó->o, …), Rest unverändert
    return unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")

# (Region, [(GI-Name, Typ), ...])  — Namen bereits ASCII geschrieben; ascii_pt als Netz
REGIONS = [
    ("Minho", [("Minho", "IGP"), ("Vinho Verde", "DOP")]),
    ("Douro", [("Douro", "DOP"), ("Porto", "DOP"), ("Duriense", "IGP")]),
    ("Tras-os-Montes", [("Tras-os-Montes", "DOP"), ("Transmontano", "IGP")]),
    ("Beiras", [("Dao", "DOP"), ("Bairrada", "DOP"), ("Beira Interior", "DOP"),
                ("Lafoes", "DOP"), ("Tavora-Varosa", "DOP"), ("Beira Atlantico", "IGP"),
                ("Terras da Beira", "IGP"), ("Terras do Dao", "IGP"), ("Terras de Cister", "IGP")]),
    ("Lisboa", [("Lisboa", "IGP"), ("Alenquer", "DOP"), ("Arruda", "DOP"),
                ("Bucelas", "DOP"), ("Carcavelos", "DOP"), ("Colares", "DOP"),
                ("Encostas d'Aire", "DOP"), ("Obidos", "DOP"), ("Torres Vedras", "DOP")]),
    ("Tejo", [("Do Tejo", "DOP"), ("Tejo", "IGP")]),
    ("Peninsula de Setubal", [("Setubal", "DOP"), ("Palmela", "DOP"),
                              ("Peninsula de Setubal", "IGP")]),
    ("Alentejo", [("Alentejo", "DOP"), ("Alentejano", "IGP")]),
    ("Algarve", [("Algarve", "IGP"), ("Lagoa", "DOP"), ("Lagos", "DOP"),
                 ("Portimao", "DOP"), ("Tavira", "DOP")]),
    ("Madeira", [("Madeira", "DOP"), ("Madeirense", "DOP"), ("Terras Madeirenses", "IGP")]),
    ("Acores", [("Acores", "IGP"), ("Biscoitos", "DOP"), ("Graciosa", "DOP"), ("Pico", "DOP")]),
]

regions = []
n_dop = n_igp = 0
for rname, gis in REGIONS:
    apps = []
    for gname, typ in gis:
        apps.append({"name": ascii_pt(gname), "type": typ})
        if typ == "DOP": n_dop += 1
        else: n_igp += 1
    regions.append({"name": ascii_pt(rname), "appellations": apps})

total_gi = n_dop + n_igp
out = {
    "country": "Portugal",
    "code": "PT",
    "continent": "Europe",
    "verified": True,
    "sources": [
        "eAmbrosia (EU-GI-Register), Extrakt Portugal/wine: 44 registrierte GIs "
        "(30 DOP/PDO + 14 IGP/PGI, PDO-PT-/PGI-PT-*). Regionszuordnung = etablierte "
        "portugiesische Weinregion-Struktur. Stand 2026-07 (User-Datei)."
    ],
    "officialCount": total_gi,
    "verifiedOn": "2026-07-16",
    "appellations": [{"name": "Vinho", "type": "Vinho"}],  # national, non-GI Tafelwein
    "regions": regions,
}
open(P, "w").write(json.dumps(out, indent=2, ensure_ascii=False) + "\n")

print(f"DOP: {n_dop} | IGP: {n_igp} | Summe GIs: {total_gi} (Soll 44)")
alln = [a["name"] for r in regions for a in r["appellations"]] + ["Vinho"]
dups = {n: c for n, c in Counter(alln).items() if c > 1}
print("Appellations-Duplikate:", dups or "keine")
nonascii = [n for n in alln + [r["name"] for r in regions] if any(ord(ch) > 127 for ch in n)]
print("Nicht-ASCII:", nonascii or "keine")
print("Regionen mit gleichnamiger Appellation:",
      [r["name"] for r in regions if r["name"] in {a["name"] for a in r["appellations"]}])
