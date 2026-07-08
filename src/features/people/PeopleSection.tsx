import { useState } from "react";
import {
  usePeople, useAddPerson, useUpdatePerson, useDeletePerson,
  PERSON_EMOJI_OPTIONS, type Person,
} from "./queries";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card } from "@/components/ui/card";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Pencil, Trash2, Plus, Check, X, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

const EmojiPicker = ({ value, onChange }: { value: string; onChange: (v: string) => void }) => (
  <div className="grid grid-cols-8 gap-1">
    {PERSON_EMOJI_OPTIONS.map((e) => (
      <button
        key={e}
        type="button"
        onClick={() => onChange(e)}
        className={cn(
          "h-9 w-9 flex items-center justify-center rounded-md text-xl transition",
          value === e ? "bg-primary/20 ring-1 ring-primary" : "hover:bg-secondary",
        )}
      >
        {e}
      </button>
    ))}
  </div>
);

export const PeopleSection = () => {
  const { data: people = [], isLoading } = usePeople();
  const addMut = useAddPerson();
  const updateMut = useUpdatePerson();
  const deleteMut = useDeletePerson();

  const [newName, setNewName] = useState("");
  const [newAvatar, setNewAvatar] = useState<string>(PERSON_EMOJI_OPTIONS[0]);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editingName, setEditingName] = useState("");
  const [editingAvatar, setEditingAvatar] = useState<string>(PERSON_EMOJI_OPTIONS[0]);
  const [deleteTarget, setDeleteTarget] = useState<Person | null>(null);

  const handleAdd = async () => {
    const trimmed = newName.trim();
    if (!trimmed) return;
    try {
      await addMut.mutateAsync({ name: trimmed, avatar: newAvatar });
      toast.success("Person added");
      setNewName("");
      setNewAvatar(PERSON_EMOJI_OPTIONS[0]);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not add person");
    }
  };

  const startEdit = (p: Person) => {
    setEditingId(p.id);
    setEditingName(p.name);
    setEditingAvatar(p.avatar || PERSON_EMOJI_OPTIONS[0]);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditingName("");
  };

  const saveEdit = async () => {
    if (!editingId) return;
    const trimmed = editingName.trim();
    if (!trimmed) {
      toast.error("Name cannot be empty");
      return;
    }
    try {
      await updateMut.mutateAsync({ id: editingId, name: trimmed, avatar: editingAvatar });
      toast.success("Person updated");
      cancelEdit();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not update");
    }
  };

  const confirmDelete = async () => {
    if (!deleteTarget) return;
    try {
      await deleteMut.mutateAsync(deleteTarget.id);
      toast.success("Person removed");
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not remove");
    }
    setDeleteTarget(null);
  };

  return (
    <Card className="p-6 gold-border bg-card/80 shadow-card">
      <div className="flex items-center justify-between mb-1">
        <h3 className="font-display text-2xl">People</h3>
        <span className="text-xs text-muted-foreground">
          {people.length} {people.length === 1 ? "person" : "people"}
        </span>
      </div>
      <p className="text-sm text-muted-foreground italic mb-6">
        Track companions, hosts, or anyone tied to your bottles.
      </p>

      {isLoading ? (
        <div className="flex items-center justify-center py-12 text-muted-foreground italic">
          <Loader2 className="w-4 h-4 animate-spin mr-2" /> Loading…
        </div>
      ) : (
        <ul className="divide-y divide-primary/15 border border-primary/15 rounded-md">
          {people.map((p) => {
            const isEditing = editingId === p.id;
            return (
              <li key={p.id} className="flex items-start gap-3 px-4 py-3">
                <div className="flex-1 min-w-0">
                  {isEditing ? (
                    <div className="space-y-2">
                      <Input
                        autoFocus
                        value={editingName}
                        onChange={(e) => setEditingName(e.target.value)}
                        onKeyDown={(e) => {
                          if (e.key === "Enter") saveEdit();
                          if (e.key === "Escape") cancelEdit();
                        }}
                        className="h-8 bg-input/50"
                      />
                      <EmojiPicker value={editingAvatar} onChange={setEditingAvatar} />
                    </div>
                  ) : (
                    <div className="flex items-center gap-3">
                      <span className="text-2xl shrink-0">{p.avatar || "👤"}</span>
                      <p className="font-body text-sm text-foreground truncate">{p.name}</p>
                    </div>
                  )}
                </div>
                <div className="flex items-center gap-1 shrink-0">
                  {isEditing ? (
                    <>
                      <Button size="icon" variant="ghost" className="h-8 w-8" onClick={saveEdit} disabled={updateMut.isPending} title="Save">
                        <Check className="w-4 h-4 text-primary" />
                      </Button>
                      <Button size="icon" variant="ghost" className="h-8 w-8" onClick={cancelEdit} title="Cancel">
                        <X className="w-4 h-4" />
                      </Button>
                    </>
                  ) : (
                    <>
                      <Button size="icon" variant="ghost" className="h-8 w-8" onClick={() => startEdit(p)} title="Rename">
                        <Pencil className="w-3.5 h-3.5" />
                      </Button>
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-8 w-8 hover:text-destructive"
                        onClick={() => setDeleteTarget(p)}
                        title="Delete"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </Button>
                    </>
                  )}
                </div>
              </li>
            );
          })}
          {people.length === 0 && (
            <li className="px-4 py-6 text-center text-muted-foreground italic text-sm">
              No people yet.
            </li>
          )}
        </ul>
      )}

      <div className="mt-6 pt-6 border-t border-primary/20 space-y-3">
        <p className="text-xs uppercase tracking-widest text-muted-foreground">Add a person</p>
        <div className="flex gap-2">
          <Input
            placeholder="Name"
            value={newName}
            onChange={(e) => setNewName(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") handleAdd();
            }}
            className="bg-input/50"
          />
          <Button onClick={handleAdd} disabled={addMut.isPending || !newName.trim()}>
            {addMut.isPending ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
            Add
          </Button>
        </div>
        <div>
          <p className="text-[11px] text-muted-foreground mb-1">Avatar</p>
          <EmojiPicker value={newAvatar} onChange={setNewAvatar} />
        </div>
      </div>

      <AlertDialog open={!!deleteTarget} onOpenChange={(o) => !o && setDeleteTarget(null)}>
        <AlertDialogContent className="gold-border bg-card">
          <AlertDialogHeader>
            <AlertDialogTitle className="font-display">Remove this person?</AlertDialogTitle>
            <AlertDialogDescription>
              {deleteTarget && (
                <>
                  Remove{" "}
                  <span className="text-foreground font-medium">
                    {deleteTarget.avatar} {deleteTarget.name}
                  </span>{" "}
                  from your people list. They also disappear from past log entries.
                </>
              )}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={confirmDelete} className="bg-destructive">
              Remove
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </Card>
  );
};
