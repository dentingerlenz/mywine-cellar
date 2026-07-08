#!/usr/bin/env node
/**
 * Phase 4 — Datenmigration v1 → v2 (docs/REBUILD_PLAN.md §8)
 *
 * Liest die CSV-Exporte aus backup/ und schreibt sie ins v2-Schema:
 *   wines (Geo-Text → FK-Auflösung), people, drinking_log (+Junction).
 * wine_colours ist ein No-op (der Keller-Trigger seedet die 6 Defaults,
 * die exakt dem Bestand des Haupt-Users entsprechen — siehe Plan §8.0).
 *
 * Idempotent: Upserts auf den Original-UUIDs — kann beliebig oft laufen.
 * Original-IDs (wines, people, drinking_log) bleiben erhalten, damit alle
 * Referenzen (drinking_log.wine_id, people_ids) ohne Mapping stimmen.
 *
 * Aufruf (Dry-Run gegen lokalen Stack):
 *   1. node_modules/.bin/supabase start && node_modules/.bin/supabase db reset
 *   2. Auth-User lokal anlegen (siehe scripts/geo/README oder Plan Anhang D):
 *      insert into auth.users (instance_id,id,aud,role,email,encrypted_password,
 *        email_confirmed_at,created_at,updated_at) values
 *      ('00000000-0000-0000-0000-000000000000','<MAIN_USER_ID>','authenticated',
 *       'authenticated','<email>','x',now(),now(),now());
 *   3. SUPABASE_URL=http://127.0.0.1:54321 SUPABASE_SERVICE_ROLE_KEY=<key> \
 *      npm run migrate:v1
 *
 * Live-Lauf (Phase 4, NUR nach User-Sign-off): gleiche Env-Vars aufs
 * Live-Projekt zeigen lassen — vorher Baseline-Migration deployen!
 *
 * Output: backup/migration-report.json + Konsolen-Zusammenfassung.
 * Unaufgelöste Geo-Namen: in scripts/migrate-overrides.json nachtragen
 * (Format siehe Datei), dann erneut laufen lassen.
 */

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import Papa from "papaparse";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const BACKUP = join(ROOT, "backup");

