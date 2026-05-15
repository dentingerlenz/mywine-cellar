import { useState, useMemo } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { useWines, useDeleteWine } from "@/hooks/useWines";
import { Wine, wineTitle } from "@/lib/wine";
import { WineCard } from "@/components/WineCard";
import { WineListRow } from "@/components/WineListRow";
import { WineFormDialog } from "@/components/WineFormDialog";
import { WineDetailDialog } from "@/components/WineDetailDialog";
import { OpenBottleDialog } from "@/components/OpenBottleDialog";
import { Dashboard } from "@/components/Dashboard";
import { FilterBar, applyFilters, emptyFilters, Filters, SortKey } from "@/components/FilterBar";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ToggleGroup, ToggleGroupItem } from "@/components/ui/toggle-group";
import {
  Plus,
  LogOut,
  Wine as WineIcon,
  Upload,
  LayoutGrid,
  List,
  Settings as SettingsIcon,
  BookOpen,
} from "lucide-react";
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
import { toast } from "sonner";

export default function Cellar() {
  const { user, signOut } = useAuth();
  const { data: wines = [], isLoading } = useWines();
  const del = useDeleteWine();
  const [filters, setFilters] = useState<Filters>(emptyFilters);
  const [view, setView] = useState<"grid" | "list">("grid");
  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState<Wine | null>(null);
  const [detail, setDetail] = useState<Wine | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<Wine | null>(null);
  const [openingBottle, setOpeningBottle] = useState<Wine | null>(null);

  const filtered = useMemo(() => applyFilters(wines, filters), [wines, filters]);

  const onAdd = () => {
    setEditing(null);
    setFormOpen(true);
  };
  const onEdit = (b: Wine) => {
    setDetail(null);
    setEditing(b);
    setFormOpen(true);
  };
  const onOpenDetail = (b: Wine) => setDetail(b);

  const confirmDelete = async () => {
    if (!deleteTarget) return;
    try {
      await del.mutateAsync(deleteTarget.id);
      toast.success("Bottle removed");
      setDetail(null);
    } catch (e: any) {
      toast.error(e.message);
    }
    setDeleteTarget(null);
  };

  return (
    <div className="min-h-screen">
      <header className="border-b border-primary/20 backdrop-blur bg-background/70 sticky top-0 z-40">
        <div className="container mx-auto px-1 py-1 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <img src="/LogoDesign1.png" alt="" className="h-12 sm:h-[80px] w-auto" />
            <img src="/LogoText.png" alt="Cave" className="h-6 sm:h-[40px] w-auto object-scale-down" />
          </div>
          <div className="flex items-center gap-2">
            <span className="hidden sm:inline text-xs text-muted-foreground italic">{user?.email}</span>
            <Button variant="ghost" size="icon" className="sm:size-auto sm:px-3" asChild title="History">
              <Link to="/history">
                <BookOpen className="w-4 h-4" /> <span className="hidden sm:inline">History</span>
              </Link>
            </Button>
            <Button variant="ghost" size="icon" className="sm:size-auto sm:px-3" asChild title="Import">
              <Link to="/import">
                <Upload className="w-4 h-4" /> <span className="hidden sm:inline">Import</span>
              </Link>
            </Button>
            <Button onClick={onAdd} size="icon" className="sm:size-auto sm:px-3" title="Add bottle">
              <Plus className="w-4 h-4" /> <span className="hidden sm:inline">Add bottle</span>
            </Button>
            <Button variant="ghost" size="icon" asChild title="Settings">
              <Link to="/settings">
                <SettingsIcon className="w-4 h-4" />
              </Link>
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

        {wines.length > 0 && <Dashboard wines={wines} />}

        {wines.length > 0 && <FilterBar filters={filters} setFilters={setFilters} wines={wines} />}

        {wines.length > 0 && (
          <div className="flex justify-end items-center gap-2 mb-4">
            <Select value={filters.sort} onValueChange={(v) => setFilters({ ...filters, sort: v as SortKey })}>
              <SelectTrigger className="w-[180px] bg-card/40">
                <SelectValue placeholder="Sort" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="producer">Producer (A–Z)</SelectItem>
                <SelectItem value="added">Recently added</SelectItem>
                <SelectItem value="vintage">Vintage</SelectItem>
                <SelectItem value="region">Region</SelectItem>
                <SelectItem value="price">Price</SelectItem>
              </SelectContent>
            </Select>
            <ToggleGroup
              type="single"
              value={view}
              onValueChange={(v) => v && setView(v as "grid" | "list")}
              className="border border-primary/30 rounded-md bg-card/40"
            >
              <ToggleGroupItem
                value="grid"
                aria-label="Grid view"
                className="data-[state=on]:bg-primary/20 data-[state=on]:text-primary"
              >
                <LayoutGrid className="w-4 h-4" />
              </ToggleGroupItem>
              <ToggleGroupItem
                value="list"
                aria-label="List view"
                className="data-[state=on]:bg-primary/20 data-[state=on]:text-primary"
              >
                <List className="w-4 h-4" />
              </ToggleGroupItem>
            </ToggleGroup>
          </div>
        )}

        {isLoading ? (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3">
            {Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="aspect-[3/4] rounded-lg bg-card/40 animate-pulse" />
            ))}
          </div>
        ) : wines.length === 0 ? (
          <div className="text-center py-20 gold-border rounded-lg bg-card/40">
            <WineIcon className="w-16 h-16 text-primary/50 mx-auto mb-4" strokeWidth={1.2} />
            <h3 className="font-display text-2xl mb-2">Your cellar is empty</h3>
            <p className="text-muted-foreground italic mb-6">Time to stock up.</p>
            <div className="flex gap-2 justify-center">
              <Button onClick={onAdd}>
                <Plus className="w-4 h-4" /> Add a bottle
              </Button>
              <Button variant="outline" asChild>
                <Link to="/import">
                  <Upload className="w-4 h-4" /> Import CSV
                </Link>
              </Button>
            </div>
          </div>
        ) : filtered.length === 0 ? (
          <div className="text-center py-16 text-muted-foreground italic">No bottles match these filters.</div>
        ) : view === "grid" ? (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3">
            {filtered.map((w) => (
              <WineCard
                key={w.id}
                wine={w}
                onOpen={onOpenDetail}
                onEdit={onEdit}
                onDelete={(b) => setDeleteTarget(b)}
                onOpenBottle={(b) => setOpeningBottle(b)}
              />
            ))}
          </div>
        ) : (
          <div className="gold-border rounded-lg bg-card/40 overflow-hidden">
            <Table>
              <TableHeader>
                <TableRow className="border-primary/20 hover:bg-transparent">
                  <TableHead>Colour</TableHead>
                  <TableHead>Producer</TableHead>
                  <TableHead>Description</TableHead>
                  <TableHead>Vintage</TableHead>
                  <TableHead>Region</TableHead>
                  <TableHead>Variety</TableHead>
                  <TableHead className="text-center">Qty</TableHead>
                  <TableHead className="text-right">Price</TableHead>
                  <TableHead className="w-12"></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filtered.map((w) => (
                  <WineListRow
                    key={w.id}
                    wine={w}
                    onOpen={onOpenDetail}
                    onEdit={onEdit}
                    onDelete={(b) => setDeleteTarget(b)}
                    onOpenBottle={(b) => setOpeningBottle(b)}
                  />
                ))}
              </TableBody>
            </Table>
          </div>
        )}
      </main>

      <WineFormDialog open={formOpen} onOpenChange={setFormOpen} wine={editing} />

      <OpenBottleDialog
        wine={openingBottle}
        open={!!openingBottle}
        onOpenChange={(o) => !o && setOpeningBottle(null)}
      />

      <WineDetailDialog
        wine={detail}
        open={!!detail}
        onOpenChange={(o) => !o && setDetail(null)}
        onEdit={onEdit}
        onDelete={(b) => setDeleteTarget(b)}
      />

      <AlertDialog open={!!deleteTarget} onOpenChange={(o) => !o && setDeleteTarget(null)}>
        <AlertDialogContent className="gold-border bg-card">
          <AlertDialogHeader>
            <AlertDialogTitle className="font-display">Remove this bottle?</AlertDialogTitle>
            <AlertDialogDescription>
              {deleteTarget ? `Remove "${wineTitle(deleteTarget)}" from your cellar? This cannot be undone.` : ""}
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
    </div>
  );
}
