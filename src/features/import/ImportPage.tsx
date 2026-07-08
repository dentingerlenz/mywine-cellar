import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Papa from "papaparse";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { supabase } from "@/integrations/supabase/client";
import { wineSchema, type WineInput, OCCASIONS } from "@/features/wines/model";
import { useBulkInsertWines } from "@/features/wines/queries";
import { useColours } from "@/features/colours/queries";
import { useGeoLookups } from "@/features/geography/queries";
import { resolveGeoNames } from "@/features/geography/resolveGeoNames";
import { useQueryClient } from "@tanstack/react-query";
import { qk } from "@/lib/queryKeys";
import { toast } from "sonner";
import { ArrowLeft, Upload, Loader2, AlertCircle, CheckCircle2 } from "lucide-react";

type RawRow = Record<string, string | undefined>;
type ParsedRow = { row: number; raw: RawRow; data?: WineInput; error?: string };

const COLOUR_SLUGS = ["sparkling", "white", "red", "rose", "orange", "dessert_fortified"];

const normaliseColourSlug = (v: string | undefined): string | undefined => {
  if (!v) return undefined;
  const s = v.toLowerCase().trim().replace(/[éè]/g, "e").replace(/[\s/-]+/g, "_");
  if (COLOUR_SLUGS.includes(s)) return s;
  if (s.startsWith("spa") || s.includes("champ") || s.includes("bub")) return "sparkling";
  if (s.startsWith("whi") || s.startsWith("wei")) return "white";
  if (s.startsWith("red") || s.startsWith("rot")) return "red";
  if (s.startsWith("ros")) return "rose";
  if (s.startsWith("ora")) return "orange";
  if (s.startsWith("des") || s.includes("sweet") || s.includes("port") || s.includes("forti")) return "dessert_fortified";
  return undefined;
};

const normaliseOccasion = (v: string | undefined): WineInput["occasion"] => {
  if (!v) return null;
  const s = v.trim();
  if ((OCCASIONS as readonly string[]).includes(s)) return s as WineInput["occasion"];
  // v1-Kürzel und lesbare Varianten akzeptieren
  const map: Record<string, WineInput["occasion"]> = { a: "anytime", t: "special", l: "lay_down", T: "top" };
  if (s in map) return map[s];
  const l = s.toLowerCase();
  if (l.startsWith("any")) return "anytime";
  if (l.startsWith("spec")) return "special";
  if (l.startsWith("lay") || l.startsWith("age")) return "lay_down";
  if (l.startsWith("top")) return "top";
  return null;
};

const num = (v: string | undefined): number | undefined => {
  if (v === undefined || v === null || v === "") return undefined;
  const n = Number(String(v).replace(",", "."));
  return Number.isFinite(n) ? n : undefined;
};