const SUPABASE_URL = process.env.SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const CELLAR_NAME = process.env.CELLAR_NAME || "My Wine Cellar";
if (!SUPABASE_URL || !SERVICE_KEY) {
  console.error("SUPABASE_URL und SUPABASE_SERVICE_ROLE_KEY müssen gesetzt sein.");
  process.exit(1);
}
// Direkter PostgREST-Zugriff statt supabase-js: das Script braucht kein
// Realtime, und supabase-js verlangt dafür Node 22+ (natives WebSocket).
const api = async (method, path, body, prefer) => {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
    method,
    headers: {
      apikey: SERVICE_KEY,
      Authorization: `Bearer ${SERVICE_KEY}`,
      "Content-Type": "application/json",
      ...(prefer ? { Prefer: prefer } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (!res.ok) throw new Error(`${method} ${path}: ${res.status} ${await res.text()}`);
  const text = await res.text();
  return text ? JSON.parse(text) : null;
};
const restSelect = (query) => api("GET", query);
const restInsert = (table, rows) => api("POST", table, rows, "return=representation");
const restUpsert = (table, rows, onConflict) =>
  api("POST", `${table}${onConflict ? `?on_conflict=${onConflict}` : ""}`, rows,
    "resolution=merge-duplicates,return=minimal");

// ── CSV laden ────────────────────────────────────────────────────────────────
const csv = (file, delimiter) =>
  Papa.parse(readFileSync(join(BACKUP, file), "utf8").trim(), {
    header: true, delimiter, skipEmptyLines: true,
  }).data;

const wines = csv("cellar-export-2026-07-07.csv", ",");
const people = csv("people.csv", ";");
const log = csv("drinking_log.csv", ";");
const profiles = csv("profiles.csv", ";");

const MAIN_USER_ID = process.env.MAIN_USER_ID || profiles[0]?.id;
if (!MAIN_USER_ID) { console.error("Kein MAIN_USER_ID (profiles.csv leer?)"); process.exit(1); }

// ── Helpers ──────────────────────────────────────────────────────────────────
const norm = (s) =>
  (s ?? "").toString().trim().toLowerCase()
    .normalize("NFD").replace(/[̀-ͯ]/g, "")
    .replace(/\s+/g, " ");
const blank = (s) => !s || !String(s).trim();
const num = (s) => (blank(s) || isNaN(Number(s)) ? null : Number(s));
const int = (s) => { const n = num(s); return n == null ? null : Math.round(n); };
const txt = (s) => (blank(s) ? null : String(s).trim());

// DE→EN-Länder-Aliasse (Audit §8.0: country ist deutsch/englisch gemischt)
const COUNTRY_ALIAS = {
  "frankreich": "France", "italien": "Italy", "spanien": "Spain",
  "deutschland": "Germany", "schweiz": "Switzerland", "osterreich": "Austria",
  "griechenland": "Greece", "sudafrika": "South Africa", "zypern": "Cyprus",
  "polen": "Poland", "danemark": "Denmark", "ungarn": "Hungary",
  "neuseeland": "New Zealand", "portugal": "Portugal", "usa": "United States",
  "vereinigte staaten": "United States", "australien": "Australia",
  "chile": "Chile", "argentinien": "Argentina", "england": "England & Wales",
};

const OVERRIDES_PATH = join(ROOT, "scripts", "migrate-overrides.json");
const overrides = existsSync(OVERRIDES_PATH)
  ? JSON.parse(readFileSync(OVERRIDES_PATH, "utf8"))
  : { countries: {}, regions: {}, sub_regions: {}, appellations: {} };
const ov = (map, key) => map?.[key] ?? map?.[norm(key)] ?? null;

const OCCASION = { a: "anytime", t: "special", l: "lay_down", T: "top" };

// ── Weinart-Feld-Routing (Zwischen-Plan) ─────────────────────────────────────
const applyProducerFix = (p) => (p ? overrides.producers?.[p.trim()] ?? p.trim() : p);

// Jahrgang-Freitext → Zahl | NV(+Basisjahr) | Reife-/Solera-Angabe
const parseVintage = (raw) => {
  const v = (raw ?? "").trim();
  if (!v) return { vintage: null, is_non_vintage: false, base_vintage: null, aging_indication: null };
  if (/^\d{4}$/.test(v)) return { vintage: Number(v), is_non_vintage: false, base_vintage: null, aging_indication: null };
  if (/^NV/i.test(v)) {
    const base = v.match(/(\d{4})/);
    return { vintage: null, is_non_vintage: true, base_vintage: base ? Number(base[1]) : null, aging_indication: null };
  }
  // Solera / Reife-/Alters-Angaben ("Soléra 2013+", "~25 years", "> 12 years", "2-4 years", "VORS")
  return { vintage: null, is_non_vintage: true, base_vintage: null, aging_indication: v };
};

// Dosage-Freitext → Stufe (benannt) ODER g/L (Zahl)
const DOSAGE_LEVELS = {
  "brut nature": "Brut Nature", "non dosé": "Brut Nature", "zero dosage": "Brut Nature", "pas dosé": "Brut Nature",
  "extra brut": "Extra Brut", "brut": "Brut", "extra dry": "Extra Dry", "extra sec": "Extra Dry",
  "sec": "Sec", "demi-sec": "Demi-Sec", "doux": "Doux",
};
const parseDosage = (raw) => {
  const v = (raw ?? "").trim();
  if (!v) return { dosage_level: null, dosage_gl: null };
  const n = Number(v.replace(",", "."));
  if (Number.isFinite(n)) return { dosage_level: null, dosage_gl: n };
  return { dosage_level: DOSAGE_LEVELS[v.toLowerCase()] ?? v, dosage_gl: null };
};

// Klassifizierungs-Token aus dem Appellations-Feld herauslösen → { classification, place }
const esc = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
const CLASS_TOKENS = [
  { t: "VDP.Grosse Lage, GG", b: false }, { t: "VDP.Grosse Lage", b: false },
  { t: "VDP.Erste Lage", b: false }, { t: "VDP.Ortswein", b: false },
  { t: "VDP.Gutswein", b: false }, { t: "VDP.Prädikatswein", b: false },
  { t: "Alsace Grand Cru", b: false }, { t: "Grand Cru", b: false },
  { t: "Premier Cru", b: false }, { t: "1er Cru", b: false }, { t: "Gran Reserva", b: false },
  { t: "V.T. de Cadiz", b: false }, { t: "Vino de la Tierra", b: false },
  { t: "Burgenländischer Landwein", b: false }, { t: "Vin de France", b: false },
  { t: "vino bianco", b: false }, { t: "Riserva", b: true }, { t: "Reserva", b: true },
  { t: "Superiore", b: true }, { t: "Supérieur", b: true }, { t: "Superior", b: true },
  { t: "Landwein", b: true }, { t: "Tafelwein", b: true }, { t: "DOCG", b: true },
  { t: "DOCa", b: true }, { t: "DOC", b: true }, { t: "DOP", b: true }, { t: "IGT", b: true },
  { t: "IGP", b: true }, { t: "AOP", b: true }, { t: "AOC", b: true }, { t: "DAC", b: true },
  { t: "GG", b: true }, { t: "DO", b: true }, { t: "AC", b: true },
];
const isVinification = (v) => /biodyn|vergoren|amphore|barrique|tonneau|maische|monate|einfluss/i.test(v);
const splitClassification = (raw) => {
  let place = " " + raw + " ";
  const found = [];
  for (const { t, b } of CLASS_TOKENS) {
    const pat = b ? `(?<=[\\s(,.])${esc(t)}(?=[\\s),.])` : esc(t);
    if (new RegExp(pat, "i").test(place)) {
      found.push(t);
      place = place.replace(new RegExp(pat, "ig"), " ");
    }
  }
  place = place.replace(/[\s,]{2,}/g, " ").replace(/^[\s,]+|[\s,]+$/g, "").trim();
  return { classification: found.length ? found.join(", ") : null, place: place || null };
};

const photoPath = (url) => {
  if (blank(url)) return null;
  const i = url.indexOf("/wine-photos/");
  return i === -1 ? url : url.slice(i + "/wine-photos/".length);
};

// ── Geo-Referenz laden & Resolver bauen ─────────────────────────────────────
const fetchAll = async (table, select) => {
  const out = [];
  for (let offset = 0; ; offset += 1000) {
    const data = await restSelect(`${table}?select=${select.replace(/\s/g, "")}&limit=1000&offset=${offset}`);
    out.push(...data);
    if (data.length < 1000) break;
  }
  return out;
};

const report = {
  started_at: new Date().toISOString(),
  cellar: null,
  counts: {},
  unresolved: { countries: {}, regions: {}, sub_regions: {}, appellations: {} },
  odd_vintages: [],
  duplicates: [],
};
const miss = (bucket, key, wine) => {
  const b = report.unresolved[bucket];
  b[key] = b[key] || { count: 0, examples: [] };
  b[key].count++;
  if (b[key].examples.length < 3)
    b[key].examples.push(`${wine.producer ?? "?"} — ${wine.description ?? "?"} (${wine.vintage ?? "?"})`);
};

async function main() {
  console.log(`Migration v1→v2 gegen ${SUPABASE_URL}`);
  console.log(`Haupt-User: ${MAIN_USER_ID}`);

  // 1. Keller sicherstellen (Trigger seedet die 6 Default-Farben)
  const membership = await restSelect(
    `cellar_members?user_id=eq.${MAIN_USER_ID}&select=cellar_id`);
  let cellarId = membership[0]?.cellar_id;
  if (!cellarId) {
    const [cellar] = await restInsert("cellars", { name: CELLAR_NAME, created_by: MAIN_USER_ID });
    cellarId = cellar.id;
    await restInsert("cellar_members", { cellar_id: cellarId, user_id: MAIN_USER_ID, role: "owner" });
    console.log(`Keller "${CELLAR_NAME}" angelegt: ${cellarId}`);
  } else {
    console.log(`Bestehender Keller wird genutzt: ${cellarId}`);
  }
  report.cellar = cellarId;

  // 2. Farben des Kellers (für colour → colour_id)
  const colours = await fetchAll("wine_colours", "id, name");
  const colourByName = new Map(colours.map((c) => [c.name, c.id]));

  // 3. Geo-Referenz
  const countries = await fetchAll("countries", "id, name");
  const regions = await fetchAll("regions", "id, country_id, name");
  const subs = await fetchAll("sub_regions", "id, region_id, name");
  const apps = await fetchAll("appellations", "id, level, country_id, region_id, sub_region_id, name");

  const countryByNorm = new Map(countries.map((c) => [norm(c.name), c]));
  const regionsByCountry = new Map(); // country_id -> Map(norm -> row)
  for (const r of regions) {
    if (!regionsByCountry.has(r.country_id)) regionsByCountry.set(r.country_id, new Map());
    regionsByCountry.get(r.country_id).set(norm(r.name), r);
  }
  const subsByRegion = new Map();
  for (const s of subs) {
    if (!subsByRegion.has(s.region_id)) subsByRegion.set(s.region_id, new Map());
    subsByRegion.get(s.region_id).set(norm(s.name), s);
  }
  const appsBySub = new Map(), appsByRegion = new Map(), appsByCountry = new Map();
  for (const a of apps) {
    const key = norm(a.name);
    if (a.level === "sub_region") {
      if (!appsBySub.has(a.sub_region_id)) appsBySub.set(a.sub_region_id, new Map());
      appsBySub.get(a.sub_region_id).set(key, a);
    } else if (a.level === "region") {
      if (!appsByRegion.has(a.region_id)) appsByRegion.set(a.region_id, new Map());
      appsByRegion.get(a.region_id).set(key, a);
    } else {
      if (!appsByCountry.has(a.country_id)) appsByCountry.set(a.country_id, new Map());
      appsByCountry.get(a.country_id).set(key, a);
    }
  }
  const subIdsOfRegion = new Map();
  for (const s of subs) {
    if (!subIdsOfRegion.has(s.region_id)) subIdsOfRegion.set(s.region_id, []);
    subIdsOfRegion.get(s.region_id).push(s.id);
  }

  const resolveGeo = (w) => {
    const out = {
      country_id: null, region_id: null, sub_region_id: null, appellation_id: null,
      classification: null, location: null, terroir_extra: null,
    };

    // Land: Override → DE/EN-Alias → exakter (normalisierter) Match
    let cRaw = txt(w.country);
    if (cRaw) {
      const o = ov(overrides.countries, cRaw);
      const canonical = o ?? COUNTRY_ALIAS[norm(cRaw)] ?? cRaw;
      const c = countryByNorm.get(norm(canonical));
      if (c) out.country_id = c.id; else miss("countries", cRaw, w);
    }

    // Region (nur mit aufgelöstem Land). Der v1-Bestand nutzt oft
    // Länderkürzel-Präfixe ("FR - Champagne") → Präfix-Variante mittesten.
    let rRaw = txt(w.region);
    let regionRow = null;
    if (rRaw && out.country_id) {
      const cName = countries.find((c) => c.id === out.country_id)?.name;
      const stripped = rRaw.replace(/^[A-Z]{2,4}\s*-\s*/, "");
      const candidates = [
        ov(overrides.regions, `${cName}|${rRaw}`),
        ov(overrides.regions, `${cName}|${stripped}`),
        rRaw,
        stripped,
      ].filter(Boolean);
      const rMap = regionsByCountry.get(out.country_id);
      for (const cand of candidates) {
        regionRow = rMap?.get(norm(cand)) ?? null;
        if (regionRow) break;
      }
      if (regionRow) out.region_id = regionRow.id; else miss("regions", `${cName} | ${rRaw}`, w);
    } else if (rRaw && !out.country_id) {
      miss("regions", `(Land unaufgelöst) | ${rRaw}`, w);
    }

    // Sub-Region: geseedet → FK; sonst Freitext → location (Dorf/Lage/Cru).
    // Tippfehler-Overrides greifen mit und ohne Region-Kontext.
    let sRaw = txt(w.sub_region);
    let subRow = null;
    if (sRaw) {
      const cName = countries.find((c) => c.id === out.country_id)?.name;
      const oSub =
        ov(overrides.sub_regions, `${cName}|${regionRow?.name}|${sRaw}`) ??
        ov(overrides.sub_regions, `${cName}|${sRaw}`);
      const cand = oSub ?? sRaw;
      subRow = out.region_id ? subsByRegion.get(out.region_id)?.get(norm(cand)) ?? null : null;
      if (subRow) out.sub_region_id = subRow.id;
      else out.location = cand; // nicht geseedet → verlustfrei ins Freitext-Feld
    }

    // Appellations-Feld-Routing: Ausbau-Notiz → terroir; Klassifizierungs-Token →
    // classification; verbleibender Ortsname → offizielle Appellation (FK) oder
    // sonst Freitext-location. Geo-Trigger füllt Vorfahren aus einem Appellations-Treffer.
    let aRaw = txt(w.appellation);
    if (aRaw) {
      if (isVinification(aRaw)) {
        out.terroir_extra = aRaw;
      } else {
        const { classification, place } = splitClassification(aRaw);
        if (classification) out.classification = classification;
        if (place) {
          const key = norm(ov(overrides.appellations, place) ?? place);
          const resolveApp = () => {
            if (subRow) { const h = appsBySub.get(subRow.id)?.get(key); if (h) return h; }
            if (out.region_id) {
              for (const sid of subIdsOfRegion.get(out.region_id) ?? []) {
                const h = appsBySub.get(sid)?.get(key); if (h) return h;
              }
              const h = appsByRegion.get(out.region_id)?.get(key); if (h) return h;
            }
            if (!out.region_id && out.country_id) {
              for (const r of regions.filter((r) => r.country_id === out.country_id)) {
                const h = appsByRegion.get(r.id)?.get(key); if (h) return h;
                for (const sid of subIdsOfRegion.get(r.id) ?? []) {
                  const h2 = appsBySub.get(sid)?.get(key); if (h2) return h2;
                }
              }
            }
            if (out.country_id) { const h = appsByCountry.get(out.country_id)?.get(key); if (h) return h; }
            return null;
          };
          const hit = resolveApp();
          if (hit) out.appellation_id = hit.id;
          else if (!out.location) out.location = place; // Ort nicht (noch) geseedet → Freitext
        }
      }
    }
    return out;
  };

  // 4. Weine transformieren
  const seen = new Map();
  report.counts.routing = { classification: 0, location: 0, non_vintage: 0, aging: 0, terroir_from_appellation: 0 };
  const winePayload = wines.map((w) => {
    // Duplikat-Schlüssel inkl. Flaschengröße (Magnum ≠ 0,75 l)
    const dupKey = `${norm(w.producer)}|${norm(w.description)}|${norm(w.vintage)}|${num(w.cl) ?? ""}`;
    if (seen.has(dupKey)) report.duplicates.push(dupKey);
    seen.set(dupKey, true);

    const colourId = colourByName.get(txt(w.colour)) ?? null;
    const cl = num(w.cl);
    const { terroir_extra, ...geo } = resolveGeo(w);
    const vintageFields = parseVintage(w.vintage);
    if (geo.classification) report.counts.routing.classification++;
    if (geo.location) report.counts.routing.location++;
    if (vintageFields.is_non_vintage) report.counts.routing.non_vintage++;
    if (vintageFields.aging_indication) report.counts.routing.aging++;
    if (terroir_extra) report.counts.routing.terroir_from_appellation++;

    return {
      id: w.id,
      cellar_id: cellarId,
      created_by: MAIN_USER_ID,
      producer: applyProducerFix(txt(w.producer)),
      name: txt(w.description),
      ...vintageFields,
      colour_id: colourId,
      variety: txt(w.variety),
      classification: geo.classification,
      size_ml: cl == null ? null : Math.round(cl * 10),
      alcohol_pct: num(w.alcohol_pct),
      residual_sugar_gl: num(w.residual_sugar_gl),
      ...parseDosage(w.dosage),
      country_id: geo.country_id,
      region_id: geo.region_id,
      sub_region_id: geo.sub_region_id,
      appellation_id: geo.appellation_id,
      location: geo.location,
      terroir_notes: [txt(w.ausbau_terroir), terroir_extra].filter(Boolean).join(" · ") || null,
      notes: txt(w.notes),
      occasion: OCCASION[txt(w.occasion)] ?? null,
      quantity: int(w.quantity) ?? 0,
      price_chf: num(w.price_chf),
      purchased_from: txt(w.purchased_from),
      ready_from: int(w.ready_from),
      drink_by: int(w.drink_by),
      rating: int(w.rating),
      label_photo_path: photoPath(w.label_photo_url),
      created_at: w.created_at,
    };
  });

  // 5. Schreiben (Batches, Upsert auf Original-IDs)
  for (let i = 0; i < winePayload.length; i += 100) {
    await restUpsert("wines", winePayload.slice(i, i + 100), "id");
  }
  report.counts.wines = winePayload.length;

  const peoplePayload = people.map((p) => ({
    id: p.id, cellar_id: cellarId, name: txt(p.name), avatar: txt(p.avatar), created_at: p.created_at,
  }));
  await restUpsert("people", peoplePayload, "id");
  report.counts.people = peoplePayload.length;

  const wineById = new Map(winePayload.map((w) => [w.id, w]));
  const logPayload = log.map((l) => {
    const w = wineById.get(l.wine_id);
    const label = w ? [w.producer, w.name].filter(Boolean).join(" — ") + (w.vintage ? ` ${w.vintage}` : "") : null;
    return {
      id: l.id, cellar_id: cellarId, wine_id: l.wine_id || null,
      wine_label: label, date: l.date, note: txt(l.note),
      rating: null, opened_by: MAIN_USER_ID, created_at: l.created_at,
    };
  });
  await restUpsert("drinking_log", logPayload, "id");
  report.counts.drinking_log = logPayload.length;

  const junction = [];
  for (const l of log) {
    let ids = [];
    try { ids = JSON.parse(l.people_ids || "[]"); } catch { /* report */ }
    for (const pid of ids) junction.push({ log_id: l.id, person_id: pid });
  }
  await restUpsert("drinking_log_people", junction, "log_id,person_id");
  report.counts.drinking_log_people = junction.length;

  // 6. Auswertung
  const resolved = (field) => winePayload.filter((w) => w[field] != null).length;
  const withText = (field) => wines.filter((w) => !blank(w[field])).length;
  report.counts.geo = {
    country: `${resolved("country_id")}/${withText("country")}`,
    region: `${resolved("region_id")}/${withText("region")}`,
    sub_region: `${resolved("sub_region_id")}/${withText("sub_region")}`,
    appellation: `${resolved("appellation_id")}/${withText("appellation")}`,
  };
  report.counts.colour_unresolved = winePayload.filter((w) => !w.colour_id).length;
  // Weinart-Feld-Routing: nach der Umstellung darf im vintage-Feld nur noch
  // eine Zahl oder null stehen — alles andere ist in eigene Felder gewandert.
  report.counts.vintage_int = winePayload.filter((w) => w.vintage != null).length;
  report.counts.dosage_level = winePayload.filter((w) => w.dosage_level).length;
  report.counts.dosage_gl = winePayload.filter((w) => w.dosage_gl != null).length;
  report.counts.geo.location_used = winePayload.filter((w) => w.location).length;
  report.finished_at = new Date().toISOString();
  writeFileSync(join(BACKUP, "migration-report.json"), JSON.stringify(report, null, 2));

  const r = report.counts.routing;
  console.log("\n── Ergebnis ──────────────────────────────────");
  console.log(`Weine: ${report.counts.wines} · People: ${report.counts.people} · Log: ${report.counts.drinking_log} (+${report.counts.drinking_log_people} Junction)`);
  console.log(`Geo — Land: ${report.counts.geo.country}, Region: ${report.counts.geo.region}, Sub(FK): ${report.counts.geo.sub_region}, Appellation(FK): ${report.counts.geo.appellation}, Location(Freitext): ${report.counts.geo.location_used}`);
  console.log(`Weinart-Felder — NV: ${r.non_vintage}, Reifeangabe: ${r.aging}, Klassifizierung: ${r.classification}, Ausbau→terroir: ${r.terroir_from_appellation}`);
  console.log(`Dosage — Stufe: ${report.counts.dosage_level}, g/L: ${report.counts.dosage_gl}`);
  console.log(`Duplikate (mit Größe): ${report.duplicates.length} · Farbe unaufgelöst: ${report.counts.colour_unresolved}`);
  console.log(`Report: backup/migration-report.json`);
}

main().catch((e) => { console.error("FEHLER:", e.message); process.exit(1); });
