import { useState } from "react";
import { useAuth } from "@/features/auth/AuthContext";
import { useCellar } from "./CellarContext";
import { useCellarMembers, useRegenerateInviteCode, useRemoveMember } from "./queries";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { toast } from "sonner";
import { Copy, RefreshCw, UserMinus, LogOut, Loader2 } from "lucide-react";

export const MembersSection = () => {
  const { user } = useAuth();
  const cellar = useCellar();
  const { data: members = [], isLoading } = useCellarMembers();
  const regen = useRegenerateInviteCode();
  const remove = useRemoveMember();
  const [confirmRemove, setConfirmRemove] = useState<{ userId: string; label: string } | null>(null);

  const isOwner = cellar.role === "owner";

  const copyCode = async () => {
    await navigator.clipboard.writeText(cellar.inviteCode);
    toast.success("Invite code copied");
  };

  const onRegen = async () => {
    try {
      await regen.mutateAsync();
      toast.success("New invite code generated — the old one no longer works.");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Could not regenerate code");
    }
  };

  const onRemove = async () => {
    if (!confirmRemove) return;
    try {
      await remove.mutateAsync(confirmRemove.userId);
      toast.success(
        confirmRemove.userId === user?.id ? "You left the cellar." : "Member removed."
      );
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Could not remove member");
    } finally {
      setConfirmRemove(null);
    }
  };

  return (
    <Card className="p-6 gold-border bg-card/90">
      <h3 className="font-display text-xl mb-1">Members</h3>
      <p className="text-sm text-muted-foreground mb-4">
        Everyone in “{cellar.cellarName}” shares the same bottles and history.
      </p>

      <div className="flex items-center gap-2 mb-6 p-3 rounded-md bg-secondary/50 border border-primary/20">
        <div className="flex-1">
          <div className="text-xs uppercase tracking-widest text-muted-foreground mb-1">
            Invite code
          </div>
          <div className="font-mono text-lg tracking-[0.3em]">{cellar.inviteCode}</div>
        </div>
        <Button variant="outline" size="icon" onClick={copyCode} aria-label="Copy invite code">
          <Copy className="w-4 h-4" />
        </Button>
        {isOwner && (
          <Button
            variant="outline"
            size="icon"
            onClick={onRegen}
            disabled={regen.isPending}
            aria-label="Generate new invite code"
          >
            {regen.isPending ? <Loader2 className="w-4 h-4 animate-spin" /> : <RefreshCw className="w-4 h-4" />}
          </Button>
        )}
      </div>

      {isLoading ? (
        <div className="text-muted-foreground italic text-sm">Loading members…</div>
      ) : (
        <ul className="space-y-2">
          {members.map((m) => {
            const label = m.display_name || m.email || m.user_id.slice(0, 8);
            const isSelf = m.user_id === user?.id;
            return (
              <li key={m.user_id} className="flex items-center gap-3 p-2 rounded-md hover:bg-secondary/40">
                <span className="flex-1 truncate">
                  {label}
                  {isSelf && <span className="text-muted-foreground"> (you)</span>}
                </span>
                <Badge variant={m.role === "owner" ? "default" : "secondary"}>{m.role}</Badge>
                {isOwner && !isSelf && (
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setConfirmRemove({ userId: m.user_id, label })}
                    aria-label={`Remove ${label}`}
                  >
                    <UserMinus className="w-4 h-4 text-destructive" />
                  </Button>
                )}
                {!isOwner && isSelf && (
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setConfirmRemove({ userId: m.user_id, label: "yourself" })}
                    aria-label="Leave cellar"
                  >
                    <LogOut className="w-4 h-4 text-destructive" />
                  </Button>
                )}
              </li>
            );
          })}
        </ul>
      )}

      <AlertDialog open={!!confirmRemove} onOpenChange={(o) => !o && setConfirmRemove(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>
              {confirmRemove?.userId === user?.id ? "Leave this cellar?" : `Remove ${confirmRemove?.label}?`}
            </AlertDialogTitle>
            <AlertDialogDescription>
              {confirmRemove?.userId === user?.id
                ? "You will lose access to the shared bottles and history until you rejoin with an invite code."
                : "They will lose access to the shared cellar. Bottles and history stay untouched."}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={onRemove} className="bg-destructive text-destructive-foreground">
              Confirm
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </Card>
  );
};
