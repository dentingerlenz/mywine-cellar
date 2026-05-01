import { Wine, COLOUR_CLASS, COLOUR_LABEL } from "@/lib/wine";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { TableCell, TableRow } from "@/components/ui/table";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { MoreHorizontal, Pencil, Trash2 } from "lucide-react";
import { QuantityControls } from "./QuantityControls";
import { cn } from "@/lib/utils";

type Props = {
  wine: Wine;
  onOpen: (w: Wine) => void;
  onEdit: (w: Wine) => void;
  onDelete: (w: Wine) => void;
};

export const WineListRow = ({ wine, onOpen, onEdit, onDelete }: Props) => {
  return (
    <TableRow
      onClick={() => onOpen(wine)}
      className="cursor-pointer hover:bg-card/60"
    >
      <TableCell>
        {wine.colour ? (
          <Badge className={cn("font-body text-[10px] uppercase tracking-wider", COLOUR_CLASS[wine.colour])}>
            {COLOUR_LABEL[wine.colour]}
          </Badge>
        ) : (
          <span className="text-muted-foreground">—</span>
        )}
      </TableCell>
      <TableCell className="font-display text-foreground">
        {wine.producer || <span className="italic text-muted-foreground">Unknown</span>}
      </TableCell>
      <TableCell className="text-muted-foreground italic max-w-[220px] truncate">
        {wine.description || "—"}
      </TableCell>
      <TableCell className="text-primary font-display">{wine.vintage || "—"}</TableCell>
      <TableCell className="text-sm">{wine.region || "—"}</TableCell>
      <TableCell className="text-sm max-w-[180px] truncate">{wine.variety || "—"}</TableCell>
      <TableCell className="text-center">×{wine.quantity}</TableCell>
      <TableCell className="text-right font-display text-primary whitespace-nowrap">
        {wine.price_chf != null ? `${wine.price_chf.toFixed(0)} CHF` : <span className="text-muted-foreground italic">—</span>}
      </TableCell>
      <TableCell className="text-right" onClick={(e) => e.stopPropagation()}>
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
      </TableCell>
    </TableRow>
  );
};
