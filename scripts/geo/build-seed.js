#!/usr/bin/env node
/**
 * Geografie-Seed-Generator (docs/REBUILD_PLAN.md §5.2)
 *
 * Liest data/geography/*.json (eine Datei pro Land), validiert die Struktur
 * und erzeugt:
 *   - supabase/seed.sql          idempotente Upserts (läuft bei `supabase db reset`
 *                                automatisch; kann auch beliebig oft manuell im
 *                                SQL-Editor ausgeführt werden)
 *   - data/geography/COVERAGE.md Abdeckungs-Übersicht pro Land
 *
 * Aufruf: npm run geo:build
 */

import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { z } from "zod";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const DATA = join(ROOT, "data", "geography");

const appellationSchema = z.object({
  name: z.string().min(1),
  type: z.string().min(1).nullable().optional(),
});

const countrySchema = z.object({
  country: z.string().min(1),
  code: z.string().length(2).nullable().optional(),
  continent: z.string().min(1).nullable().optional(),
  verified: z.boolean().optional(), // true erst nach Abgleich mit offiziellem Register
  sources: z.array(z.string()).optional(),
  appellations: z.array(appellationSchema).optional(), // country-level
  regions: z.array(
    z.object({
      name: z.string().min(1),
      appellations: z.array(appellationSchema).optional(), // region-level
      subRegions: z.array(
        z.object({
          name: z.string().min(1),
          appellations: z.array(appellationSchema).optional(),
        })
      ).optional(),
    })
  ),
});

const q = (s) => `'${String(s).replace(/'/g, "''")}'`;
const qn = (s) => (s == null ? "null" : q(s));

const files = readdirSync(DATA).filter((f) => f.endsWith(".json")).sort();
const countries = [];
const problems = [];

for (const file of files) {
  const raw = JSON.parse(readFileSync(join(DATA, file), "utf8"));
  const parsed = countrySchema.safeParse(raw);
  if (!parsed.success) {
    problems.push(`${file}: ${parsed.error.issues.map((i) => `${i.path.join(".")} — ${i.message}`).join("; ")}`);
    continue;
  }
  countries.push({ file, ...parsed.data });
}

// ── Daten-Invarianten (aus dem Geo-Voll-Audit 2026-07; Verstoß = Build-Abbruch)
// Regionsübergreifende Appellationen, die bewusst an MEHREREN Regionen hängen
// (der Picker dedupliziert die Anzeige):
const MULTI_ANCHOR = new Set(["Mediterranee", "Delle Venezie", "Beiras", "Vully"]);
const TYPE_PREFIX = /^(AOC|AOP|IGP|IGT|PGI|PDO|DOCG|DOCa|DOC|DO|AVA|DAC|GI|VR|VdlT|Vino de la Tierra|Vinho Regional|Vin de Pays)\s/;

for (const c of countries) {
  const allNames = [];
  const perParent = new Map();
  const walk = (apps, parentKey) => {
    for (const a of apps ?? []) {
      allNames.push(a.name);
      const key = `${parentKey}|${a.name}`;
      if (perParent.has(key)) problems.push(`${c.file}: '${a.name}' doppelt am selben Anker (${parentKey})`);
      perParent.set(key, true);
      if (TYPE_PREFIX.test(a.name)) problems.push(`${c.file}: Typ-Kürzel im Namen: '${a.name}' (gehört ins type-Feld)`);
      if (a.name.includes("’")) problems.push(`${c.file}: typografischer Apostroph in '${a.name}' (gerades ' verwenden)`);
    }
  };
  walk(c.appellations, "country");
  for (const r of c.regions ?? []) {
    walk(r.appellations, `region:${r.name}`);
    if (r.name.includes("’")) problems.push(`${c.file}: typografischer Apostroph in Region '${r.name}'`);
    for (const s of r.subRegions ?? []) {
      if (s.name === r.name) problems.push(`${c.file}: Sub-Region '${s.name}' heißt wie ihre Region (auflösen: Apps auf Regionsebene)`);
      if (s.name.includes("’")) problems.push(`${c.file}: typografischer Apostroph in Sub-Region '${s.name}'`);
      walk(s.appellations, `sub:${r.name}/${s.name}`);
    }
  }
  const seen = new Map();
  for (const n of allNames) seen.set(n, (seen.get(n) ?? 0) + 1);
  for (const [n, count] of seen) {
    if (count > 1 && !MULTI_ANCHOR.has(n)) {
      problems.push(`${c.file}: '${n}' ${count}x im Land — Duplikat oder in MULTI_ANCHOR aufnehmen`);
    }
  }
}

if (problems.length) {
  console.error("Validierung fehlgeschlagen:\n" + problems.map((p) => `  ✗ ${p}`).join("\n"));
  process.exit(1);
}

// ── SQL erzeugen ─────────────────────────────────────────────────────────────
const lines = [
  "-- ═══════════════════════════════════════════════════════════════════════",
  "-- GENERIERT von scripts/geo/build-seed.js — NICHT von Hand editieren!",
  "-- Quelle: data/geography/*.json  ·  Neu erzeugen: npm run geo:build",
  `-- Stand: ${new Date().toISOString().slice(0, 10)} · ${countries.length} Länder`,
  "-- Idempotent: kann beliebig oft ausgeführt werden.",
  "-- ═══════════════════════════════════════════════════════════════════════",
  "",
  "begin;",
  "",
];

