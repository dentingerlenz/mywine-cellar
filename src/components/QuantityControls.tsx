import { Wine } from "@/lib/wine";
import { Button } from "@/components/ui/button";
import { Minus, Plus } from "lucide-react";
import { useUpdateQuantity } from "@/hooks/useWines";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

type Props = {
  wine: Wine;
  size?: "sm" | "md";
  className?: string;
};

export const QuantityControls = ({ wine, size = "md", className }: Props) => {
  const update = useUpdateQuantity();
  const isZero = wine.quantity === 0;

  const change = async (delta: number) => {
    const next = Math.max(0, wine.quantity + delta);
    if (next === wine.quantity) return;
    try {
      await update.mutateAsync({ id: wine.id, quantity: next });
      toast.success(`Quantity updated · ×${next}`);
    } catch (e: any) {
      toast.error(e.message || "Could not update quantity");
    }
  };

  const btnSize = size === "sm" ? "h-7 w-7" : "h-8 w-8";
  const numSize = size === "sm" ? "text-sm w-6" : "text-base w-8";

  return (
    <div
      className={cn(
        "inline-flex items-center gap-1 rounded-md border border-primary/30 bg-background/60 backdrop-blur px-1",
        className,
      )}
      onClick={(e) => e.stopPropagation()}
    >
      <Button
        size="icon"
        variant="ghost"
        className={cn(btnSize, "text-primary hover:text-primary hover:bg-primary/10")}
        onClick={() => change(-1)}
        disabled={update.isPending || wine.quantity === 0}
        aria-label="Decrease quantity"
      >
        <Minus className="w-3.5 h-3.5" />
      </Button>
      <span
        className={cn(
          "text-center font-display tabular-nums",
          numSize,
          isZero ? "text-muted-foreground/60 italic" : "text-foreground",
        )}
      >
        {wine.quantity}
      </span>
      <Button
        size="icon"
        variant="ghost"
        className={cn(btnSize, "text-primary hover:text-primary hover:bg-primary/10")}
        onClick={() => change(1)}
        disabled={update.isPending}
        aria-label="Increase quantity"
      >
        <Plus className="w-3.5 h-3.5" />
      </Button>
    </div>
  );
};
