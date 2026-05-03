import { useState, useEffect } from "react";
import {
  DndContext,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  DragEndEvent,
} from "@dnd-kit/core";
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  useSortable,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import {
  useWineCountries,
  useWineRegions,
  useSeedGeographyFromWines,
  useAddWineCountry,
  useRenameWineCountry,
  useDeleteWineCountry,
  useReorderWineCountries,
  useAddWineRegion,
  useRenameWineRegion,
  useDeleteWineRegion,
  useReorderWineRegions,
  WineCountryRow,
  WineRegionRow,
} from "@/hooks/useWineGeography";
import { useWines } from "@/hooks/useWines";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card } from "@/components/ui/card";
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
import {
  Pencil,
  Trash2,
  Plus,
  Check,
  X,
  Loader2,
  GripVertical,
  ChevronRight,
  ChevronDown,
} from "lucide-react";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

type DeleteTarget =
  | { type: "country"; row: WineCountryRow; affected: number }
  | { type: "region"; row: WineRegionRow; affected: number };

const RegionRow = ({
  region,
  affected,
  isFirst,
  isLast,
  onMoveUp,
  onMoveDown,
  onRename,
  onDelete,
  renaming,
}: {
  region: WineRegionRow;
  affected: number;
  isFirst: boolean;
  isLast: boolean;
  onMoveUp: () => void;
  onMoveDown: () => void;
  onRename: (name: string) => Promise<void>;
  onDelete: () => void;
  renaming: boolean;
}) => {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } = useSortable({
    id: region.id,
  });
  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  const [editing, setEditing] = useState(false);
  const [value, setValue] = useState(region.name);

  const start = () => {
    setValue(region.name);
    setEditing(true);
  };
  const cancel = () => setEditing(false);
  const save = async () => {
    const t = value.trim();
    if (!t) return toast.error("Name cannot be empty");
    try {
      await onRename(t);
      setEditing(false);
    } catch (e: any) {
      toast.error(e.message ?? "Could not rename");
    }
  };

  return (
    <li
      ref={setNodeRef}
      style={style}
      className="flex items-center gap-2 pl-10 pr-3 py-2 border-t border-primary/10 bg-background/30"
    >
      <button
        type="button"
        className="touch-none cursor-grab active:cursor-grabbing text-muted-foreground hover:text-foreground"
        {...attributes}
        {...listeners}
        aria-label="Drag region"
      >
        <GripVertical className="w-4 h-4" />
      </button>
      <div className="flex-1 min-w-0">
        {editing ? (
          <Input
            autoFocus
            value={value}
            onChange={(e) => setValue(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") save();
              if (e.key === "Escape") cancel();
            }}
            className="h-8 bg-input/50"
          />
        ) : (
          <div>
            <p className="text-sm text-foreground truncate">{region.name}</p>
            <p className="text-[11px] text-muted-foreground">
              {affected} {affected === 1 ? "bottle" : "bottles"}
            </p>
          </div>
        )}
      </div>
      <div className="flex items-center gap-0.5 shrink-0">
        {editing ? (
          <>
            <Button size="icon" variant="ghost" className="h-7 w-7" onClick={save} disabled={renaming} title="Save">
              <Check className="w-3.5 h-3.5 text-primary" />
            </Button>
            <Button size="icon" variant="ghost" className="h-7 w-7" onClick={cancel} title="Cancel">
              <X className="w-3.5 h-3.5" />
            </Button>
          </>
        ) : (
          <>
            <Button size="icon" variant="ghost" className="h-7 w-7" onClick={start} title="Rename">
              <Pencil className="w-3.5 h-3.5" />
            </Button>
            <Button
              size="icon"
              variant="ghost"
              className="h-7 w-7 hover:text-destructive"
              onClick={onDelete}
              title="Delete"
            >
              <Trash2 className="w-3.5 h-3.5" />
            </Button>
          </>
        )}
      </div>
    </li>
  );
};

