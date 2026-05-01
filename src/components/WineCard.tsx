import { Wine, COLOUR_CLASS, COLOUR_LABEL, OCCASION_CLASS, OCCASION_LABEL, wineTitle } from "@/lib/wine";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { BottlePlaceholder } from "./BottlePlaceholder";
import { Pencil, Trash2, Star } from "lucide-react";
import { QuantityControls } from "./QuantityControls";
import { cn } from "@/lib/utils";

type Props = {
  wine: Wine;
  onOpen: (w: Wine) => void;
  onEdit: (w: Wine) => void;
  onDelete: (w: Wine) => void;
};

export const WineCard = ({ wine, onOpen, onEdit, onDelete }: Props) => {
  return (
    <Card
      onClick={() => onOpen(wine)}
      className="group overflow-hidden gold-border shadow-card hover:shadow-warm transition-all duration-300 bg-card/80 backdrop-blur cursor-pointer"
    >
      <div className="aspect-[3/4] relative overflow-hidden">
        {wine.label_photo_url ? (
          <img
            src={wine.label_photo_url}
            alt={wineTitle(wine)}
            loading="lazy"
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
          />
        ) : (
          <BottlePlaceholder className="w-full h-full" />
        )}
        {wine.colour && (
          <Badge className={cn("absolute top-3 left-3 font-body text-[10px] uppercase tracking-wider", COLOUR_CLASS[wine.colour])}>
            {COLOUR_LABEL[wine.colour]}
          </Badge>
        )}
        <div className="absolute top-3 right-3 bg-background/80 backdrop-blur px-2 py-1 rounded-md text-xs font-body text-primary border border-primary/30">
          ×{wine.quantity}
        </div>
        {wine.occasion && (
          <Badge variant="outline" className={cn("absolute bottom-3 left-3 font-body text-[10px] uppercase tracking-wider", OCCASION_CLASS[wine.occasion])}>
            {OCCASION_LABEL[wine.occasion]}
          </Badge>
        )}
      </div>
      <div className="p-4 space-y-2">
        <div>
          <h3 className="font-display text-lg leading-tight text-foreground line-clamp-2">
            {wine.producer || <span className="italic text-muted-foreground">Unknown producer</span>}
          </h3>
          {wine.description && (
            <p className="text-sm text-muted-foreground italic line-clamp-1">{wine.description}</p>
          )}
        </div>
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          {wine.vintage && <span className="text-primary font-display">{wine.vintage}</span>}
          {wine.region && <span className="truncate">· {wine.region}</span>}
        </div>
        {wine.rating && (
          <div className="flex gap-0.5">
            {Array.from({ length: 5 }).map((_, i) => (
              <Star key={i} className={cn("w-3.5 h-3.5", i < wine.rating! ? "fill-primary text-primary" : "text-muted")} />
            ))}
          </div>
        )}
        <div className="flex items-center justify-between pt-2">
          <span className="text-sm font-display text-primary">
            {wine.price_chf != null ? `${wine.price_chf.toFixed(0)} CHF` : <span className="text-muted-foreground italic text-xs">No price</span>}
          </span>
          <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
            <Button size="icon" variant="ghost" className="h-8 w-8" onClick={(e) => { e.stopPropagation(); onEdit(wine); }}>
              <Pencil className="w-4 h-4" />
            </Button>
            <Button size="icon" variant="ghost" className="h-8 w-8 hover:text-destructive" onClick={(e) => { e.stopPropagation(); onDelete(wine); }}>
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </div>
    </Card>
  );
};
