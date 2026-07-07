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
    const out = { country_id: null, region_id: null, sub_region_id: null, appellation_id: null };

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

    // Sub-Region (nur mit aufgelöster Region)
    let sRaw = txt(w.sub_region);
    let subRow = null;
    if (sRaw && out.region_id) {
      const key = `${countries.find((c) => c.id === out.country_id)?.name}|${regionRow?.name}|${sRaw}`;
      const o = ov(overrides.sub_regions, key);
      subRow = subsByRegion.get(out.region_id)?.get(norm(o ?? sRaw)) ?? null;
      if (subRow) out.sub_region_id = subRow.id;
      else miss("sub_regions", `${regionRow?.name} | ${sRaw}`, w);
    }

    // Appellation: erst Sub-Ebene, dann alle Subs der Region, dann Region-,
    // dann Land-Ebene. Ist die Region unaufgelöst, landesweit suchen — der
    // Geo-Trigger in der DB füllt Region/Land aus dem Treffer automatisch auf.
    let aRaw = txt(w.appellation);
    if (aRaw) {
      const key = norm(ov(overrides.appellations, aRaw) ?? aRaw);
      let hit = null;
      if (subRow) hit = appsBySub.get(subRow.id)?.get(key) ?? null;
      if (!hit && out.region_id)
        for (const sid of subIdsOfRegion.get(out.region_id) ?? []) {
          hit = appsBySub.get(sid)?.get(key) ?? null;
          if (hit) break;
        }
      if (!hit && out.region_id) hit = appsByRegion.get(out.region_id)?.get(key) ?? null;
      if (!hit && !out.region_id && out.country_id) {
        const countryRegions = regions.filter((r) => r.country_id === out.country_id);
        for (const r of countryRegions) {
          hit = appsByRegion.get(r.id)?.get(key) ?? null;
          if (!hit)
            for (const sid of subIdsOfRegion.get(r.id) ?? []) {
              hit = appsBySub.get(sid)?.get(key) ?? null;
              if (hit) break;
            }
          if (hit) break;
        }
      }
      if (!hit && out.country_id) hit = appsByCountry.get(out.country_id)?.get(key) ?? null;
      if (hit) out.appellation_id = hit.id;
      else miss("appellations", `${txt(w.region) ?? "?"} | ${aRaw}`, w);
    }
    return out;
  };

  // 4. Weine transformieren
  const seen = new Map();
  const winePayload = wines.map((w) => {
    const dupKey = `${norm(w.producer)}|${norm(w.description)}|${norm(w.vintage)}`;
    if (seen.has(dupKey)) report.duplicates.push(dupKey);
    seen.set(dupKey, true);

    const v = txt(w.vintage);
    if (v && !/^\d{4}$/.test(v)) report.odd_vintages.push(`${w.producer}: "${v}"`);

    const colourId = colourByName.get(txt(w.colour)) ?? null;
    const cl = num(w.cl);

    return {
      id: w.id,
      cellar_id: cellarId,
      created_by: MAIN_USER_ID,
      producer: txt(w.producer),
      name: txt(w.description),
      vintage: v,
      colour_id: colourId,
      variety: txt(w.variety),
      size_ml: cl == null ? null : Math.round(cl * 10),
      alcohol_pct: num(w.alcohol_pct),
      residual_sugar_gl: num(w.residual_sugar_gl),
      dosage: txt(w.dosage),
      ...resolveGeo(w),
      terroir_notes: txt(w.ausbau_terroir),
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
  report.finished_at = new Date().toISOString();
  writeFileSync(join(BACKUP, "migration-report.json"), JSON.stringify(report, null, 2));

  console.log("\n── Ergebnis ──────────────────────────────────");
  console.log(`Weine: ${report.counts.wines} · People: ${report.counts.people} · Log: ${report.counts.drinking_log} (+${report.counts.drinking_log_people} Junction)`);
  console.log(`Geo aufgelöst — Land: ${report.counts.geo.country}, Region: ${report.counts.geo.region}, Sub: ${report.counts.geo.sub_region}, Appellation: ${report.counts.geo.appellation}`);
  console.log(`Farbe unaufgelöst: ${report.counts.colour_unresolved}`);
  const nMiss = (b) => Object.keys(report.unresolved[b]).length;
  console.log(`Unaufgelöste distinct Namen — Land: ${nMiss("countries")}, Region: ${nMiss("regions")}, Sub: ${nMiss("sub_regions")}, App: ${nMiss("appellations")}`);
  console.log(`Report: backup/migration-report.json`);
}

main().catch((e) => { console.error("FEHLER:", e.message); process.exit(1); });
