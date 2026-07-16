#!/usr/bin/env python3
"""australia.json aus dem Wine-Australia-GI-Register (Browser-Extraktion) neu bauen.
Hierarchie State/Zone -> Region -> Subregion. Flach je Bundesstaat: Region = State,
darunter Zones (GI Zone), Regionen (GI), Subregionen (GI Subregion), plus State GI.
"South Eastern Australia" (Multi-State-Zone) country-level als Broad GI. Grenz-GIs
Murray Darling / Swan Hill nur einmal (NSW). Keine Bestandsweine.
"""
import json
from collections import Counter
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/australia.json"
Z,R,S,ST = "GI Zone","GI","GI Subregion","State GI"

STATES = {
 "South Australia": [("South Australia",ST)]
  + [(n,Z) for n in ["Adelaide","Barossa","Far North","Fleurieu","Limestone Coast","Lower Murray","Mount Lofty Ranges","The Peninsulas"]]
  + [(n,R) for n in ["Barossa Valley","Eden Valley","Southern Flinders Ranges","Currency Creek","Kangaroo Island",
      "Langhorne Creek","McLaren Vale","Southern Fleurieu","Coonawarra","Mount Benson","Mount Gambier","Padthaway",
      "Robe","Wrattonbully","Riverland","Adelaide Hills","Adelaide Plains","Clare Valley"]]
  + [(n,S) for n in ["High Eden","Lenswood","Piccadilly Valley"]],
 "New South Wales": [("New South Wales",ST)]
  + [(n,Z) for n in ["Big Rivers","Central Ranges","Hunter Valley","Northern Rivers","Northern Slopes","South Coast","Southern New South Wales","Western Plains"]]
  + [(n,R) for n in ["Murray Darling","Perricoota","Riverina","Swan Hill","Cowra","Mudgee","Orange","Hunter",
      "Hastings River","New England Australia","Shoalhaven Coast","Southern Highlands","Canberra District","Gundagai","Hilltops","Tumbarumba"]]
  + [(n,S) for n in ["Broke Fordwich","Pokolbin","Upper Hunter Valley"]],
 "Victoria": [("Victoria",ST)]
  + [(n,Z) for n in ["Central Victoria","Gippsland","North East Victoria","North West Victoria","Port Phillip","Western Victoria"]]
  + [(n,R) for n in ["Bendigo","Goulburn Valley","Heathcote","Strathbogie Ranges","Upper Goulburn","Alpine Valleys",
      "Beechworth","Glenrowan","King Valley","Rutherglen","Geelong","Macedon Ranges","Mornington Peninsula","Sunbury",
      "Yarra Valley","Grampians","Henty","Pyrenees"]]
  + [(n,S) for n in ["Nagambie Lakes","Great Western"]],
 "Western Australia": [("Western Australia",ST)]
  + [(n,Z) for n in ["Central Western Australia","Eastern Plains, Inland and North of Western Australia","Greater Perth","South West Australia","West Australian South East Coastal"]]
  + [(n,R) for n in ["Peel","Perth Hills","Swan District","Blackwood Valley","Geographe","Great Southern","Manjimup","Margaret River","Pemberton"]]
  + [(n,S) for n in ["Swan Valley","Albany","Denmark","Frankland River","Mount Barker","Porongurup"]],
 "Queensland": [("Queensland",ST),("Granite Belt",R),("South Burnett",R)],
 "Tasmania": [("Tasmania",ST)],
}
regions=[{"name":st,"appellations":[{"name":n,"type":t} for n,t in apps]} for st,apps in STATES.items()]
out={"country":"Australia","code":"AU","continent":"Oceania","verified":True,
 "sources":["Wine Australia Register of Protected GIs — Australian Geographical Indications "
            "(wineaustralia.com, Browser-Extraktion 2026): State/Zone/Region/Subregion. Flach je "
            "Bundesstaat mit Typ-Badge; South Eastern Australia country-level (Broad GI); "
            "grenzüberschreitende Murray Darling/Swan Hill einmal (NSW)."],
 "officialCount":sum(len(r["appellations"]) for r in regions)+1,"verifiedOn":"2026-07-16",
 "appellations":[{"name":"South Eastern Australia","type":"Broad GI"}],
 "regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
alln=[a["name"] for r in regions for a in r["appellations"]]+["South Eastern Australia"]
print("Staaten:",len(regions),"| Appellationen:",len(alln))
for t in [ST,Z,R,S,"Broad GI"]:
    print(f"  {t}: {sum(1 for n in [] )+sum(1 for r in regions for a in r['appellations'] if a['type']==t)+(1 if t=='Broad GI' else 0)}")
d={n:c for n,c in Counter(alln).items() if c>1}
print("Duplikate:", d or "keine"); print("Nicht-ASCII:",[n for n in alln if any(ord(c)>127 for c in n)] or "keine")
assert not d, d
