import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";

export type DrinkingLogEntry = {
  id: string;
  user_id: string;
  wine_id: string | null;
  date: string;
  note: string | null;
  people_ids: string[];
  created_at: string;
};

export const useDrinkingLog = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["drinking_log", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("drinking_log")
        .select("*")
        .order("date", { ascending: false })
        .order("created_at", { ascending: false });
      if (error) throw error;
      return (data ?? []) as DrinkingLogEntry[];
    },
  });
};

export const useDeleteDrinkingLogEntry = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("drinking_log").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["drinking_log"] }),
  });
};
