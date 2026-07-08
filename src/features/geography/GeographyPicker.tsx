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

export type GeoSelection = {
  country_id: string | null;
  region_id: string | null;
  sub_region_id: string | null;
  appellation_id: string | null;
};

export const emptyGeoSelection: GeoSelection = {
  country_id: null, region_id: null, sub_region_id: null, appellation_id: null,
};

const CONTINENT_ORDER = ["Europe", "Americas", "North America", "South America", "Oceania", "Africa", "Asia"];

/**
 * 4-Ebenen-Kaskade (Land → Region → Sub-Region → Appellation) auf FK-Basis.
 * Appellation-Wahl füllt die Vorfahren automatisch (eine Quelle: useGeoLookups).
 * Wiederverwendet in Formular, Filtern und Settings (Plan §6.1).
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
  const appellations = geo.appellationsForSelection(value);
  const selectedAppellation = value.appellation_id
    ? geo.appellationById.get(value.appellation_id)
    : undefined;

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
      <div>
        <Label>Country</Label>
        <Select
          value={value.country_id ?? "none"}
          onValueChange={(v) =>
            onChange({ ...emptyGeoSelection, country_id: v === "none" ? null : v })
          }
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
          onValueChange={(v) =>
            onChange({
              ...value,
              region_id: v === "none" ? null : v,
              sub_region_id: null,
              appellation_id: null,
            })
          }
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
          onValueChange={(v) =>
            // Appellation bewusst NICHT löschen — manuelle Sub-Region-Wahl
            // soll eine bereits gewählte Appellation nicht wegwischen.
            onChange({ ...value, sub_region_id: v === "none" ? null : v })
          }
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
                      onChange({ ...value, appellation_id: null });
                    }}
                  />
                )}
                <ChevronsUpDown className="w-3.5 h-3.5 opacity-50" />
              </span>
            </Button>
          </PopoverTrigger>
          <PopoverContent className="w-[320px] p-0 bg-card gold-border" align="start">
            <Command>
              <CommandInput placeholder="Search appellation…" />
              <CommandList className="max-h-64">
                <CommandEmpty>No appellation found.</CommandEmpty>
                <CommandGroup>
                  {appellations.map((a) => (
                    <CommandItem
                      key={a.id}
                      value={`${a.name} ${a.type ?? ""}`}
                      onSelect={() => {
                        // Vorfahren automatisch setzen — kein manuelles Nachziehen
                        onChange({
                          country_id: value.country_id,
                          region_id: value.region_id,
                          sub_region_id: value.sub_region_id,
                          ...geo.ancestorsOfAppellation(a.id),
                          appellation_id: a.id,
                        });
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
