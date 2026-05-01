import { useEffect, useRef, useState } from "react";
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
  const [editing, setEditing] = useState(false);
  const [draft, setDraft] = useState(String(wine.quantity));
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (!editing) setDraft(String(wine.quantity));
  }, [wine.quantity, editing]);

  useEffect(() => {
    if (editing) {
      inputRef.current?.focus();
      inputRef.current?.select();
    }
  }, [editing]);

  const setQuantity = async (next: number) => {
    const safe = Math.max(0, Math.floor(next));
    if (safe === wine.quantity) return;
    try {
      await update.mutateAsync({ id: wine.id, quantity: safe });
      toast.success(`Quantity updated · ×${safe}`);
    } catch (e: any) {
      toast.error(e.message || "Could not update quantity");
    }
  };

  const change = (delta: number) => setQuantity(wine.quantity + delta);

  const commit = () => {
    const parsed = parseInt(draft, 10);
    if (Number.isNaN(parsed) || parsed < 0) {
      setDraft(String(wine.quantity));
    } else if (parsed !== wine.quantity) {
      setQuantity(parsed);
    }
    setEditing(false);
  };

  const cancel = () => {
    setDraft(String(wine.quantity));
    setEditing(false);
  };

  const btnSize = size === "sm" ? "h-7 w-7" : "h-8 w-8";
  const numSize = size === "sm" ? "text-sm w-8" : "text-base w-10";

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
      {editing ? (
        <input
          ref={inputRef}
          type="number"
          inputMode="numeric"
          min={0}
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onBlur={commit}
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              e.preventDefault();
              commit();
            } else if (e.key === "Escape") {
              e.preventDefault();
              cancel();
            }
          }}
          className={cn(
            "text-center font-display tabular-nums bg-transparent outline-none border-b border-primary/50 focus:border-primary [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none",
            numSize,
          )}
          aria-label="Edit quantity"
        />
      ) : (
        <button
          type="button"
          onClick={() => setEditing(true)}
          className={cn(
            "text-center font-display tabular-nums hover:text-primary transition-colors cursor-text",
            numSize,
            isZero ? "text-muted-foreground/60 italic" : "text-foreground",
          )}
          aria-label="Edit quantity"
        >
          {wine.quantity}
        </button>
      )}
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
