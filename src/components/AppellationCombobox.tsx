import { useState, useRef } from "react";
import { Input } from "@/components/ui/input";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import type {
  WineAppellationRow,
  WineCountryRow,
  WineRegionRow,
  WineSubRegionRow,
} from "@/hooks/useWineGeography";

export type AppellationAutoFill = {
  countryId: string;
  regionId: string;
  subRegionId: string;
  appellationName: string;
};

type Props = {
  value: string;
  onChange: (v: string) => void;
  /** Currently selected ids — used to scope the in-context tiered list */
  countryId: string;
  regionId: string;
  subRegionId: string;
  /** Full datasets — required for reverse lookup */
  allAppellations: WineAppellationRow[];
  countries: WineCountryRow[];
  regions: WineRegionRow[];
  subRegions: WineSubRegionRow[];
  /**
   * Called when a suggestion is picked. The handler must set
   * country/region/sub-region/appellation in one go WITHOUT triggering
   * cascading clears.
   */
  onAutoFill: (next: AppellationAutoFill) => void;
  placeholder?: string;
  disabled?: boolean;
};

type ResolvedContext = {
  countryId: string;
  regionId: string;
  subRegionId: string;
  countryName: string | null;
  regionName: string | null;
  subRegionName: string | null;
};

const matchesQuery = (name: string, query: string) => {
  if (!query) return true;
  const q = query.toLowerCase().trim();
  if (!q) return true;
  const n = name.toLowerCase();
  if (n.startsWith(q)) return true;
  // Match start of any word inside the name
  return n.split(/[\s\-/(),.]+/).some((w) => w.startsWith(q));
};

