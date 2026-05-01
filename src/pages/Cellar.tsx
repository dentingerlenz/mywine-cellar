import { useState, useMemo } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { useBottles, useDeleteBottle } from "@/hooks/useBottles";
import { Bottle } from "@/lib/wine";
import { BottleCard } from "@/components/BottleCard";
import { BottleFormDialog } from "@/components/BottleFormDialog";
import { Dashboard } from "@/components/Dashboard";
import { FilterBar, applyFilters, emptyFilters, Filters } from "@/components/FilterBar";
import { Button } from "@/components/ui/button";
import { Plus, LogOut, Wine, Upload } from "lucide-react";
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle } from "@/components/ui/alert-dialog";
import { toast } from "sonner";

export default function Cellar() {
  const { user, signOut } = useAuth();
  const { data: bottles = [], isLoading } = useBottles();
  const del = useDeleteBottle();
  const [filters, setFilters] = useState<Filters>(emptyFilters);
  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState<Bottle | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<Bottle | null>(null);

  const filtered = useMemo(() => applyFilters(bottles, filters), [bottles, filters]);

  const onAdd = () => { setEditing(null); setFormOpen(true); };
  const onEdit = (b: Bottle) => { setEditing(b); setFormOpen(true); };

  const confirmDelete = async () => {
    if (!deleteTarget) return;
    try {
      await del.mutateAsync(deleteTarget.id);
      toast.success("Bottle removed");
    } catch (e: any) {
      toast.error(e.message);
    }
    setDeleteTarget(null);
  };

  return (
    <div className="min-h-screen">
      <header className="border-b border-primary/20 backdrop-blur bg-background/70 sticky top-0 z-40">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Wine className="w-6 h-6 text-primary" strokeWidth={1.5} />
            <h1 className="font-display text-2xl tracking-tight">Cave</h1>
          </div>
          <div className="flex items-center gap-2">
            <span className="hidden sm:inline text-xs text-muted-foreground italic">{user?.email}</span>
            <Button variant="ghost" size="sm" asChild>
              <Link to="/import"><Upload className="w-4 h-4" /> Import</Link>
            </Button>
            <Button onClick={onAdd} size="sm">
              <Plus className="w-4 h-4" /> Add bottle
            </Button>
            <Button variant="ghost" size="icon" onClick={() => signOut()} title="Sign out">
              <LogOut className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h2 className="font-display text-4xl md:text-5xl tracking-tight">Your cellar</h2>
          <p className="text-muted-foreground italic mt-1">A living record of every bottle.</p>
        </div>

        {bottles.length > 0 && <Dashboard bottles={bottles} />}

        {bottles.length > 0 && <FilterBar filters={filters} setFilters={setFilters} bottles={bottles} />}

        {isLoading ? (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="aspect-[3/4] rounded-lg bg-card/40 animate-pulse" />
            ))}
          </div>
        ) : bottles.length === 0 ? (
          <div className="text-center py-20 gold-border rounded-lg bg-card/40">
            <Wine className="w-16 h-16 text-primary/50 mx-auto mb-4" strokeWidth={1.2} />
            <h3 className="font-display text-2xl mb-2">Your cellar is empty</h3>
            <p className="text-muted-foreground italic mb-6">Time to stock up.</p>
            <div className="flex gap-2 justify-center">
              <Button onClick={onAdd}><Plus className="w-4 h-4" /> Add a bottle</Button>
              <Button variant="outline" asChild><Link to="/import"><Upload className="w-4 h-4" /> Import CSV</Link></Button>
            </div>
          </div>
        ) : filtered.length === 0 ? (
          <div className="text-center py-16 text-muted-foreground italic">No bottles match these filters.</div>
        ) : (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
            {filtered.map((b) => (
              <BottleCard key={b.id} bottle={b} onEdit={onEdit} onDelete={(b) => setDeleteTarget(b)} />
            ))}
          </div>
        )}
      </main>

      <BottleFormDialog open={formOpen} onOpenChange={setFormOpen} bottle={editing} />

      <AlertDialog open={!!deleteTarget} onOpenChange={(o) => !o && setDeleteTarget(null)}>
        <AlertDialogContent className="gold-border bg-card">
          <AlertDialogHeader>
            <AlertDialogTitle className="font-display">Remove this bottle?</AlertDialogTitle>
            <AlertDialogDescription>
              "{deleteTarget?.name}" will be removed from your cellar. This cannot be undone.
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
