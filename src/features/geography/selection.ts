import type { Appellation, Country, Region, SubRegion } from "./queries";

/**
 * Reine Auswahl-Logik der Geo-Kaskade (Land → Region → Sub-Region → Appellation).
 * EINE Funktion (`resolveSelection`) stellt nach jeder Feld-Änderung einen
 * vollständigen, widerspruchsfreien Zustand her — Vorfahren werden aufgefüllt,
 * unverträgliche Nachfahren gelöscht, verträgliche behalten.
 * Unit-Tests: selection.test.ts.
 */

export type GeoSelection = {
  country_id: string | null;
  region_id: string | null;
  sub_region_id: string | null;
  appellation_id: string | null;
};

export const emptyGeoSelection: GeoSelection = {
  country_id: null,
  region_id: null,
  sub_region_id: null,
  appellation_id: null,
};

/** Der Teil von useGeoLookups, den die Auswahl-Logik braucht (pur, testbar). */
export type GeoLookups = {
  countryById: Map<string, Country>;
  regionById: Map<string, Region>;
  subRegionById: Map<string, SubRegion>;
  appellationById: Map<string, Appellation>;
  appellations: Appellation[];
  subRegions: SubRegion[];
};

export type GeoField = "country" | "region" | "sub_region" | "appellation";

/** Vorfahren-Kette einer Appellation, abhängig von ihrem Anker-Level. */
const ancestorsOf = (geo: GeoLookups, a: Appellation) => {
  if (a.level === "sub_region" && a.sub_region_id) {
    const sub = geo.subRegionById.get(a.sub_region_id);
    const region = sub ? geo.regionById.get(sub.region_id) : undefined;
    return {
      country_id: region?.country_id ?? null,
      region_id: sub?.region_id ?? null,
      sub_region_id: a.sub_region_id,
    };
  }
  if (a.level === "region" && a.region_id) {
    const region = geo.regionById.get(a.region_id);
    return {
      country_id: region?.country_id ?? null,
      region_id: a.region_id,
      sub_region_id: null,
    };
  }
  return { country_id: a.country_id ?? null, region_id: null, sub_region_id: null };
};

/** Land, zu dem eine Sub-Region gehört. */
const countryOfSub = (geo: GeoLookups, subId: string) => {
  const sub = geo.subRegionById.get(subId);
  return sub ? geo.regionById.get(sub.region_id)?.country_id ?? null : null;
};

/**
 * Eine Appellation bleibt nur ausgewählt, wenn ihr ANKER in der neuen Auswahl
 * weiterhin gesetzt ist (country-level → gleiches Land, region-level → gleiche
 * Region, sub-level → gleiche Sub-Region). Alles andere wäre widersprüchlich.
 */
const keepAppellation = (geo: GeoLookups, appellationId: string | null, next: Omit<GeoSelection, "appellation_id">) => {
  if (!appellationId) return null;
  const a = geo.appellationById.get(appellationId);
  if (!a) return null;
  if (a.level === "country") return a.country_id === next.country_id ? appellationId : null;
  if (a.level === "region") return a.region_id === next.region_id ? appellationId : null;
  return a.sub_region_id === next.sub_region_id ? appellationId : null;
};

const isKnownId = (geo: GeoLookups, field: GeoField, id: string) => {
  if (field === "country") return geo.countryById.has(id);
  if (field === "region") return geo.regionById.has(id);
  if (field === "sub_region") return geo.subRegionById.has(id);
  return geo.appellationById.has(id);
};

/**
 * Wendet die Änderung EINES Feldes auf die aktuelle Auswahl an und liefert den
 * konsistenten Folgezustand. Bei No-ops (gleicher Wert, unbekannte ID) wird das
 * `current`-Objekt IDENTISCH zurückgegeben — der Aufrufer kann darauf prüfen.
 *
 * Unbekannte IDs sind kein Nutzer-Input: Radix' Select feuert ein internes
 * onValueChange(""), wenn ihm ein Wert gesetzt wird, zu dem (noch) kein Item
 * gerendert war — genau so verlor der Erstklick auf „Pays d'Oc" Region und
 * Appellation wieder. Solche Werte werden hier verworfen.
 */
