import { describe, it, expect } from "vitest";
import type { Appellation, Country, Region, SubRegion } from "./queries";
import {
  type GeoLookups, appellationOptions, emptyGeoSelection, resolveSelection,
} from "./selection";

// ── Mini-Welt als Fixture (nur die Felder, die die Logik benutzt) ────────────
const country = (id: string, name: string) => ({ id, name }) as Country;
const region = (id: string, name: string, country_id: string) =>
  ({ id, name, country_id }) as Region;
const sub = (id: string, name: string, region_id: string) =>
  ({ id, name, region_id }) as SubRegion;
const app = (
  id: string, name: string,
  anchor: { country_id?: string; region_id?: string; sub_region_id?: string },
  type: string | null = "AOC",
) =>
  ({
    id, name, type,
    level: anchor.sub_region_id ? "sub_region" : anchor.region_id ? "region" : "country",
    country_id: anchor.country_id ?? null,
    region_id: anchor.region_id ?? null,
    sub_region_id: anchor.sub_region_id ?? null,
  }) as Appellation;

const fr = country("fr", "France");
const italy = country("it", "Italy");
const bordeaux = region("bordeaux", "Bordeaux", "fr");
const languedoc = region("languedoc", "Languedoc-Roussillon", "fr");
const champagne = region("champagne", "Champagne", "fr");
const rhone = region("rhone", "Vallee du Rhone", "fr");
const provence = region("provence", "Provence", "fr");
const piemonte = region("piemonte", "Piemonte", "it");

const medoc = sub("s-medoc", "Medoc", "bordeaux");
const pomerol = sub("s-pomerol", "Pomerol", "bordeaux");
const mdr = sub("s-mdr", "Montagne de Reims", "champagne");
const cdb = sub("s-cdb", "Cote des Blancs", "champagne");

const aMedoc = app("a-medoc", "Medoc", { sub_region_id: "s-medoc" });
const aPomerol = app("a-pomerol", "Pomerol", { sub_region_id: "s-pomerol" });
const aBordeaux = app("a-bordeaux", "Bordeaux", { region_id: "bordeaux" });
const aPaysDoc = app("a-paysdoc", "Pays d'Oc", { region_id: "languedoc" }, "IGP");
const aChampagne = app("a-champagne", "Champagne", { region_id: "champagne" });
const aVdF = app("a-vdf", "Vin de France", { country_id: "fr" }, null);
const aMedRhone = app("a-med-rhone", "Mediterranee", { region_id: "rhone" }, "IGP");
const aMedProvence = app("a-med-prov", "Mediterranee", { region_id: "provence" }, "IGP");
const aBarolo = app("a-barolo", "Barolo", { region_id: "piemonte" }, "DOCG");

const world = (): GeoLookups => {
  const regions = [bordeaux, languedoc, champagne, rhone, provence, piemonte];
  const subRegions = [medoc, pomerol, mdr, cdb];
  const appellations = [
    aMedoc, aPomerol, aBordeaux, aPaysDoc, aChampagne, aVdF, aMedRhone, aMedProvence, aBarolo,
  ];
  return {
    countryById: new Map([fr, italy].map((c) => [c.id, c])),
    regionById: new Map(regions.map((r) => [r.id, r])),
    subRegionById: new Map(subRegions.map((s) => [s.id, s])),
    appellationById: new Map(appellations.map((a) => [a.id, a])),
    appellations,
    subRegions,
  };
};
const geo = world();
const sel = (
  country_id: string | null, region_id: string | null,
  sub_region_id: string | null, appellation_id: string | null,
) => ({ country_id, region_id, sub_region_id, appellation_id });

// ── resolveSelection ─────────────────────────────────────────────────────────
describe("resolveSelection: Appellations-Wahl füllt den ganzen Pfad", () => {
  it("region-level Appellation aus leerem Zustand (Pays d'Oc, User-Bug 1)", () => {
    expect(resolveSelection(geo, emptyGeoSelection, "appellation", "a-paysdoc"))
      .toEqual(sel("fr", "languedoc", null, "a-paysdoc"));
  });

  it("sub-level Appellation bindet ihre Sub-Region (Medoc, User-Bug 2)", () => {
    expect(resolveSelection(geo, emptyGeoSelection, "appellation", "a-medoc"))
      .toEqual(sel("fr", "bordeaux", "s-medoc", "a-medoc"));
  });

  it("region-level Appellation behält eine passende Sub-Region-Wahl", () => {
    expect(resolveSelection(geo, sel("fr", "champagne", "s-mdr", null), "appellation", "a-champagne"))
      .toEqual(sel("fr", "champagne", "s-mdr", "a-champagne"));
  });

  it("region-level Appellation verwirft eine fremde Sub-Region", () => {
    expect(resolveSelection(geo, sel("fr", "bordeaux", "s-medoc", null), "appellation", "a-paysdoc"))
      .toEqual(sel("fr", "languedoc", null, "a-paysdoc"));
  });

  it("country-level Appellation behält passende Region + Sub-Region", () => {
    expect(resolveSelection(geo, sel("fr", "champagne", "s-cdb", null), "appellation", "a-vdf"))
      .toEqual(sel("fr", "champagne", "s-cdb", "a-vdf"));
  });

  it("X-Löschen der Appellation lässt den Rest stehen", () => {
    expect(resolveSelection(geo, sel("fr", "bordeaux", "s-medoc", "a-medoc"), "appellation", null))
      .toEqual(sel("fr", "bordeaux", "s-medoc", null));
  });
});

