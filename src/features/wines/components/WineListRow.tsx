import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { TableCell, TableRow } from "@/components/ui/table";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { MoreHorizontal, Pencil, Trash2, Wine as WineIcon } from "lucide-react";
import { cn } from "@/lib/utils";
import type { Wine } from "../model";
import { useColourLookup } from "@/features/colours/queries";
import { useGeoLookups } from "@/features/geography/queries";
import { QuantityControls } from "./QuantityControls";
import { PriceControl } from "./PriceControl";

type Props = {
  wine: Wine;
  onOpen: (w: Wine) => void;
  onEdit: (w: Wine) => void;
  onDelete: (w: Wine) => void;
  onOpenBottle: (w: Wine) => void;
};

export const WineListRow = ({ wine, onOpen, onEdit, onDelete, onOpenBottle }: Props) => {
  const colours = useColourLookup();
  const geo = useGeoLookups();
  const regionName = wine.region_id ? geo.regionById.get(wine.region_id)?.name : null;
  const geoExtra = [
    wine.sub_region_id ? geo.subRegionById.get(wine.sub_region_id)?.name : null,
    wine.appellation_id ? geo.appellationById.get(wine.appellation_id)?.name : null,
  ]
    .filter(Boolean)
    .join(" · ");

  return (
    <TableRow onClick={() => onOpen(wine)} className="cursor-pointer hover:bg-card/60">
      <TableCell>
        {wine.colour_id ? (
          <Badge className={cn("font-body text-[10px] uppercase tracking-wider", colours.classFor(wine.colour_id))}>
            {colours.labelFor(wine.colour_id)}
          </Badge>
        ) : (
          <span className="text-muted-foreground">—</span>
        )}
      </TableCell>
      <TableCell className="font-display text-foreground">
        {wine.producer || <span className="italic text-muted-foreground">Unknown</span>}
      </TableCell>
      <TableCell className="text-muted-foreground italic max-w-[220px] truncate">
        {wine.name || "—"}
      </TableCell>
      <TableCell className="text-primary font-display">{wine.vintage || "—"}</TableCell>
      <TableCell className="text-sm">
        <div className="truncate max-w-[200px]">{regionName || "—"}</div>
        {geoExtra && (
          <div className="text-[10px] text-muted-foreground italic truncate max-w-[200px]">
            {geoExtra}
          </div>
        )}
      </TableCell>
      <TableCell className="text-sm max-w-[180px] truncate">{wine.variety || "—"}</TableCell>
      <TableCell className="text-sm max-w-[120px] truncate">{wine.storage_location || "—"}</TableCell>
      <TableCell className="text-center"><QuantityControls wine={wine} size="sm" /></TableCell>
      <TableCell className="text-right whitespace-nowrap">
        <PriceControl wine={wine} size="sm" align="right" />
      </TableCell>
      <TableCell className="text-right" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-end gap-1">
          <Button
            size="icon"
            variant="ghost"
            className="h-8 w-8 text-primary hover:text-primary hover:bg-primary/10"
            onClick={() => onOpenBottle(wine)}
            title="Open a bottle"
          >
            <WineIcon className="w-4 h-4" />
          </Button>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button size="icon" variant="ghost" className="h-8 w-8">
                <MoreHorizontal className="w-4 h-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="gold-border bg-card">
              <DropdownMenuItem onClick={() => onEdit(wine)}>
                <Pencil className="w-4 h-4 mr-2" /> Edit
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => onDelete(wine)} className="text-destructive focus:text-destructive">
                <Trash2 className="w-4 h-4 mr-2" /> Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </TableCell>
    </TableRow>
  );
};
