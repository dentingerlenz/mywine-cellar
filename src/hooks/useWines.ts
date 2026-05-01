import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Wine, WineInput } from "@/lib/wine";
import { useAuth } from "@/contexts/AuthContext";

type GeoMaps = {
  countryById: Map<string, string>; // id -> name
  regionById: Map<string, string>; // id -> name
};

const toPayload = (v: WineInput, geo?: GeoMaps) => {
  const country_id = v.country_id ? String(v.country_id) : null;
  const region_id = v.region_id ? String(v.region_id) : null;
  // Mirror the resolved name into the legacy text columns so any code
  // still reading `country` / `region` keeps working until fully retired.
  const country = country_id ? geo?.countryById.get(country_id) ?? null : null;
  const region = region_id ? geo?.regionById.get(region_id) ?? null : null;
  return {
    colour: v.colour ?? null,
    producer: v.producer || null,
    description: v.description || null,
    vintage: v.vintage || null,
    cl: (v.cl as number | null | undefined) ?? null,
    variety: v.variety || null,
    residual_sugar_gl: (v.residual_sugar_gl as number | null | undefined) ?? null,
    dosage: v.dosage || null,
    alcohol_pct: (v.alcohol_pct as number | null | undefined) ?? null,
    country_id,
    region_id,
    country,
    region,
    sub_region: v.sub_region || null,
    appellation: v.appellation || null,
    ausbau_terroir: v.ausbau_terroir || null,
    notes: v.notes || null,
    occasion: v.occasion ?? null,
    quantity: v.quantity ?? 1,
    price_chf: (v.price_chf as number | null | undefined) ?? null,
    purchased_from: v.purchased_from || null,
    ready_from: (v.ready_from as number | null | undefined) ?? null,
    drink_by: (v.drink_by as number | null | undefined) ?? null,
    rating: (v.rating as number | null | undefined) ?? null,
  };
};

const fetchGeoMaps = async (): Promise<GeoMaps> => {
  const [{ data: countries }, { data: regions }] = await Promise.all([
    supabase.from("wine_countries").select("id, name"),
    supabase.from("wine_regions").select("id, name"),
  ]);
  return {
    countryById: new Map((countries ?? []).map((c: any) => [c.id, c.name])),
    regionById: new Map((regions ?? []).map((r: any) => [r.id, r.name])),
  };
};

export const useWines = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["wines", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("wines")
        .select("*")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data as unknown as Wine[];
    },
  });
};

export const useUpsertWine = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async ({
      id,
      values,
      label_photo_url,
    }: {
      id?: string;
      values: WineInput;
      label_photo_url?: string | null;
    }) => {
      if (!user) throw new Error("Not signed in");
      if (values.colour) {
        const { data: colourRow, error: colourErr } = await supabase
          .from("wine_colours")
          .select("name")
          .eq("user_id", user.id)
          .eq("name", values.colour)
          .maybeSingle();
        if (colourErr) throw colourErr;
        if (!colourRow) throw new Error(`Unknown colour category: ${values.colour}`);
      }
      const geo = await fetchGeoMaps();
      const payload: any = { ...toPayload(values, geo), user_id: user.id };
      if (label_photo_url !== undefined) payload.label_photo_url = label_photo_url;
      if (id) {
        const { error } = await supabase.from("wines").update(payload).eq("id", id);
        if (error) throw error;
      } else {
        const { error } = await supabase.from("wines").insert(payload);
        if (error) throw error;
      }
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wines"] }),
  });
};

export const useDeleteWine = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("wines").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wines"] }),
  });
};

export const useUpdatePrice = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, price_chf }: { id: string; price_chf: number | null }) => {
      const value = price_chf == null || !Number.isFinite(price_chf) || price_chf < 0 ? null : price_chf;
      const { error } = await supabase.from("wines").update({ price_chf: value }).eq("id", id);
      if (error) throw error;
      return value;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wines"] }),
  });
};

export const useUpdateQuantity = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, quantity }: { id: string; quantity: number }) => {
      const q = Math.max(0, Math.floor(quantity));
      const { error } = await supabase.from("wines").update({ quantity: q }).eq("id", id);
      if (error) throw error;
      return q;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wines"] }),
  });
};

export const uploadLabelPhoto = async (file: File, userId: string): Promise<string> => {
  const ext = file.name.split(".").pop()?.toLowerCase() || "jpg";
  const path = `${userId}/${crypto.randomUUID()}.${ext}`;
  const { error } = await supabase.storage.from("wine-photos").upload(path, file, {
    cacheControl: "3600",
    upsert: false,
  });
  if (error) throw error;
  const { data } = supabase.storage.from("wine-photos").getPublicUrl(path);
  return data.publicUrl;
};

/**
 * Bulk insert used by CSV import. Accepts either resolved {country_id, region_id}
 * (preferred) or legacy {country, region} text — but text-based rows must be
 * resolved to ids by the caller before this point.
 */
export const useBulkInsertWines = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async (rows: WineInput[]) => {
      if (!user) throw new Error("Not signed in");
      const colours = new Set(
        rows.map((r) => r.colour).filter((c): c is string => !!c)
      );
      if (colours.size > 0) {
        const { data: known, error: cErr } = await supabase
          .from("wine_colours")
          .select("name")
          .eq("user_id", user.id)
          .in("name", Array.from(colours));
        if (cErr) throw cErr;
        const knownSet = new Set((known ?? []).map((r: any) => r.name));
        const missing = Array.from(colours).filter((c) => !knownSet.has(c));
        if (missing.length) throw new Error(`Unknown colour categories: ${missing.join(", ")}`);
      }
      const geo = await fetchGeoMaps();
      const payload = rows.map((v) => ({ ...toPayload(v, geo), user_id: user.id }));
      const { error } = await supabase.from("wines").insert(payload);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wines"] }),
  });
};
