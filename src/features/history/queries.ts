import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useCellar } from "@/features/cellar/CellarContext";
import { qk } from "@/lib/queryKeys";
import type { Tables } from "@/integrations/supabase/types";

// Junction-Zeilen werden direkt mitgeladen und als people_ids[] angeboten,
// damit die UI wie gewohnt mit einer flachen Liste arbeiten kann.
export type DrinkingLogEntry = Tables<"drinking_log"> & { people_ids: string[] };

export const useDrinkingLog = () => {
  const { cellarId } = useCellar();
  return useQuery({
    queryKey: [...qk.drinkingLog, cellarId],
    queryFn: async (): Promise<DrinkingLogEntry[]> => {
      const { data, error } = await supabase
        .from("drinking_log")
        .select("*, drinking_log_people ( person_id )")
        .order("date", { ascending: false })
        .order("created_at", { ascending: false });
      if (error) throw error;
      return (data ?? []).map(({ drinking_log_people, ...entry }) => ({
        ...entry,
        people_ids: (drinking_log_people ?? []).map((j) => j.person_id),
      }));
    },
  });
};

export type AddLogEntryInput = {
  wine_id: string;
  wine_label: string;
  date: string; // yyyy-mm-dd
  note?: string | null;
  rating?: number | null; // V6: „Wie war er?" beim Öffnen
  people_ids: string[];
};

export const useAddLogEntry = () => {
  const qc = useQueryClient();
  const { cellarId } = useCellar();
  return useMutation({
    mutationFn: async (input: AddLogEntryInput) => {
      const { data: userData } = await supabase.auth.getUser();
      const { data: entry, error } = await supabase
        .from("drinking_log")
        .insert({
          cellar_id: cellarId,
          wine_id: input.wine_id,
          wine_label: input.wine_label,
          date: input.date,
          note: input.note || null,
          rating: input.rating ?? null,
          opened_by: userData.user?.id ?? null,
        })
        .select("id")
        .single();
      if (error) throw error;
      if (input.people_ids.length) {
        const { error: jErr } = await supabase.from("drinking_log_people").insert(
          input.people_ids.map((person_id) => ({ log_id: entry.id, person_id }))
        );
        if (jErr) throw jErr;
      }
      return entry.id;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.drinkingLog }),
  });
};

export const useDeleteLogEntry = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("drinking_log").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.drinkingLog }),
  });
};
