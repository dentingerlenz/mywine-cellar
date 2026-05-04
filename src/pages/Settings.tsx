import { useState } from "react";
import { Link } from "react-router-dom";
import { useWines } from "@/hooks/useWines";
import {
  useWineColours,
  useAddWineColour,
  useRenameWineColour,
  useDeleteWineColour,
  WineColourRow,
} from "@/hooks/useWineColours";
import { colourClassFor } from "@/contexts/WineColoursContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { ArrowLeft, Pencil, Trash2, Plus, Check, X, Settings as SettingsIcon, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { cn } from "@/lib/utils";
import { CountriesRegionsSection } from "@/components/CountriesRegionsSection";
import { PeopleSection } from "@/components/PeopleSection";

export default function Settings() {
  const { data: colours = [], isLoading } = useWineColours();
  const { data: wines = [] } = useWines();
  const addMut = useAddWineColour();
  const renameMut = useRenameWineColour();
  const deleteMut = useDeleteWineColour();

  const [editingId, setEditingId] = useState<string | null>(null);
  const [editingValue, setEditingValue] = useState("");
  const [newName, setNewName] = useState("");
  const [deleteTarget, setDeleteTarget] = useState<WineColourRow | null>(null);

  const countFor = (name: string) =>
    wines.filter((w) => w.colour === name).length;

  const startEdit = (c: WineColourRow) => {
    setEditingId(c.id);
    setEditingValue(c.display_name);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditingValue("");
  };

  const saveEdit = async () => {
    if (!editingId) return;
    const trimmed = editingValue.trim();
    if (!trimmed) {
      toast.error("Name cannot be empty");
      return;
    }
    try {
      await renameMut.mutateAsync({ id: editingId, display_name: trimmed });
      toast.success("Category renamed");
      cancelEdit();
    } catch (e: any) {
      toast.error(e.message ?? "Could not rename");
    }
  };

  const handleAdd = async () => {
    const trimmed = newName.trim();
    if (!trimmed) return;
    try {
      await addMut.mutateAsync(trimmed);
      toast.success("Category added");
      setNewName("");
    } catch (e: any) {
      toast.error(e.message ?? "Could not add category");
    }
  };

  const confirmDelete = async () => {
    if (!deleteTarget) return;
    try {
      await deleteMut.mutateAsync(deleteTarget.id);
      toast.success("Category removed");
    } catch (e: any) {
      toast.error(e.message ?? "Could not remove category");
    }
    setDeleteTarget(null);
  };

  const deleteAffected = deleteTarget ? countFor(deleteTarget.name) : 0;

  return (
    <div className="min-h-screen">
      <header className="border-b border-primary/20 backdrop-blur bg-background/70 sticky top-0 z-40">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <SettingsIcon className="w-6 h-6 text-primary" strokeWidth={1.5} />
            <h1 className="font-display text-2xl tracking-tight">Settings</h1>
          </div>
          <Button variant="ghost" size="sm" asChild>
            <Link to="/"><ArrowLeft className="w-4 h-4" /> Back to cellar</Link>
          </Button>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8 max-w-3xl">
        <div className="mb-8">
          <h2 className="font-display text-4xl md:text-5xl tracking-tight">Preferences</h2>
          <p className="text-muted-foreground italic mt-1">Tailor your cellar's vocabulary.</p>
        </div>

        <Card className="p-6 gold-border bg-card/80 shadow-card">
          <div className="flex items-center justify-between mb-1">
            <h3 className="font-display text-2xl">Wine categories</h3>
            <span className="text-xs text-muted-foreground">{colours.length} {colours.length === 1 ? "category" : "categories"}</span>
          </div>
          <p className="text-sm text-muted-foreground italic mb-6">
            Rename, add, or remove colour categories. Changes apply across cards, filters and the dashboard.
          </p>

          {isLoading ? (
            <div className="flex items-center justify-center py-12 text-muted-foreground italic">
              <Loader2 className="w-4 h-4 animate-spin mr-2" /> Loading…
            </div>
          ) : (
            <ul className="divide-y divide-primary/15 border border-primary/15 rounded-md">
              {colours.map((c) => {
                const count = countFor(c.name);
                const isEditing = editingId === c.id;
                return (
                  <li key={c.id} className="flex items-center gap-3 px-4 py-3">
                    <Badge className={cn("font-body text-[10px] uppercase tracking-wider shrink-0", colourClassFor(c.name))}>
                      {c.display_name}
                    </Badge>
                    <div className="flex-1 min-w-0">
                      {isEditing ? (
                        <Input
                          autoFocus
                          value={editingValue}
                          onChange={(e) => setEditingValue(e.target.value)}
                          onKeyDown={(e) => {
                            if (e.key === "Enter") saveEdit();
                            if (e.key === "Escape") cancelEdit();
                          }}
                          className="h-8 bg-input/50"
                        />
                      ) : (
                        <div>
                          <p className="font-body text-sm text-foreground truncate">{c.display_name}</p>
                          <p className="text-[11px] text-muted-foreground font-mono">
                            {c.name} · {count} {count === 1 ? "bottle" : "bottles"}
                          </p>
                        </div>
                      )}
                    </div>
                    <div className="flex items-center gap-1 shrink-0">
                      {isEditing ? (
                        <>
                          <Button size="icon" variant="ghost" className="h-8 w-8" onClick={saveEdit} disabled={renameMut.isPending} title="Save">
                            <Check className="w-4 h-4 text-primary" />
                          </Button>
                          <Button size="icon" variant="ghost" className="h-8 w-8" onClick={cancelEdit} title="Cancel">
                            <X className="w-4 h-4" />
                          </Button>
                        </>
                      ) : (
                        <>
                          <Button size="icon" variant="ghost" className="h-8 w-8" onClick={() => startEdit(c)} title="Rename">
                            <Pencil className="w-3.5 h-3.5" />
                          </Button>
                          <Button
                            size="icon"
                            variant="ghost"
                            className="h-8 w-8 hover:text-destructive"
                            onClick={() => setDeleteTarget(c)}
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
              {colours.length === 0 && (
                <li className="px-4 py-6 text-center text-muted-foreground italic text-sm">
                  No categories yet.
                </li>
              )}
            </ul>
          )}

          <div className="mt-6 pt-6 border-t border-primary/20">
            <p className="text-xs uppercase tracking-widest text-muted-foreground mb-2">Add a category</p>
            <div className="flex gap-2">
              <Input
                placeholder="e.g. Natural, Pet-Nat, Orange…"
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
          </div>
        </Card>

        <div className="mt-6">
          <CountriesRegionsSection />
        </div>

        <div className="mt-6">
          <PeopleSection />
        </div>
      </main>

      <AlertDialog open={!!deleteTarget} onOpenChange={(o) => !o && setDeleteTarget(null)}>
        <AlertDialogContent className="gold-border bg-card">
          <AlertDialogHeader>
            <AlertDialogTitle className="font-display">Remove this category?</AlertDialogTitle>
            <AlertDialogDescription>
              {deleteTarget && (
                <>
                  Remove <span className="text-foreground font-medium">"{deleteTarget.display_name}"</span> from your categories.
                  {deleteAffected > 0 ? (
                    <span className="block mt-2 text-destructive">
                      ⚠ {deleteAffected} {deleteAffected === 1 ? "bottle is" : "bottles are"} currently assigned to this category.
                      They will remain in your cellar but will need to be reassigned to a different category.
                    </span>
                  ) : (
                    <span className="block mt-2">No bottles are currently assigned to this category.</span>
                  )}
                </>
              )}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={confirmDelete} className="bg-destructive">Remove</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
