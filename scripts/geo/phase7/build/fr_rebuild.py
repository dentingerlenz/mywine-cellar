#!/usr/bin/env python3
"""Frankreich vollständig aus der offiziellen INAO-AOC-Liste (Stand 26.01.2012)
neu aufbauen. Nur Kategorie "Vin". ASCII (frz. Diakritika weg), Apostrophe bleiben.
Grand Crus (eigene AOCs in der Liste) = type 'Grand Cru'; Alsace Grand Cru = ein
Eintrag (die 51 Lieux-dits sind Denominations, nicht separate AOCs). Denominations
géographiques (Hautes Cotes, Villages, Chablis-1er/GC-Climats …) laufen ueber das
Classification-Feld, konsistent mit der 1er-Cru-Entscheidung.
"""
import json, unicodedata, re

P = "/Users/lenzdentinger/Documents/mywine-cellar-v2/data/geography/france.json"
SCRATCH = "/private/tmp/claude-501/-Users-lenzdentinger-Documents-mywine-cellar-v2/8b86d295-2bfa-4790-8251-55808d78edc6/scratchpad"
A, GC, IGP = "AOC", "Grand Cru", "IGP"

def aoc(names): return [{"name": n, "type": A} for n in names]
def gc(names):  return [{"name": n, "type": GC} for n in names]
def igp(names): return [{"name": n, "type": IGP} for n in names]
def sub(name, appellations): return {"name": name, "appellations": appellations}

regions = []

# ── Bordeaux ──────────────────────────────────────────────────────────────────
regions.append({"name": "Bordeaux",
    "appellations": aoc(["Bordeaux", "Bordeaux Superieur", "Cotes de Bordeaux",
                         "Cremant de Bordeaux"]) + igp(["Atlantique"]),
    "subRegions": [
        sub("Medoc", aoc(["Medoc", "Haut-Medoc", "Saint-Estephe", "Pauillac", "Saint-Julien",
                          "Listrac-Medoc", "Moulis-en-Medoc", "Margaux"])),
        sub("Graves", aoc(["Graves", "Graves Superieures", "Pessac-Leognan"])),
        sub("Sauternes", aoc(["Sauternes", "Barsac", "Cerons"])),
        sub("Saint-Emilion", aoc(["Saint-Emilion", "Saint-Emilion Grand Cru",
            "Montagne-Saint-Emilion", "Saint-Georges-Saint-Emilion", "Lussac-Saint-Emilion",
            "Puisseguin-Saint-Emilion"])),
        sub("Pomerol", aoc(["Pomerol", "Lalande-de-Pomerol"])),
        sub("Fronsac", aoc(["Fronsac", "Canon-Fronsac"])),
        sub("Bourg", aoc(["Cotes de Bourg"])),
        sub("Blaye", aoc(["Blaye", "Cotes de Blaye"])),
        sub("Entre-Deux-Mers", aoc(["Entre-Deux-Mers", "Graves de Vayres", "Cadillac",
            "Loupiac", "Sainte-Croix-du-Mont", "Premieres Cotes de Bordeaux",
            "Sainte-Foy-Bordeaux", "Cotes de Bordeaux Saint-Macaire"])),
    ]})

# ── Sud-Ouest (Sud-Ouest bassin non-Bordeaux + Toulouse-Pyrenees) ─────────────
regions.append({"name": "Sud-Ouest",
    "appellations": igp(["Comte Tolosan", "Cotes de Gascogne", "Cotes du Tarn",
                         "Cotes du Lot", "Perigord", "Landes", "Agenais", "Gers"]),
    "subRegions": [
        sub("Bergerac", aoc(["Bergerac", "Cotes de Bergerac", "Monbazillac", "Pecharmant",
            "Montravel", "Cotes de Montravel", "Haut-Montravel", "Saussignac", "Rosette"])),
        sub("Garonne", aoc(["Cotes de Duras", "Cotes du Marmandais", "Buzet", "Brulhois",
            "Saint-Sardos"])),
        sub("Lot & Aveyron", aoc(["Cahors", "Coteaux du Quercy", "Marcillac", "Cotes de Millau",
            "Entraygues et le Fel", "Estaing"])),
        sub("Gaillac & Fronton", aoc(["Gaillac", "Gaillac Premieres Cotes", "Fronton"])),
        sub("Gascogne & Bearn", aoc(["Madiran", "Pacherenc du Vic-Bilh", "Bearn", "Saint-Mont",
            "Tursan", "Jurancon", "Irouleguy", "Floc de Gascogne"])),
    ]})

