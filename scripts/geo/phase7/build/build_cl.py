#!/usr/bin/env python3
"""chile.json aus dem offiziellen Decreto 464 (SAG, Zonificacion Viticola) neu bauen.
Aus dem SAG-PDF geparst + bereinigt. Region = REGION VITICOLA (6), Appellationen
flach: Valles (Subregionen/Zonen, Typ "DO") + Areas (Comunas, Typ "DO Area").
Spanisch -> ASCII. Keine Bestandsweine.
"""
import json
from collections import Counter
P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/chile.json"

REGIONS = {
 "Atacama": (["Valle de Copiapo","Valle del Huasco"], []),
 "Coquimbo": (["Valle del Elqui","Valle del Limari","Valle del Choapa"],
              ["La Serena","Vicuna","Paiguano","Ovalle","Punitaqui","Rio Hurtado","Salamanca","Illapel"]),
 "Aconcagua": (["Valle del Aconcagua","Valle de Casablanca","Valle de San Antonio","Valle del Marga-Marga","Valle de Leyda"],
               ["Panquehue","Quillota","Hijuelas","Catemu","Llaillay","San Felipe","Santa Maria","Calle Larga",
                "San Esteban","San Juan","Santo Domingo","Zapallar","Cartagena"]),
 "Valle Central": (["Valle del Maipo","Valle del Rapel","Valle de Curico","Valle del Maule","Valle del Cachapoal",
                    "Valle de Colchagua","Valle del Teno","Valle del Lontue","Valle del Claro","Valle del Loncomilla","Valle del Tutuven"],
                   ["Pirque","Puente Alto","Buin","Isla de Maipo","Talagante","Melipilla","Maria Pinto","Colina",
                    "Calera de Tango","Til Til","Lampa","Rancagua","Requinoa","Peumo","Machali","Coltauco","San Fernando",
                    "Chimbarongo","Nancagua","Santa Cruz","Palmilla","Peralillo","Lolol","Litueche","La Estrella",
                    "Paredones","Pumanque","Rauco","Romeral","Vichuquen","Molina","Talca","Pencahue","San Clemente",
                    "San Rafael","Empedrado","Curepto","San Javier","Villa Alegre","Parral","Linares","Colbun","Longavi","Retiro"]),
 "Sur": (["Valle del Itata","Valle del Bio-Bio","Valle del Malleco"], ["Chillan","Quillon","Coelemu","Mulchen"]),
 "Austral": (["Valle del Cautin","Valle de Osorno"], []),
}
regions=[{"name":r,"appellations":[{"name":v,"type":"DO"} for v in valles]+[{"name":a,"type":"DO Area"} for a in areas]}
         for r,(valles,areas) in REGIONS.items()]
tot=sum(len(x["appellations"]) for x in regions)
out={"country":"Chile","code":"CL","continent":"Americas","verified":True,
 "sources":["Decreto N° 464 (SAG, Zonificacion Viticola y Denominacion de Origen; sag.gob.cl PDF): "
            "6 Regionen viticolas -> Valles (Subregionen/Zonen, DO) + Areas (Comunas, DO Area). "
            "Aus dem amtlichen PDF geparst; Spanisch -> ASCII."],
 "officialCount":tot,"verifiedOn":"2026-07-16","regions":regions}
open(P,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
alln=[a["name"] for r in regions for a in r["appellations"]]
print("Regionen:",len(regions),"| DOs:",tot,"| Valles:",
      sum(1 for r in regions for a in r["appellations"] if a["type"]=="DO"),
      "| Areas:",sum(1 for r in regions for a in r["appellations"] if a["type"]=="DO Area"))
d={n:c for n,c in Counter(alln).items() if c>1}
print("Duplikate:", d or "keine"); print("Nicht-ASCII:",[n for n in alln if any(ord(c)>127 for c in n)] or "keine")
assert not d, d