const CountryItem = ({
  country,
  regions,
  countryAffected,
  regionAffected,
  expanded,
  onToggleExpanded,
  isFirst,
  isLast,
  onMoveUp,
  onMoveDown,
  onRenameCountry,
  onDeleteCountry,
  onAddRegion,
  onRenameRegion,
  onDeleteRegion,
  onReorderRegions,
  renamingCountry,
  addingRegion,
  renamingRegion,
}: {
  country: WineCountryRow;
  regions: WineRegionRow[];
  countryAffected: number;
  regionAffected: (regionId: string) => number;
  expanded: boolean;
  onToggleExpanded: () => void;
  isFirst: boolean;
  isLast: boolean;
  onMoveUp: () => void;
  onMoveDown: () => void;
  onRenameCountry: (name: string) => Promise<void>;
  onDeleteCountry: () => void;
  onAddRegion: (name: string) => Promise<void>;
  onRenameRegion: (id: string, name: string) => Promise<void>;
  onDeleteRegion: (region: WineRegionRow) => void;
  onReorderRegions: (orderedIds: string[]) => void;
  renamingCountry: boolean;
  addingRegion: boolean;
  renamingRegion: boolean;
}) => {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } = useSortable({
    id: country.id,
  });
  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  const [editing, setEditing] = useState(false);
  const [value, setValue] = useState(country.name);
  const [newRegion, setNewRegion] = useState("");

  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates }),
  );

  const startEdit = () => {
    setValue(country.name);
    setEditing(true);
  };
  const cancelEdit = () => setEditing(false);
  const saveEdit = async () => {
    const t = value.trim();
    if (!t) return toast.error("Name cannot be empty");
    try {
      await onRenameCountry(t);
      setEditing(false);
    } catch (e: any) {
      toast.error(e.message ?? "Could not rename");
    }
  };

  const handleAddRegion = async () => {
    const t = newRegion.trim();
    if (!t) return;
    try {
      await onAddRegion(t);
      setNewRegion("");
      toast.success("Region added");
    } catch (e: any) {
      toast.error(e.message ?? "Could not add region");
    }
  };

  const onRegionDragEnd = (e: DragEndEvent) => {
    const { active, over } = e;
    if (!over || active.id === over.id) return;
    const oldIndex = regions.findIndex((r) => r.id === active.id);
    const newIndex = regions.findIndex((r) => r.id === over.id);
    if (oldIndex < 0 || newIndex < 0) return;
    const reordered = arrayMove(regions, oldIndex, newIndex);
    onReorderRegions(reordered.map((r) => r.id));
  };

  const moveRegion = (idx: number, dir: -1 | 1) => {
    const target = idx + dir;
    if (target < 0 || target >= regions.length) return;
    const reordered = arrayMove(regions, idx, target);
    onReorderRegions(reordered.map((r) => r.id));
  };

  return (
    <li ref={setNodeRef} style={style} className="bg-card/40">
      <div className="flex items-center gap-2 px-3 py-2.5">
        <button
          type="button"
          className="touch-none cursor-grab active:cursor-grabbing text-muted-foreground hover:text-foreground"
          {...attributes}
          {...listeners}
          aria-label="Drag country"
        >
          <GripVertical className="w-4 h-4" />
        </button>
        <button
          type="button"
          onClick={onToggleExpanded}
          className="text-muted-foreground hover:text-foreground"
          aria-label={expanded ? "Collapse" : "Expand"}
        >
          {expanded ? <ChevronDown className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
        </button>
        <div className="flex-1 min-w-0">
          {editing ? (
            <Input
              autoFocus
              value={value}
              onChange={(e) => setValue(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") saveEdit();
                if (e.key === "Escape") cancelEdit();
              }}
              className="h-8 bg-input/50"
            />
          ) : (
            <div>
              <p className="font-display text-base text-foreground truncate">{country.name}</p>
              <p className="text-[11px] text-muted-foreground">
                {regions.length} {regions.length === 1 ? "region" : "regions"} · {countryAffected}{" "}
                {countryAffected === 1 ? "bottle" : "bottles"}
              </p>
            </div>
          )}
        </div>
        <div className="flex items-center gap-0.5 shrink-0">
          {editing ? (
            <>
              <Button size="icon" variant="ghost" className="h-8 w-8" onClick={saveEdit} disabled={renamingCountry} title="Save">
                <Check className="w-4 h-4 text-primary" />
              </Button>
              <Button size="icon" variant="ghost" className="h-8 w-8" onClick={cancelEdit} title="Cancel">
                <X className="w-4 h-4" />
              </Button>
            </>
          ) : (
            <>
              <Button size="icon" variant="ghost" className="h-8 w-8" onClick={startEdit} title="Rename">
                <Pencil className="w-3.5 h-3.5" />
              </Button>
              <Button
                size="icon"
                variant="ghost"
                className="h-8 w-8 hover:text-destructive"
                onClick={onDeleteCountry}
                title="Delete"
              >
                <Trash2 className="w-3.5 h-3.5" />
              </Button>
            </>
          )}
        </div>
      </div>

      {expanded && (
        <div className="border-t border-primary/15">
          {regions.length === 0 ? (
            <p className="px-10 py-3 text-xs italic text-muted-foreground">No regions yet.</p>
          ) : (
            <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={onRegionDragEnd}>
              <SortableContext items={regions.map((r) => r.id)} strategy={verticalListSortingStrategy}>
                <ul>
                  {regions.map((r, idx) => (
                    <RegionRow
                      key={r.id}
                      region={r}
                      affected={regionAffected(r.id)}
                      isFirst={idx === 0}
                      isLast={idx === regions.length - 1}
                      onMoveUp={() => moveRegion(idx, -1)}
                      onMoveDown={() => moveRegion(idx, 1)}
                      onRename={(name) => onRenameRegion(r.id, name)}
                      onDelete={() => onDeleteRegion(r)}
                      renaming={renamingRegion}
                    />
                  ))}
                </ul>
              </SortableContext>
            </DndContext>
          )}
          <div className="flex gap-2 px-10 py-3 border-t border-primary/10">
            <Input
              placeholder="Add a region…"
              value={newRegion}
              onChange={(e) => setNewRegion(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") handleAddRegion();
              }}
              className="h-8 bg-input/50"
            />
            <Button size="sm" onClick={handleAddRegion} disabled={addingRegion || !newRegion.trim()}>
              {addingRegion ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Plus className="w-3.5 h-3.5" />}
              Add
            </Button>
          </div>
        </div>
      )}
    </li>
  );
};

