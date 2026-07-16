#!/usr/bin/env python3
"""south-africa.json aus dem offiziellen SAWIS Wine-of-Origin-Register neu bauen.

Quelle: "Production Areas Defined in Terms of the Wine of Origin Scheme"
(SAWIS/WoSA, Feb 2026, User-PDF). Das WO-Schema ist mehrstufig:
Geographical Unit → (Overarching) Region → Subregion → District → Ward.

Modell (flach, wie US/NZ): Region = Geographical Unit; darunter flach als
Appellationen: die WO-Regionen (Typ "WO Region"), Districts ("WO District") und
Wards ("WO Ward"), plus die GU selbst ("WO Geographical Unit"). Subregionen
(Cape West Coast, Central Orange River …) werden als Ebene weggelassen; ihre Wards
hängen an der GU. Erhält die Bestandsweine (alle Region "Western Cape"; die 2
"Elgin"-Weine werden zur Appellation Elgin aufgewertet). Bilinguale Namen →
Englisch (Teil vor "/"), gerade Apostrophe.
"""
import json
from collections import Counter

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/south-africa.json"
GU = "WO Geographical Unit"; RG = "WO Region"; DI = "WO District"; WD = "WO Ward"

# je GU: Liste (name, type). Reihenfolge: GU, Regionen, Districts, Wards.
DATA = {
 "Western Cape": (
    [("Western Cape", GU)]
  + [(n, RG) for n in ["Coastal Region","Cape South Coast","Breede River Valley","Klein Karoo","Olifants River"]]
  + [(n, DI) for n in [
      # Cape South Coast
      "Cape Agulhas","Elgin","Lower Duivenhoks River","Overberg","Plettenberg Bay","Swellendam","Walker Bay","Still Bay",
      # Coastal Region
      "Cape Town","Darling","Franschhoek","Lutzville Valley","Paarl","Stellenbosch","Swartland","Tulbagh","Wellington",
      # Breede River Valley
      "Breedekloof","Robertson","Worcester",
      # Klein Karoo
      "Calitzdorp","Langeberg-Garcia",
      # Olifants River
      "Citrusdal Mountain","Citrusdal Valley",
      # Western Cape, no region
      "Ceres Plateau","Prince Albert"]]
  + [(n, WD) for n in [
      # Overberg / Swellendam / Walker Bay / Still Bay / Cape Agulhas (CSC)
      "Elim","Elandskloof","Greyton","Klein River","Shaw's Mountain","Theewater",
      "Buffeljags","Malgas","Stormsvlei",
      "Bot River","Hemel-en-Aarde Ridge","Hemel-en-Aarde Valley","Sunday's Glen","Springfontein Rim",
      "Stanford Foothills","Upper Hemel-en-Aarde Valley","Goukou River Valley","Herbertsdale","Napier",
      # Cape Town / Darling / Lutzville / Paarl / Stellenbosch / Swartland / Wellington / Cape West Coast (Coastal)
      "Constantia","Durbanville","Hout Bay","Philadelphia","Groenekloof","Koekenaap",
      "Agter-Paarl","Simonsberg-Paarl","Voor-Paardeberg",
      "Banghoek","Bottelary","Devon Valley","Jonkershoek Valley","Papegaaiberg","Polkadraai Hills",
      "Simonsberg-Stellenbosch","Vlottenburg",
      "Malmesbury","Paardeberg","Paardeberg South","Piket-Bo-Berg","Porseleinberg","Riebeekberg","Riebeeksrivier",
      "St Helena Bay","Blouvlei","Bovlei","Groenberg","Limietberg","Mid-Berg River","Bamboes Bay","Lamberts Bay",
      # Breedekloof / Robertson / Worcester
      "Goudini","Slanghoek",
      "Agterkliphoogte","Ashton","Boesmansrivier","Bonnievale","Eilandia","Goedemoed","Goree","Goudmyn",
      "Hoopsrivier","Klaasvoogds","Le Chasseur","McGregor","Vinkrivier","Zandrivier",
      "Hex River Valley","Keeromsberg","Moordkuil","Nuy","Rooikrans","Scherpenheuvel","Stettyn",
      # Klein Karoo / Olifants River / WC-none
      "Groenfontein","Cango Valley","Koo Plateau","Montagu","Outeniqua","Tradouw","Tradouw Highlands","Upper Langkloof",
      "Piekenierskloof","Spruitdrift","Vredendal",
      "Ceres","Kweekvallei","Prince Albert Valley","Swartberg","Nieuwoudtville","Cederberg","Leipoldtville-Sandveld"]]
 ),
 "Northern Cape": (
    [("Northern Cape", GU), ("Karoo-Hoogland", RG)]
  + [(n, DI) for n in ["Sutherland-Karoo","Douglas"]]
  + [(n, WD) for n in ["Groblershoop","Grootdrink","Kakamas","Keimoes","Upington","Hartswater","Prieska"]]
 ),
 "Eastern Cape": [("Eastern Cape", GU), ("St Francis Bay", WD)],
 "KwaZulu-Natal": [("KwaZulu-Natal", GU), ("Central Drakensberg", DI), ("Lions River", DI)],
 "Free State": [("Free State", GU), ("Rietrivier FS", WD)],
}

regions = [{"name": gu, "appellations": [{"name": n, "type": t} for n, t in items]}
           for gu, items in DATA.items()]

out = {
    "country": "South Africa", "code": "ZA", "continent": "Africa",
    "verified": True,
    "sources": [
        "SAWIS/WoSA 'Production Areas Defined in Terms of the Wine of Origin Scheme' (Feb 2026, User-PDF). "
        "Flach je Geographical Unit; WO-Regionen/Districts/Wards als Appellationen mit Typ-Badge. "
        "Subregionen als Ebene weggelassen; bilinguale Namen → Englisch."
    ],
    "officialCount": sum(len(r["appellations"]) for r in regions),
    "verifiedOn": "2026-07-16",
    "appellations": [{"name": "Wine of Origin", "type": "WO"}],
    "regions": regions,
}
open(P, "w").write(json.dumps(out, indent=2, ensure_ascii=False) + "\n")

alln = [a["name"] for r in regions for a in r["appellations"]] + ["Wine of Origin"]
print("Regionen (GU):", len(regions), "| Appellationen:", sum(len(r["appellations"]) for r in regions))
for t in [GU, RG, DI, WD]:
    print(f"  {t}: {sum(1 for r in regions for a in r['appellations'] if a['type']==t)}")
dups = {n: c for n, c in Counter(alln).items() if c > 1}
print("Duplikate:", dups or "keine")
print("Nicht-ASCII:", [n for n in alln if any(ord(c) > 127 for c in n)] or "keine")
print("Curly-Apostroph:", [n for n in alln if "’" in n] or "keine")
assert not dups, f"Duplikate: {dups}"
print("OK")
