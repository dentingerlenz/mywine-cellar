import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";

export type Person = {
  id: string;
  user_id: string;
  name: string;
  avatar: string | null;
  created_at: string;
};

export const usePeople = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: ["people", user?.id],
    enabled: !!user,
    queryFn: async () => {
      const { data, error } = await supabase
        .from("people")
        .select("*")
        .order("created_at", { ascending: true });
      if (error) throw error;
      return (data ?? []) as Person[];
    },
  });
};

export const useAddPerson = () => {
  const qc = useQueryClient();
  const { user } = useAuth();
  return useMutation({
    mutationFn: async ({ name, avatar }: { name: string; avatar: string }) => {
      if (!user) throw new Error("Not signed in");
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const { error } = await supabase
        .from("people")
        .insert({ user_id: user.id, name: trimmed, avatar });
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["people"] }),
  });
};

export const useRenamePerson = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name, avatar }: { id: string; name: string; avatar?: string }) => {
      const trimmed = name.trim();
      if (!trimmed) throw new Error("Name is required");
      const patch: any = { name: trimmed };
      if (avatar !== undefined) patch.avatar = avatar;
      const { error } = await supabase.from("people").update(patch).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["people"] }),
  });
};

export const useDeletePerson = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("people").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["people"] }),
  });
};

export const PERSON_EMOJI_OPTIONS = [
  "👤", "👨", "👩", "👦", "👧", "👴",
  "👵", "🧑", "🧔", "👨‍🦰", "👩‍🦰", "🧑‍🦱",
  "👨‍🦳", "👩‍🦳", "🧑‍🦲", "👨‍🎓",
];
