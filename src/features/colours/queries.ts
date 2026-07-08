import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useCellar } from "@/features/cellar/CellarContext";
import { qk } from "@/lib/queryKeys";
import type { Tables } from "@/integrations/supabase/types";

export type WineColour = Tables<"wine_colours">;

// Weinart steuert die weinart-spezifischen Formularfelder.
export type WineKind = "still" | "sparkling" | "sweet_fortified";
export const WINE_KIND_LABEL: Record<WineKind, string> = {
  still: "Still",
  sparkling: "Sparkling",
  sweet_fortified: "Sweet / Fortified",
};

// Eingebautes Styling (aus v1 übernommen), gekeyt über den Slug (name);
// Custom-Farben bekommen den neutralen Fallback.
export const COLOUR_CLASS_BY_NAME: Record<string, string> = {
  sparkling: "bg-wine-sparkling text-background",
  white: "bg-wine-white text-background",
  red: "bg-wine-red text-foreground",
  rose: "bg-wine-rose text-background",
  dessert_fortified: "bg-wine-dessert text-background",
  orange: "bg-wine-orange text-background",
};
export const FALLBACK_COLOUR_CLASS = "bg-secondary text-foreground border border-primary/30";

export const COLOUR_HEX_BY_NAME: Record<string, string> = {
  sparkling: "#c9a84c",
  white: "hsl(48, 55%, 75%)",
  red: "hsl(350, 70%, 35%)",
  rose: "#e8a0a0",
  dessert_fortified: "#c4956a",
  orange: "#e07b39",
};
export const FALLBACK_COLOUR_HEX = "hsl(44, 53%, 54%)";

export const colourClassFor = (slug: string | null | undefined): string =>
  (slug && COLOUR_CLASS_BY_NAME[slug]) || FALLBACK_COLOUR_CLASS;

export const colourHexFor = (slug: string | null | undefined): string =>
  (slug && COLOUR_HEX_BY_NAME[slug]) || FALLBACK_COLOUR_HEX;

export const useColours = () => {
  const { cellarId } = useCellar();
  return useQuery({
    queryKey: [...qk.colours, cellarId],
    queryFn: async (): Promise<WineColour[]> => {
      const { data, error } = await supabase
        .from("wine_colours")
        .select("*")
        .order("sort_order")
        .order("created_at");
      if (error) throw error;
      return data ?? [];
    },
  });
};

/** Lookup über colour_id — die eine Quelle für Label/Styling/Weinart in der UI. */
export const useColourLookup = () => {
  const { data: colours = [], isLoading } = useColours();
  const byId = new Map(colours.map((c) => [c.id, c]));
  const slugFor = (id: string | null | undefined) => (id ? byId.get(id)?.name ?? null : null);
  return {
    colours,
    loading: isLoading,
    byId,
    labelFor: (id: string | null | undefined) => (id ? byId.get(id)?.display_name ?? "—" : "—"),
    classFor: (id: string | null | undefined) => colourClassFor(slugFor(id)),
    hexFor: (id: string | null | undefined) => colourHexFor(slugFor(id)),
    kindFor: (id: string | null | undefined): WineKind =>
      (id ? (byId.get(id)?.kind as WineKind | undefined) : undefined) ?? "still",
  };
};

const slugify = (s: string) =>
  s.trim().toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "");

export const useAddColour = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  return useMutation({
    mutationFn: async ({ displayName, kind = "still" }: { displayName: string; kind?: WineKind }) => {
      const display_name = displayName.trim();
      if (!display_name) throw new Error("Name is required");
      const { data: existing } = await supabase
        .from("wine_colours")
        .select("sort_order")
        .order("sort_order", { ascending: false })
        .limit(1);
      const { error } = await supabase.from("wine_colours").insert({
        cellar_id: cellarId,
        name: slugify(display_name),
        display_name,
        kind,
        sort_order: (existing?.[0]?.sort_order ?? -1) + 1,
      });
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.colours }),
  });
};

export const useUpdateColourKind = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, kind }: { id: string; kind: WineKind }) => {
      const { error } = await supabase.from("wine_colours").update({ kind }).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.colours }),
  });
};

export const useRenameColour = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, display_name }: { id: string; display_name: string }) => {
      const trimmed = display_name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { error } = await supabase
        .from("wine_colours")
        .update({ display_name: trimmed })
        .eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.colours }),
  });
};

export const useDeleteColour = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("wine_colours").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: qk.colours });
      qc.invalidateQueries({ queryKey: qk.wines }); // colour_id → null via FK
    },
  });
};
