import { Wine, OCCASION_LABEL, OCCASION_CLASS, getDrinkStatus, DRINK_LABEL, wineTitle } from "@/lib/wine";
import { useWineColoursCtx, colourClassFor } from "@/contexts/WineColoursContext";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { BottlePlaceholder } from "./BottlePlaceholder";
import { Pencil, Trash2, Star } from "lucide-react";
import { cn } from "@/lib/utils";

type Props = {
  wine: Wine | null;
  open: boolean;
  onOpenChange: (v: boolean) => void;
  onEdit: (w: Wine) => void;
  onDelete: (w: Wine) => void;
};

const Field = ({ label, value }: { label: string; value: React.ReactNode }) => {
  if (value == null || value === "" ) return null;
  return (
    <div>
      <p className="text-[10px] uppercase tracking-widest text-muted-foreground">{label}</p>
      <p className="font-body text-sm text-foreground mt-0.5">{value}</p>
    </div>
  );
};

export const WineDetailDialog = ({ wine, open, onOpenChange, onEdit, onDelete }: Props) => {
  const { labelFor } = useWineColoursCtx();
  if (!wine) return null;
  const status = getDrinkStatus(wine);
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-3xl max-h-[90vh] overflow-y-auto bg-card gold-border">
        <DialogHeader>
          <DialogTitle className="font-display text-3xl">{wineTitle(wine)}</DialogTitle>
        </DialogHeader>
        <div className="grid md:grid-cols-[200px,1fr] gap-6">
          <div className="aspect-[3/4] rounded-md overflow-hidden gold-border bg-secondary">
            {wine.label_photo_url ? (
              <img src={wine.label_photo_url} alt="" className="w-full h-full object-cover" />
            ) : (
              <BottlePlaceholder className="w-full h-full" />
            )}
          </div>
          <div className="space-y-4">
            <div className="flex flex-wrap gap-2">
              {wine.colour && <Badge className={cn("font-body text-[10px] uppercase tracking-wider", colourClassFor(wine.colour))}>{labelFor(wine.colour)}</Badge>}
              {wine.occasion && <Badge variant="outline" className={cn("font-body text-[10px] uppercase tracking-wider", OCCASION_CLASS[wine.occasion])}>{OCCASION_LABEL[wine.occasion]}</Badge>}
              <Badge variant="outline" className="text-xs border-primary/40 text-primary">{DRINK_LABEL[status]}</Badge>
              {wine.rating && (
                <span className="flex items-center gap-0.5">
                  {Array.from({ length: 5 }).map((_, i) => (
                    <Star key={i} className={cn("w-3.5 h-3.5", i < wine.rating! ? "fill-primary text-primary" : "text-muted")} />
                  ))}
                </span>
              )}
            </div>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-x-4 gap-y-3">
              <Field label="Vintage" value={wine.vintage} />
              <Field label="Quantity" value={`× ${wine.quantity}`} />
              <Field label="Bottle" value={wine.cl ? `${wine.cl} cl` : null} />
              <Field label="Variety" value={wine.variety} />
              <Field label="Alcohol" value={wine.alcohol_pct != null ? `${wine.alcohol_pct} %` : null} />
              <Field label="Residual sugar" value={wine.residual_sugar_gl != null ? `${wine.residual_sugar_gl} g/L` : null} />
              <Field label="Dosage" value={wine.dosage} />
              <Field label="Country" value={wine.country} />
              <Field label="Region" value={wine.region} />
              <Field label="Sub-region" value={wine.sub_region} />
              <Field label="Appellation" value={wine.appellation} />
              <Field label="Ready from" value={wine.ready_from} />
              <Field label="Drink by" value={wine.drink_by} />
              <Field label="Price" value={wine.price_chf != null ? `${wine.price_chf.toFixed(2)} CHF` : null} />
              <Field label="Purchased from" value={wine.purchased_from} />
            </div>
            {wine.ausbau_terroir && (
              <div>
                <p className="text-[10px] uppercase tracking-widest text-muted-foreground mb-1">Ausbau / Terroir</p>
                <p className="font-body text-sm italic text-foreground/90 whitespace-pre-wrap">{wine.ausbau_terroir}</p>
              </div>
            )}
            {wine.notes && (
              <div>
                <p className="text-[10px] uppercase tracking-widest text-muted-foreground mb-1">Tasting notes</p>
                <p className="font-body text-sm italic text-foreground/90 whitespace-pre-wrap">{wine.notes}</p>
              </div>
            )}
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onDelete(wine)} className="text-destructive hover:text-destructive">
            <Trash2 className="w-4 h-4" /> Remove
          </Button>
          <Button onClick={() => onEdit(wine)}>
            <Pencil className="w-4 h-4" /> Edit
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