const appellationInsert = (level, parentSql, name, type, ord) => {
  const { fromWhere, fkCol, fkVal } = parentSql;
  return [
    `insert into public.appellations (level, ${fkCol}, name, type, sort_order)`,
    `select ${q(level)}, ${fkVal}, ${q(name)}, ${qn(type)}, ${ord}`,
    fromWhere,
    `  and not exists (select 1 from public.appellations a`,
    `    where a.name = ${q(name)} and a.level = ${q(level)} and a.${fkCol} = ${fkVal});`,
  ].join("\n");
};

countries.forEach((c, ci) => {
  lines.push(`-- ── ${c.country} ${"─".repeat(Math.max(4, 66 - c.country.length))}`);
  lines.push(
    `insert into public.countries (name, code, continent, sort_order)`,
    `values (${q(c.country)}, ${qn(c.code)}, ${qn(c.continent)}, ${ci})`,
    `on conflict (name) do update set code = excluded.code, continent = excluded.continent, sort_order = excluded.sort_order;`,
    ""
  );

  (c.appellations ?? []).forEach((a, ai) => {
    lines.push(
      appellationInsert("country", {
        fromWhere: `from public.countries c where c.name = ${q(c.country)}`,
        fkCol: "country_id",
        fkVal: "c.id",
      }, a.name, a.type ?? null, ai),
      ""
    );
  });

  (c.regions ?? []).forEach((r, ri) => {
    lines.push(
      `insert into public.regions (country_id, name, sort_order)`,
      `select c.id, ${q(r.name)}, ${ri} from public.countries c where c.name = ${q(c.country)}`,
      `on conflict (country_id, name) do update set sort_order = excluded.sort_order;`,
      ""
    );

    (r.appellations ?? []).forEach((a, ai) => {
      lines.push(
        appellationInsert("region", {
          fromWhere: [
            `from public.regions r`,
            `  join public.countries c on c.id = r.country_id`,
            `  where c.name = ${q(c.country)} and r.name = ${q(r.name)}`,
          ].join("\n"),
          fkCol: "region_id",
          fkVal: "r.id",
        }, a.name, a.type ?? null, ai),
        ""
      );
    });

    (r.subRegions ?? []).forEach((s, si) => {
      lines.push(
        `insert into public.sub_regions (region_id, name, sort_order)`,
        `select r.id, ${q(s.name)}, ${si}`,
        `from public.regions r join public.countries c on c.id = r.country_id`,
        `where c.name = ${q(c.country)} and r.name = ${q(r.name)}`,
        `on conflict (region_id, name) do update set sort_order = excluded.sort_order;`,
        ""
      );

      (s.appellations ?? []).forEach((a, ai) => {
        lines.push(
          appellationInsert("sub_region", {
            fromWhere: [
              `from public.sub_regions s`,
              `  join public.regions r on r.id = s.region_id`,
              `  join public.countries c on c.id = r.country_id`,
              `  where c.name = ${q(c.country)} and r.name = ${q(r.name)} and s.name = ${q(s.name)}`,
            ].join("\n"),
            fkCol: "sub_region_id",
            fkVal: "s.id",
          }, a.name, a.type ?? null, ai),
          ""
        );
      });
    });
  });
});

lines.push("commit;", "");
writeFileSync(join(ROOT, "supabase", "seed.sql"), lines.join("\n"));

// ── COVERAGE.md erzeugen ─────────────────────────────────────────────────────
const count = (c) => {
  const regions = c.regions ?? [];
  const subs = regions.flatMap((r) => r.subRegions ?? []);
  const apps =
    (c.appellations?.length ?? 0) +
    regions.reduce((n, r) => n + (r.appellations?.length ?? 0), 0) +
    subs.reduce((n, s) => n + (s.appellations?.length ?? 0), 0);
  return { regions: regions.length, subs: subs.length, apps };
};

const totals = { regions: 0, subs: 0, apps: 0 };
const rows = countries.map((c) => {
  const n = count(c);
  totals.regions += n.regions;
  totals.subs += n.subs;
  totals.apps += n.apps;
  const status = c.verified
    ? `✅ verifiziert (${(c.sources ?? []).join(", ") || "Quelle fehlt!"})`
    : "⚠️ unverifiziert (v1-Übernahme / Modellwissen)";
  return `| ${c.country} | ${n.regions} | ${n.subs} | ${n.apps} | ${status} |`;
});

writeFileSync(
  join(DATA, "COVERAGE.md"),
  [
    "# Geografie-Abdeckung",
    "",
    "> GENERIERT von `npm run geo:build` — nicht von Hand editieren.",
    "> Status wird pro Land im JSON gepflegt (`verified: true` + `sources: [...]`),",
    "> erst NACH Abgleich mit dem offiziellen Register (INAO, federdoc, TTB, …).",
    "> Ziel laut Plan §5.3: ~1'400–1'500 Appellationen; Tier-1-Sollwerte:",
    "> Frankreich ~360 · Italien ~280 (77 DOCG + Top-DOC) · Spanien ~80 ·",
    "> Deutschland (13 Anbaugebiete, Bereiche, VDP) · Schweiz ~65 · Portugal ~35.",
    "",
    `Stand: ${new Date().toISOString().slice(0, 10)} · **${countries.length} Länder · ${totals.apps} Appellationen**`,
    "",
    "| Land | Regionen | Sub-Regionen | Appellationen | Status |",
    "|---|---|---|---|---|",
    ...rows,
    "",
    `| **Gesamt** | **${totals.regions}** | **${totals.subs}** | **${totals.apps}** | |`,
    "",
  ].join("\n")
);

console.log(`✓ supabase/seed.sql geschrieben (${countries.length} Länder, ${totals.apps} Appellationen)`);
console.log(`✓ data/geography/COVERAGE.md aktualisiert`);
