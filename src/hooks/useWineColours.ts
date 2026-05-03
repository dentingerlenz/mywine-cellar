import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useEffect, useRef } from "react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";

export type WineColourRow = {
  id: string;
  user_id: string;
  name: string;
  display_name: string;
  sort_order: number;
};

export const DEFAULT_COLOURS: Array<{ name: string; display_name: string; sort_order: number }> = [
  { name: "sparkling", display_name: "Sparkling", sort_order: 0 },
  { name: "white", display_name: "White", sort_order: 1 },
  { name: "red", display_name: "Red", sort_order: 2 },
  { name: "rose", display_name: "Rosé", sort_order: 3 },
  { name: "dessert_fortified", display_name: "Dessert / Fortified", sort_order: 4 },
];

export const slugifyColourName = (s: string): string =>
  s
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "")
    .slice(0, 60) || "category";

export const useWineColours = () => {
  const { user } = useAuth();
  const qc = useQueryClient();
  const seededRef = useRef(false);

  const query = useQuery({
    queryKey: ["wine_colours", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("wine_colours")
        .select("*")
        .order("sort_order", { ascending: true })
        .order("created_at", { ascending: true });
      if (error) throw error;
      return (data ?? []) as WineColourRow[];
    },
  });

  // Seed defaults on first load if empty
  useEffect(() => {
    if (!user || query.isLoading || !query.data || seededRef.current) return;
    if (query.data.length === 0) {
      seededRef.current = true;
      (async () => {
        const payload = DEFAULT_COLOURS.map((c) => ({ ...c, user_id: user.id }));
        const { error } = await supabase.from("wine_colours").insert(payload);
        if (!error) qc.invalidateQueries({ queryKey: ["wine_colours"] });
      })();
    }
  }, [user, query.data, query.isLoading, qc]);

  return query;
};

export const useAddWineColour = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async (display_name: string) => {
      if (!user) throw new Error("Not signed in");
      const trimmed = display_name.trim();
      if (!trimmed) throw new Error("Name is required");
      // Get current max sort_order
      const { data: existing } = await supabase
        .from("wine_colours")
        .select("name, sort_order")
        .order("sort_order", { ascending: false })
        .limit(1);
      const baseSlug = slugifyColourName(trimmed);
      // Ensure unique name
      const { data: dup } = await supabase
        .from("wine_colours")
        .select("name")
        .eq("user_id", user.id)
        .like("name", `${baseSlug}%`);
      const taken = new Set((dup ?? []).map((r: any) => r.name));
      let name = baseSlug;
      let i = 2;
      while (taken.has(name)) {
        name = `${baseSlug}_${i++}`;
      }
      const sort_order = (existing?.[0]?.sort_order ?? 0) + 1;
      const { error } = await supabase
        .from("wine_colours")
        .insert({ user_id: user.id, name, display_name: trimmed, sort_order });
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_colours"] }),
  });
};

export const useRenameWineColour = () => {
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
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_colours"] }),
  });
};

export const useDeleteWineColour = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("wine_colours").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["wine_colours"] });
      qc.invalidateQueries({ queryKey: ["wines"] });
    },
  });
};
