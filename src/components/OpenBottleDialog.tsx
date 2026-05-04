import { useEffect, useState } from "react";
import { format } from "date-fns";
import { CalendarIcon, Loader2, Wine as WineIcon } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useQueryClient } from "@tanstack/react-query";
import { usePeople } from "@/hooks/usePeople";
import { Wine, wineTitle } from "@/lib/wine";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Calendar } from "@/components/ui/calendar";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import { toast } from "sonner";

type Props = {
  wine: Wine | null;
  open: boolean;
  onOpenChange: (v: boolean) => void;
};

export const OpenBottleDialog = ({ wine, open, onOpenChange }: Props) => {
  const { user } = useAuth();
  const qc = useQueryClient();
  const { data: people = [] } = usePeople();

  const [date, setDate] = useState<Date>(new Date());
  const [selectedPeople, setSelectedPeople] = useState<string[]>([]);
  const [note, setNote] = useState("");
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setDate(new Date());
      setSelectedPeople([]);
      setNote("");
    }
  }, [open]);

  if (!wine) return null;

  const outOfStock = (wine.quantity ?? 0) <= 0;

  const togglePerson = (id: string) => {
    setSelectedPeople((prev) =>
      prev.includes(id) ? prev.filter((p) => p !== id) : [...prev, id],
    );
  };

  const handleConfirm = async () => {
    if (!user) return;
    setSubmitting(true);
    try {
      const { error: logErr } = await supabase.from("drinking_log").insert({
        user_id: user.id,
        wine_id: wine.id,
        date: format(date, "yyyy-MM-dd"),
        note: note.trim() || null,
        people_ids: selectedPeople,
      });
      if (logErr) throw logErr;

      const newQty = Math.max(0, (wine.quantity ?? 0) - 1);
      if (newQty !== wine.quantity) {
        const { error: qErr } = await supabase
          .from("wines")
          .update({ quantity: newQty })
          .eq("id", wine.id);
        if (qErr) throw qErr;
      }

      qc.invalidateQueries({ queryKey: ["wines"] });
      qc.invalidateQueries({ queryKey: ["drinking_log"] });
      toast.success(outOfStock ? "Bottle logged" : "Bottle logged & removed from stock");
      onOpenChange(false);
    } catch (e: any) {
      toast.error(e.message ?? "Could not log bottle");
    } finally {
      setSubmitting(false);
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
