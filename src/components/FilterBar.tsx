import { Bottle, WINE_COLOURS, COLOUR_LABEL, WineColour } from "@/lib/wine";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Search, X } from "lucide-react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

export type Filters = {
  q: string;
  colour: WineColour | "all";
  country: string;
  region: string;
  grape: string;
  vintageMin: string;
  vintageMax: string;
  drinkStatus: "all" | "drink_now" | "too_young" | "past_peak";
};

export const emptyFilters: Filters = {
  q: "", colour: "all", country: "", region: "", grape: "",
  vintageMin: "", vintageMax: "", drinkStatus: "all",
};

export const FilterBar = ({
  filters, setFilters, bottles,
}: {
  filters: Filters;
  setFilters: (f: Filters) => void;
  bottles: Bottle[];
}) => {
  const countries = Array.from(new Set(bottles.map((b) => b.country).filter(Boolean) as string[])).sort();
  const regions = Array.from(new Set(bottles.map((b) => b.region).filter(Boolean) as string[])).sort();
  const hasFilter = JSON.stringify(filters) !== JSON.stringify(emptyFilters);

  return (
    <div className="space-y-3 mb-6">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
        <Input
          placeholder="Search by name or producer…"
          value={filters.q}
          onChange={(e) => setFilters({ ...filters, q: e.target.value })}
          className="pl-9 bg-input/50"
        />
      </div>
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-2">
        <Select value={filters.colour} onValueChange={(v) => setFilters({ ...filters, colour: v as any })}>
          <SelectTrigger><SelectValue placeholder="Colour" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All colours</SelectItem>
            {WINE_COLOURS.map((c) => <SelectItem key={c} value={c}>{COLOUR_LABEL[c]}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={filters.country || "all"} onValueChange={(v) => setFilters({ ...filters, country: v === "all" ? "" : v })}>
          <SelectTrigger><SelectValue placeholder="Country" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All countries</SelectItem>
            {countries.map((c) => <SelectItem key={c} value={c}>{c}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={filters.region || "all"} onValueChange={(v) => setFilters({ ...filters, region: v === "all" ? "" : v })}>
          <SelectTrigger><SelectValue placeholder="Region" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All regions</SelectItem>
            {regions.map((r) => <SelectItem key={r} value={r}>{r}</SelectItem>)}
          </SelectContent>
        </Select>
        <Input placeholder="Grape" value={filters.grape} onChange={(e) => setFilters({ ...filters, grape: e.target.value })} />
        <div className="flex gap-1">
          <Input type="number" placeholder="From" value={filters.vintageMin} onChange={(e) => setFilters({ ...filters, vintageMin: e.target.value })} />
          <Input type="number" placeholder="To" value={filters.vintageMax} onChange={(e) => setFilters({ ...filters, vintageMax: e.target.value })} />
        </div>
        <Select value={filters.drinkStatus} onValueChange={(v) => setFilters({ ...filters, drinkStatus: v as any })}>
          <SelectTrigger><SelectValue placeholder="Window" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Any window</SelectItem>
            <SelectItem value="drink_now">Drink now</SelectItem>
            <SelectItem value="too_young">Too young</SelectItem>
            <SelectItem value="past_peak">Past peak</SelectItem>
          </SelectContent>
        </Select>
      </div>
      {hasFilter && (
        <Button variant="ghost" size="sm" onClick={() => setFilters(emptyFilters)} className="text-xs">
          <X className="w-3 h-3" /> Clear filters
        </Button>
      )}
    </div>
  );
};

export const applyFilters = (bottles: Bottle[], f: Filters): Bottle[] => {
  return bottles.filter((b) => {
    if (f.q) {
      const q = f.q.toLowerCase();
      if (!b.name.toLowerCase().includes(q) && !(b.producer ?? "").toLowerCase().includes(q)) return false;
    }
    if (f.colour !== "all" && b.colour !== f.colour) return false;
    if (f.country && b.country !== f.country) return false;
    if (f.region && b.region !== f.region) return false;
    if (f.grape && !(b.grape ?? "").toLowerCase().includes(f.grape.toLowerCase())) return false;
    if (f.vintageMin && (b.vintage ?? 0) < Number(f.vintageMin)) return false;
    if (f.vintageMax && (b.vintage ?? 9999) > Number(f.vintageMax)) return false;
    if (f.drinkStatus !== "all") {
      const year = new Date().getFullYear();
      const status =
        b.ready_from == null && b.drink_by == null ? "unknown"
        : b.ready_from != null && year < b.ready_from ? "too_young"
        : b.drink_by != null && year > b.drink_by ? "past_peak"
        : "drink_now";
      if (status !== f.drinkStatus) return false;
    }
    return true;
  });
};
