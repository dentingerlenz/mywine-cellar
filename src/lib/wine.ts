import { z } from "zod";

export const WINE_COLOURS = ["sparkling", "white", "red", "orange_rose", "dessert_fortified"] as const;
export type WineColour = (typeof WINE_COLOURS)[number];

export const COLOUR_LABEL: Record<WineColour, string> = {
  sparkling: "Sparkling",
  white: "White",
  red: "Red",
  orange_rose: "Orange / Rosé",
  dessert_fortified: "Dessert / Fortified",
};

export const COLOUR_CLASS: Record<WineColour, string> = {
  sparkling: "bg-wine-sparkling text-background",
  white: "bg-wine-white text-background",
  red: "bg-wine-red text-foreground",
  orange_rose: "bg-wine-rose text-background",
  dessert_fortified: "bg-wine-dessert text-background",
};

export const OCCASIONS = ["a", "t", "l", "T"] as const;
export type Occasion = (typeof OCCASIONS)[number];

export const OCCASION_LABEL: Record<Occasion, string> = {
  a: "Anytime",
  t: "Special occasion",
  l: "Lay down",
  T: "Top bottle",
};

export const OCCASION_CLASS: Record<Occasion, string> = {
  a: "bg-secondary text-foreground border-primary/30",
  t: "bg-primary/20 text-primary border-primary/50",
  l: "bg-secondary text-foreground border-primary/30",
  T: "bg-primary text-primary-foreground border-primary",
};

export const CL_OPTIONS = [37.5, 50, 75, 100, 150, 300, 600] as const;

export const wineSchema = z.object({
  producer: z.string().trim().min(1, "Producer is required").max(200),
  description: z.string().trim().max(300).optional().or(z.literal("")),
  vintage: z.string().trim().max(60).optional().or(z.literal("")),
  cl: z.coerce.number().int().min(1).max(9999).optional().nullable(),
  colour: z.enum(WINE_COLOURS, { required_error: "Colour is required" }),
  variety: z.string().trim().max(200).optional().or(z.literal("")),
  residual_sugar_gl: z.coerce.number().min(0).max(999).optional().nullable(),
  dosage: z.string().trim().max(60).optional().or(z.literal("")),
  alcohol_pct: z.coerce.number().min(0).max(99).optional().nullable(),
  country: z.string().trim().max(120).optional().or(z.literal("")),
  region: z.string().trim().max(120).optional().or(z.literal("")),
  sub_region: z.string().trim().max(120).optional().or(z.literal("")),
  appellation: z.string().trim().max(120).optional().or(z.literal("")),
  ausbau_terroir: z.string().max(2000).optional().or(z.literal("")),
  notes: z.string().max(2000).optional().or(z.literal("")),
  occasion: z.enum(OCCASIONS).optional().nullable(),
  quantity: z.coerce.number().int().min(0).max(9999).default(1),
  price_chf: z.coerce.number().min(0).max(999999).optional().nullable(),
  purchased_from: z.string().trim().max(200).optional().or(z.literal("")),
  ready_from: z.coerce.number().int().min(1800).max(2200).optional().nullable(),
  drink_by: z.coerce.number().int().min(1800).max(2200).optional().nullable(),
  rating: z.coerce.number().int().min(1).max(5).optional().nullable(),
});

export type WineInput = z.infer<typeof wineSchema>;

export type Wine = {
  id: string;
  user_id: string;
  colour: WineColour | null;
  producer: string | null;
  description: string | null;
  vintage: string | null;
  cl: number | null;
  variety: string | null;
  residual_sugar_gl: number | null;
  dosage: string | null;
  alcohol_pct: number | null;
  country: string | null;
  region: string | null;
  sub_region: string | null;
  appellation: string | null;
  ausbau_terroir: string | null;
  notes: string | null;
  occasion: Occasion | null;
  quantity: number;
  price_chf: number | null;
  purchased_from: string | null;
  ready_from: number | null;
  drink_by: number | null;
  rating: number | null;
  label_photo_url: string | null;
  created_at: string;
};

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

export const wineTitle = (w: Pick<Wine, "producer" | "description">) =>
  [w.producer, w.description].filter(Boolean).join(" — ") || "Untitled bottle";
