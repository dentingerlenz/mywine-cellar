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

export const wineSchema = z.object({
  producer: z.string().trim().min(1, "Producer is required").max(200),
  name: z.string().trim().max(300).optional().or(z.literal("")),
  vintage: z.string().trim().max(60).optional().or(z.literal("")),
  colour_id: z.string().uuid({ message: "Colour is required" }),
  variety: z.string().trim().max(200).optional().or(z.literal("")),
  size_ml: optionalNum(z.coerce.number().int().min(10).max(99999)),
  alcohol_pct: optionalNum(z.coerce.number().min(0).max(99)),
  residual_sugar_gl: optionalNum(z.coerce.number().min(0).max(999)),
  dosage: z.string().trim().max(60).optional().or(z.literal("")),
  country_id: optionalUuid,
  region_id: optionalUuid,
  sub_region_id: optionalUuid,
  appellation_id: optionalUuid,
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

const dupNorm = (s: string | null | undefined) => (s ?? "").trim().toLowerCase();

/** V3 — Duplikat-Warnung: gleicher Produzent + Name + Jahrgang im Bestand. */
export const findDuplicates = (
  wines: readonly Pick<Wine, "id" | "producer" | "name" | "vintage" | "quantity">[],
  input: { producer?: string | null; name?: string | null; vintage?: string | null },
  excludeId?: string
) =>
  wines.filter(
    (w) =>
      w.id !== excludeId &&
      dupNorm(w.producer) === dupNorm(input.producer) &&
      dupNorm(w.name) === dupNorm(input.name) &&
      dupNorm(w.vintage) === dupNorm(input.vintage) &&
      dupNorm(input.producer) !== ""
  );
