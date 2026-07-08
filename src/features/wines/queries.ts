import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useCellar } from "@/features/cellar/CellarContext";
import { qk } from "@/lib/queryKeys";
import { type Wine, type WineInput, monthYearToDate } from "./model";

const toPayload = (v: WineInput) => ({
  producer: v.producer || null,
  name: v.name || null,
  vintage: v.vintage ?? null,
  is_non_vintage: v.is_non_vintage ?? false,
  base_vintage: v.base_vintage ?? null,
  aging_indication: v.aging_indication || null,
  colour_id: v.colour_id,
  variety: v.variety || null,
  classification: v.classification || null,
  size_ml: v.size_ml ?? null,
  alcohol_pct: v.alcohol_pct ?? null,
  residual_sugar_gl: v.residual_sugar_gl ?? null,
  dosage_level: v.dosage_level || null,
  dosage_gl: v.dosage_gl ?? null,
  tirage_date: monthYearToDate(v.tirage_date),
  disgorgement_date: monthYearToDate(v.disgorgement_date),
  country_id: v.country_id ?? null,
  region_id: v.region_id ?? null,
  sub_region_id: v.sub_region_id ?? null,
  appellation_id: v.appellation_id ?? null,
  location: v.location || null,
  terroir_notes: v.terroir_notes || null,
  notes: v.notes || null,
  occasion: v.occasion ?? null,
  quantity: v.quantity ?? 1,
  price_chf: v.price_chf ?? null,
  purchased_from: v.purchased_from || null,
  storage_location: v.storage_location || null,
  ready_from: v.ready_from ?? null,
  drink_by: v.drink_by ?? null,
  rating: v.rating ?? null,
});

export const useWines = () => {
  const { cellarId } = useCellar();
  return useQuery({
    queryKey: [...qk.wines, cellarId],
    queryFn: async (): Promise<Wine[]> => {
      const { data, error } = await supabase
        .from("wines")
        .select("*")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data ?? [];
    },
  });
};

export const useUpsertWine = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  return useMutation({
    mutationFn: async ({
      id,
      values,
      label_photo_path,
    }: {
      id?: string;
      values: WineInput;
      label_photo_path?: string | null;
    }) => {
      const payload = {
        ...toPayload(values),
        cellar_id: cellarId,
        ...(label_photo_path !== undefined ? { label_photo_path } : {}),
      };
      if (id) {
        const { error } = await supabase.from("wines").update(payload).eq("id", id);
        if (error) throw error;
      } else {
        const { data: userData } = await supabase.auth.getUser();
        const { error } = await supabase
          .from("wines")
          .insert({ ...payload, created_by: userData.user?.id ?? null });
        if (error) throw error;
      }
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.wines }),
  });
};

export const useDeleteWine = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("wines").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.wines }),
  });
};

/** Optimistisches Update — Menge ändert sich sofort, Rollback bei Fehler. */
export const useUpdateQuantity = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  const key = [...qk.wines, cellarId];
  return useMutation({
    mutationFn: async ({ id, quantity }: { id: string; quantity: number }) => {
      const q = Math.max(0, Math.floor(quantity));
      const { error } = await supabase.from("wines").update({ quantity: q }).eq("id", id);
      if (error) throw error;
      return q;
    },
    onMutate: async ({ id, quantity }) => {
      await qc.cancelQueries({ queryKey: key });
      const previous = qc.getQueryData<Wine[]>(key);
      qc.setQueryData<Wine[]>(key, (old) =>
        (old ?? []).map((w) => (w.id === id ? { ...w, quantity: Math.max(0, Math.floor(quantity)) } : w))
      );
      return { previous };
    },
    onError: (_e, _v, ctx) => ctx?.previous && qc.setQueryData(key, ctx.previous),
    onSettled: () => qc.invalidateQueries({ queryKey: qk.wines }),
  });
};

export const useUpdatePrice = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  const key = [...qk.wines, cellarId];
  return useMutation({
    mutationFn: async ({ id, price_chf }: { id: string; price_chf: number | null }) => {
      const value =
        price_chf == null || !Number.isFinite(price_chf) || price_chf < 0 ? null : price_chf;
      const { error } = await supabase.from("wines").update({ price_chf: value }).eq("id", id);
      if (error) throw error;
      return value;
    },
    onMutate: async ({ id, price_chf }) => {
      await qc.cancelQueries({ queryKey: key });
      const previous = qc.getQueryData<Wine[]>(key);
      qc.setQueryData<Wine[]>(key, (old) =>
        (old ?? []).map((w) => (w.id === id ? { ...w, price_chf } : w))
      );
      return { previous };
    },
    onError: (_e, _v, ctx) => ctx?.previous && qc.setQueryData(key, ctx.previous),
    onSettled: () => qc.invalidateQueries({ queryKey: qk.wines }),
  });
};

/** CSV-Import: ein Insert für alle Zeilen (Payloads inkl. aufgelöster Geo-IDs). */
export const useBulkInsertWines = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  return useMutation({
    mutationFn: async (rows: WineInput[]) => {
      const { data: userData } = await supabase.auth.getUser();
      const payload = rows.map((v) => ({
        ...toPayload(v),
        cellar_id: cellarId,
        created_by: userData.user?.id ?? null,
      }));
      const { error } = await supabase.from("wines").insert(payload);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.wines }),
  });
};

// ── Label-Fotos: Storage-PFAD in der DB, URL wird abgeleitet ────────────────
export const labelPhotoUrl = (path: string | null | undefined): string | null =>
  path ? supabase.storage.from("wine-photos").getPublicUrl(path).data.publicUrl : null;

export const uploadLabelPhoto = async (file: File, cellarId: string): Promise<string> => {
  const ext = file.name.split(".").pop()?.toLowerCase() || "jpg";
  const path = `${cellarId}/${crypto.randomUUID()}.${ext}`;
  const { error } = await supabase.storage
    .from("wine-photos")
    .upload(path, file, { cacheControl: "3600", upsert: false });
  if (error) throw error;
  return path;
};
