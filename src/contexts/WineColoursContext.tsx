import { createContext, useContext, useMemo, ReactNode } from "react";
import { useWineColours, WineColourRow } from "@/hooks/useWineColours";

type Ctx = {
  colours: WineColourRow[];
  byName: Record<string, WineColourRow>;
  labelFor: (name: string | null | undefined) => string;
  loading: boolean;
};

const WineColoursContext = createContext<Ctx | null>(null);

// Built-in colour visual styles (CSS classes) for known names. Custom names get a neutral fallback.
export const COLOUR_CLASS_BY_NAME: Record<string, string> = {
  sparkling: "bg-wine-sparkling text-background",
  white: "bg-wine-white text-background",
  red: "bg-wine-red text-foreground",
  orange_rose: "bg-wine-rose text-background",
  dessert_fortified: "bg-wine-dessert text-background",
};
export const FALLBACK_COLOUR_CLASS = "bg-secondary text-foreground border border-primary/30";

export const COLOUR_HEX_BY_NAME: Record<string, string> = {
  sparkling: "hsl(45, 70%, 70%)",
  white: "hsl(48, 55%, 75%)",
  red: "hsl(350, 70%, 35%)",
  orange_rose: "hsl(25, 70%, 60%)",
  dessert_fortified: "hsl(30, 65%, 50%)",
};
export const FALLBACK_COLOUR_HEX = "hsl(44, 53%, 54%)";

export const colourClassFor = (name: string | null | undefined): string =>
  (name && COLOUR_CLASS_BY_NAME[name]) || FALLBACK_COLOUR_CLASS;

export const colourHexFor = (name: string | null | undefined): string =>
  (name && COLOUR_HEX_BY_NAME[name]) || FALLBACK_COLOUR_HEX;

export const WineColoursProvider = ({ children }: { children: ReactNode }) => {
  const { data, isLoading } = useWineColours();
  const value = useMemo<Ctx>(() => {
    const colours = data ?? [];
    const byName: Record<string, WineColourRow> = {};
    for (const c of colours) byName[c.name] = c;
    return {
      colours,
      byName,
      labelFor: (name) => (name && byName[name]?.display_name) || name || "—",
      loading: isLoading,
    };
  }, [data, isLoading]);

  return <WineColoursContext.Provider value={value}>{children}</WineColoursContext.Provider>;
};

export const useWineColoursCtx = () => {
  const ctx = useContext(WineColoursContext);
  if (!ctx) throw new Error("useWineColoursCtx must be used within WineColoursProvider");
  return ctx;
};
