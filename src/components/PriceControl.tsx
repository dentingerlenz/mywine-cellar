import { useEffect, useRef, useState } from "react";
import { Wine } from "@/lib/wine";
import { useUpdatePrice } from "@/hooks/useWines";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

type Props = {
  wine: Wine;
  size?: "sm" | "md";
  align?: "left" | "right";
  className?: string;
};

export const PriceControl = ({ wine, size = "sm", align = "left", className }: Props) => {
  const update = useUpdatePrice();
  const [editing, setEditing] = useState(false);
  const [draft, setDraft] = useState(
    wine.price_chf != null ? String(wine.price_chf) : "",
  );
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (!editing) setDraft(wine.price_chf != null ? String(wine.price_chf) : "");
  }, [wine.price_chf, editing]);

  useEffect(() => {
    if (editing) {
      inputRef.current?.focus();
      inputRef.current?.select();
    }
  }, [editing]);

  const savePrice = async (next: number | null) => {
    const current = wine.price_chf ?? null;
    if (next === current) return;
    try {
      await update.mutateAsync({ id: wine.id, price_chf: next });
      toast.success(next == null ? "Price cleared" : `Price updated · ${next.toFixed(0)} CHF`);
    } catch (e: any) {
      toast.error(e.message || "Could not update price");
    }
  };

  const commit = () => {
    const trimmed = draft.trim();
    if (trimmed === "") {
      savePrice(null);
    } else {
      const n = Number(trimmed);
      if (!Number.isFinite(n) || n < 0) {
        setDraft(wine.price_chf != null ? String(wine.price_chf) : "");
      } else {
        savePrice(n);
      }
    }
    setEditing(false);
  };

  const cancel = () => {
    setDraft(wine.price_chf != null ? String(wine.price_chf) : "");
    setEditing(false);
  };

  const textSize = size === "sm" ? "text-sm" : "text-base";
  const alignClass = align === "right" ? "text-right" : "text-left";

  return (
    <span
      className={cn("inline-flex items-baseline gap-1 whitespace-nowrap", className)}
      onClick={(e) => e.stopPropagation()}
    >
      {editing ? (
        <>
          <input
            ref={inputRef}
            type="number"
            inputMode="decimal"
            min={0}
            step="0.01"
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
            placeholder="—"
            className={cn(
              "w-16 bg-transparent outline-none border-b border-primary/50 focus:border-primary font-display tabular-nums text-primary [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none",
              textSize,
              alignClass,
            )}
            aria-label="Edit price"
          />
          <span className="font-display text-primary text-xs">CHF</span>
        </>
      ) : (
        <button
          type="button"
          onClick={() => setEditing(true)}
          className={cn(
            "font-display tabular-nums hover:text-primary transition-colors cursor-text",
            textSize,
            alignClass,
            wine.price_chf != null ? "text-primary" : "text-muted-foreground italic text-xs",
          )}
          aria-label="Edit price"
        >
          {wine.price_chf != null ? `${wine.price_chf.toFixed(0)} CHF` : "No price"}
        </button>
      )}
    </span>
  );
};
