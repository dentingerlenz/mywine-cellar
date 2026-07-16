#!/usr/bin/env python3
"""united-states.json aus dem offiziellen TTB Established-AVAs-Register neu bauen.

Quelle: TTB "Established American Viticultural Areas"
(ttb.gov/regulated-commodities/beverage-alcohol/wine/established-avas), Stand
29.04.2026 = 279 AVAs (261 Single-State + 18 Multi-State), im Browser direkt aus
den DOM-Tabellen extrahiert. Flach (wie die übrigen Länder): Region = Bundesstaat,
AVAs flach darunter, Typ "AVA". Multi-State-AVAs → Primärstaat (Namen bleiben
landesweit eindeutig). Gerade Apostrophe, ASCII-Bindestriche.
"""
import json, unicodedata
from collections import Counter

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/united-states.json"

def norm(s):
    s = s.replace("’", "'").replace("‘", "'")          # curly → straight
    s = s.replace("–", "-").replace("—", "-")          # en/em dash → hyphen
    s = unicodedata.normalize("NFKC", s)
    return " ".join(s.split())

# Single-State AVAs, gruppiert nach Bundesstaat (Namen bereits bereinigt).
STATES = {
 "Arizona": ["Sonoita", "Verde Valley", "Willcox"],
 "Arkansas": ["Altus", "Arkansas Mountain"],
 "California": ["Adelaida District","Alexander Valley","Alta Mesa","Anderson Valley","Alisos Canyon",
  "Antelope Valley of the California High Desert","Arroyo Grande Valley","Arroyo Seco","Atlas Peak",
  "Ballard Canyon","Ben Lomond Mountain","Benmore Valley","Bennett Valley","Big Valley District-Lake County",
  "Borden Ranch","California Shenandoah Valley","Calistoga","Capay Valley","Carmel Valley","Central Coast",
  "Chalk Hill","Chalone","Chiles Valley","Cienega Valley","Clarksburg","Clear Lake","Clements Hills",
  "Cole Ranch","Comptche","Contra Costa","Coombsville","Cosumnes River","Covelo","Creston District",
  "Crystal Springs of Napa Valley","Cucamonga Valley","Diablo Grande","Diamond Mountain District","Dos Rios",
  "Dry Creek Valley","Dunnigan Hills","Eagle Peak Mendocino County","Edna Valley","El Dorado","El Pomar District",
  "Fair Play","Fiddletown","Fort Ross-Seaview","Fountaingrove District","Gabilan Mountains",
  "Green Valley of Russian River Valley","Guenoc Valley","Hames Valley","Happy Canyon of Santa Barbara",
  "High Valley","Howell Mountain","Inwood Valley","Jahant","Kelsey Bench-Lake County","Knights Valley",
  "Lamorinda","Leona Valley","Lime Kiln Valley","Livermore Valley","Lodi","Long Valley-Lake County",
  "Los Carneros","Los Olivos District","Madera","Malibu Coast","Malibu-Newton Canyon","Manton Valley",
  "Mendocino","Mendocino Ridge","Merritt Island","McDowell Valley","Mokelumne River","Monterey",
  "Moon Mountain District Sonoma County","Mt. Harlan","Mt. Veeder","Napa Valley","North Coast","North Yuba",
  "Northern Sonoma","Oak Knoll District of Napa Valley","Oakville","Pacheco Pass","Paicines",
  "Palos Verdes Peninsula","Paso Robles","Paso Robles Estrella District","Paso Robles Geneseo District",
  "Paso Robles Highlands District","Paso Robles Willow Creek District","Paulsell Valley","Petaluma Gap",
  "Pine Mountain-Cloverdale Peak","Potter Valley","Ramona Valley","Red Hills Lake County","Redwood Valley",
  "River Junction","Rockpile","Russian River Valley","Rutherford","Saddle Rock-Malibu","Salado Creek",
  "San Antonio Valley","San Benito","San Bernabe","San Francisco Bay","San Juan Creek",
  "San Luis Obispo Coast","San Luis Rey","San Lucas","San Miguel District","San Pasqual Valley",
  "San Ysidro District","Santa Clara Valley","Santa Cruz Mountains","Santa Lucia Highlands",
  "Santa Margarita Ranch","Santa Maria Valley","Santa Ynez Valley","Seiad Valley","Sierra Foothills",
  "Sierra Pelona Valley","Sloughhouse","Solano County Green Valley","Sonoma Coast","Sonoma Mountain",
  "Sonoma Valley","South Coast","Spring Mountain District","Squaw Valley-Miramonte","St. Helena",
  "Sta. Rita Hills","Stags Leap District","Suisun Valley","Tehachapi Mountains","Temecula Valley",
  "Templeton Gap District","Tracy Hills","Trinity Lakes","Upper Lake Valley","West Sonoma Coast",
  "Wild Horse Valley","Willow Creek","Winters Highlands","York Mountain","Yorkville Highlands",
  "Yountville","Yucaipa Valley"],
 "Colorado": ["Grand Valley", "West Elks"],
 "Connecticut": ["Eastern Connecticut Highlands", "Western Connecticut Highlands"],
 "Georgia": ["Dahlonega Plateau"],
 "Hawaii": ["Ulupalakua"],
 "Idaho": ["Eagle Foothills"],
 "Illinois": ["Shawnee Hills"],
 "Indiana": ["Indiana Uplands"],
 "Maryland": ["Catoctin", "Linganore"],
 "Massachusetts": ["Martha's Vineyard", "Nashoba Valley"],
 "Michigan": ["Fennville", "Lake Michigan Shore", "Leelanau Peninsula", "Old Mission Peninsula", "Tip of the Mitt"],
 "Minnesota": ["Alexandria Lakes"],
 "Missouri": ["Augusta", "Hermann", "Ozark Highlands"],
 "New Jersey": ["Cape May Peninsula", "Outer Coastal Plain", "Warren Hills"],
 "New Mexico": ["Middle Rio Grande Valley", "Mimbres Valley"],
 "New York": ["Cayuga Lake","Champlain Valley of New York","Finger Lakes","Hudson River Region","Long Island",
  "Niagara Escarpment","North Fork of Long Island","Seneca Lake","The Hamptons, Long Island","Upper Hudson"],
 "North Carolina": ["Crest of the Blue Ridge Henderson County","Haw River Valley","Swan Creek","Tryon Foothills","Yadkin Valley"],
 "Ohio": ["Grand River Valley", "Isle St. George", "Loramie Creek"],
 "Oregon": ["Applegate Valley","Chehalem Mountains","Dundee Hills","Elkton Oregon","Eola-Amity Hills",
  "Laurelwood District","Lower Long Tom","McMinnville","Mt. Pisgah, Polk County, Oregon",
  "Red Hill Douglas County Oregon","Ribbon Ridge","The Rocks District of Milton-Freewater","Rogue Valley",
  "Southern Oregon","Tualatin Hills","Umpqua Valley","Van Duzer Corridor","Willamette Valley","Yamhill-Carlton"],
 "Pennsylvania": ["Lancaster Valley", "Lehigh Valley"],
 "Tennessee": ["Nine Lakes of East Tennessee", "Upper Cumberland"],
 "Texas": ["Bell Mountain","Escondido Valley","Fredericksburg in the Texas Hill Country","Texas Davis Mountains",
  "Texas High Plains","Texas Hill Country","Texoma"],
 "Virginia": ["Middleburg Virginia","Monticello","North Fork of Roanoke","Northern Neck George Washington Birthplace",
  "Rocky Knob","Virginia's Eastern Shore","Virginia Peninsula"],
 "Washington": ["Ancient Lakes of Columbia Valley","Beverly, Washington","Candy Mountain","Goose Gap",
  "Horse Heaven Hills","Lake Chelan","Naches Heights","Puget Sound","Rattlesnake Hills","Red Mountain",
  "Rocky Reach","Royal Slope","Snipes Mountain","The Burn of Columbia Valley","Wahluke Slope","White Bluffs","Yakima Valley"],
 "West Virginia": ["Kanawha River Valley"],
 "Wisconsin": ["Lake Wisconsin", "Wisconsin Ledge"],
}