export const AppellationCombobox = ({
  value,
  onChange,
  countryId,
  regionId,
  subRegionId,
  allAppellations,
  countries,
  regions,
  subRegions,
  onAutoFill,
  placeholder,
  disabled,
}: Props) => {
  const [open, setOpen] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const countryById = new Map(countries.map((c) => [c.id, c]));
  const regionById = new Map(regions.map((r) => [r.id, r]));
  const subRegionById = new Map(subRegions.map((s) => [s.id, s]));

  const resolveContext = (a: WineAppellationRow): ResolvedContext => {
    let cId = a.country_id ?? "";
    let rId = a.region_id ?? "";
    let srId = a.sub_region_id ?? "";
    if (srId && !rId) {
      const sr = subRegionById.get(srId);
      if (sr) rId = sr.region_id;
    }
    if (rId && !cId) {
      const r = regionById.get(rId);
      if (r) cId = r.country_id;
    }
    return {
      countryId: cId,
      regionId: rId,
      subRegionId: srId,
      countryName: cId ? countryById.get(cId)?.name ?? null : null,
      regionName: rId ? regionById.get(rId)?.name ?? null : null,
      subRegionName: srId ? subRegionById.get(srId)?.name ?? null : null,
    };
  };

  const pick = (a: WineAppellationRow) => {
    const ctx = resolveContext(a);
    onAutoFill({
      countryId: ctx.countryId,
      regionId: ctx.regionId,
      subRegionId: ctx.subRegionId,
      appellationName: a.name,
    });
    setOpen(false);
    inputRef.current?.blur();
  };

  // ─── Build tier 1 / 2 / 3 (in-context) ───
  const tierAppellation = subRegionId
    ? allAppellations.filter(
        (a) => a.level === "appellation" && a.sub_region_id === subRegionId,
      )
    : regionId
    ? allAppellations.filter(
        (a) => a.level === "appellation" && a.region_id === regionId,
      )
    : [];
  const tierRegion = regionId
    ? allAppellations.filter(
        (a) => a.level === "region" && a.region_id === regionId,
      )
    : [];
  const tierCountry = countryId
    ? allAppellations.filter(
        (a) => a.level === "country" && a.country_id === countryId,
      )
    : [];

  // Apply text filter to each tier
  const fTierAppellation = tierAppellation.filter((a) => matchesQuery(a.name, value));
  const fTierRegion = tierRegion.filter((a) => matchesQuery(a.name, value));
  const fTierCountry = tierCountry.filter((a) => matchesQuery(a.name, value));

  const hasContextResults =
    fTierAppellation.length + fTierRegion.length + fTierCountry.length > 0;

  // ─── Reverse lookup ───
  // Activates when (a) no country selected and user typed, OR
  // (b) a country IS selected but current typed text yields no in-context results.
  const typed = (value ?? "").trim();
  const showReverse =
    typed.length > 0 && (!countryId || !hasContextResults);

  const reverseMatches = showReverse
    ? allAppellations.filter((a) => matchesQuery(a.name, typed))
    : [];

  // Group reverse matches by country name
  const reverseGrouped = (() => {
    const groups = new Map<string, { country: string | null; items: Array<{ a: WineAppellationRow; ctx: ResolvedContext }> }>();
    for (const a of reverseMatches) {
      const ctx = resolveContext(a);
      const key = ctx.countryName ?? "Unknown";
      if (!groups.has(key)) groups.set(key, { country: ctx.countryName, items: [] });
      groups.get(key)!.items.push({ a, ctx });
    }
    return [...groups.entries()]
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([, v]) => v);
  })();

  const renderTypeBadge = (t: string | null) =>
    t ? (
      <span className="text-[10px] uppercase tracking-wider text-muted-foreground shrink-0">
        {t}
      </span>
    ) : null;

  const renderHeader = (label: string) => (
    <div className="px-2 pt-2 pb-1 text-[10px] uppercase tracking-widest text-primary/70">
      {label}
    </div>
  );

  const renderItem = (a: WineAppellationRow, contextLine?: string) => (
    <button
      key={a.id}
      type="button"
      className={cn(
        "w-full text-left px-2 py-1.5 rounded-sm text-sm hover:bg-accent flex items-start justify-between gap-2",
      )}
      onClick={() => pick(a)}
    >
      <span className="flex flex-col min-w-0">
        <span className="truncate">{a.name}</span>
        {contextLine && (
          <span className="text-[11px] text-muted-foreground truncate">
            {contextLine}
          </span>
        )}
      </span>
      {renderTypeBadge(a.appellation_type)}
    </button>
  );

  const popoverOpen =
    open && allAppellations.length > 0 && (!!countryId || typed.length > 0);

  return (
    <Popover open={popoverOpen} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Input
          ref={inputRef}
          value={value}
          disabled={disabled}
          placeholder={placeholder}
          onChange={(e) => {
            onChange(e.target.value);
            setOpen(true);
          }}
          onFocus={() => setOpen(true)}
          autoComplete="off"
        />
      </PopoverTrigger>
      <PopoverContent
        className="p-1 max-h-72 overflow-auto bg-popover gold-border"
        align="start"
        onOpenAutoFocus={(e) => e.preventDefault()}
        style={{ width: "var(--radix-popover-trigger-width)" }}
      >
        {showReverse ? (
          reverseGrouped.map((g) => (
            <div key={g.country ?? "unknown"}>
              {renderHeader(g.country ?? "Unknown")}
              {g.items.map(({ a, ctx }) => {
                const parts = [
                  ctx.subRegionName,
                  ctx.regionName,
                  ctx.countryName,
                ].filter(Boolean);
                return renderItem(a, parts.join(" — "));
              })}
            </div>
          ))
        ) : (
          <>
            {fTierAppellation.length > 0 && (
              <>
                {renderHeader("Appellation")}
                {fTierAppellation.map((a) => renderItem(a))}
              </>
            )}
            {fTierRegion.length > 0 && (
              <>
                {renderHeader("Regional")}
                {fTierRegion.map((a) => renderItem(a))}
              </>
            )}
            {fTierCountry.length > 0 && (
              <>
                {renderHeader("Country-wide")}
                {fTierCountry.map((a) => renderItem(a))}
              </>
            )}
          </>
        )}
      </PopoverContent>
    </Popover>
  );
};
