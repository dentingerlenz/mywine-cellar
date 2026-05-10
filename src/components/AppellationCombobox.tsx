import { useState, useRef, useEffect } from "react";
import { Input } from "@/components/ui/input";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import type { WineAppellationRow } from "@/hooks/useWineGeography";

type Props = {
  value: string;
  onChange: (v: string) => void;
  suggestions: WineAppellationRow[];
  placeholder?: string;
  disabled?: boolean;
};

export const AppellationCombobox = ({ value, onChange, suggestions, placeholder, disabled }: Props) => {
  const [open, setOpen] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const filtered = suggestions.filter((s) =>
    !value ? true : s.name.toLowerCase().includes(value.toLowerCase()),
  );

  return (
    <Popover open={open && filtered.length > 0} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Input
          ref={inputRef}
          value={value}
          disabled={disabled}
          placeholder={placeholder}
          onChange={(e) => { onChange(e.target.value); setOpen(true); }}
          onFocus={() => setOpen(true)}
          autoComplete="off"
        />
      </PopoverTrigger>
      <PopoverContent
        className="p-1 max-h-64 overflow-auto bg-popover gold-border"
        align="start"
        onOpenAutoFocus={(e) => e.preventDefault()}
        style={{ width: "var(--radix-popover-trigger-width)" }}
      >
        {filtered.map((s) => (
          <button
            key={s.id}
            type="button"
            className={cn(
              "w-full text-left px-2 py-1.5 rounded-sm text-sm hover:bg-accent flex items-center justify-between gap-2",
            )}
            onClick={() => { onChange(s.name); setOpen(false); inputRef.current?.blur(); }}
          >
            <span className="truncate">{s.name}</span>
            {s.appellation_type && (
              <span className="text-[10px] uppercase tracking-wider text-muted-foreground shrink-0">
                {s.appellation_type}
              </span>
            )}
          </button>
        ))}
      </PopoverContent>
    </Popover>
  );
};
