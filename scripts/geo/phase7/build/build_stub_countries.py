#!/usr/bin/env python3
"""Reine Land-Stubs für die restlichen Wein-produzierenden Länder anlegen.
Nur country/code/continent (verified:false, keine Regionen/Appellationen) — die
genaue Geografie folgt später (im Gedächtnis vermerkt). Überschreibt KEINE
bestehende Datei.
"""
import json, os, re
DATA = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography"

# (Name, ISO-2, Kontinent)
COUNTRIES = [
 # Europa
 ("Russia","RU","Europe"),("North Macedonia","MK","Europe"),("Malta","MT","Europe"),
 ("Bosnia and Herzegovina","BA","Europe"),("Montenegro","ME","Europe"),("Albania","AL","Europe"),
 ("Kosovo","XK","Europe"),("Sweden","SE","Europe"),("Norway","NO","Europe"),("Finland","FI","Europe"),
 ("Ireland","IE","Europe"),("Estonia","EE","Europe"),("Latvia","LV","Europe"),("Lithuania","LT","Europe"),
 ("Belarus","BY","Europe"),("Liechtenstein","LI","Europe"),
 # Asien
 ("Kazakhstan","KZ","Asia"),("Uzbekistan","UZ","Asia"),("Kyrgyzstan","KG","Asia"),
 ("Tajikistan","TJ","Asia"),("Turkmenistan","TM","Asia"),("Syria","SY","Asia"),("Jordan","JO","Asia"),
 ("Palestine","PS","Asia"),("Iran","IR","Asia"),("Iraq","IQ","Asia"),("Vietnam","VN","Asia"),
 ("Indonesia","ID","Asia"),("South Korea","KR","Asia"),("Taiwan","TW","Asia"),("Sri Lanka","LK","Asia"),
 # Afrika
 ("Egypt","EG","Africa"),("Namibia","NA","Africa"),("Zimbabwe","ZW","Africa"),("Tanzania","TZ","Africa"),
 ("Madagascar","MG","Africa"),("Cape Verde","CV","Africa"),("Reunion","RE","Africa"),
 # Amerika
 ("Peru","PE","Americas"),("Bolivia","BO","Americas"),("Venezuela","VE","Americas"),
 ("Colombia","CO","Americas"),("Ecuador","EC","Americas"),("Paraguay","PY","Americas"),
 ("Cuba","CU","Americas"),("Dominican Republic","DO","Americas"),
 # Ozeanien
 ("French Polynesia","PF","Oceania"),
]
def fname(n): return re.sub(r"[^a-z0-9]+","-",n.lower()).strip("-")+".json"
written=[]; skipped=[]
for name,code,cont in COUNTRIES:
    p=os.path.join(DATA,fname(name))
    if os.path.exists(p): skipped.append(name); continue
    out={"country":name,"code":code,"continent":cont,"verified":False,
         "sources":["Land-Stub — genaue Geografie (Regionen/Appellationen) noch ausständig (Phase-7-Nachtrag)."],
         "regions":[]}
    open(p,"w").write(json.dumps(out,indent=2,ensure_ascii=False)+"\n")
    written.append(name)
print(f"Geschrieben ({len(written)}):", ", ".join(written))
if skipped: print(f"Übersprungen (existiert): {skipped}")