# ── Bourgogne ─────────────────────────────────────────────────────────────────
regions.append({"name": "Bourgogne",
    "appellations": aoc(["Bourgogne", "Bourgogne Aligote", "Bourgogne Mousseux",
        "Bourgogne Passe-Tout-Grains", "Coteaux Bourguignons", "Cremant de Bourgogne"]),
    "subRegions": [
        sub("Chablis", aoc(["Petit Chablis", "Chablis", "Chablis Grand Cru", "Irancy", "Saint-Bris"])),
        sub("Cote de Nuits", aoc(["Marsannay", "Fixin", "Gevrey-Chambertin", "Morey-Saint-Denis",
            "Chambolle-Musigny", "Vougeot", "Vosne-Romanee", "Nuits-Saint-Georges",
            "Cote de Nuits-Villages"]) + gc([
            "Chambertin", "Chambertin-Clos de Beze", "Chapelle-Chambertin", "Charmes-Chambertin",
            "Griotte-Chambertin", "Latricieres-Chambertin", "Mazis-Chambertin",
            "Mazoyeres-Chambertin", "Ruchottes-Chambertin", "Clos de la Roche",
            "Clos des Lambrays", "Clos de Tart", "Clos Saint-Denis", "Bonnes-Mares", "Musigny",
            "Clos de Vougeot", "Echezeaux", "Grands-Echezeaux", "La Grande Rue", "La Romanee",
            "La Tache", "Richebourg", "Romanee-Conti", "Romanee-Saint-Vivant"])),
        sub("Cote de Beaune", aoc(["Ladoix", "Aloxe-Corton", "Pernand-Vergelesses",
            "Savigny-les-Beaune", "Chorey-les-Beaune", "Beaune", "Pommard", "Volnay", "Monthelie",
            "Auxey-Duresses", "Saint-Romain", "Meursault", "Blagny", "Puligny-Montrachet",
            "Chassagne-Montrachet", "Saint-Aubin", "Santenay", "Maranges", "Cote de Beaune",
            "Cote de Beaune-Villages"]) + gc([
            "Corton", "Corton-Charlemagne", "Charlemagne", "Montrachet", "Chevalier-Montrachet",
            "Batard-Montrachet", "Bienvenues Batard-Montrachet", "Criots-Batard-Montrachet"])),
        sub("Cote Chalonnaise", aoc(["Bouzeron", "Rully", "Mercurey", "Givry", "Montagny"])),
        sub("Maconnais", aoc(["Macon", "Pouilly-Fuisse", "Pouilly-Loche", "Pouilly-Vinzelles",
            "Saint-Veran", "Vire-Clesse"])),
    ]})

# ── Beaujolais (+ Lyonnais/Forez) ─────────────────────────────────────────────
regions.append({"name": "Beaujolais",
    "appellations": aoc(["Beaujolais"]),
    "subRegions": [
        sub("Crus du Beaujolais", aoc(["Brouilly", "Chenas", "Chiroubles", "Cote de Brouilly",
            "Fleurie", "Julienas", "Morgon", "Moulin-a-Vent", "Regnie", "Saint-Amour"])),
        sub("Lyonnais & Forez", aoc(["Coteaux du Lyonnais", "Cotes du Forez", "Cote Roannaise"])),
    ]})

# ── Savoie & Jura ─────────────────────────────────────────────────────────────
regions.append({"name": "Savoie & Jura",
    "appellations": igp(["Franche-Comte"]),
    "subRegions": [
        sub("Jura", aoc(["Arbois", "Chateau-Chalon", "L'Etoile", "Cotes du Jura",
            "Cremant du Jura", "Macvin du Jura"])),
        sub("Savoie", aoc(["Vin de Savoie", "Roussette de Savoie", "Seyssel"])),
        sub("Bugey", aoc(["Bugey", "Roussette du Bugey"])),
    ]})

