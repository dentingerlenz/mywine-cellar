import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Bottle, BottleInput } from "@/lib/wine";
import { useAuth } from "@/contexts/AuthContext";

export const useBottles = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["bottles", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("bottles")
        .select("*")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data as Bottle[];
    },
  });
};

export const useUpsertBottle = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async ({ id, values, photo_url }: { id?: string; values: BottleInput; photo_url?: string | null }) => {
      if (!user) throw new Error("Not signed in");
      const payload: any = {
        user_id: user.id,
        name: values.name,
        producer: values.producer || null,
        vintage: values.vintage ?? null,
        region: values.region || null,
        country: values.country || null,
        appellation: values.appellation || null,
        grape: values.grape || null,
        colour: values.colour ?? null,
        format: values.format || null,
        quantity: values.quantity ?? 1,
        note: values.note || null,
        rating: values.rating ?? null,
        ready_from: values.ready_from ?? null,
        drink_by: values.drink_by ?? null,
      };
      if (photo_url !== undefined) payload.photo_url = photo_url;
      if (id) {
        const { error } = await supabase.from("bottles").update(payload).eq("id", id);
        if (error) throw error;
      } else {
        const { error } = await supabase.from("bottles").insert(payload);
        if (error) throw error;
      }
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["bottles"] }),
  });
};

export const useDeleteBottle = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("bottles").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["bottles"] }),
  });
};

export const uploadWinePhoto = async (file: File, userId: string): Promise<string> => {
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

export const useBulkInsertBottles = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async (rows: BottleInput[]) => {
      if (!user) throw new Error("Not signed in");
      const payload = rows.map((v) => ({
        user_id: user.id,
        name: v.name,
        producer: v.producer || null,
        vintage: v.vintage ?? null,
        region: v.region || null,
        country: v.country || null,
        appellation: v.appellation || null,
        grape: v.grape || null,
        colour: v.colour ?? null,
        format: v.format || null,
        quantity: v.quantity ?? 1,
        note: v.note || null,
        rating: v.rating ?? null,
        ready_from: v.ready_from ?? null,
        drink_by: v.drink_by ?? null,
      }));
      const { error } = await supabase.from("bottles").insert(payload);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["bottles"] }),
  });
};
