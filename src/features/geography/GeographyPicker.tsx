import { useMemo, useState } from "react";
import { Check, ChevronsUpDown, X } from "lucide-react";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import {
  Select, SelectContent, SelectGroup, SelectItem, SelectLabel, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import {
  Command, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList,
} from "@/components/ui/command";
import { cn } from "@/lib/utils";
import { useGeoLookups } from "./queries";
import {
  type GeoField, type GeoSelection, appellationOptions, resolveSelection,
} from "./selection";

export type { GeoSelection };
export { emptyGeoSelection } from "./selection";

const CONTINENT_ORDER = ["Europe", "Americas", "North America", "South America", "Oceania", "Africa", "Asia"];

/**
 * 4-Ebenen-Kaskade (Land → Region → Sub-Region → Appellation) auf FK-Basis.
 * Sämtliche Zustands-Übergänge laufen über `resolveSelection` (selection.ts):
 * Vorfahren werden aufgefüllt, widersprüchliche Nachfahren gelöscht, ungültige
 * Werte (z. B. Radix-interne ""-Resets) verworfen.
 */
export const GeographyPicker = ({
  value, onChange, disabled,
}: {
  value: GeoSelection;
  onChange: (next: GeoSelection) => void;
  disabled?: boolean;
}) => {
  const geo = useGeoLookups();
  const [appOpen, setAppOpen] = useState(false);

  const update = (field: GeoField, id: string | null) => {
    const next = resolveSelection(geo, value, field, id);
    if (next !== value) onChange(next);
  };
  const fromSelect = (v: string) => (v === "none" ? null : v);

  const continentGroups = useMemo(() => {
    const groups = new Map<string, typeof geo.countries>();
    for (const c of geo.countries) {
      const key = c.continent || "Other";
      if (!groups.has(key)) groups.set(key, []);
      groups.get(key)!.push(c);
    }
    const ordered: Array<{ continent: string; countries: typeof geo.countries }> = [];
    for (const cont of CONTINENT_ORDER) {
      const list = groups.get(cont);
      if (list?.length) {
        ordered.push({ continent: cont, countries: [...list].sort((a, b) => a.name.localeCompare(b.name)) });
        groups.delete(cont);
      }
    }
    for (const [cont, list] of groups.entries()) {
      ordered.push({ continent: cont, countries: [...list].sort((a, b) => a.name.localeCompare(b.name)) });
    }
    return ordered;
  }, [geo.countries]);

  const regions = geo.regionsByCountry(value.country_id);
  const subRegions = geo.subRegionsByRegion(value.region_id);
  const appellations = appellationOptions(geo, value);
  const selectedAppellation = value.appellation_id
    ? geo.appellationById.get(value.appellation_id)
    : undefined;

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
      <div>
        <Label>Country</Label>
        <Select
          value={value.country_id ?? "none"}
          onValueChange={(v) => update("country", fromSelect(v))}
          disabled={disabled}
        >
          <SelectTrigger><SelectValue placeholder="Select country" /></SelectTrigger>
          <SelectContent className="max-h-72">
            <SelectItem value="none">—</SelectItem>
            {continentGroups.map((g) => (
              <SelectGroup key={g.continent}>
                <SelectLabel className="text-[10px] uppercase tracking-widest text-primary/80">
                  {g.continent}
                </SelectLabel>
                {g.countries.map((c) => (
                  <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                ))}
              </SelectGroup>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div>
        <Label>Region</Label>
        <Select
          value={value.region_id ?? "none"}
          onValueChange={(v) => update("region", fromSelect(v))}
          disabled={disabled || !value.country_id}
        >
          <SelectTrigger>
            <SelectValue placeholder={value.country_id ? "Select region" : "Select a country first"} />
          </SelectTrigger>
          <SelectContent className="max-h-72">
            <SelectItem value="none">—</SelectItem>
            {regions.map((r) => (
              <SelectItem key={r.id} value={r.id}>{r.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div>
        <Label>Sub-region</Label>
        <Select
          value={value.sub_region_id ?? "none"}
          onValueChange={(v) => update("sub_region", fromSelect(v))}
          disabled={disabled || !value.region_id}
        >
          <SelectTrigger>
            <SelectValue placeholder={value.region_id ? "Select sub-region" : "Select a region first"} />
          </SelectTrigger>
          <SelectContent className="max-h-72">
            <SelectItem value="none">—</SelectItem>
            {subRegions.map((s) => (
              <SelectItem key={s.id} value={s.id}>{s.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div>
        <Label>Appellation</Label>
        <Popover open={appOpen} onOpenChange={setAppOpen}>
          <PopoverTrigger asChild>
            <Button
              type="button"
              variant="outline"
              role="combobox"
              aria-expanded={appOpen}
              disabled={disabled}
              className="w-full justify-between font-normal bg-input/50 px-3"
            >
              <span className={cn("truncate", !selectedAppellation && "text-muted-foreground text-xs")}>
                {selectedAppellation?.name ?? "Search…"}
              </span>
              <span className="flex items-center gap-1 shrink-0">
                {selectedAppellation && (
                  <X
                    className="w-3.5 h-3.5 opacity-60 hover:opacity-100"
                    onClick={(e) => {
                      e.stopPropagation();
                      update("appellation", null);
                    }}
                  />
                )}
                <ChevronsUpDown className="w-3.5 h-3.5 opacity-50" />
              </span>
            </Button>
          </PopoverTrigger>
          <PopoverContent className="w-[320px] p-0 bg-card gold-border" align="start">
            {/* value = UUID (eindeutig, fixes Doppelnamen-Kollisionen); gesucht
                wird ausschließlich über keywords (Name + Typ, simple Teilstring-Suche). */}
            <Command
              filter={(_, search, keywords) =>
                (keywords ?? []).join(" ").toLowerCase().includes(search.toLowerCase()) ? 1 : 0
              }
            >
              <CommandInput placeholder="Search appellation…" />
              <CommandList className="max-h-64">
                <CommandEmpty>No appellation found.</CommandEmpty>
                <CommandGroup>
                  {appellations.map((a) => (
                    <CommandItem
                      key={a.id}
                      value={a.id}
                      keywords={[a.name, a.type ?? ""]}
                      onSelect={() => {
                        update("appellation", a.id);
                        setAppOpen(false);
                      }}
                    >
                      <Check
                        className={cn(
                          "mr-2 h-4 w-4",
                          value.appellation_id === a.id ? "opacity-100" : "opacity-0",
                        )}
                      />
                      <span className="flex-1 truncate">{a.name}</span>
                      {a.type && (
                        <span className="text-[10px] text-muted-foreground uppercase ml-2">{a.type}</span>
                      )}
                    </CommandItem>
                  ))}
                </CommandGroup>
              </CommandList>
            </Command>
          </PopoverContent>
        </Popover>
      </div>
    </div>
  );
};
