import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useCellar } from "@/features/cellar/CellarContext";
import { qk } from "@/lib/queryKeys";
import type { Tables } from "@/integrations/supabase/types";

export type WineColour = Tables<"wine_colours">;

// Eingebautes Styling, gekeyt über den Slug (name); Custom-Farben → Fallback.
export const COLOUR_STYLE: Record<string, { dot: string; badge: string }> = {
  sparkling: { dot: "bg-amber-200", badge: "bg-amber-100/80 text-amber-900 border-amber-300" },
  white: { dot: "bg-yellow-100", badge: "bg-yellow-50 text-yellow-900 border-yellow-200" },
  red: { dot: "bg-red-800", badge: "bg-red-100/80 text-red-900 border-red-300" },
  rose: { dot: "bg-pink-300", badge: "bg-pink-100/80 text-pink-900 border-pink-300" },
  orange: { dot: "bg-orange-400", badge: "bg-orange-100/80 text-orange-900 border-orange-300" },
  dessert_fortified: { dot: "bg-amber-700", badge: "bg-amber-100/80 text-amber-900 border-amber-400" },
};
export const FALLBACK_COLOUR_STYLE = {
  dot: "bg-muted-foreground",
  badge: "bg-secondary text-foreground border-primary/30",
};
export const colourStyle = (slug: string | null | undefined) =>
  (slug && COLOUR_STYLE[slug]) || FALLBACK_COLOUR_STYLE;

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

const slugify = (s: string) =>
  s.trim().toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "");

export const useAddColour = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  return useMutation({
    mutationFn: async (displayName: string) => {
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
        sort_order: (existing?.[0]?.sort_order ?? -1) + 1,
      });
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
