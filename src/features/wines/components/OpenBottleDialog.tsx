import { useEffect, useState } from "react";
import { format } from "date-fns";
import { CalendarIcon, Loader2, Star, Wine as WineIcon } from "lucide-react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Calendar } from "@/components/ui/calendar";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import { toast } from "sonner";
import { type Wine, wineTitle } from "../model";
import { useUpdateQuantity } from "../queries";
import { usePeople } from "@/features/people/queries";
import { useAddLogEntry } from "@/features/history/queries";

type Props = {
  wine: Wine | null;
  open: boolean;
  onOpenChange: (v: boolean) => void;
};

export const OpenBottleDialog = ({ wine, open, onOpenChange }: Props) => {
  const { data: people = [] } = usePeople();
  const addEntry = useAddLogEntry();
  const updateQuantity = useUpdateQuantity();

  const [date, setDate] = useState<Date>(new Date());
  const [selectedPeople, setSelectedPeople] = useState<string[]>([]);
  const [note, setNote] = useState("");
  const [rating, setRating] = useState<number | null>(null); // V6: „Wie war er?"

  useEffect(() => {
    if (open) {
      setDate(new Date());
      setSelectedPeople([]);
      setNote("");
      setRating(null);
    }
  }, [open]);

  if (!wine) return null;

  const outOfStock = (wine.quantity ?? 0) <= 0;
  const submitting = addEntry.isPending || updateQuantity.isPending;

  const togglePerson = (id: string) => {
    setSelectedPeople((prev) =>
      prev.includes(id) ? prev.filter((p) => p !== id) : [...prev, id],
    );
  };

  const handleConfirm = async () => {
    try {
      const label = `${wineTitle(wine)}${wine.vintage ? ` ${wine.vintage}` : ""}`;
      await addEntry.mutateAsync({
        wine_id: wine.id,
        wine_label: label,
        date: format(date, "yyyy-MM-dd"),
        note: note.trim() || null,
        rating,
        people_ids: selectedPeople,
      });
      const newQty = Math.max(0, (wine.quantity ?? 0) - 1);
      if (newQty !== wine.quantity) {
        await updateQuantity.mutateAsync({ id: wine.id, quantity: newQty });
      }
      toast.success(outOfStock ? "Bottle logged" : "Bottle logged & removed from stock");
      onOpenChange(false);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not log bottle");
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg gold-border bg-card">
        <DialogHeader>
          <DialogTitle className="font-display text-2xl flex items-center gap-2">
            <WineIcon className="w-5 h-5 text-primary" /> Open a bottle
          </DialogTitle>
          <p className="text-sm text-muted-foreground italic mt-1">{wineTitle(wine)}</p>
        </DialogHeader>

        {outOfStock && (
          <div className="rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-xs text-destructive">
            ⚠ No bottles in stock — log anyway?
          </div>
        )}

        <div className="space-y-4">
          <div>
            <Label className="mb-1.5 block">Date</Label>
            <Popover>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  className={cn(
                    "w-full justify-start text-left font-normal bg-input/50",
                    !date && "text-muted-foreground",
                  )}
                >
                  <CalendarIcon className="mr-2 h-4 w-4" />
                  {date ? format(date, "PPP") : "Pick a date"}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto p-0 bg-card gold-border" align="start">
                <Calendar
                  mode="single"
                  selected={date}
                  onSelect={(d) => d && setDate(d)}
                  initialFocus
                  className={cn("p-3 pointer-events-auto")}
                />
              </PopoverContent>
            </Popover>
          </div>

          <div>
            <Label className="mb-1.5 block">How was it?</Label>
            <div className="flex items-center gap-1">
              {Array.from({ length: 5 }).map((_, i) => {
                const value = i + 1;
                const active = rating != null && value <= rating;
                return (
                  <button
                    key={value}
                    type="button"
                    onClick={() => setRating(rating === value ? null : value)}
                    aria-label={`Rate ${value} of 5`}
                    className="p-0.5"
                  >
                    <Star
                      className={cn(
                        "w-6 h-6 transition-colors",
                        active ? "fill-primary text-primary" : "text-muted hover:text-primary/60",
                      )}
                    />
                  </button>
                );
              })}
              {rating != null && (
                <span className="text-xs text-muted-foreground ml-2">{rating}/5</span>
              )}
            </div>
          </div>

          <div>
            <Label className="mb-1.5 block">Shared with</Label>
            {people.length === 0 ? (
              <p className="text-xs text-muted-foreground italic">
                No people yet. Add them in Settings to tag bottles.
              </p>
            ) : (
              <div className="flex flex-wrap gap-1.5">
                {people.map((p) => {
                  const active = selectedPeople.includes(p.id);
                  return (
                    <button
                      key={p.id}
                      type="button"
                      onClick={() => togglePerson(p.id)}
                      className={cn(
                        "inline-flex items-center gap-1.5 rounded-full border px-2.5 py-1 text-xs transition",
                        active
                          ? "bg-primary/20 border-primary text-foreground"
                          : "border-primary/20 hover:border-primary/40 text-muted-foreground",
                      )}
                    >
                      <span className="text-base leading-none">{p.avatar || "👤"}</span>
                      <span>{p.name}</span>
                    </button>
                  );
                })}
              </div>
            )}
          </div>

          <div>
            <Label className="mb-1.5 block">Note</Label>
            <Textarea
              rows={3}
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="How was it? Who brought it? Any occasion?"
              className="bg-input/50 placeholder:text-xs placeholder:opacity-[0.35]"
            />
          </div>
        </div>

        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)} disabled={submitting}>
            Cancel
          </Button>
          <Button onClick={handleConfirm} disabled={submitting}>
            {submitting && <Loader2 className="w-4 h-4 animate-spin mr-1" />}
            Log & Remove from Stock
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
