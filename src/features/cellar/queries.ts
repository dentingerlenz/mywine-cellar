import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/features/auth/AuthContext";
import { qk } from "@/lib/queryKeys";

export type Membership = {
  cellarId: string;
  cellarName: string;
  inviteCode: string;
  role: "owner" | "member";
};

export type CellarMember = {
  user_id: string;
  role: "owner" | "member";
  display_name: string | null;
  email: string | null;
};

const fetchMembership = async (): Promise<Membership | null> => {
  const { data, error } = await supabase
    .from("cellar_members")
    .select("role, cellars ( id, name, invite_code )")
    .maybeSingle();
  if (error) throw error;
  if (!data?.cellars) return null;
  return {
    cellarId: data.cellars.id,
    cellarName: data.cellars.name,
    inviteCode: data.cellars.invite_code,
    role: data.role as Membership["role"],
  };
};

export const useMembership = () => {
  const { user } = useAuth();
  return useQuery({
    queryKey: qk.membership(user?.id),
    enabled: !!user,
    queryFn: fetchMembership,
  });
};

export const useCreateCellar = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (name: string) => {
      const { data, error } = await supabase.rpc("create_cellar", { p_name: name });
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["membership"] }),
  });
};

export const useJoinCellar = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (inviteCode: string) => {
      const { data, error } = await supabase.rpc("join_cellar", { p_invite_code: inviteCode });
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["membership"] }),
  });
};

export const useRegenerateInviteCode = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async () => {
      const { data, error } = await supabase.rpc("regenerate_invite_code");
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["membership"] }),
  });
};

export const useCellarMembers = () => {
  return useQuery({
    queryKey: qk.members,
    queryFn: async (): Promise<CellarMember[]> => {
      const { data, error } = await supabase
        .from("cellar_members")
        .select("user_id, role, profiles ( display_name, email )")
        .order("created_at", { ascending: true });
      if (error) throw error;
      return (data ?? []).map((m) => ({
        user_id: m.user_id,
        role: m.role as CellarMember["role"],
        display_name: m.profiles?.display_name ?? null,
        email: m.profiles?.email ?? null,
      }));
    },
  });
};

/** Owner entfernt ein Mitglied; ein Mitglied entfernt sich selbst (Austritt). */
export const useRemoveMember = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (userId: string) => {
      const { error } = await supabase.from("cellar_members").delete().eq("user_id", userId);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: qk.members });
      qc.invalidateQueries({ queryKey: ["membership"] });
    },
  });
};