# ── Champagne ─────────────────────────────────────────────────────────────────
regions.append({"name": "Champagne",
    "appellations": aoc(["Champagne", "Coteaux Champenois", "Rose des Riceys"]),
    "subRegions": [sub("Montagne de Reims", []), sub("Vallee de la Marne", []),
                   sub("Cote des Blancs", []), sub("Cote de Sezanne", []),
                   sub("Aube (Cote des Bar)", [])]})

# ── Alsace (+ Lorraine) ───────────────────────────────────────────────────────
regions.append({"name": "Alsace",
    "appellations": aoc(["Alsace", "Cremant d'Alsace"]) + gc(["Alsace Grand Cru"]),
    "subRegions": [sub("Lorraine", aoc(["Moselle", "Cotes de Toul"]))]})

# ── Vallee de la Loire ────────────────────────────────────────────────────────
regions.append({"name": "Vallee de la Loire",
    "appellations": aoc(["Cremant de Loire", "Rose de Loire"]) + igp(["Val de Loire"]),
    "subRegions": [
        sub("Pays Nantais", aoc(["Muscadet", "Muscadet Sevre et Maine",
            "Muscadet Coteaux de la Loire", "Muscadet Cotes de Grandlieu",
            "Gros Plant du Pays Nantais", "Coteaux d'Ancenis", "Fiefs Vendeens"])),
        sub("Anjou-Saumur", aoc(["Anjou", "Anjou Coteaux de la Loire", "Anjou Villages",
            "Anjou Villages Brissac", "Savennieres", "Savennieres Coulee de Serrant",
            "Savennieres Roche aux Moines", "Coteaux du Layon", "Coteaux de l'Aubance",
            "Bonnezeaux", "Quarts de Chaume", "Rose d'Anjou", "Cabernet d'Anjou", "Saumur",
            "Saumur-Champigny", "Coteaux de Saumur", "Cabernet de Saumur"])),
        sub("Touraine", aoc(["Touraine", "Touraine Noble Joue", "Vouvray", "Montlouis-sur-Loire",
            "Chinon", "Bourgueil", "Saint-Nicolas-de-Bourgueil", "Cheverny", "Cour-Cheverny",
            "Jasnieres", "Coteaux du Loir", "Coteaux du Vendomois", "Valencay", "Chateaumeillant",
            "Haut-Poitou", "Orleans", "Orleans-Clery"])),
        sub("Centre-Loire", aoc(["Sancerre", "Pouilly-Fume", "Pouilly-sur-Loire", "Menetou-Salon",
            "Quincy", "Reuilly", "Coteaux du Giennois"])),
    ]})

# ── Auvergne ──────────────────────────────────────────────────────────────────
regions.append({"name": "Auvergne", "appellations": aoc(["Cotes d'Auvergne", "Saint-Pourcain"])})

# ── Vallee du Rhone ───────────────────────────────────────────────────────────
regions.append({"name": "Vallee du Rhone",
    "appellations": aoc(["Cotes du Rhone"]) + igp(["Mediterranee", "Comtes Rhodaniens",
                        "Collines Rhodaniennes", "Ardeche", "Drome", "Vaucluse"]),
    "subRegions": [
        sub("Rhone Nord", aoc(["Cote-Rotie", "Condrieu", "Chateau-Grillet", "Saint-Joseph",
            "Crozes-Hermitage", "Hermitage", "Cornas", "Saint-Peray"])),
        sub("Rhone Sud", aoc(["Chateauneuf-du-Pape", "Gigondas", "Vacqueyras", "Vinsobres",
            "Beaumes de Venise", "Muscat de Beaumes-de-Venise", "Rasteau", "Lirac", "Tavel",
            "Luberon", "Ventoux", "Grignan-les-Adhemar", "Cotes du Vivarais", "Pierrevert",
            "Cotes du Rhone Villages"])),
        sub("Diois", aoc(["Clairette de Die", "Cremant de Die", "Coteaux de Die",
            "Chatillon-en-Diois"])),
    ]})

