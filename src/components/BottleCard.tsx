import { Bottle, COLOUR_CLASS, COLOUR_LABEL, DRINK_LABEL, getDrinkStatus } from "@/lib/wine";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { BottlePlaceholder } from "./BottlePlaceholder";
import { Pencil, Trash2, Star } from "lucide-react";
import { cn } from "@/lib/utils";

type Props = {
  bottle: Bottle;
  onEdit: (b: Bottle) => void;
  onDelete: (b: Bottle) => void;
};

export const BottleCard = ({ bottle, onEdit, onDelete }: Props) => {
  const status = getDrinkStatus(bottle);
  return (
    <Card className="group overflow-hidden gold-border shadow-card hover:shadow-warm transition-all duration-300 bg-card/80 backdrop-blur">
      <div className="aspect-[3/4] relative overflow-hidden">
        {bottle.photo_url ? (
          <img
            src={bottle.photo_url}
            alt={bottle.name}
            loading="lazy"
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
          />
        ) : (
          <BottlePlaceholder className="w-full h-full" />
        )}
        {bottle.colour && (
          <Badge className={cn("absolute top-3 left-3 font-body text-xs uppercase tracking-wider", COLOUR_CLASS[bottle.colour])}>
            {COLOUR_LABEL[bottle.colour]}
          </Badge>
        )}
        <div className="absolute top-3 right-3 bg-background/80 backdrop-blur px-2 py-1 rounded-md text-xs font-body text-primary border border-primary/30">
          ×{bottle.quantity}
        </div>
      </div>
      <div className="p-4 space-y-2">
        <div>
          <h3 className="font-display text-lg leading-tight text-foreground line-clamp-2">{bottle.name}</h3>
          {bottle.producer && (
            <p className="text-sm text-muted-foreground italic">{bottle.producer}</p>
          )}
        </div>
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          {bottle.vintage && <span className="text-primary font-display">{bottle.vintage}</span>}
          {bottle.region && <span>· {bottle.region}</span>}
        </div>
        {bottle.rating && (
          <div className="flex gap-0.5">
            {Array.from({ length: 5 }).map((_, i) => (
              <Star key={i} className={cn("w-3.5 h-3.5", i < bottle.rating! ? "fill-primary text-primary" : "text-muted")} />
            ))}
          </div>
        )}
        <div className="flex items-center justify-between pt-2">
          <Badge variant="outline" className={cn(
            "font-body text-xs border-primary/30",
            status === "drink_now" && "text-primary border-primary",
            status === "past_peak" && "text-destructive border-destructive/50"
          )}>
            {DRINK_LABEL[status]}
          </Badge>
          <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
            <Button size="icon" variant="ghost" className="h-8 w-8" onClick={() => onEdit(bottle)}>
              <Pencil className="w-4 h-4" />
            </Button>
            <Button size="icon" variant="ghost" className="h-8 w-8 hover:text-destructive" onClick={() => onDelete(bottle)}>
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </div>
    </Card>
  );
};
