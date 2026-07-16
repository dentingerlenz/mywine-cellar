import { z } from "zod";
import type { Tables } from "@/integrations/supabase/types";

// Domänenmodell v2 — basiert direkt auf den generierten DB-Typen.
export type Wine = Tables<"wines">;

export type Occasion = "anytime" | "special" | "lay_down" | "top";
export const OCCASIONS: readonly Occasion[] = ["anytime", "special", "lay_down", "top"] as const;

export const OCCASION_LABEL: Record<Occasion, string> = {
  anytime: "Anytime",
  special: "Special occasion",
  lay_down: "Lay down",
  top: "Top bottle",
};

export const OCCASION_CLASS: Record<Occasion, string> = {
  anytime: "bg-secondary text-foreground border-primary/30",
  special: "bg-primary/20 text-primary border-primary/50",
  lay_down: "bg-secondary text-foreground border-primary/30",
  top: "bg-primary text-primary-foreground border-primary",
};

export const SIZE_ML_OPTIONS = [375, 500, 750, 1000, 1500, 3000, 6000] as const;

const optionalNum = (schema: z.ZodType<number>) =>
  z.preprocess(
    (v) =>
      v === "" || v === null || v === undefined || (typeof v === "number" && Number.isNaN(v))
        ? null
        : v,
    schema.nullable()
  );

const optionalUuid = z.preprocess(
  (v) => (v === "" || v === undefined ? null : v),
  z.string().uuid().nullable()
);

// Dosage-Stufen (Schaumwein), von trocken nach süß.
export const DOSAGE_LEVELS = [
  "Brut Nature", "Extra Brut", "Brut", "Extra Dry", "Sec", "Demi-Sec", "Doux",
] as const;

// Kuratierte Klassifikations-Stufen für das Freitext-Feld „Classification".
// Immer wählbar (auch ohne Bestandswein), ergänzt um die real vergebenen Werte.
// Bewusst die Qualitäts-/Klassifikationsebene — NICHT die Geografie. Für Deutschland
// die VDP-Stufen: die konkrete Einzellage bleibt Freitext (Name/Location), aber der
// VDP-Rang ist hier wählbar. Dazu die gängigen internationalen Klassifikationen.
export const CLASSIFICATION_SUGGESTIONS: readonly string[] = [
  // Deutschland — VDP-Klassifikationspyramide (+ Grosses Gewächs)
  "VDP.Grosse Lage", "VDP.Erste Lage", "VDP.Ortswein", "VDP.Gutswein",
  "VDP.Prädikatswein", "Grosses Gewächs",
  // Frankreich
  "Grand Cru", "Premier Cru", "AOC", "AOP", "IGP",
  // Italien
  "DOCG", "DOC", "IGT",
  // Spanien / Portugal
  "DOCa", "DO", "DOP", "IG",
  // Österreich
  "DAC",
] as const;

// Freitext-Jahrgang → strukturierte Felder (geteilt von Import & Scan).
export const parseVintageInput = (raw: string | number | null | undefined) => {
  const v = String(raw ?? "").trim();
  const empty = { vintage: null as number | null, is_non_vintage: false, base_vintage: null as number | null, aging_indication: "" };
  if (!v) return empty;
  if (/^\d{4}$/.test(v)) return { ...empty, vintage: Number(v) };
  if (/^NV/i.test(v)) {
    const base = v.match(/(\d{4})/);
    return { ...empty, is_non_vintage: true, base_vintage: base ? Number(base[1]) : null };
  }
  // Solera / Reife-/Alters-Angabe
  return { ...empty, is_non_vintage: true, aging_indication: v };
};

const DOSAGE_LEVEL_ALIASES: Record<string, string> = {
  "brut nature": "Brut Nature", "non dosé": "Brut Nature", "zero dosage": "Brut Nature", "pas dosé": "Brut Nature",
  "extra brut": "Extra Brut", "brut": "Brut", "extra dry": "Extra Dry", "extra sec": "Extra Dry",
  "sec": "Sec", "demi-sec": "Demi-Sec", "doux": "Doux",
};
export const parseDosageInput = (raw: string | number | null | undefined) => {
  const v = String(raw ?? "").trim();
  if (!v) return { dosage_level: "", dosage_gl: null as number | null };
  const n = Number(v.replace(",", "."));
  if (Number.isFinite(n)) return { dosage_level: "", dosage_gl: n };
  return { dosage_level: DOSAGE_LEVEL_ALIASES[v.toLowerCase()] ?? v, dosage_gl: null };
};

