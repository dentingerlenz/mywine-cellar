import { Wine, OCCASION_CLASS, OCCASION_LABEL, wineTitle } from "@/lib/wine";
import { useWineColoursCtx, colourClassFor } from "@/contexts/WineColoursContext";
import { useGeographyLookups } from "@/hooks/useWineGeography";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { BottlePlaceholder } from "./BottlePlaceholder";
import { Pencil, Trash2, Star } from "lucide-react";
import { QuantityControls } from "./QuantityControls";
import { PriceControl } from "./PriceControl";
import { cn } from "@/lib/utils";

type Props = {
  wine: Wine;
  onOpen: (w: Wine) => void;
  onEdit: (w: Wine) => void;
  onDelete: (w: Wine) => void;
};

export const WineCard = ({ wine, onOpen, onEdit, onDelete }: Props) => {
  const { labelFor } = useWineColoursCtx();
  const { regionNameFor } = useGeographyLookups();
  const regionName = regionNameFor(wine);
  return (
    <Card
      onClick={() => onOpen(wine)}
      className="group overflow-hidden gold-border shadow-card hover:shadow-warm transition-all duration-300 bg-card/80 backdrop-blur cursor-pointer"
    >
      <div className="aspect-[4/3] relative overflow-hidden">
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
          <Badge className={cn("absolute top-2 left-2 font-body text-[9px] uppercase tracking-wider px-1.5 py-0", colourClassFor(wine.colour))}>
            {labelFor(wine.colour)}
          </Badge>
        )}
        <div className="absolute top-2 right-2">
          <QuantityControls wine={wine} size="sm" />
        </div>
        {wine.occasion && (
          <Badge variant="outline" className={cn("absolute bottom-2 left-2 font-body text-[9px] uppercase tracking-wider px-1.5 py-0", OCCASION_CLASS[wine.occasion])}>
            {OCCASION_LABEL[wine.occasion]}
          </Badge>
        )}
      </div>
      <div className="p-2.5 space-y-1">
        <div>
          <h3 className="font-display text-base leading-tight text-foreground line-clamp-2">
            {wine.producer || <span className="italic text-muted-foreground">Unknown producer</span>}
          </h3>
          {wine.description && (
            <p className="text-[11px] text-muted-foreground italic line-clamp-1">{wine.description}</p>
          )}
        </div>
        <div className="flex items-center gap-1.5 text-[11px] text-muted-foreground">
          {wine.vintage && <span className="text-primary font-display text-sm">{wine.vintage}</span>}
          {regionName && <span className="truncate">· {regionName}</span>}
        </div>
        {wine.rating && (
          <div className="flex gap-0.5">
            {Array.from({ length: 5 }).map((_, i) => (
              <Star key={i} className={cn("w-3 h-3", i < wine.rating! ? "fill-primary text-primary" : "text-muted")} />
            ))}
          </div>
        )}
        <div className="flex items-center justify-between pt-1">
          <PriceControl wine={wine} size="sm" />
          <div className="flex gap-0.5 opacity-0 group-hover:opacity-100 transition-opacity">
            <Button size="icon" variant="ghost" className="h-7 w-7" onClick={(e) => { e.stopPropagation(); onEdit(wine); }}>
              <Pencil className="w-3.5 h-3.5" />
            </Button>
            <Button size="icon" variant="ghost" className="h-7 w-7 hover:text-destructive" onClick={(e) => { e.stopPropagation(); onDelete(wine); }}>
              <Trash2 className="w-3.5 h-3.5" />
            </Button>
          </div>
        </div>
      </div>
    </Card>
  );
};
