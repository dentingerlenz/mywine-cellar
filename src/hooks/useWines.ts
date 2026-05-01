import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Wine, WineInput } from "@/lib/wine";
import { useAuth } from "@/contexts/AuthContext";

const toPayload = (v: WineInput) => ({
  colour: v.colour ?? null,
  producer: v.producer || null,
  description: v.description || null,
  vintage: v.vintage || null,
  cl: (v.cl as number | null | undefined) ?? null,
  variety: v.variety || null,
  residual_sugar_gl: (v.residual_sugar_gl as number | null | undefined) ?? null,
  dosage: v.dosage || null,
  alcohol_pct: (v.alcohol_pct as number | null | undefined) ?? null,
  country: v.country || null,
  region: v.region || null,
  sub_region: v.sub_region || null,
  appellation: v.appellation || null,
  ausbau_terroir: v.ausbau_terroir || null,
  notes: v.notes || null,
  occasion: v.occasion ?? null,
  quantity: v.quantity ?? 1,
  price_chf: v.price_chf ?? null,
  purchased_from: v.purchased_from || null,
  ready_from: v.ready_from ?? null,
  drink_by: v.drink_by ?? null,
  rating: v.rating ?? null,
});

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
      const payload: any = { ...toPayload(values), user_id: user.id };
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

export const useBulkInsertWines = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async (rows: WineInput[]) => {
      if (!user) throw new Error("Not signed in");
      const payload = rows.map((v) => ({ ...toPayload(v), user_id: user.id }));
      const { error } = await supabase.from("wines").insert(payload);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wines"] }),
  });
};
