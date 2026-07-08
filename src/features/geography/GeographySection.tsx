import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Check, ChevronDown, ChevronRight, ChevronUp, Loader2, Pencil, Plus, Trash2, X,
} from "lucide-react";
import { toast } from "sonner";
import {
  useCountries, useRegions,
  useAddCountry, useAddRegion,
  useRenameGeoRow, useDeleteGeoRow, useReorderGeoRows,
} from "./queries";
import { useWines } from "@/features/wines/queries";

type EditState = { table: "countries" | "regions"; id: string; value: string } | null;
type DeleteState = { table: "countries" | "regions"; id: string; name: string; used: number } | null;

/**
 * Verwaltung der globalen Länder/Regionen (Sub-Regionen & Appellationen werden
 * über die Geo-Seeds gepflegt, Plan §5). Reihenfolge über ↑/↓ mit der
 * Batch-RPC statt Drag-and-drop — bewusst schlanker als v1.
 */
export const GeographySection = () => {
  const { data: countries = [], isLoading } = useCountries();
  const { data: regions = [] } = useRegions();
  const { data: wines = [] } = useWines();

  const addCountry = useAddCountry();
  const addRegion = useAddRegion();
  const renameCountry = useRenameGeoRow("countries");
  const renameRegion = useRenameGeoRow("regions");
  const deleteCountry = useDeleteGeoRow("countries");
  const deleteRegion = useDeleteGeoRow("regions");
  const reorderCountries = useReorderGeoRows("countries");
  const reorderRegions = useReorderGeoRows("regions");

  const [expanded, setExpanded] = useState<string | null>(null);
  const [editing, setEditing] = useState<EditState>(null);
  const [deleting, setDeleting] = useState<DeleteState>(null);
  const [newCountry, setNewCountry] = useState("");
  const [newRegion, setNewRegion] = useState("");

  const usedByCountry = (id: string) => wines.filter((w) => w.country_id === id).length;
  const usedByRegion = (id: string) => wines.filter((w) => w.region_id === id).length;

  const saveEdit = async () => {
    if (!editing) return;
    const mut = editing.table === "countries" ? renameCountry : renameRegion;
    try {
      await mut.mutateAsync({ id: editing.id, name: editing.value });
      toast.success("Renamed");
      setEditing(null);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not rename");
    }
  };

  const confirmDelete = async () => {
    if (!deleting) return;
    const mut = deleting.table === "countries" ? deleteCountry : deleteRegion;
    try {
      await mut.mutateAsync(deleting.id);
      toast.success("Removed");
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not remove");
    }
    setDeleting(null);
  };

  const move = async (
    table: "countries" | "regions",
    ids: string[],
    index: number,
    dir: -1 | 1,
  ) => {
    const target = index + dir;
    if (target < 0 || target >= ids.length) return;
    const next = [...ids];
    [next[index], next[target]] = [next[target], next[index]];
    const mut = table === "countries" ? reorderCountries : reorderRegions;
    try {
      await mut.mutateAsync(next);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not reorder");
    }
  };

  const countryIds = countries.map((c) => c.id);

  return (
    <Card className="p-6 gold-border bg-card/80 shadow-card">
      <div className="flex items-center justify-between mb-1">
        <h3 className="font-display text-2xl">Countries & regions</h3>
        <span className="text-xs text-muted-foreground">
          {countries.length} countries · {regions.length} regions
        </span>
      </div>
      <p className="text-sm text-muted-foreground italic mb-6">
        Shared reference data for everyone. Sub-regions and appellations are maintained
        via the geography dataset.
      </p>

      {isLoading ? (
        <div className="flex items-center justify-center py-12 text-muted-foreground italic">
          <Loader2 className="w-4 h-4 animate-spin mr-2" /> Loading…
        </div>
      ) : (
        <ul className="divide-y divide-primary/15 border border-primary/15 rounded-md">
          {countries.map((c, i) => {
            const isOpen = expanded === c.id;
            const childRegions = regions.filter((r) => r.country_id === c.id);
            const regionIds = childRegions.map((r) => r.id);
            const isEditingThis = editing?.table === "countries" && editing.id === c.id;
            return (
              <li key={c.id}>
                <div className="flex items-center gap-2 px-3 py-2.5">
                  <button
                    type="button"
                    onClick={() => setExpanded(isOpen ? null : c.id)}
                    className="p-1 text-muted-foreground hover:text-foreground"
                    aria-label={isOpen ? "Collapse" : "Expand"}
                  >
                    {isOpen ? <ChevronDown className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
                  </button>
                  <div className="flex-1 min-w-0">
                    {isEditingThis ? (
                      <Input
                        autoFocus
                        value={editing.value}
                        onChange={(e) => setEditing({ ...editing, value: e.target.value })}
                        onKeyDown={(e) => {
                          if (e.key === "Enter") saveEdit();
                          if (e.key === "Escape") setEditing(null);
                        }}
                        className="h-8 bg-input/50"
                      />
                    ) : (
                      <p className="font-body text-sm truncate">
                        {c.name}
                        <span className="text-[11px] text-muted-foreground ml-2">
                          {childRegions.length} regions · {usedByCountry(c.id)} bottles
                        </span>
                      </p>
                    )}
                  </div>
                  <div className="flex items-center gap-0.5 shrink-0">
                    {isEditingThis ? (
                      <>
                        <Button size="icon" variant="ghost" className="h-7 w-7" onClick={saveEdit}>
                          <Check className="w-4 h-4 text-primary" />
                        </Button>
                        <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => setEditing(null)}>
                          <X className="w-4 h-4" />
                        </Button>
                      </>
                    ) : (
                      <>
                        <Button size="icon" variant="ghost" className="h-7 w-7" disabled={i === 0} onClick={() => move("countries", countryIds, i, -1)} title="Move up">
                          <ChevronUp className="w-3.5 h-3.5" />
                        </Button>
                        <Button size="icon" variant="ghost" className="h-7 w-7" disabled={i === countries.length - 1} onClick={() => move("countries", countryIds, i, 1)} title="Move down">
                          <ChevronDown className="w-3.5 h-3.5" />
                        </Button>
                        <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => setEditing({ table: "countries", id: c.id, value: c.name })} title="Rename">
                          <Pencil className="w-3.5 h-3.5" />
                        </Button>
                        <Button
                          size="icon"
                          variant="ghost"
                          className="h-7 w-7 hover:text-destructive"
                          onClick={() => setDeleting({ table: "countries", id: c.id, name: c.name, used: usedByCountry(c.id) })}
                          title="Delete"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </Button>
                      </>
                    )}
                  </div>
                </div>

                {isOpen && (
                  <div className="pl-10 pr-3 pb-3 space-y-1">
                    {childRegions.map((r, ri) => {
                      const isEditingRegion = editing?.table === "regions" && editing.id === r.id;
                      return (
                        <div key={r.id} className="flex items-center gap-2 py-1">
                          <div className="flex-1 min-w-0">
                            {isEditingRegion ? (
                              <Input
                                autoFocus
                                value={editing.value}
                                onChange={(e) => setEditing({ ...editing, value: e.target.value })}
                                onKeyDown={(e) => {
                                  if (e.key === "Enter") saveEdit();
                                  if (e.key === "Escape") setEditing(null);
                                }}
                                className="h-7 bg-input/50 text-sm"
                              />
                            ) : (
                              <p className="text-sm text-muted-foreground truncate">
                                {r.name}
                                <span className="text-[10px] ml-2">{usedByRegion(r.id)} bottles</span>
                              </p>
                            )}
                          </div>
                          <div className="flex items-center gap-0.5 shrink-0">
                            {isEditingRegion ? (
                              <>
                                <Button size="icon" variant="ghost" className="h-6 w-6" onClick={saveEdit}>
                                  <Check className="w-3.5 h-3.5 text-primary" />
                                </Button>
                                <Button size="icon" variant="ghost" className="h-6 w-6" onClick={() => setEditing(null)}>
                                  <X className="w-3.5 h-3.5" />
                                </Button>
                              </>
                            ) : (
                              <>
                                <Button size="icon" variant="ghost" className="h-6 w-6" disabled={ri === 0} onClick={() => move("regions", regionIds, ri, -1)} title="Move up">
                                  <ChevronUp className="w-3 h-3" />
                                </Button>
                                <Button size="icon" variant="ghost" className="h-6 w-6" disabled={ri === childRegions.length - 1} onClick={() => move("regions", regionIds, ri, 1)} title="Move down">
                                  <ChevronDown className="w-3 h-3" />
                                </Button>
                                <Button size="icon" variant="ghost" className="h-6 w-6" onClick={() => setEditing({ table: "regions", id: r.id, value: r.name })} title="Rename">
                                  <Pencil className="w-3 h-3" />
                                </Button>
                                <Button
                                  size="icon"
                                  variant="ghost"
                                  className="h-6 w-6 hover:text-destructive"
                                  onClick={() => setDeleting({ table: "regions", id: r.id, name: r.name, used: usedByRegion(r.id) })}
                                  title="Delete"
                                >
                                  <Trash2 className="w-3 h-3" />
                                </Button>
                              </>
                            )}
                          </div>
                        </div>
                      );
                    })}
                    <div className="flex gap-2 pt-2">
                      <Input
                        placeholder="Add region…"
                        value={newRegion}
                        onChange={(e) => setNewRegion(e.target.value)}
                        onKeyDown={async (e) => {
                          if (e.key === "Enter" && newRegion.trim()) {
                            try {
                              await addRegion.mutateAsync({
                                country_id: c.id,
                                name: newRegion.trim(),
                                sort_order: childRegions.length,
                              });
                              setNewRegion("");
                            } catch (err) {
                              toast.error(err instanceof Error ? err.message : "Could not add");
                            }
                          }
                        }}
                        className="h-7 bg-input/50 text-sm"
                      />
                    </div>
                  </div>
                )}
              </li>
            );
          })}
        </ul>
      )}

      <div className="mt-6 pt-6 border-t border-primary/20">
        <p className="text-xs uppercase tracking-widest text-muted-foreground mb-2">Add a country</p>
        <div className="flex gap-2">
          <Input
            placeholder="e.g. Georgia"
            value={newCountry}
            onChange={(e) => setNewCountry(e.target.value)}
            onKeyDown={async (e) => {
              if (e.key === "Enter" && newCountry.trim()) {
                try {
                  await addCountry.mutateAsync({ name: newCountry.trim(), sort_order: countries.length });
                  setNewCountry("");
                } catch (err) {
                  toast.error(err instanceof Error ? err.message : "Could not add");
                }
              }
            }}
            className="bg-input/50"
          />
          <Button
            onClick={async () => {
              if (!newCountry.trim()) return;
              try {
                await addCountry.mutateAsync({ name: newCountry.trim(), sort_order: countries.length });
                setNewCountry("");
              } catch (err) {
                toast.error(err instanceof Error ? err.message : "Could not add");
              }
            }}
            disabled={addCountry.isPending || !newCountry.trim()}
          >
            {addCountry.isPending ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
            Add
          </Button>
        </div>
      </div>

      <AlertDialog open={!!deleting} onOpenChange={(o) => !o && setDeleting(null)}>
        <AlertDialogContent className="gold-border bg-card">
          <AlertDialogHeader>
            <AlertDialogTitle className="font-display">Remove "{deleting?.name}"?</AlertDialogTitle>
            <AlertDialogDescription>
              {deleting?.table === "countries"
                ? "All its regions, sub-regions and appellations are removed too (shared with all members)."
                : "Its sub-regions and appellations are removed too (shared with all members)."}
              {deleting && deleting.used > 0 && (
                <span className="block mt-2 text-destructive">
                  ⚠ {deleting.used} {deleting.used === 1 ? "bottle references" : "bottles reference"} this
                  entry — their link will be cleared (bottles stay in the cellar).
                </span>
              )}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={confirmDelete} className="bg-destructive">Remove</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </Card>
  );
};
