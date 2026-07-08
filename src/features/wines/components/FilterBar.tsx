import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Search, X } from "lucide-react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { type Wine, OCCASIONS, OCCASION_LABEL, type Occasion } from "../model";
import { useColourLookup } from "@/features/colours/queries";
import { useGeoLookups } from "@/features/geography/queries";

export type SortKey = "added" | "producer" | "vintage" | "region" | "price";

export type Filters = {
  q: string;
  colour_id: string; // "" = alle
  country_id: string;
  region_id: string;
  storage: string; // V1: Lagerplatz ("" = alle)
  occasion: Occasion | "all";
  vintageMin: string;
  vintageMax: string;
  inStockOnly: boolean;
  sort: SortKey;
};

export const emptyFilters: Filters = {
  q: "", colour_id: "", country_id: "", region_id: "", storage: "", occasion: "all",
  vintageMin: "", vintageMax: "", inStockOnly: false, sort: "producer",
};

export const FilterBar = ({
  filters, setFilters, wines,
}: {
  filters: Filters;
  setFilters: (f: Filters) => void;
  wines: Wine[];
}) => {
  const { colours } = useColourLookup();
  const geo = useGeoLookups();

  // Nur Länder/Regionen anbieten, die im Bestand vorkommen
  const usedCountryIds = new Set(wines.map((w) => w.country_id).filter((id): id is string => !!id));
  const usedRegionIds = new Set(wines.map((w) => w.region_id).filter((id): id is string => !!id));
  const visibleCountries = geo.countries.filter((c) => usedCountryIds.has(c.id));
  const regions = geo
    .regionsByCountry(filters.country_id || null)
    .filter((r) => usedRegionIds.has(r.id));
  const storageLocations = Array.from(
    new Set(wines.map((w) => w.storage_location).filter((s): s is string => !!s?.trim()))
  ).sort((a, b) => a.localeCompare(b));

  const hasFilter = JSON.stringify(filters) !== JSON.stringify(emptyFilters);

  return (
    <div className="space-y-3 mb-6">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
        <Input
          placeholder="Search producer, name, variety, notes, place…"
          value={filters.q}
          onChange={(e) => setFilters({ ...filters, q: e.target.value })}
          className="pl-9 bg-input/50"
        />
      </div>
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-7 gap-2">
        <Select
          value={filters.colour_id || "all"}
          onValueChange={(v) => setFilters({ ...filters, colour_id: v === "all" ? "" : v })}
        >
          <SelectTrigger><SelectValue placeholder="Colour" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All colours</SelectItem>
            {colours.map((c) => <SelectItem key={c.id} value={c.id}>{c.display_name}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select
          value={filters.country_id || "all"}
          onValueChange={(v) =>
            setFilters({ ...filters, country_id: v === "all" ? "" : v, region_id: "" })
          }
        >
          <SelectTrigger><SelectValue placeholder="Country" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All countries</SelectItem>
            {visibleCountries.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select
          value={filters.region_id || "all"}
          onValueChange={(v) => setFilters({ ...filters, region_id: v === "all" ? "" : v })}
          disabled={!filters.country_id}
        >
          <SelectTrigger>
            <SelectValue placeholder={filters.country_id ? "Region" : "Select a country first"} />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All regions</SelectItem>
            {regions.map((r) => <SelectItem key={r.id} value={r.id}>{r.name}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select
          value={filters.storage || "all"}
          onValueChange={(v) => setFilters({ ...filters, storage: v === "all" ? "" : v })}
          disabled={storageLocations.length === 0}
        >
          <SelectTrigger><SelectValue placeholder="Storage" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All locations</SelectItem>
            {storageLocations.map((s) => <SelectItem key={s} value={s}>{s}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select
          value={filters.occasion}
          onValueChange={(v) => setFilters({ ...filters, occasion: v as Filters["occasion"] })}
        >
          <SelectTrigger><SelectValue placeholder="Occasion" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Any occasion</SelectItem>
            {OCCASIONS.map((o) => <SelectItem key={o} value={o}>{OCCASION_LABEL[o]}</SelectItem>)}
          </SelectContent>
        </Select>
        <div className="flex gap-1">
          <Input type="number" placeholder="From" value={filters.vintageMin} onChange={(e) => setFilters({ ...filters, vintageMin: e.target.value })} />
          <Input type="number" placeholder="To" value={filters.vintageMax} onChange={(e) => setFilters({ ...filters, vintageMax: e.target.value })} />
        </div>
        <div className="flex items-center gap-2 px-3 rounded-md border border-border bg-input/50">
          <Switch id="inStock" checked={filters.inStockOnly} onCheckedChange={(v) => setFilters({ ...filters, inStockOnly: v })} />
          <Label htmlFor="inStock" className="text-xs cursor-pointer">In stock</Label>
        </div>
      </div>
      {hasFilter && (
        <Button variant="ghost" size="sm" onClick={() => setFilters(emptyFilters)} className="text-xs">
          <X className="w-3 h-3" /> Clear filters
        </Button>
      )}
    </div>
  );
};

const parseVintageYear = (v: string | null): number | null => {
  if (!v) return null;
  const m = v.match(/(\d{4})/);
  return m ? Number(m[1]) : null;
};

/** Namen für Suche/Sortierung liefert der Aufrufer (aus useGeoLookups). */
export type GeoNames = {
  regionName: (w: Wine) => string;
  searchText: (w: Wine) => string;
};

export const applyFilters = (wines: Wine[], f: Filters, geo: GeoNames): Wine[] => {
  const list = wines.filter((b) => {
    if (f.q) {
      const q = f.q.toLowerCase();
      if (!geo.searchText(b).includes(q)) return false;
    }
    if (f.colour_id && b.colour_id !== f.colour_id) return false;
    if (f.country_id && b.country_id !== f.country_id) return false;
    if (f.region_id && b.region_id !== f.region_id) return false;
    if (f.storage && b.storage_location !== f.storage) return false;
    if (f.occasion !== "all" && b.occasion !== f.occasion) return false;
    if (f.inStockOnly && b.quantity <= 0) return false;
    const y = parseVintageYear(b.vintage);
    if (f.vintageMin) { if (y == null || y < Number(f.vintageMin)) return false; }
    if (f.vintageMax) { if (y == null || y > Number(f.vintageMax)) return false; }
    return true;
  });

  const sorted = [...list];
  switch (f.sort) {
    case "producer":
      sorted.sort((a, b) => (a.producer ?? "").localeCompare(b.producer ?? "")); break;
    case "vintage":
      sorted.sort((a, b) => (parseVintageYear(b.vintage) ?? 0) - (parseVintageYear(a.vintage) ?? 0)); break;
    case "region":
      sorted.sort((a, b) => geo.regionName(a).localeCompare(geo.regionName(b))); break;
    case "price":
      sorted.sort((a, b) => (b.price_chf ?? 0) - (a.price_chf ?? 0)); break;
    default: break;
  }
  return sorted;
};