# Multi-State AVAs → Primärstaat (wein-relevanteste Zuordnung).
MULTI = [
 ("Appalachian High Country","North Carolina"),("Central Delaware Valley","New Jersey"),
 ("Columbia Gorge","Washington"),("Columbia Valley","Washington"),("Cumberland Valley","Pennsylvania"),
 ("Lake Erie","New York"),("Lewis-Clark Valley","Idaho"),("Loess Hills District","Iowa"),
 ("Mesilla Valley","New Mexico"),("Mississippi Delta","Mississippi"),("Ohio River Valley","Ohio"),
 ("Ozark Mountain","Missouri"),("Shenandoah Valley","Virginia"),("Snake River Valley","Idaho"),
 ("Southeastern New England","Massachusetts"),("Upper Hiwassee Highlands","North Carolina"),
 ("Upper Mississippi River Valley","Wisconsin"),("Walla Walla Valley","Washington"),
]

# zusammenbauen: dict state -> [avas]
grouped = {s: [norm(a) for a in avs] for s, avs in STATES.items()}
for name, state in MULTI:
    grouped.setdefault(state, []).append(norm(name))

# feste, sinnvolle Regionsreihenfolge (Wein-Bedeutung grob), Rest alphabetisch
ORDER = ["California","Oregon","Washington","New York","Virginia","Texas","Idaho","Michigan","Missouri",
         "New Mexico","Colorado","Arizona","North Carolina","New Jersey","Pennsylvania","Ohio","Maryland",
         "Massachusetts","Connecticut","Tennessee","Arkansas","Georgia","Hawaii","Illinois","Indiana",
         "Iowa","Minnesota","Mississippi","West Virginia","Wisconsin"]
