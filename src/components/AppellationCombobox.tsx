import { useState, useRef } from "react";
import { Input } from "@/components/ui/input";
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
  countryId: string;
  regionId: string;
  subRegionId: string;
  allAppellations: WineAppellationRow[];
  countries: WineCountryRow[];
  regions: WineRegionRow[];
  subRegions: WineSubRegionRow[];
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
  if (!query.trim()) return true;
  const q = query.toLowerCase().trim();
  const n = name.toLowerCase();
  if (n.startsWith(q)) return true;
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
  const inputRef = useRef(null);

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

  const pick = (a: WineAppellationRow, ctx?: ResolvedContext) => {
    const resolved = ctx ?? resolveContext(a);
    onAutoFill({
      countryId: resolved.countryId,
      regionId: resolved.regionId,
      subRegionId: resolved.subRegionId,
      appellationName: a.name,
    });
    setOpen(false);
    inputRef.current?.blur();
  };

  const typed = (value ?? "").trim();

  // ─── In-context tiers (country/region/sub-region already selected) ───
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

  const fTierAppellation = tierAppellation.filter((a) => matchesQuery(a.name, typed));
  const fTierRegion = tierRegion.filter((a) => matchesQuery(a.name, typed));
  const fTierCountry = tierCountry.filter((a) => matchesQuery(a.name, typed));
  const hasContextResults =
    fTierAppellation.length + fTierRegion.length + fTierCountry.length > 0;

  // ─── Reverse lookup ───
  // Show when: no country selected at all, OR country selected but nothing
  // matches in context AND the user has typed something.
  const showReverse =
    allAppellations.length > 0 &&
    typed.length > 0 &&
    (!countryId || !hasContextResults);

  const reverseMatches = showReverse
    ? allAppellations.filter((a) => matchesQuery(a.name, typed))
    : [];

  const reverseGrouped = (() => {
    // Deduplicate by country+region+name. If a name appears across multiple
    // sub-regions of the same region, clear sub_region so autofill doesn't
    // arbitrarily pick one.
    const seen = new Map<string, { a: WineAppellationRow; ctx: ResolvedContext }>();
    for (const a of reverseMatches) {
      const ctx = resolveContext(a);
      const dedupeKey = `${ctx.countryName ?? ""}|${ctx.regionId}|${a.name}`;
      if (!seen.has(dedupeKey)) {
        const subRegionCount = reverseMatches.filter((m) => {
          const mCtx = resolveContext(m);
          return m.name === a.name && mCtx.regionId === ctx.regionId;
        }).length;
        seen.set(dedupeKey, {
          a,
          ctx:
            subRegionCount > 1
              ? { ...ctx, subRegionId: "", subRegionName: null }
              : ctx,
        });
      }
    }

    const groups = new Map<
      string,
      { country: string | null; items: Array<{ a: WineAppellationRow; ctx: ResolvedContext }> }
    >();
    for (const { a, ctx } of seen.values()) {
      const key = ctx.countryName ?? "Unknown";
      if (!groups.has(key)) groups.set(key, { country: ctx.countryName, items: [] });
      groups.get(key)!.items.push({ a, ctx });
    }
    return [...groups.entries()]
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([, v]) => v);
  })();

  // ─── Decide whether to show the popover ───
  // Always show if: data is loaded AND (user typed something OR a country is selected)
  const shouldShowPopover =
    open &&
    allAppellations.length > 0 &&
    (typed.length > 0 || !!countryId);

  const hasAnything = showReverse
    ? reverseMatches.length > 0
    : hasContextResults;

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

  const renderItem = (
    a: WineAppellationRow,
    contextLine?: string,
    ctx?: ResolvedContext,
  ) => (
    <button
      key={a.id + (ctx?.subRegionId ?? "")}
      type="button"
      className={cn(
        "w-full text-left px-2 py-1.5 rounded-sm text-sm hover:bg-accent flex items-start justify-between gap-2",
      )}
      onClick={() => pick(a, ctx)}
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

  return (
    <div className="relative">
      <Input
        ref={inputRef}
        value={value}
        disabled={disabled}
        placeholder={placeholder ?? "Type appellation to search…"}
        onChange={(e) => {
          onChange(e.target.value);
          setOpen(true);
        }}
        onFocus={() => setOpen(true)}
        onBlur={() => setTimeout(() => setOpen(false), 150)}
        autoComplete="off"
      />
      {shouldShowPopover && hasAnything && (
        <div className="absolute z-50 left-0 right-0 top-full mt-1 max-h-72 overflow-auto rounded-md border bg-popover shadow-md gold-border p-1">
          {showReverse ? (
            reverseGrouped.length > 0 ? (
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
              <div className="px-2 py-1.5 text-sm text-muted-foreground">
                No appellations found for &ldquo;{typed}&rdquo;
              </div>
            )
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
        </div>
      )}
    </div>
  );
};
