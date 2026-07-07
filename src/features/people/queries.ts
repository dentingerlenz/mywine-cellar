import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useCellar } from "@/features/cellar/CellarContext";
import { qk } from "@/lib/queryKeys";
import type { Tables } from "@/integrations/supabase/types";

export type Person = Tables<"people">;

export const usePeople = () => {
  const { cellarId } = useCellar();
  return useQuery({
    queryKey: [...qk.people, cellarId],
    queryFn: async (): Promise<Person[]> => {
      const { data, error } = await supabase
        .from("people")
        .select("*")
        .order("created_at");
      if (error) throw error;
      return data ?? [];
    },
  });
};

export const useAddPerson = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  return useMutation({
    mutationFn: async ({ name, avatar }: { name: string; avatar?: string | null }) => {
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { error } = await supabase
        .from("people")
        .insert({ cellar_id: cellarId, name: trimmed, avatar: avatar ?? null });
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.people }),
  });
};

export const useUpdatePerson = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name, avatar }: { id: string; name?: string; avatar?: string | null }) => {
      const patch: Partial<Person> = {};
      if (name !== undefined) {
        const trimmed = name.trim();
        if (!trimmed) throw new Error("Name is required");
        patch.name = trimmed;
      }
      if (avatar !== undefined) patch.avatar = avatar;
      const { error } = await supabase.from("people").update(patch).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.people }),
  });
};

export const useDeletePerson = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("people").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: qk.people });
      qc.invalidateQueries({ queryKey: qk.drinkingLog }); // Junction-Zeilen kaskadiert
    },
  });
};
