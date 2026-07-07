import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useWines } from "@/hooks/useWines";

export type WineCountryRow = {
  id: string;
  user_id: string;
  name: string;
  sort_order: number;
  continent: string | null;
};

export type WineRegionRow = {
  id: string;
  user_id: string;
  country_id: string;
  name: string;
  sort_order: number;
};

export type WineSubRegionRow = {
  id: string;
  user_id: string;
  region_id: string;
  name: string;
  sort_order: number;
};

export type AppellationLevel = "country" | "region" | "appellation";

export type WineAppellationRow = {
  id: string;
  user_id: string;
  sub_region_id: string | null;
  region_id: string | null;
  country_id: string | null;
  level: AppellationLevel;
  name: string;
  appellation_type: string | null;
  sort_order: number;
};

export const useWineSubRegions = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["wine_sub_regions", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("wine_sub_regions")
        .select("*")
        .order("sort_order", { ascending: true })
        .order("name", { ascending: true });
      if (error) throw error;
      return (data ?? []) as WineSubRegionRow[];
    },
  });
};

export const useWineAppellations = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["wine_appellations", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("wine_appellations")
        .select("*")
        .order("sort_order", { ascending: true })
        .order("name", { ascending: true });
      if (error) throw error;
      return (data ?? []) as WineAppellationRow[];
    },
  });
};

export const useWineCountries = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["wine_countries", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("wine_countries")
        .select("*")
        .order("sort_order", { ascending: true })
        .order("created_at", { ascending: true });
      if (error) throw error;
      return (data ?? []) as WineCountryRow[];
    },
  });
};

export const useWineRegions = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["wine_regions", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("wine_regions")
        .select("*")
        .order("sort_order", { ascending: true })
        .order("created_at", { ascending: true });
      if (error) throw error;
      return (data ?? []) as WineRegionRow[];
    },
  });
};

/**
 * Lookup helpers that resolve a wine's country / region display name.
 * Prefers the FK ids (country_id / region_id); falls back to the legacy
 * text columns if a wine hasn't been migrated yet.
 */
export const useGeographyLookups = () => {
  const { data: countries = [] } = useWineCountries();
  const { data: regions = [] } = useWineRegions();
  const countryById = new Map(countries.map((c) => [c.id, c]));
  const regionById = new Map(regions.map((r) => [r.id, r]));
  const countryNameFor = (
    w: { country_id?: string | null; country?: string | null },
  ) => (w.country_id && countryById.get(w.country_id)?.name) || w.country || null;
  const regionNameFor = (
    w: { region_id?: string | null; region?: string | null },
  ) => (w.region_id && regionById.get(w.region_id)?.name) || w.region || null;
  return { countries, regions, countryById, regionById, countryNameFor, regionNameFor };
};

// ─── Country mutations ───────────────────────────────────────────────────────

export const useAddWineCountry = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async (name: string) => {
      if (!user) throw new Error("Not signed in");
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { data: existing } = await supabase
        .from("wine_countries")
        .select("sort_order")
        .order("sort_order", { ascending: false })
        .limit(1);
      const sort_order = (existing?.[0]?.sort_order ?? -1) + 1;
      const { error } = await supabase
        .from("wine_countries")
        .insert({ user_id: user.id, name: trimmed, sort_order });
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_countries"] }),
  });
};

export const useRenameWineCountry = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name }: { id: string; name: string }) => {
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { error } = await supabase.from("wine_countries").update({ name: trimmed }).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_countries"] }),
  });
};

export const useDeleteWineCountry = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("wine_countries").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["wine_countries"] });
      qc.invalidateQueries({ queryKey: ["wine_regions"] });
    },
  });
};

export const useReorderWineCountries = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (orderedIds: string[]) => {
      // Update each row's sort_order to its new index
      await Promise.all(
        orderedIds.map((id, idx) =>
          supabase.from("wine_countries").update({ sort_order: idx }).eq("id", id),
        ),
      );
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_countries"] }),
  });
};

// ─── Region mutations ────────────────────────────────────────────────────────

export const useAddWineRegion = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async ({ country_id, name }: { country_id: string; name: string }) => {
      if (!user) throw new Error("Not signed in");
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { data: existing } = await supabase
        .from("wine_regions")
        .select("sort_order")
        .eq("country_id", country_id)
        .order("sort_order", { ascending: false })
        .limit(1);
      const sort_order = (existing?.[0]?.sort_order ?? -1) + 1;
      const { error } = await supabase
        .from("wine_regions")
        .insert({ user_id: user.id, country_id, name: trimmed, sort_order });
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_regions"] }),
  });
};

export const useRenameWineRegion = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name }: { id: string; name: string }) => {
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { error } = await supabase.from("wine_regions").update({ name: trimmed }).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_regions"] }),
  });
};

export const useDeleteWineRegion = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("wine_regions").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_regions"] }),
  });
};

export const useReorderWineRegions = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (orderedIds: string[]) => {
      await Promise.all(
        orderedIds.map((id, idx) =>
          supabase.from("wine_regions").update({ sort_order: idx }).eq("id", id),
        ),
      );
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wine_regions"] }),
  });
};
