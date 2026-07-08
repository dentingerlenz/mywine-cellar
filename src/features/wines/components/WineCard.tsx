import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Pencil, Trash2, Star, Wine as WineIcon, MapPin } from "lucide-react";
import { cn } from "@/lib/utils";
import { type Wine, wineTitle, occasionLabel, occasionClass } from "../model";
import { labelPhotoUrl } from "../queries";
import { useColourLookup } from "@/features/colours/queries";
import { useGeoLookups } from "@/features/geography/queries";
import { BottlePlaceholder } from "./BottlePlaceholder";
import { QuantityControls } from "./QuantityControls";
import { PriceControl } from "./PriceControl";

type Props = {
  wine: Wine;
  onOpen: (w: Wine) => void;
  onEdit: (w: Wine) => void;
  onDelete: (w: Wine) => void;
  onOpenBottle: (w: Wine) => void;
};

export const WineCard = ({ wine, onOpen, onEdit, onDelete, onOpenBottle }: Props) => {
  const colours = useColourLookup();
  const geo = useGeoLookups();
  const photo = labelPhotoUrl(wine.label_photo_path);
  const regionName = wine.region_id ? geo.regionById.get(wine.region_id)?.name : null;
  const geoExtra = [
    wine.sub_region_id ? geo.subRegionById.get(wine.sub_region_id)?.name : null,
    wine.appellation_id ? geo.appellationById.get(wine.appellation_id)?.name : null,
  ]
    .filter(Boolean)
    .join(" · ");
  const occLabel = occasionLabel(wine.occasion);

  return (
    <Card
      onClick={() => onOpen(wine)}
      className="group overflow-hidden gold-border shadow-card hover:shadow-warm transition-all duration-300 bg-card/80 backdrop-blur cursor-pointer"
    >
      <div className="aspect-[4/3] relative overflow-hidden">
        {photo ? (
          <img
            src={photo}
            alt={wineTitle(wine)}
            loading="lazy"
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
          />
        ) : (
          <BottlePlaceholder className="w-full h-full" />
        )}
        {wine.colour_id && (
          <Badge className={cn("absolute top-2 left-2 font-body text-[9px] uppercase tracking-wider px-1.5 py-0", colours.classFor(wine.colour_id))}>
            {colours.labelFor(wine.colour_id)}
          </Badge>
        )}
        <div className="absolute top-2 right-2">
          <QuantityControls wine={wine} size="sm" />
        </div>
        {occLabel && (
          <Badge variant="outline" className={cn("absolute bottom-2 left-2 font-body text-[9px] uppercase tracking-wider px-1.5 py-0", occasionClass(wine.occasion))}>
            {occLabel}
          </Badge>
        )}
      </div>
      <div className="p-2.5 space-y-1">
        <div>
          <h3 className="font-display text-base leading-tight text-foreground line-clamp-2">
            {wine.producer || <span className="italic text-muted-foreground">Unknown producer</span>}
          </h3>
          {wine.name && (
            <p className="text-[11px] text-muted-foreground italic line-clamp-1">{wine.name}</p>
          )}
        </div>
        <div className="flex items-center gap-1.5 text-[11px] text-muted-foreground">
          {wine.vintage && <span className="text-primary font-display text-sm">{wine.vintage}</span>}
          {regionName && <span className="truncate">· {regionName}</span>}
        </div>
        {geoExtra && (
          <p className="text-[10px] text-muted-foreground italic truncate">{geoExtra}</p>
        )}
        {wine.storage_location && (
          <p className="text-[10px] text-muted-foreground truncate flex items-center gap-1">
            <MapPin className="w-2.5 h-2.5 shrink-0" /> {wine.storage_location}
          </p>
        )}
        {wine.rating && (
          <div className="flex gap-0.5">
            {Array.from({ length: 5 }).map((_, i) => (
              <Star key={i} className={cn("w-3 h-3", i < (wine.rating ?? 0) ? "fill-primary text-primary" : "text-muted")} />
            ))}
          </div>
        )}
        <div className="flex items-center justify-between pt-1">
          <PriceControl wine={wine} size="sm" />
          <div className="flex gap-0.5 transition-opacity">
            <Button
              size="icon"
              variant="ghost"
              className="h-7 w-7 text-primary hover:text-primary hover:bg-primary/10"
              onClick={(e) => { e.stopPropagation(); onOpenBottle(wine); }}
              title="Open a bottle"
            >
              <WineIcon className="w-3.5 h-3.5" />
            </Button>
            <Button size="icon" variant="ghost" className="h-7 w-7 opacity-0 group-hover:opacity-100" onClick={(e) => { e.stopPropagation(); onEdit(wine); }}>
              <Pencil className="w-3.5 h-3.5" />
            </Button>
            <Button size="icon" variant="ghost" className="h-7 w-7 opacity-0 group-hover:opacity-100 hover:text-destructive" onClick={(e) => { e.stopPropagation(); onDelete(wine); }}>
              <Trash2 className="w-3.5 h-3.5" />
            </Button>
          </div>
        </div>
      </div>
    </Card>
  );
};