describe("resolveSelection: keine widersprüchlichen Zustände (User-Bug 2)", () => {
  it("Sub-Region-Wechsel verwirft eine dort nicht gültige Appellation", () => {
    expect(resolveSelection(geo, sel("fr", "bordeaux", "s-medoc", "a-medoc"), "sub_region", "s-pomerol"))
      .toEqual(sel("fr", "bordeaux", "s-pomerol", null));
  });

  it("Sub-Region-Wechsel behält eine region-weite Appellation", () => {
    expect(resolveSelection(geo, sel("fr", "champagne", "s-mdr", "a-champagne"), "sub_region", "s-cdb"))
      .toEqual(sel("fr", "champagne", "s-cdb", "a-champagne"));
  });

  it("Sub-Region setzen füllt Region + Land auf", () => {
    expect(resolveSelection(geo, emptyGeoSelection, "sub_region", "s-medoc"))
      .toEqual(sel("fr", "bordeaux", "s-medoc", null));
  });

  it("Region-Wechsel löscht Sub-Region und fremde Appellation", () => {
    expect(resolveSelection(geo, sel("fr", "bordeaux", "s-medoc", "a-medoc"), "region", "languedoc"))
      .toEqual(sel("fr", "languedoc", null, null));
  });

  it("Region setzen füllt das Land auf", () => {
    expect(resolveSelection(geo, emptyGeoSelection, "region", "piemonte"))
      .toEqual(sel("it", "piemonte", null, null));
  });

  it("Land-Wechsel setzt alles darunter zurück", () => {
    expect(resolveSelection(geo, sel("fr", "bordeaux", "s-medoc", "a-medoc"), "country", "it"))
      .toEqual(sel("it", null, null, null));
  });
});

describe("resolveSelection: ungültige Werte sind kein User-Input (Radix-Reset)", () => {
  const current = sel("fr", "languedoc", null, "a-paysdoc");

  it('ignoriert onValueChange("") — Objekt-Identität bleibt', () => {
    expect(resolveSelection(geo, current, "region", "")).toBe(current);
  });

  it("ignoriert unbekannte IDs", () => {
    expect(resolveSelection(geo, current, "appellation", "nope")).toBe(current);
  });

  it("No-op bei unverändertem Wert — Objekt-Identität bleibt", () => {
    expect(resolveSelection(geo, current, "region", "languedoc")).toBe(current);
    expect(resolveSelection(geo, current, "appellation", "a-paysdoc")).toBe(current);
  });
});

// ── appellationOptions ───────────────────────────────────────────────────────
describe("appellationOptions", () => {
  it("Sub-Region-View: eigene + Region- + Land-Ebene, keine Nachbar-Subs", () => {
    const names = appellationOptions(geo, sel("fr", "bordeaux", "s-medoc", null)).map((a) => a.id);
    expect(names).toContain("a-medoc");
    expect(names).toContain("a-bordeaux");
    expect(names).toContain("a-vdf");
    expect(names).not.toContain("a-pomerol");
    expect(names).not.toContain("a-barolo");
  });

  it("Länder-View dedupliziert mehrfach verankerte Appellationen", () => {
    const meds = appellationOptions(geo, sel("fr", null, null, null))
      .filter((a) => a.name === "Mediterranee");
    expect(meds).toHaveLength(1);
  });

  it("Region-View zeigt den eigenen Anker der mehrfach verankerten Appellation", () => {
    const provenceView = appellationOptions(geo, sel("fr", "provence", null, null));
    expect(provenceView.map((a) => a.id)).toContain("a-med-prov");
    expect(provenceView.map((a) => a.id)).not.toContain("a-med-rhone");
  });

  it("ohne Auswahl: alle, aber ohne Doppel-Zeilen", () => {
    const all = appellationOptions(geo, emptyGeoSelection);
    expect(all.filter((a) => a.name === "Mediterranee")).toHaveLength(1);
    expect(all.map((a) => a.id)).toContain("a-barolo");
  });
});
