# Phase 7 — Geografie registerbasiert vervollständigen

Backup & Provenienz für die Phase-7-Arbeit (Appellationen Land für Land aus
**offiziellen Registern** neu aufbauen, statt Modellwissen/Wikipedia). Diese
Skripte sind Wegwerf-/Einmal-Werkzeuge, hier als Nachweis + Wiederverwendung
gesichert. Der maßgebliche Datenstand liegt in `data/geography/*.json`.

## Stand (2026-07-16)

| Land | Appellationen | Quelle | Prod |
|---|---|---|---|
| Frankreich | 351 | INAO AOC-Liste (2012) + IGP (2014) + Post-2012-Nachträge | ✅ live |
| Italien | 522 | MASAF Elenco DOP (18.03.2026) + IGP (13.05.2026) | ✅ live |
| Schweiz | 63 | BLW/OFAG AOC-Register (1.1.2026) | ✅ live |
| Spanien | 149 | MAPA Listado DOP/IGP (02.07.2026) | ✅ live |
| Österreich | 27 | ÖWM „Wein aus Österreich" 11/2025 (DAC + generische Gebiete) | ✅ live |
| Deutschland | 66 | Weingesetz/Weinverordnung: 13 Anbaugebiete (g.U.) + 41 Bereiche + Landwein (recherchiert, kein amtliches PDF) | ✅ live |
| Neuseeland | 19 | IPONZ GI-Register (wine): 10 regionale + 9 lokale GIs (IP 1004–1028) | ✅ live |
| Portugal | 44 | eAmbrosia (EU-GI-Register), Extrakt PT/wine: 30 DOP + 14 IGP | ✅ live |
| USA | 279 | TTB Established AVAs (Stand 29.04.2026): 261 Single-State + 18 Multi-State | ✅ live |
| Südafrika | 142 | SAWIS/WoSA WO-Register (Production Areas, Feb 2026): 5 GU + 6 Region + 30 District + 101 Ward | ⏳ committet |
| Zypern | 11 | Offizielle Wein-GI-Liste (User): 7 PDO + 4 PGI | ⏳ committet |
| Ungarn | 38 | kormany.hu GI-Register: 32 OEM + 6 OFJ, 6 Weinregionen | ⏳ committet |
| Griechenland | 107 | Recherchiert: 33 PDO + regionale/Präfektur-PGIs, 9 Regionen | ⏳ committet |
| Polen | 16 | Recherchiert (1 generelle PGI): 8 Weinregionen + Subregionen | ⏳ committet |
| Argentinien | 105 | INV-Register (gob.ar PDF): 103 IG + 2 DOC, Provinzen | ⏳ committet |
| Chile | 95 | Decreto 464 (SAG PDF): 6 Regionen, Valles + Areas | ⏳ committet |
| Australien | 111 | Wine Australia GI-Register: Zonen/Regionen/Subregionen je Bundesstaat | ⏳ committet |

**Deploy-Historie 2026-07-16:** DE+NZ+PT (apps 1545→1606), dann USA (→1821).
FR/IT/CH/ES/AT/DE/NZ/PT/US sind live.

**Offener Deploy-Batch (bündeln bis User-Auftrag):** `…130000` (ZA) + `…140000`–`…200000`
(CY/AR/HU/AU/CL/GR/PL) = 8 Migrationen, committet + lokal verifiziert (Konvergenz
539/539 + Wein-Erhalt gegen alle Bestandsweine). Deploy auf User-Auftrag.

**Deutschland-Besonderheit:** Einzellagen/Grosslagen sind bewusst KEINE Geografie
→ die konkrete Lage steht im Freitextfeld „Location". Die VDP-Klassifikationsstufen
(VDP.Grosse Lage/Erste Lage/Ortswein/Gutswein, Grosses Gewächs) sind KEINE Region,
sondern im Formularfeld „Classification" wählbar (kuratierte Liste in
`src/features/wines/model.ts` → `CLASSIFICATION_SUGGESTIONS`). Die Migration hängt
alte informelle Sub-Regionen (Mittelmosel/Terrassenmosel) verlustfrei ins
„Location"-Feld um.