order = ORDER + sorted(s for s in grouped if s not in ORDER)

regions = [{"name": s, "appellations": [{"name": a, "type": "AVA"} for a in grouped[s]]}
           for s in order if s in grouped]

total = sum(len(r["appellations"]) for r in regions)
out = {
    "country": "United States", "code": "US", "continent": "Americas",
    "verified": True,
    "sources": [
        "TTB Established American Viticultural Areas "
        "(ttb.gov/regulated-commodities/beverage-alcohol/wine/established-avas), Stand 29.04.2026: "
        "279 AVAs (261 Single-State + 18 Multi-State). Flach je Bundesstaat; Multi-State-AVAs am "
        "Primärstaat. Sub-AVA-Verschachtelung nicht abgebildet (alle AVAs als Region-Appellationen)."
    ],
    "officialCount": 279, "verifiedOn": "2026-07-16",
    "regions": regions,
}
open(P, "w").write(json.dumps(out, indent=2, ensure_ascii=False) + "\n")

# --- Selbstkontrolle ---
alln = [a["name"] for r in regions for a in r["appellations"]]
print(f"Regionen: {len(regions)} | AVAs total: {total} (Soll 279) | California: {len(grouped['California'])} (Soll 154)")
dups = {n: c for n, c in Counter(alln).items() if c > 1}
print("Duplikate:", dups or "keine")
bad = [n for n in alln if any(ord(ch) > 127 for ch in n) or "'" in n.replace("'", "") ]
print("Nicht-ASCII:", [n for n in alln if any(ord(c) > 127 for c in n)] or "keine")
print("Curly/Dash-Reste:", [n for n in alln if "’" in n or "–" in n or "—" in n] or "keine")
assert total == 279, f"Total {total} != 279"
assert len(grouped["California"]) == 154, f"CA {len(grouped['California'])} != 154"
assert not dups, "Duplikate!"
print("OK")
