import { useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { format, parseISO } from "date-fns";
import { BookOpen, CalendarIcon, Star, Trash2, Wine as WineIcon, ArrowLeft, Loader2 } from "lucide-react";
import { useDrinkingLog, useDeleteLogEntry } from "./queries";
import { usePeople } from "@/features/people/queries";
import { useWines } from "@/features/wines/queries";
import { type Wine, wineTitle } from "@/features/wines/model";
import { WineDetailDialog } from "@/features/wines/components/WineDetailDialog";
import { WineFormDialog } from "@/features/wine-form/WineFormDialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Calendar } from "@/components/ui/calendar";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { cn } from "@/lib/utils";
import { toast } from "sonner";

export default function HistoryPage() {
  const { data: entries = [], isLoading } = useDrinkingLog();
  const { data: people = [] } = usePeople();
  const { data: wines = [] } = useWines();
  const del = useDeleteLogEntry();

  const [personFilter, setPersonFilter] = useState<string | "all">("all");
  const [fromDate, setFromDate] = useState<Date | undefined>();
  const [toDate, setToDate] = useState<Date | undefined>();
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [detailWine, setDetailWine] = useState<Wine | null>(null);
  const [editing, setEditing] = useState<Wine | null>(null);
  const [formOpen, setFormOpen] = useState(false);

  const wineById = useMemo(() => new Map(wines.map((w) => [w.id, w])), [wines]);
  const personById = useMemo(
    () => new Map(people.map((p) => [p.id, { name: p.name, avatar: p.avatar }])),
    [people],
  );

  const filtered = useMemo(() => {
    return entries.filter((e) => {
      if (personFilter !== "all" && !e.people_ids.includes(personFilter)) return false;
      const d = parseISO(e.date);
      if (fromDate && d < fromDate) return false;
      if (toDate) {
        const end = new Date(toDate);
        end.setHours(23, 59, 59, 999);
        if (d > end) return false;
      }
      return true;
    });
  }, [entries, personFilter, fromDate, toDate]);

  const confirmDelete = async () => {
    if (!deleteId) return;
    try {
      await del.mutateAsync(deleteId);
      toast.success("Entry removed");
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not delete");
    }
    setDeleteId(null);
  };

  const clearFilters = () => {
    setPersonFilter("all");
    setFromDate(undefined);
    setToDate(undefined);
  };

  return (
    <div className="min-h-screen">
      <header className="border-b border-primary/20 backdrop-blur bg-background/70 sticky top-0 z-40">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <BookOpen className="w-6 h-6 text-primary" strokeWidth={1.5} />
            <h1 className="font-display text-2xl tracking-tight">Cellar History</h1>
          </div>
          <Button variant="ghost" size="sm" asChild>
            <Link to="/"><ArrowLeft className="w-4 h-4" /> Back to cellar</Link>
          </Button>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h2 className="font-display text-4xl md:text-5xl tracking-tight">Bottles enjoyed</h2>
          <p className="text-muted-foreground italic mt-1">Every cork that has been pulled.</p>
        </div>

        <div className="gold-border rounded-lg bg-card/40 p-4 mb-6 flex flex-wrap items-end gap-4">
          <div className="flex-1 min-w-[180px]">
            <Label className="mb-1.5 block text-[10px] uppercase tracking-widest text-muted-foreground">Person</Label>
            <select
              value={personFilter}
              onChange={(e) => setPersonFilter(e.target.value)}
              className="w-full h-10 rounded-md bg-input/50 border border-primary/20 px-3 text-sm"
            >
              <option value="all">All people</option>
              {people.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.avatar || "👤"} {p.name}
                </option>
              ))}
            </select>
          </div>
          <div>
            <Label className="mb-1.5 block text-[10px] uppercase tracking-widest text-muted-foreground">From</Label>
            <Popover>
              <PopoverTrigger asChild>
                <Button variant="outline" className={cn("w-[170px] justify-start text-left font-normal bg-input/50", !fromDate && "text-muted-foreground")}>
                  <CalendarIcon className="mr-2 h-4 w-4" />
                  {fromDate ? format(fromDate, "d MMM yyyy") : "Any"}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto p-0 bg-card gold-border" align="start">
                <Calendar mode="single" selected={fromDate} onSelect={setFromDate} initialFocus className={cn("p-3 pointer-events-auto")} />
              </PopoverContent>
            </Popover>
          </div>
          <div>
            <Label className="mb-1.5 block text-[10px] uppercase tracking-widest text-muted-foreground">To</Label>
            <Popover>
              <PopoverTrigger asChild>
                <Button variant="outline" className={cn("w-[170px] justify-start text-left font-normal bg-input/50", !toDate && "text-muted-foreground")}>
                  <CalendarIcon className="mr-2 h-4 w-4" />
                  {toDate ? format(toDate, "d MMM yyyy") : "Any"}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto p-0 bg-card gold-border" align="start">
                <Calendar mode="single" selected={toDate} onSelect={setToDate} initialFocus className={cn("p-3 pointer-events-auto")} />
              </PopoverContent>
            </Popover>
          </div>
          {(personFilter !== "all" || fromDate || toDate) && (
            <Button variant="ghost" size="sm" onClick={clearFilters}>Clear</Button>
          )}
        </div>

        {isLoading ? (
          <div className="flex justify-center py-20"><Loader2 className="w-6 h-6 animate-spin text-primary" /></div>
        ) : filtered.length === 0 ? (
          <div className="text-center py-20 gold-border rounded-lg bg-card/40">
            <BookOpen className="w-16 h-16 text-primary/50 mx-auto mb-4" strokeWidth={1.2} />
            <h3 className="font-display text-2xl mb-2">No entries yet</h3>
            <p className="text-muted-foreground italic">
              {entries.length === 0 ? "Open your first bottle to start the log." : "No entries match these filters."}
            </p>
          </div>
        ) : (
          <ul className="space-y-3">
            {filtered.map((entry) => {
              const wine = entry.wine_id ? wineById.get(entry.wine_id) : null;
              // v2: Snapshot rettet den Namen, auch wenn der Wein gelöscht wurde
              const wineLabel = wine ? wineTitle(wine) : entry.wine_label ?? "Wine no longer in cellar";
              return (
                <li
                  key={entry.id}
                  className="gold-border rounded-lg bg-card/40 p-4 flex flex-col sm:flex-row sm:items-start gap-4"
                >
                  <div className="sm:w-32 shrink-0">
                    <p className="text-[10px] uppercase tracking-widest text-muted-foreground">Date</p>
                    <p className="font-display text-lg leading-tight">{format(parseISO(entry.date), "d MMM yyyy")}</p>
                  </div>
                  <div className="flex-1 min-w-0 space-y-2">
                    {wine ? (
                      <button
                        onClick={() => setDetailWine(wine)}
                        className="group text-left flex items-center gap-2 hover:text-primary transition-colors"
                      >
                        <WineIcon className="w-4 h-4 text-primary shrink-0" strokeWidth={1.5} />
                        <span className="font-display text-lg underline-offset-4 group-hover:underline">{wineLabel}</span>
                      </button>
                    ) : (
                      <div className="flex items-center gap-2 text-muted-foreground italic">
                        <WineIcon className="w-4 h-4 shrink-0" strokeWidth={1.5} />
                        <span>{wineLabel}</span>
                      </div>
                    )}

                    {entry.rating != null && (
                      <span className="flex items-center gap-0.5">
                        {Array.from({ length: 5 }).map((_, i) => (
                          <Star key={i} className={cn("w-3.5 h-3.5", i < (entry.rating ?? 0) ? "fill-primary text-primary" : "text-muted")} />
                        ))}
                      </span>
                    )}

                    {entry.people_ids.length > 0 && (
                      <div className="flex flex-wrap gap-1.5">
                        {entry.people_ids.map((pid) => {
                          const p = personById.get(pid);
                          return (
                            <span
                              key={pid}
                              className="inline-flex items-center gap-1.5 rounded-full border border-primary/20 bg-background/40 px-2.5 py-0.5 text-xs"
                            >
                              <span className="text-base leading-none">{p?.avatar || "👤"}</span>
                              <span className="text-muted-foreground">{p?.name ?? "Unknown"}</span>
                            </span>
                          );
                        })}
                      </div>
                    )}

                    {entry.note && (
                      <p className="font-body text-sm italic text-foreground/80 whitespace-pre-wrap">
                        “{entry.note}”
                      </p>
                    )}
                  </div>
                  <div className="shrink-0">
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => setDeleteId(entry.id)}
                      className="text-muted-foreground hover:text-destructive"
                      title="Delete entry"
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                </li>
              );
            })}
          </ul>
        )}
      </main>

      <WineDetailDialog
        wine={detailWine}
        open={!!detailWine}
        onOpenChange={(o) => !o && setDetailWine(null)}
        onEdit={(w) => { setDetailWine(null); setEditing(w); setFormOpen(true); }}
        onDelete={() => { /* kein Löschen aus der Historie */ }}
      />

      <WineFormDialog open={formOpen} onOpenChange={setFormOpen} wine={editing} />

      <AlertDialog open={!!deleteId} onOpenChange={(o) => !o && setDeleteId(null)}>
        <AlertDialogContent className="gold-border bg-card">
          <AlertDialogHeader>
            <AlertDialogTitle className="font-display">Delete this log entry?</AlertDialogTitle>
            <AlertDialogDescription>
              This removes the entry from your cellar history. Stock quantity will not be restored.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={confirmDelete} className="bg-destructive">Delete</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