export const CountriesRegionsSection = () => {
  useSeedGeographyFromWines();

  const { data: countries = [], isLoading: countriesLoading } = useWineCountries();
  const { data: regions = [], isLoading: regionsLoading } = useWineRegions();
  const { data: wines = [] } = useWines();

  const addCountryMut = useAddWineCountry();
  const renameCountryMut = useRenameWineCountry();
  const deleteCountryMut = useDeleteWineCountry();
  const reorderCountriesMut = useReorderWineCountries();
  const addRegionMut = useAddWineRegion();
  const renameRegionMut = useRenameWineRegion();
  const deleteRegionMut = useDeleteWineRegion();
  const reorderRegionsMut = useReorderWineRegions();

  // Local optimistic order so DnD feels instant
  const [countryOrder, setCountryOrder] = useState<string[] | null>(null);
  const [regionOrders, setRegionOrders] = useState<Record<string, string[]>>({});

  useEffect(() => {
    setCountryOrder(null);
  }, [countries.map((c) => c.id).join(",")]);

  const orderedCountries = countryOrder
    ? (countryOrder.map((id) => countries.find((c) => c.id === id)).filter(Boolean) as WineCountryRow[])
    : countries;

  const regionsForCountry = (cid: string): WineRegionRow[] => {
    const all = regions.filter((r) => r.country_id === cid);
    const localOrder = regionOrders[cid];
    if (localOrder) {
      return localOrder.map((id) => all.find((r) => r.id === id)).filter(Boolean) as WineRegionRow[];
    }
    return all;
  };

  const [expanded, setExpanded] = useState<Record<string, boolean>>({});
  const toggleExpanded = (id: string) => setExpanded((e) => ({ ...e, [id]: !e[id] }));

  const [newCountry, setNewCountry] = useState("");
  const [deleteTarget, setDeleteTarget] = useState<DeleteTarget | null>(null);

  const countryAffected = (id: string) =>
    wines.filter((w) => w.country_id === id && (w.quantity ?? 0) > 0).length;
  const regionAffected = (id: string) =>
    wines.filter((w) => w.region_id === id && (w.quantity ?? 0) > 0).length;

  const handleAddCountry = async () => {
    const t = newCountry.trim();
    if (!t) return;
    try {
      await addCountryMut.mutateAsync(t);
      setNewCountry("");
      toast.success("Country added");
    } catch (e: any) {
      toast.error(e.message ?? "Could not add country");
    }
  };

  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates }),
  );

  const onCountryDragEnd = (e: DragEndEvent) => {
    const { active, over } = e;
    if (!over || active.id === over.id) return;
    const oldIndex = orderedCountries.findIndex((c) => c.id === active.id);
    const newIndex = orderedCountries.findIndex((c) => c.id === over.id);
    if (oldIndex < 0 || newIndex < 0) return;
    const reordered = arrayMove(orderedCountries, oldIndex, newIndex).map((c) => c.id);
    setCountryOrder(reordered);
    reorderCountriesMut.mutate(reordered);
  };

  const moveCountry = (idx: number, dir: -1 | 1) => {
    const target = idx + dir;
    if (target < 0 || target >= orderedCountries.length) return;
    const reordered = arrayMove(orderedCountries, idx, target).map((c) => c.id);
    setCountryOrder(reordered);
    reorderCountriesMut.mutate(reordered);
  };

  const handleReorderRegions = (cid: string, orderedIds: string[]) => {
    setRegionOrders((prev) => ({ ...prev, [cid]: orderedIds }));
    reorderRegionsMut.mutate(orderedIds, {
      onSettled: () => {
        setRegionOrders((prev) => {
          const { [cid]: _, ...rest } = prev;
          return rest;
        });
      },
    });
  };

  const confirmDelete = async () => {
    if (!deleteTarget) return;
    try {
      if (deleteTarget.type === "country") {
        await deleteCountryMut.mutateAsync(deleteTarget.row.id);
        toast.success("Country removed");
      } else {
        await deleteRegionMut.mutateAsync(deleteTarget.row.id);
        toast.success("Region removed");
      }
    } catch (e: any) {
      toast.error(e.message ?? "Could not remove");
    }
    setDeleteTarget(null);
  };

  const isLoading = countriesLoading || regionsLoading;

  return (
    <Card className="p-6 gold-border bg-card/80 shadow-card">
      <div className="flex items-center justify-between mb-1">
        <h3 className="font-display text-2xl">Countries & regions</h3>
        <span className="text-xs text-muted-foreground">
          {countries.length} {countries.length === 1 ? "country" : "countries"} ·{" "}
          {regions.length} {regions.length === 1 ? "region" : "regions"}
        </span>
      </div>
      <p className="text-sm text-muted-foreground italic mb-6">
        Curate the geography of your cellar. Drag to reorder, expand a country to manage its regions.
      </p>

      {isLoading ? (
        <div className="flex items-center justify-center py-12 text-muted-foreground italic">
          <Loader2 className="w-4 h-4 animate-spin mr-2" /> Loading…
        </div>
      ) : orderedCountries.length === 0 ? (
        <p className="text-center py-8 text-sm italic text-muted-foreground border border-primary/15 rounded-md">
          No countries yet. Add one below.
        </p>
      ) : (
        <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={onCountryDragEnd}>
          <SortableContext items={orderedCountries.map((c) => c.id)} strategy={verticalListSortingStrategy}>
            <ul className="border border-primary/15 rounded-md divide-y divide-primary/15 overflow-hidden">
              {orderedCountries.map((c, idx) => (
                <CountryItem
                  key={c.id}
                  country={c}
                  regions={regionsForCountry(c.id)}
                  countryAffected={countryAffected(c.id)}
                  regionAffected={regionAffected}
                  expanded={!!expanded[c.id]}
                  onToggleExpanded={() => toggleExpanded(c.id)}
                  isFirst={idx === 0}
                  isLast={idx === orderedCountries.length - 1}
                  onMoveUp={() => moveCountry(idx, -1)}
                  onMoveDown={() => moveCountry(idx, 1)}
                  onRenameCountry={(name) => renameCountryMut.mutateAsync({ id: c.id, name })}
                  onDeleteCountry={() =>
                    setDeleteTarget({ type: "country", row: c, affected: countryAffected(c.id) })
                  }
                  onAddRegion={(name) => addRegionMut.mutateAsync({ country_id: c.id, name })}
                  onRenameRegion={(id, name) => renameRegionMut.mutateAsync({ id, name })}
                  onDeleteRegion={(region) =>
                    setDeleteTarget({ type: "region", row: region, affected: regionAffected(region.id) })
                  }
                  onReorderRegions={(ids) => handleReorderRegions(c.id, ids)}
                  renamingCountry={renameCountryMut.isPending}
                  addingRegion={addRegionMut.isPending}
                  renamingRegion={renameRegionMut.isPending}
                />
              ))}
            </ul>
          </SortableContext>
        </DndContext>
      )}

      <div className="mt-6 pt-6 border-t border-primary/20">
        <p className="text-xs uppercase tracking-widest text-muted-foreground mb-2">Add a country</p>
        <div className="flex gap-2">
          <Input
            placeholder="e.g. France, Italy…"
            value={newCountry}
            onChange={(e) => setNewCountry(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") handleAddCountry();
            }}
            className="bg-input/50"
          />
          <Button onClick={handleAddCountry} disabled={addCountryMut.isPending || !newCountry.trim()}>
            {addCountryMut.isPending ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
            Add
          </Button>
        </div>
      </div>

      <AlertDialog open={!!deleteTarget} onOpenChange={(o) => !o && setDeleteTarget(null)}>
        <AlertDialogContent className="gold-border bg-card">
          <AlertDialogHeader>
            <AlertDialogTitle className="font-display">
              {deleteTarget?.type === "country" ? "Remove this country?" : "Remove this region?"}
            </AlertDialogTitle>
            <AlertDialogDescription>
              {deleteTarget && (
                <>
                  Remove{" "}
                  <span className="text-foreground font-medium">"{deleteTarget.row.name}"</span>
                  {deleteTarget.type === "country" && (
                    <>
                      {" "}and all of its regions
                      <span className="block mt-2 text-destructive">
                        ⚠ This will also delete{" "}
                        {regions.filter((r) => r.country_id === deleteTarget.row.id).length}{" "}
                        region(s) under this country.
                      </span>
                    </>
                  )}
                  .
                  {deleteTarget.affected > 0 ? (
                    <span className="block mt-2 text-destructive">
                      {deleteTarget.affected}{" "}
                      {deleteTarget.affected === 1 ? "bottle is" : "bottles are"} currently using this name.
                      They will remain in your cellar but will need to be reassigned.
                    </span>
                  ) : (
                    <span className="block mt-2">No bottles are currently assigned to it.</span>
                  )}
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