export default function ImportPage() {
  const navigate = useNavigate();
  const qc = useQueryClient();
  const bulk = useBulkInsertWines();
  const { data: colours = [] } = useColours();
  const geo = useGeoLookups();
  const [rows, setRows] = useState<ParsedRow[]>([]);
  const [fileName, setFileName] = useState("");
  const [importing, setImporting] = useState(false);

  const colourIdBySlug = new Map(colours.map((c) => [c.name, c.id]));

  const onFile = (file: File) => {
    setFileName(file.name);
    Papa.parse<RawRow>(file, {
      header: true,
      skipEmptyLines: true,
      transformHeader: (h) => h.toLowerCase().trim().replace(/\s+/g, "_"),
      complete: (results) => {
        const parsed: ParsedRow[] = results.data.map((raw, i) => {
          const slug = normaliseColourSlug(raw.colour ?? raw.color);
          const colour_id = slug ? colourIdBySlug.get(slug) : undefined;
          if (!colour_id) {
            return { row: i + 2, raw, error: `colour: unknown value "${raw.colour ?? raw.color ?? ""}"` };
          }
          // Geo-Text → FK-IDs (Namen bleiben zur Anzeige im raw)
          const resolved = resolveGeoNames(
            {
              country: raw.country,
              region: raw.region,
              sub_region: raw.sub_region ?? raw.subregion,
              appellation: raw.appellation,
            },
            geo,
          );
          const cl = num(raw.cl);
          const candidate = {
            producer: raw.producer,
            name: raw.name ?? raw.description,
            vintage: raw.vintage ? String(raw.vintage) : undefined,
            colour_id,
            variety: raw.variety,
            size_ml: num(raw.size_ml) ?? (cl != null ? Math.round(cl * 10) : undefined),
            residual_sugar_gl: num(raw.residual_sugar_gl ?? raw.residual_sugar),
            dosage: raw.dosage,
            alcohol_pct: num(raw.alcohol_pct ?? raw.alcohol),
            country_id: resolved.country_id,
            region_id: resolved.region_id,
            sub_region_id: resolved.sub_region_id,
            appellation_id: resolved.appellation_id,
            terroir_notes: raw.terroir_notes ?? raw.ausbau_terroir ?? raw.ausbau,
            notes: raw.notes,
            occasion: normaliseOccasion(raw.occasion),
            quantity: num(raw.quantity) ?? 1,
            price_chf: num(raw.price_chf ?? raw.price),
            purchased_from: raw.purchased_from ?? raw.purchase_source,
            storage_location: raw.storage_location ?? raw.storage,
          };
          const result = wineSchema.safeParse(candidate);
          if (result.success) return { row: i + 2, raw, data: result.data };
          return {
            row: i + 2,
            raw,
            error: result.error.issues.map((x) => `${x.path.join(".")}: ${x.message}`).join("; "),
          };
        });
        setRows(parsed);
      },
      error: (err) => toast.error(err.message),
    });
  };

  const valid = rows.filter((r) => r.data);
  const invalid = rows.filter((r) => r.error);
  const unresolvedGeoCount = valid.filter(
    (r) =>
      (r.raw.country && !r.data?.country_id) ||
      (r.raw.region && !r.data?.region_id) ||
      ((r.raw.sub_region ?? r.raw.subregion) && !r.data?.sub_region_id) ||
      (r.raw.appellation && !r.data?.appellation_id),
  ).length;

  /**
   * Fehlende Länder/Regionen anlegen (Referenzdaten sind global; Familien-
   * Pragmatik wie in v1). Sub-Regionen/Appellationen werden NICHT auto-erzeugt
   * — die pflegt der Geo-Datensatz.
   */
  const createMissingGeo = async (r: ParsedRow): Promise<Partial<WineInput>> => {
    const patch: Partial<WineInput> = {};
    const cName = (r.raw.country ?? "").trim();
    const rName = (r.raw.region ?? "").trim();
    let countryId = r.data?.country_id ?? null;

    if (cName && !countryId) {
      const { data, error } = await supabase
        .from("countries")
        .insert({ name: cName, sort_order: geo.countries.length })
        .select("id")
        .single();
      if (error) {
        // Unique-Konflikt: parallel angelegt → nachschlagen
        const { data: existing } = await supabase
          .from("countries").select("id").ilike("name", cName).maybeSingle();
        countryId = existing?.id ?? null;
      } else {
        countryId = data.id;
      }
      patch.country_id = countryId;
    }

    if (rName && countryId && !r.data?.region_id) {
      const { data, error } = await supabase
        .from("regions")
        .insert({ country_id: countryId, name: rName })
        .select("id")
        .single();
      if (error) {
        const { data: existing } = await supabase
          .from("regions").select("id").eq("country_id", countryId).ilike("name", rName).maybeSingle();
        patch.region_id = existing?.id ?? null;
      } else {
        patch.region_id = data.id;
      }
    }
    return patch;
  };

  const onImport = async () => {
    if (valid.length === 0) return;
    setImporting(true);
    try {
      const enriched: WineInput[] = [];
      for (const r of valid) {
        const patch = await createMissingGeo(r);
        enriched.push({ ...(r.data as WineInput), ...patch });
      }
      await bulk.mutateAsync(enriched);
      qc.invalidateQueries({ queryKey: qk.countries });
      qc.invalidateQueries({ queryKey: qk.regions });
      toast.success(`${valid.length} bottles imported`);
      navigate("/");
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Import failed");
    } finally {
      setImporting(false);
    }
  };

  return (
    <div className="min-h-screen">
      <header className="border-b border-primary/20 backdrop-blur bg-background/70 sticky top-0 z-40">
        <div className="container mx-auto px-4 py-4 flex items-center gap-3">
          <Button variant="ghost" size="icon" asChild><Link to="/"><ArrowLeft className="w-4 h-4" /></Link></Button>
          <h1 className="font-display text-2xl">Import from CSV</h1>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8 max-w-6xl">
        <Card className="p-6 gold-border bg-card/80 mb-6">
          <h2 className="font-display text-xl mb-2">Expected columns</h2>
          <p className="text-sm text-muted-foreground mb-4 font-body">
            <code className="text-primary text-xs break-all">colour, producer, name, vintage, cl (oder size_ml), variety, residual_sugar_gl, dosage, alcohol_pct, country, region, sub_region, appellation, terroir_notes, notes, occasion, quantity, price_chf, purchased_from, storage_location</code>
            <br />Columns may appear in any order. Headers are case-insensitive. Missing values are tolerated.
            Old v1 exports (description, ausbau_terroir, a/t/l/T occasions) are understood too.
          </p>
          <label className="block">
            <div className="border-2 border-dashed border-primary/40 rounded-lg p-10 text-center hover:bg-secondary/40 transition cursor-pointer">
              <Upload className="w-8 h-8 text-primary mx-auto mb-2" />
              <p className="font-display text-lg">{fileName || "Choose a CSV file"}</p>
              <p className="text-xs text-muted-foreground mt-1">Click to browse</p>
            </div>
            <input type="file" accept=".csv,text/csv" className="hidden" onChange={(e) => e.target.files?.[0] && onFile(e.target.files[0])} />
          </label>
        </Card>

        {rows.length > 0 && (
          <>
            <div className="flex items-center justify-between mb-4">
              <div className="flex gap-4 text-sm">
                <span className="flex items-center gap-1 text-primary"><CheckCircle2 className="w-4 h-4" /> {valid.length} valid</span>
                {invalid.length > 0 && <span className="flex items-center gap-1 text-destructive"><AlertCircle className="w-4 h-4" /> {invalid.length} skipped</span>}
                {unresolvedGeoCount > 0 && (
                  <span className="flex items-center gap-1 text-muted-foreground">
                    <AlertCircle className="w-4 h-4" /> {unresolvedGeoCount} with unmatched geography
                  </span>
                )}
              </div>
              <Button onClick={onImport} disabled={valid.length === 0 || importing}>
                {importing && <Loader2 className="w-4 h-4 animate-spin" />}
                Import {valid.length} bottles
              </Button>
            </div>

            <Card className="gold-border bg-card/80 overflow-hidden">
              <div className="overflow-x-auto max-h-[60vh]">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Row</TableHead>
                      <TableHead></TableHead>
                      <TableHead>Producer</TableHead>
                      <TableHead>Name</TableHead>
                      <TableHead>Vintage</TableHead>
                      <TableHead>Colour</TableHead>
                      <TableHead>Country</TableHead>
                      <TableHead>Geo</TableHead>
                      <TableHead>Qty</TableHead>
                      <TableHead>Issue</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {rows.map((r) => {
                      const geoOk =
                        (!r.raw.country || !!r.data?.country_id) &&
                        (!r.raw.region || !!r.data?.region_id) &&
                        (!(r.raw.sub_region ?? r.raw.subregion) || !!r.data?.sub_region_id) &&
                        (!r.raw.appellation || !!r.data?.appellation_id);
                      return (
                        <TableRow key={r.row} className={r.error ? "opacity-60" : ""}>
                          <TableCell className="font-mono text-xs">{r.row}</TableCell>
                          <TableCell>
                            {r.data ? <CheckCircle2 className="w-4 h-4 text-primary" /> : <AlertCircle className="w-4 h-4 text-destructive" />}
                          </TableCell>
                          <TableCell className="max-w-[180px] truncate">{r.raw.producer}</TableCell>
                          <TableCell className="max-w-[200px] truncate">{r.raw.name ?? r.raw.description}</TableCell>
                          <TableCell>{r.raw.vintage}</TableCell>
                          <TableCell>{r.raw.colour ?? r.raw.color}</TableCell>
                          <TableCell>{r.raw.country}</TableCell>
                          <TableCell>
                            {r.data ? (
                              geoOk ? (
                                <span className="text-primary text-xs">matched</span>
                              ) : (
                                <span className="text-muted-foreground text-xs" title="Unmatched parts will be created (country/region) or left empty (sub-region/appellation)">
                                  partial
                                </span>
                              )
                            ) : null}
                          </TableCell>
                          <TableCell>{r.raw.quantity}</TableCell>
                          <TableCell className="text-xs text-destructive max-w-[260px] truncate">{r.error}</TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              </div>
            </Card>
          </>
        )}
      </main>
    </div>
  );
}