export const wineSchema = z.object({
  producer: z.string().trim().min(1, "Producer is required").max(200),
  name: z.string().trim().max(300).optional().or(z.literal("")),
  // Jahrgang als Jahreszahl (Stillweine / echte Jahrgangsweine).
  vintage: optionalNum(z.coerce.number().int().min(1800).max(2100)),
  is_non_vintage: z.coerce.boolean().default(false),
  base_vintage: optionalNum(z.coerce.number().int().min(1800).max(2100)),
  aging_indication: z.string().trim().max(120).optional().or(z.literal("")),
  colour_id: z.string().uuid({ message: "Colour is required" }),
  variety: z.string().trim().max(200).optional().or(z.literal("")),
  classification: z.string().trim().max(120).optional().or(z.literal("")),
  size_ml: optionalNum(z.coerce.number().int().min(10).max(99999)),
  alcohol_pct: optionalNum(z.coerce.number().min(0).max(99)),
  residual_sugar_gl: optionalNum(z.coerce.number().min(0).max(999)),
  dosage_level: z.string().trim().max(40).optional().or(z.literal("")),
  dosage_gl: optionalNum(z.coerce.number().min(0).max(999)),
  // Schaumwein: Monat/Jahr im Formularformat "YYYY-MM" (leer = keine Angabe).
  tirage_date: z.string().regex(/^\d{4}-\d{2}$/, "Use month/year").optional().or(z.literal("")),
  disgorgement_date: z.string().regex(/^\d{4}-\d{2}$/, "Use month/year").optional().or(z.literal("")),
  country_id: optionalUuid,
  region_id: optionalUuid,
  sub_region_id: optionalUuid,
  appellation_id: optionalUuid,
  location: z.string().trim().max(160).optional().or(z.literal("")),
  terroir_notes: z.string().max(2000).optional().or(z.literal("")),
  notes: z.string().max(2000).optional().or(z.literal("")),
  occasion: z.enum(["anytime", "special", "lay_down", "top"]).nullable().optional(),
  quantity: z.coerce.number().int().min(0).max(9999).default(1),
  price_chf: optionalNum(z.coerce.number().min(0).max(999999)),
  purchased_from: z.string().trim().max(200).optional().or(z.literal("")),
  storage_location: z.string().trim().max(120).optional().or(z.literal("")),
  ready_from: optionalNum(z.coerce.number().int().min(1800).max(2200)),
  drink_by: optionalNum(z.coerce.number().int().min(1800).max(2200)),
  rating: optionalNum(z.coerce.number().int().min(1).max(5)),
});

export type WineInput = z.infer<typeof wineSchema>;

export type DrinkStatus = "drink_now" | "too_young" | "past_peak" | "unknown";

export const getDrinkStatus = (w: Pick<Wine, "ready_from" | "drink_by">): DrinkStatus => {
  const year = new Date().getFullYear();
  if (w.ready_from == null && w.drink_by == null) return "unknown";
  if (w.ready_from != null && year < w.ready_from) return "too_young";
  if (w.drink_by != null && year > w.drink_by) return "past_peak";
  return "drink_now";
};

export const DRINK_LABEL: Record<DrinkStatus, string> = {
  drink_now: "Drink now",
  too_young: "Too young",
  past_peak: "Past peak",
  unknown: "—",
};

export const wineTitle = (w: Pick<Wine, "producer" | "name">) =>
  [w.producer, w.name].filter(Boolean).join(" — ") || "Untitled bottle";

// occasion kommt aus der DB als string|null — Helpers kapseln das Narrowing.
export const occasionLabel = (o: string | null | undefined): string | null =>
  o && o in OCCASION_LABEL ? OCCASION_LABEL[o as Occasion] : null;

export const occasionClass = (o: string | null | undefined): string =>
  o && o in OCCASION_CLASS ? OCCASION_CLASS[o as Occasion] : "";

export const formatSize = (size_ml: number | null | undefined): string | null =>
  size_ml == null ? null : `${size_ml % 10 === 0 ? size_ml / 10 : (size_ml / 10).toFixed(1)} cl`;

/** Anzeige des Jahrgangs je nach Weinart: Jahr | „NV" (+ Basisjahr) | Reifeangabe. */
export const vintageDisplay = (
  w: Pick<Wine, "vintage" | "is_non_vintage" | "base_vintage" | "aging_indication">
): string | null => {
  if (w.vintage != null) return String(w.vintage);
  if (w.aging_indication) return w.aging_indication;
  if (w.is_non_vintage) return w.base_vintage ? `NV · ${w.base_vintage}` : "NV";
  return null;
};

/** Dosage kompakt: Stufe (+ g/L) oder nur g/L. */
export const dosageDisplay = (
  w: Pick<Wine, "dosage_level" | "dosage_gl">
): string | null => {
  const parts = [w.dosage_level, w.dosage_gl != null ? `${w.dosage_gl} g/L` : null].filter(Boolean);
  return parts.length ? parts.join(" · ") : null;
};

// Monat/Jahr-Konvertierung zwischen DB-Datum (YYYY-MM-01) und Formular (YYYY-MM).
const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
export const monthYearToDate = (s: string | null | undefined) =>
  s && /^\d{4}-\d{2}$/.test(s) ? `${s}-01` : null;
export const dateToMonthYear = (d: string | null | undefined) =>
  d && d.length >= 7 ? d.slice(0, 7) : "";
export const formatMonthYear = (d: string | null | undefined): string | null => {
  if (!d || d.length < 7) return null;
  const [y, m] = d.split("-");
  return `${MONTHS[Number(m) - 1] ?? m} ${y}`;
};
/** Monate auf der Hefe zwischen Tirage und Dégorgement (beide YYYY-MM[-DD]). */
export const monthsOnLees = (
  tirage: string | null | undefined,
  disgorgement: string | null | undefined
): number | null => {
  if (!tirage || !disgorgement) return null;
  const [ty, tm] = tirage.split("-").map(Number);
  const [dy, dm] = disgorgement.split("-").map(Number);
  const n = (dy - ty) * 12 + (dm - tm);
  return n >= 0 ? n : null;
};

const dupNorm = (s: string | null | number | undefined) =>
  (s ?? "").toString().trim().toLowerCase();

/** V3 — Duplikat-Warnung: gleicher Produzent + Name + Jahrgang + Flaschengröße. */
export const findDuplicates = (
  wines: readonly Pick<Wine, "id" | "producer" | "name" | "vintage" | "size_ml" | "quantity">[],
  input: { producer?: string | null; name?: string | null; vintage?: number | null; size_ml?: number | null },
  excludeId?: string
) =>
  wines.filter(
    (w) =>
      w.id !== excludeId &&
      dupNorm(w.producer) === dupNorm(input.producer) &&
      dupNorm(w.name) === dupNorm(input.name) &&
      dupNorm(w.vintage) === dupNorm(input.vintage) &&
      dupNorm(w.size_ml) === dupNorm(input.size_ml) &&
      dupNorm(input.producer) !== ""
  );
