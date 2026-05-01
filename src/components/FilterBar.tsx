import { Wine, WineColour, OCCASIONS, OCCASION_LABEL, Occasion } from "@/lib/wine";
import { useWineColoursCtx } from "@/contexts/WineColoursContext";
import { useWineCountries, useWineRegions } from "@/hooks/useWineGeography";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Search, X } from "lucide-react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";

export type SortKey = "added" | "producer" | "vintage" | "region" | "price";

// Filter values are now FK ids (country_id / region_id) not text strings.
export type Filters = {
  q: string;
  colour: WineColour | "all";
  country_id: string;
  region_id: string;
  occasion: Occasion | "all";
  vintageMin: string;
  vintageMax: string;
  inStockOnly: boolean;
  sort: SortKey;
};

export const emptyFilters: Filters = {
  q: "", colour: "all", country_id: "", region_id: "", occasion: "all",
  vintageMin: "", vintageMax: "", inStockOnly: false, sort: "added",
};

export const FilterBar = ({
  filters, setFilters, wines,
}: {
  filters: Filters;
  setFilters: (f: Filters) => void;
  wines: Wine[];
}) => {
  const { colours } = useWineColoursCtx();
  const { data: countries = [] } = useWineCountries();
  const { data: allRegions = [] } = useWineRegions();
  const regions = filters.country_id
    ? allRegions.filter((r) => r.country_id === filters.country_id)
    : [];
  const hasFilter = JSON.stringify(filters) !== JSON.stringify(emptyFilters);

  return (
    <div className="space-y-3 mb-6">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
        <Input
          placeholder="Search producer, description, variety, notes…"
          value={filters.q}
          onChange={(e) => setFilters({ ...filters, q: e.target.value })}
          className="pl-9 bg-input/50"
        />
      </div>
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-2">
        <Select value={filters.colour} onValueChange={(v) => setFilters({ ...filters, colour: v as any })}>
          <SelectTrigger><SelectValue placeholder="Colour" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All colours</SelectItem>
            {colours.map((c) => <SelectItem key={c.name} value={c.name}>{c.display_name}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select
          value={filters.country_id || "all"}
          onValueChange={(v) =>
            // Reset region whenever country changes
            setFilters({ ...filters, country_id: v === "all" ? "" : v, region_id: "" })
          }
        >
          <SelectTrigger><SelectValue placeholder="Country" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All countries</SelectItem>
            {countries.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
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
        <Select value={filters.occasion} onValueChange={(v) => setFilters({ ...filters, occasion: v as any })}>
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
        <Select value={filters.sort} onValueChange={(v) => setFilters({ ...filters, sort: v as SortKey })}>
          <SelectTrigger><SelectValue placeholder="Sort" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="added">Recently added</SelectItem>
            <SelectItem value="producer">Producer</SelectItem>
            <SelectItem value="vintage">Vintage</SelectItem>
            <SelectItem value="region">Region</SelectItem>
            <SelectItem value="price">Price</SelectItem>
          </SelectContent>
        </Select>
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

export const applyFilters = (wines: Wine[], f: Filters): Wine[] => {
  const list = wines.filter((b) => {
    if (f.q) {
      const q = f.q.toLowerCase();
      const hay = [b.producer, b.description, b.variety, b.notes, b.region, b.country].filter(Boolean).join(" ").toLowerCase();
      if (!hay.includes(q)) return false;
    }
    if (f.colour !== "all" && b.colour !== f.colour) return false;
    if (f.country_id && b.country_id !== f.country_id) return false;
    if (f.region_id && b.region_id !== f.region_id) return false;
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
      sorted.sort((a, b) => (a.region ?? "").localeCompare(b.region ?? "")); break;
    case "price":
      sorted.sort((a, b) => (b.price_chf ?? 0) - (a.price_chf ?? 0)); break;
    default: break;
  }
  return sorted;
};
