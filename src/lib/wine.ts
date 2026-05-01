import { z } from "zod";

export const WINE_COLOURS = ["red", "white", "rose", "sparkling", "dessert"] as const;
export type WineColour = (typeof WINE_COLOURS)[number];

export const COLOUR_LABEL: Record<WineColour, string> = {
  red: "Red",
  white: "White",
  rose: "Rosé",
  sparkling: "Sparkling",
  dessert: "Dessert",
};

export const COLOUR_CLASS: Record<WineColour, string> = {
  red: "bg-wine-red text-foreground",
  white: "bg-wine-white text-background",
  rose: "bg-wine-rose text-background",
  sparkling: "bg-wine-sparkling text-background",
  dessert: "bg-wine-dessert text-background",
};

export const FORMATS = ["375ml", "75cl", "Magnum (1.5L)", "Jeroboam (3L)", "Methuselah (6L)"] as const;

export const bottleSchema = z.object({
  name: z.string().trim().min(1, "Name is required").max(200),
  producer: z.string().trim().max(200).optional().or(z.literal("")),
  vintage: z.coerce.number().int().min(1800).max(new Date().getFullYear() + 1).optional().nullable(),
  region: z.string().trim().max(120).optional().or(z.literal("")),
  country: z.string().trim().max(120).optional().or(z.literal("")),
  appellation: z.string().trim().max(120).optional().or(z.literal("")),
  grape: z.string().trim().max(200).optional().or(z.literal("")),
  colour: z.enum(WINE_COLOURS).optional().nullable(),
  format: z.string().max(40).optional().or(z.literal("")),
  quantity: z.coerce.number().int().min(0).max(9999).default(1),
  note: z.string().max(2000).optional().or(z.literal("")),
  rating: z.coerce.number().int().min(1).max(5).optional().nullable(),
  ready_from: z.coerce.number().int().min(1800).max(2200).optional().nullable(),
  drink_by: z.coerce.number().int().min(1800).max(2200).optional().nullable(),
});

export type BottleInput = z.infer<typeof bottleSchema>;

export type Bottle = {
  id: string;
  user_id: string;
  name: string;
  producer: string | null;
  vintage: number | null;
  region: string | null;
  country: string | null;
  appellation: string | null;
  grape: string | null;
  colour: WineColour | null;
  format: string | null;
  quantity: number;
  note: string | null;
  rating: number | null;
  ready_from: number | null;
  drink_by: number | null;
  photo_url: string | null;
  created_at: string;
  updated_at: string;
};

export type DrinkStatus = "drink_now" | "too_young" | "past_peak" | "unknown";

export const getDrinkStatus = (b: Pick<Bottle, "ready_from" | "drink_by">): DrinkStatus => {
  const year = new Date().getFullYear();
  if (b.ready_from == null && b.drink_by == null) return "unknown";
  if (b.ready_from != null && year < b.ready_from) return "too_young";
  if (b.drink_by != null && year > b.drink_by) return "past_peak";
  return "drink_now";
};

export const DRINK_LABEL: Record<DrinkStatus, string> = {
  drink_now: "Drink now",
  too_young: "Too young",
  past_peak: "Past peak",
  unknown: "—",
};