# ── Languedoc-Roussillon ──────────────────────────────────────────────────────
regions.append({"name": "Languedoc-Roussillon",
    "appellations": igp(["Pays d'Oc", "Pays d'Herault", "Cotes Catalanes", "Cevennes", "Gard",
                         "Cote Vermeille", "Aude"]),
    "subRegions": [
        sub("Languedoc", aoc(["Languedoc", "Clairette du Languedoc", "Clairette de Bellegarde",
            "Picpoul de Pinet", "Cabardes", "Malepere", "Minervois", "Minervois-La Liviniere",
            "Corbieres", "Corbieres-Boutenac", "Saint-Chinian", "Faugeres", "Fitou", "Limoux",
            "Cremant de Limoux", "Costieres de Nimes", "Duche d'Uzes", "Muscat de Frontignan",
            "Muscat de Lunel", "Muscat de Mireval", "Muscat de Saint-Jean-de-Minervois"])),
        sub("Roussillon", aoc(["Cotes du Roussillon", "Cotes du Roussillon Villages", "Collioure",
            "Banyuls", "Banyuls grand cru", "Maury", "Rivesaltes", "Muscat de Rivesaltes",
            "Grand Roussillon"])),
    ]})

# ── Provence (flach: keine eponyme Sub-Region) ────────────────────────────────
regions.append({"name": "Provence",
    "appellations": aoc(["Coteaux d'Aix-en-Provence", "Les Baux de Provence",
        "Cotes de Provence", "Bandol", "Cassis", "Palette", "Coteaux Varois en Provence",
        "Bellet"]) + igp(["Mediterranee", "Var", "Bouches-du-Rhone", "Alpilles", "Maures",
                          "Mont Caume"])})

# ── Corse ─────────────────────────────────────────────────────────────────────
regions.append({"name": "Corse",
    "appellations": aoc(["Vin de Corse", "Ajaccio", "Patrimonio", "Muscat du Cap Corse"])
                    + igp(["Ile de Beaute"])})

# ── Charentes (Pineau des Charentes = Vin de liqueur) ─────────────────────────
regions.append({"name": "Charentes",
    "appellations": aoc(["Pineau des Charentes"]) + igp(["Charentais"])})

# ── zusammensetzen (Normandy=Domfront war Poire, kein Wein -> raus) ───────────
d = json.load(open(P))
d["regions"] = regions
ordered = {k: d[k] for k in ("country", "code", "continent", "verified", "sources",
                             "officialCount", "verifiedOn", "appellations", "regions") if k in d}
open(P, "w").write(json.dumps(ordered, indent=2, ensure_ascii=False) + "\n")

# ── Vollstaendigkeits-Check gegen INAO ───────────────────────────────────────
inao = json.load(open(f"{SCRATCH}/inao_aoc.json"))
def key(s):
    s = unicodedata.normalize('NFKD', s).encode('ascii','ignore').decode().lower()
    return re.sub(r'[^a-z0-9]', '', s)  # nur Alphanumerik → Apostroph/Bindestrich egal
master = {}
for b, ns in inao.items():
    for n in ns: master[key(n)] = n
# manuelle Aequivalenzen (Listen-Primaername -> unsere Schreibweise)
EQUIV = {"moulis": "moulis en medoc", "cote rotie": "cote rotie",
         "clairettte de die": "clairette de die", "muscat de risevaltes": "muscat de rivesaltes",
         "rousette du bugey": "roussette du bugey", "coteaux champenois": "coteaux champenois"}
placed = set()
for r in regions:
    for a in r.get("appellations") or []:
        if a["type"] != IGP: placed.add(key(a["name"]))
    for s in r.get("subRegions") or []:
        for a in s.get("appellations") or []:
            if a["type"] != IGP: placed.add(key(a["name"]))

# INAO -> platziert?
missing = []
for k, n in master.items():
    kk = EQUIV.get(k, k)
    if k not in placed and kk not in placed:
        # Alsace grand cru + Denominations, die wir bewusst weglassen:
        missing.append(n)
extra = [k for k in placed if k not in master and k not in EQUIV.values()]
cnt = sum(1 for r in regions for a in (r.get('appellations') or []) if a['type']!=IGP) + \
      sum(1 for r in regions for s in (r.get('subRegions') or []) for a in (s.get('appellations') or []) if a['type']!=IGP)
igpcnt = sum(1 for r in regions for a in (r.get('appellations') or []) if a['type']==IGP)
print(f"AOC platziert: {cnt} · IGP: {igpcnt}")
print(f"\nINAO-AOCs NICHT platziert ({len(missing)}):")
print("  " + ", ".join(sorted(missing)))
print(f"\nPlatziert, aber NICHT in INAO ({len(extra)}):")
print("  " + ", ".join(sorted(extra)))
EOF