**Neuseeland-Besonderheit:** Register hat 2 Ebenen (regionale GI enthält lokale
GIs). Flach modelliert — lokale GIs (Kumeu, Bannockburn, Central Hawke's Bay …)
als Geschwister-Appellationen unter ihrer Region, alle Typ „GI". Nicht-registrierte
informelle Sub-Regionen (Wairau Valley, Southern Valleys, Awatere …) sind KEINE GI
→ Migration hängt solche Bestandsweine ins „Location"-Feld um (wie DE Mittelmosel).

**Portugal-Besonderheit:** Quelle eAmbrosia (EU-Register) liefert nur Name + PDO/PGI,
keine Region → Regionsgruppierung = etablierte portug. Weinregion-Struktur (11 Regionen).
Romanische Diakritika → ASCII (Konvention wie ES/FR). Douro-Unterzonen ohne eigene DOP
(Douro Superior …) → Migration hängt sie ins „Location"-Feld, AUCH wenn der Wein die
DOP „Douro" behält (verfeinerter Erhalt-Schritt: Sub ins Location wenn ≠ Appellation).

**USA-Besonderheit:** TTB-Register direkt aus den DOM-Tabellen extrahiert (JS im
Browser), nicht WebFetch (Seite zu groß). Flach je Bundesstaat (Region), 279 AVAs
als Appellationen (Typ „AVA"); AVA-Verschachtelung (Napa→Oakville, Central Coast→…)
bewusst NICHT abgebildet — alle AVAs sind gleichrangig direkt wählbar. Multi-State-
AVAs am wein-relevantesten Primärstaat. curly ' → gerade, En-/Em-Dash → „-".

**Südafrika-Besonderheit:** WO-Schema ist mehrstufig (Geographical Unit → Region →
Subregion → District → Ward), bilingual Eng/Afr. Flach je GU (Region), alles darunter
als Appellationen mit Typ-Badge (WO Geographical Unit / WO Region / WO District /
WO Ward); Subregionen (Cape West Coast …) als Ebene weggelassen. Namen → Englisch
(vor „/"), gerade Apostrophe, PDF-Tippfehler „Simonsberg-Stellenbosh" → „…bosch"
korrigiert. Erhält die 4 Bestandsweine (Region Western Cape), Elgin-Weine → Appellation.

**Reihenfolge weiter:** Rest-Kernländer (GR, AU, CL, AR …).

## Workflow pro Land (identisch, wiederholbar)

1. **Offizielle Quelle beschaffen** — User liefert PDF/URL. Vorher klären, ob es
   ein amtliches Register gibt. Extrahieren:
   `pip3 install pypdf` (im scratchpad), dann
   `pypdf.PdfReader(pdf).pages[i].extract_text()`.
   (poppler/pdftotext ist NICHT installiert; das Read-Tool kann PDFs nicht rendern.)
2. **Parsen** → (Name, Typ, Region). Fallstricke aus der Praxis:
   - Seiten-Header/-Footer vor dem Parsen strippen.
   - Anker möglichst auf einen eindeutigen Code (z. B. `PDO-IT-…`, `PGI-ES-…` —
     IGP-Codes sind `PGI-…`, NICHT `PDO-…`!).
   - Verklebte Tokens („NameDOP") mit Leerzeichen trennen.
   - Mehrsprachige/Dialekt-Alternativnamen auf die Kanonform reduzieren.
   - **Vollständigkeits-Check:** laufende Nummer (N°) lückenlos, Summe == Register.
   - De-Akzentuieren: **französische** Diakritika → ASCII; **deutsche** Umlaute
     bleiben (ö/ü/ä). Apostrophe gerade (`'`).
3. **`data/geography/<land>.json` neu bauen** — jede Denomination als Appellation
   unter ihrer offiziellen Region, Typ korrekt (DO/DOCa/DOCG/DAC/AOC/…). „Flach"
   auf Regionsebene (keine Sub-Regionen), außer das Land braucht sie zwingend
   (Frankreich = Regionen + Sub-Regionen). Einzellagen/1er-Cru/MGA/Vigna sind
   KEINE Appellation → Classification/Location-Feld. `verified:true` +
   `officialCount` + `verifiedOn` + `sources` setzen.
4. **`npm run geo:build`** — Validator muss grün sein (harte Invarianten; neue
   Typen ggf. in `KNOWN_TYPES` in `scripts/geo/build-seed.js` aufnehmen).
5. **Daten committen** (englisch).
6. **Prod-Migration erzeugen** — für flache Länder:
   `python3 scripts/geo/phase7/gen_flat_migration.py <Country> <basename> <YYYYMMDDHHMMSS>`.
   Für Frankreich (mit Sub-Regionen): `gen_fr_migration.py` als Vorlage.
7. **Lokal verifizieren** (Docker-Stack):
   - Wein-Erhalt-Simulation: alten Prod-Zustand (`git show <letzter-deployter-
     commit>:supabase/seed.sql`) laden, je 1 Wein pro realer Prod-Kombination
     (aus `select … group by region,sub,appellation`), Migration laufen lassen,
     prüfen: **0 Weine ohne country**, Sub→Appellation korrekt.
   - Konvergenz: migrierter Länder-Satz == frischer Seed (`db reset`), Diff leer.
8. **Migration committen.** Deploy gebündelt (User-Wunsch): mehrere Migrationen
   sammeln, dann EIN Push.

## Deploy (gebündelt)

Direktverbindung ist IPv6-only und scheitert im Nutzer-Netz → **Session-Pooler**:
```
supabase db push --db-url \
  'postgresql://postgres.czmjxsojbomkqtluzhru:<PW>@aws-0-eu-west-1.pooler.supabase.com:5432/postgres' \
  --include-all
```
(PW nur ephemer; die pgdelta-Warnung ist harmlos.) Danach pgcheck-Nachkontrolle
(`scripts/geo/phase7/` … bzw. scratchpad `pgcheck/` mit `npm i pg`): apps-Zahlen
vorher/nachher, **0 verwaiste Wein-FKs**, 0 Duplikate. Dann `git push` → Vercel.

## Dateien hier

- `gen_flat_migration.py` — parametrisierter Migrations-Generator (flache Länder).
- `gen_fr_migration.py`, `gen_it_migration.py` — die konkret genutzten Generatoren.
- `build/` — die Länder-Bau-Skripte (FR-Regionen, IT, CH; ES/AT wurden inline
  gebaut, Muster identisch).
- `sources/` — extrahierte offizielle Listen als Text/JSON (Provenienz).
  Österreich-Broschüre (144 S., 38 MB) nicht abgelegt — reproduzierbar von
  `oesterreichwein.at/…/SU_DE_202511_web_komprimiert.pdf` (Infos S. 27–37).
