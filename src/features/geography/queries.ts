import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { qk } from "@/lib/queryKeys";
import type { Tables } from "@/integrations/supabase/types";

export type Country = Tables<"countries">;
export type Region = Tables<"regions">;
export type SubRegion = Tables<"sub_regions">;
export type Appellation = Tables<"appellations">;

// Geo-Referenz ist global (kein cellar-Scope) und ändert sich selten.
const geoQuery = { staleTime: 5 * 60 * 1000 };

export const useCountries = () =>
  useQuery({
    queryKey: qk.countries,
    ...geoQuery,
    queryFn: async (): Promise<Country[]> => {
      const { data, error } = await supabase
        .from("countries")
        .select("*")
        .order("sort_order")
        .order("name");
      if (error) throw error;
      return data ?? [];
    },
  });

export const useRegions = () =>
  useQuery({
    queryKey: qk.regions,
    ...geoQuery,
    queryFn: async (): Promise<Region[]> => {
      const { data, error } = await supabase
        .from("regions")
        .select("*")
        .order("sort_order")
        .order("name");
      if (error) throw error;
      return data ?? [];
    },
  });

export const useSubRegions = () =>
  useQuery({
    queryKey: qk.subRegions,
    ...geoQuery,
    queryFn: async (): Promise<SubRegion[]> => {
      const { data, error } = await supabase
        .from("sub_regions")
        .select("*")
        .order("sort_order")
        .order("name");
      if (error) throw error;
      return data ?? [];
    },
  });

export const useAppellations = () =>
  useQuery({
    queryKey: qk.appellations,
    ...geoQuery,
    queryFn: async (): Promise<Appellation[]> => {
      const { data, error } = await supabase
        .from("appellations")
        .select("*")
        .order("sort_order")
        .order("name");
      if (error) throw error;
      return data ?? [];
    },
  });

/**
 * Lookup-Maps für Anzeige & Kaskade — eine Quelle für Form, Filter, Detail.
 * Alle vier Tabellen sind klein genug, um sie komplett im Client zu halten.
 */
export const useGeoLookups = () => {
  const { data: countries = [] } = useCountries();
  const { data: regions = [] } = useRegions();
  const { data: subRegions = [] } = useSubRegions();
  const { data: appellations = [] } = useAppellations();

  const countryById = new Map(countries.map((c) => [c.id, c]));
  const regionById = new Map(regions.map((r) => [r.id, r]));
  const subRegionById = new Map(subRegions.map((s) => [s.id, s]));
  const appellationById = new Map(appellations.map((a) => [a.id, a]));

  const regionsByCountry = (countryId: string | null | undefined) =>
    countryId ? regions.filter((r) => r.country_id === countryId) : [];
  const subRegionsByRegion = (regionId: string | null | undefined) =>
    regionId ? subRegions.filter((s) => s.region_id === regionId) : [];
  /** Appellationen, die zum aktuellen Kaskaden-Stand passen (tiefste Ebene zuerst). */
  const appellationsForSelection = (sel: {
    country_id?: string | null;
    region_id?: string | null;
    sub_region_id?: string | null;
  }) => {
    if (sel.sub_region_id) {
      const subLevel = appellations.filter((a) => a.sub_region_id === sel.sub_region_id);
      const regionLevel = appellations.filter((a) => a.region_id === sel.region_id);
      return [...subLevel, ...regionLevel];
    }
    if (sel.region_id) {
      const subIds = new Set(subRegionsByRegion(sel.region_id).map((s) => s.id));
      return appellations.filter(
        (a) => a.region_id === sel.region_id || (a.sub_region_id && subIds.has(a.sub_region_id))
      );
    }
    if (sel.country_id) {
      const regionIds = new Set(regionsByCountry(sel.country_id).map((r) => r.id));
      const subIds = new Set(subRegions.filter((s) => regionIds.has(s.region_id)).map((s) => s.id));
      return appellations.filter(
        (a) =>
          a.country_id === sel.country_id ||
          (a.region_id && regionIds.has(a.region_id)) ||
          (a.sub_region_id && subIds.has(a.sub_region_id))
      );
    }
    return appellations;
  };

  /** Vorfahren einer Appellation (fürs Auto-Ausfüllen der Kaskade im Formular). */
  const ancestorsOfAppellation = (appellationId: string) => {
    const a = appellationById.get(appellationId);
    if (!a) return {};
    if (a.level === "sub_region" && a.sub_region_id) {
      const s = subRegionById.get(a.sub_region_id);
      const r = s ? regionById.get(s.region_id) : undefined;
      return {
        sub_region_id: a.sub_region_id,
        region_id: s?.region_id ?? null,
        country_id: r?.country_id ?? null,
      };
    }
    if (a.level === "region" && a.region_id) {
      const r = regionById.get(a.region_id);
      return { region_id: a.region_id, country_id: r?.country_id ?? null };
    }
    return { country_id: a.country_id ?? null };
  };

  return {
    countries, regions, subRegions, appellations,
    countryById, regionById, subRegionById, appellationById,
    regionsByCountry, subRegionsByRegion, appellationsForSelection, ancestorsOfAppellation,
  };
};

// ── Pflege-Mutationen (Settings-Manager; global, Familien-Pragmatik) ─────────
type GeoTable = "countries" | "regions" | "sub_regions" | "appellations";
const keyFor: Record<GeoTable, readonly string[]> = {
  countries: qk.countries,
  regions: qk.regions,
  sub_regions: qk.subRegions,
  appellations: qk.appellations,
};

export const useAddCountry = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (row: { name: string; code?: string | null; continent?: string | null; sort_order?: number }) => {
      const { error } = await supabase.from("countries").insert(row);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.countries }),
  });
};

export const useAddRegion = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (row: { country_id: string; name: string; sort_order?: number }) => {
      const { error } = await supabase.from("regions").insert(row);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.regions }),
  });
};

export const useAddSubRegion = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (row: { region_id: string; name: string; sort_order?: number }) => {
      const { error } = await supabase.from("sub_regions").insert(row);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.subRegions }),
  });
};

export const useAddAppellation = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (row: {
      level: "country" | "region" | "sub_region";
      country_id?: string | null;
      region_id?: string | null;
      sub_region_id?: string | null;
      name: string;
      type?: string | null;
      sort_order?: number;
    }) => {
      const { error } = await supabase.from("appellations").insert(row);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.appellations }),
  });
};

export const useRenameGeoRow = (table: GeoTable) => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name }: { id: string; name: string }) => {
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { error } = await supabase.from(table).update({ name: trimmed }).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: keyFor[table] }),
  });
};

export const useDeleteGeoRow = (table: GeoTable) => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from(table).delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      // Kaskaden können Kinder mitlöschen → alle Geo-Caches invalidieren
      (Object.values(keyFor) as readonly (readonly string[])[]).forEach((k) =>
        qc.invalidateQueries({ queryKey: k })
      );
    },
  });
};

/** Batch-Reorder über die reorder_rows-RPC (ein Request statt N). */
export const useReorderGeoRows = (table: GeoTable | "wine_colours") => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (orderedIds: string[]) => {
      const { error } = await supabase.rpc("reorder_rows", {
        p_table: table,
        p_ids: orderedIds,
      });
      if (error) throw error;
    },
    onSuccess: () =>
      qc.invalidateQueries({
        queryKey: table === "wine_colours" ? qk.colours : keyFor[table],
      }),
  });
};
