import type { Appellation, Country, Region, SubRegion } from "./queries";

/**
 * Geteilter Namens-Resolver (Plan §6.2): Label-Scan und CSV-Import liefern
 * Geo-NAMEN — hier werden sie auf FK-IDs aufgelöst. Gleiche Logik wie im
 * Migrations-Script (scripts/migrate-v1-data.js): Normalisierung,
 * DE→EN-Länder-Alias, Kürzel-Präfix-Strip, Ebenen-Fallback für Appellationen.
 */

const norm = (s: string | null | undefined) =>
  (s ?? "")
    .toString()
    .trim()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/\s+/g, " ");

const COUNTRY_ALIAS: Record<string, string> = {
  frankreich: "France", italien: "Italy", spanien: "Spain",
  deutschland: "Germany", schweiz: "Switzerland", osterreich: "Austria",
  griechenland: "Greece", sudafrika: "South Africa", zypern: "Cyprus",
  polen: "Poland", danemark: "Denmark", ungarn: "Hungary",
  neuseeland: "New Zealand", usa: "United States",
  "vereinigte staaten": "United States", australien: "Australia",
  argentinien: "Argentina", england: "England & Wales",
};

const stripPrefix = (s: string) => s.replace(/^[A-Z]{2,4}\s*-\s*/, "");

export type GeoData = {
  countries: Country[];
  regions: Region[];
  subRegions: SubRegion[];
  appellations: Appellation[];
};

export type ResolvedGeo = {
  country_id: string | null;
  region_id: string | null;
  sub_region_id: string | null;
  appellation_id: string | null;
  unresolved: { field: "country" | "region" | "sub_region" | "appellation"; value: string }[];
};

export const resolveGeoNames = (
  names: {
    country?: string | null;
    region?: string | null;
    sub_region?: string | null;
    appellation?: string | null;
  },
  geo: GeoData
): ResolvedGeo => {
  const out: ResolvedGeo = {
    country_id: null, region_id: null, sub_region_id: null, appellation_id: null,
    unresolved: [],
  };

  const cRaw = names.country?.trim();
  if (cRaw) {
    const canonical = COUNTRY_ALIAS[norm(cRaw)] ?? cRaw;
    const hit =
      geo.countries.find((c) => norm(c.name) === norm(canonical)) ??
      geo.countries.find((c) => norm(c.name) === norm(stripPrefix(cRaw)));
    if (hit) out.country_id = hit.id;
    else out.unresolved.push({ field: "country", value: cRaw });
  }

  const rRaw = names.region?.trim();
  let region: Region | undefined;
  if (rRaw && out.country_id) {
    const candidates = [rRaw, stripPrefix(rRaw)];
    region = geo.regions.find(
      (r) => r.country_id === out.country_id && candidates.some((c) => norm(r.name) === norm(c))
    );
    if (region) out.region_id = region.id;
    else out.unresolved.push({ field: "region", value: rRaw });
  }

  const sRaw = names.sub_region?.trim();
  let sub: SubRegion | undefined;
  if (sRaw && out.region_id) {
    sub = geo.subRegions.find(
      (s) => s.region_id === out.region_id && norm(s.name) === norm(sRaw)
    );
    if (sub) out.sub_region_id = sub.id;
    else out.unresolved.push({ field: "sub_region", value: sRaw });
  }

  const aRaw = names.appellation?.trim();
  if (aRaw) {
    const key = norm(aRaw);
    const inSub = (subId: string) =>
      geo.appellations.find((a) => a.sub_region_id === subId && norm(a.name) === key);
    let hit: Appellation | undefined;
    if (sub) hit = inSub(sub.id);
    if (!hit && out.region_id) {
      for (const s of geo.subRegions.filter((s) => s.region_id === out.region_id)) {
        hit = inSub(s.id);
        if (hit) break;
      }
      hit ??= geo.appellations.find((a) => a.region_id === out.region_id && norm(a.name) === key);
    }
    if (!hit && out.country_id) {
      const regionIds = new Set(
        geo.regions.filter((r) => r.country_id === out.country_id).map((r) => r.id)
      );
      const subIds = new Set(
        geo.subRegions.filter((s) => regionIds.has(s.region_id)).map((s) => s.id)
      );
      hit = geo.appellations.find(
        (a) =>
          norm(a.name) === key &&
          (a.country_id === out.country_id ||
            (a.region_id != null && regionIds.has(a.region_id)) ||
            (a.sub_region_id != null && subIds.has(a.sub_region_id)))
      );
    }
    if (hit) out.appellation_id = hit.id;
    else out.unresolved.push({ field: "appellation", value: aRaw });
  }

  return out;
};