export const resolveSelection = (
  geo: GeoLookups,
  current: GeoSelection,
  field: GeoField,
  id: string | null,
): GeoSelection => {
  if (id !== null && !isKnownId(geo, field, id)) return current;

  switch (field) {
    case "country": {
      if (id === current.country_id) return current;
      return {
        ...emptyGeoSelection,
        country_id: id,
        appellation_id: keepAppellation(geo, current.appellation_id, {
          country_id: id, region_id: null, sub_region_id: null,
        }),
      };
    }

    case "region": {
      if (id === current.region_id) return current;
      const next = {
        country_id: id ? geo.regionById.get(id)?.country_id ?? null : current.country_id,
        region_id: id,
        sub_region_id: null,
      };
      return { ...next, appellation_id: keepAppellation(geo, current.appellation_id, next) };
    }

    case "sub_region": {
      if (id === current.sub_region_id) return current;
      const next = {
        country_id: id ? countryOfSub(geo, id) : current.country_id,
        region_id: id ? geo.subRegionById.get(id)?.region_id ?? null : current.region_id,
        sub_region_id: id,
      };
      return { ...next, appellation_id: keepAppellation(geo, current.appellation_id, next) };
    }

    case "appellation": {
      if (id === current.appellation_id) return current;
      if (id === null) return { ...current, appellation_id: null };
      const a = geo.appellationById.get(id)!;
      const anchors = ancestorsOf(geo, a);
      // Tiefere, weiterhin verträgliche Wahl des Users erhalten (z. B. bleibt
      // die Sub-Region „Montagne de Reims" bei der region-weiten „Champagne").
      let region_id = anchors.region_id;
      let sub_region_id = anchors.sub_region_id;
      if (a.level === "country" && current.region_id) {
        const r = geo.regionById.get(current.region_id);
        if (r?.country_id === anchors.country_id) region_id = current.region_id;
      }
      if (sub_region_id === null && current.sub_region_id && region_id) {
        const s = geo.subRegionById.get(current.sub_region_id);
        if (s?.region_id === region_id) sub_region_id = current.sub_region_id;
      }
      return { country_id: anchors.country_id, region_id, sub_region_id, appellation_id: id };
    }
  }
};

/**
 * Appellationen, die zur aktuellen Auswahl passen (tiefste Ebene zuerst;
 * landesweite immer dabei). Mehrfach verankerte Appellationen (gleicher Name +
 * Typ an mehreren Eltern, z. B. „Mediterranee" unter Rhône UND Provence)
 * erscheinen pro Liste nur einmal.
 */
export const appellationOptions = (geo: GeoLookups, sel: GeoSelection): Appellation[] => {
  const countryLevel = (countryId: string | null) =>
    countryId
      ? geo.appellations.filter((a) => a.level === "country" && a.country_id === countryId)
      : [];

  let result: Appellation[];
  if (sel.sub_region_id) {
    const regionId = geo.subRegionById.get(sel.sub_region_id)?.region_id ?? sel.region_id;
    result = [
      ...geo.appellations.filter((a) => a.sub_region_id === sel.sub_region_id),
      ...(regionId ? geo.appellations.filter((a) => a.region_id === regionId) : []),
      ...countryLevel(regionId ? geo.regionById.get(regionId)?.country_id ?? null : sel.country_id),
    ];
  } else if (sel.region_id) {
    const subIds = new Set(geo.subRegions.filter((s) => s.region_id === sel.region_id).map((s) => s.id));
    result = [
      ...geo.appellations.filter(
        (a) => a.region_id === sel.region_id || (a.sub_region_id && subIds.has(a.sub_region_id)),
      ),
      ...countryLevel(geo.regionById.get(sel.region_id)?.country_id ?? sel.country_id),
    ];
  } else if (sel.country_id) {
    const regionIds = new Set(
      [...geo.regionById.values()].filter((r) => r.country_id === sel.country_id).map((r) => r.id),
    );
    const subIds = new Set(geo.subRegions.filter((s) => regionIds.has(s.region_id)).map((s) => s.id));
    result = geo.appellations.filter(
      (a) =>
        a.country_id === sel.country_id ||
        (a.region_id && regionIds.has(a.region_id)) ||
        (a.sub_region_id && subIds.has(a.sub_region_id)),
    );
  } else {
    result = geo.appellations;
  }

  const seen = new Set<string>();
  return result.filter((a) => {
    const key = `${a.name}|${a.type ?? ""}`;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
};
