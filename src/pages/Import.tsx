import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Papa from "papaparse";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { useBulkInsertWines } from "@/hooks/useWines";
import { wineSchema, WineInput, BUILTIN_WINE_COLOURS, OCCASIONS } from "@/lib/wine";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useWineCountries, useWineRegions } from "@/hooks/useWineGeography";
import { useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { ArrowLeft, Upload, Loader2, AlertCircle, CheckCircle2 } from "lucide-react";

type ParsedRow = { row: number; raw: any; data?: WineInput; error?: string };

const normaliseColour = (v: string | undefined) => {
  if (!v) return undefined;
  const s = v.toLowerCase().trim().replace(/[éè]/g, "e").replace(/[\s/-]+/g, "_");
  if ((BUILTIN_WINE_COLOURS as readonly string[]).includes(s)) return s;
  if (s.startsWith("spa") || s.includes("champ") || s.includes("bub")) return "sparkling";
  if (s.startsWith("whi")) return "white";
  if (s.startsWith("red")) return "red";
  if (s.startsWith("ros")) return "rose";
  if (s.startsWith("ora") || s.includes("orange")) return "orange";
  if (s.startsWith("des") || s.includes("sweet") || s.includes("port") || s.includes("forti")) return "dessert_fortified";
  return undefined;
};

const normaliseOccasion = (v: string | undefined) => {
  if (!v) return undefined;
  const s = v.trim();
  if (OCCASIONS.includes(s as any)) return s;
  const l = s.toLowerCase();
  if (l.startsWith("any")) return "a";
  if (l.startsWith("spec")) return "t";
  if (l.startsWith("lay") || l.startsWith("age")) return "l";
  if (l.startsWith("top")) return "T";
  return undefined;
};

const num = (v: any) => {
  if (v === undefined || v === null || v === "") return undefined;
  const n = Number(String(v).replace(",", "."));
  return Number.isFinite(n) ? n : undefined;
};

export default function Import() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const qc = useQueryClient();
  const bulk = useBulkInsertWines();
  const { data: countries = [] } = useWineCountries();
  const { data: regions = [] } = useWineRegions();
  const [rows, setRows] = useState<ParsedRow[]>([]);
  const [fileName, setFileName] = useState("");
  const [importing, setImporting] = useState(false);

  const onFile = (file: File) => {
    setFileName(file.name);
    Papa.parse(file, {
      header: true,
      skipEmptyLines: true,
      transformHeader: (h) => h.toLowerCase().trim().replace(/\s+/g, "_"),
      complete: (results) => {
        const parsed: ParsedRow[] = results.data.map((raw: any, i) => {
          // Note: country / region are NOT validated here as ids — they are
          // resolved (and created if missing) at import time.
          const candidate = {
            colour: normaliseColour(raw.colour ?? raw.color),
            producer: raw.producer,
            description: raw.description,
            vintage: raw.vintage ? String(raw.vintage) : undefined,
            cl: num(raw.cl),
            variety: raw.variety,
            residual_sugar_gl: num(raw.residual_sugar_gl ?? raw.residual_sugar),
            dosage: raw.dosage,
            alcohol_pct: num(raw.alcohol_pct ?? raw.alcohol),
            sub_region: raw.sub_region ?? raw.subregion,
            appellation: raw.appellation,
            ausbau_terroir: raw.ausbau_terroir ?? raw.ausbau,
            notes: raw.notes,
            occasion: normaliseOccasion(raw.occasion),
            quantity: num(raw.quantity) ?? 1,
            price_chf: num(raw.price_chf ?? raw.price),
            purchased_from: raw.purchased_from ?? raw.purchase_source,
          };
          const result = wineSchema.safeParse(candidate);
          if (result.success) return { row: i + 2, raw, data: result.data };
          return { row: i + 2, raw, error: result.error.issues.map((x) => `${x.path.join(".")}: ${x.message}`).join("; ") };
        });
        setRows(parsed);
      },
      error: (err) => toast.error(err.message),
    });
  };

  const valid = rows.filter((r) => r.data);
  const invalid = rows.filter((r) => r.error);

  /**
   * Resolve a country / region text value to an id. If no curated row matches
   * (case-insensitive, trimmed), create a new entry in the relevant table.
   */
  const resolveGeography = async (
    countryText: string | undefined,
    regionText: string | undefined,
  ): Promise<{ country_id: string | null; region_id: string | null }> => {
    if (!user) return { country_id: null, region_id: null };
    const cName = (countryText ?? "").trim();
    const rName = (regionText ?? "").trim();
    let country_id: string | null = null;
    let region_id: string | null = null;

    if (cName) {
      const existing = countries.find(
        (c) => c.name.toLowerCase() === cName.toLowerCase(),
      );
      if (existing) {
        country_id = existing.id;
      } else {
        const sort_order = countries.length;
        const { data, error } = await supabase
          .from("wine_countries")
          .insert({ user_id: user.id, name: cName, sort_order })
          .select("id")
          .single();
        if (error) throw error;
        country_id = data.id;
        // Locally extend the list so subsequent rows in this batch reuse it.
        countries.push({ id: data.id, user_id: user.id, name: cName, sort_order, continent: null });
      }
    }

    if (rName && country_id) {
      const existing = regions.find(
        (r) =>
          r.country_id === country_id &&
          r.name.toLowerCase() === rName.toLowerCase(),
      );
      if (existing) {
        region_id = existing.id;
      } else {
        const sort_order = regions.filter((r) => r.country_id === country_id).length;
        const { data, error } = await supabase
          .from("wine_regions")
          .insert({ user_id: user.id, country_id, name: rName, sort_order })
          .select("id")
          .single();
        if (error) throw error;
        region_id = data.id;
        regions.push({
          id: data.id,
          user_id: user.id,
          country_id,
          name: rName,
          sort_order,
        });
      }
    }

    return { country_id, region_id };
  };

  const onImport = async () => {
    if (valid.length === 0) return;
    setImporting(true);
    try {
      // Resolve geography sequentially so we don't insert the same country twice.
      const enriched: WineInput[] = [];
      for (const r of valid) {
        const { country_id, region_id } = await resolveGeography(
          r.raw.country,
          r.raw.region,
        );
        enriched.push({
          ...(r.data as WineInput),
          country_id: country_id ?? "",
          region_id: region_id ?? "",
        });
      }
      await bulk.mutateAsync(enriched);
      qc.invalidateQueries({ queryKey: ["wine_countries"] });
      qc.invalidateQueries({ queryKey: ["wine_regions"] });
      toast.success(`${valid.length} bottles imported`);
      navigate("/");
    } catch (e: any) {
      toast.error(e.message);
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
            <code className="text-primary text-xs break-all">colour, producer, description, vintage, cl, variety, residual_sugar_gl, dosage, alcohol_pct, country, region, sub_region, appellation, ausbau_terroir, notes, occasion, quantity, price_chf, purchased_from</code>
            <br />Columns may appear in any order. Headers are case-insensitive. Missing values are tolerated.
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
                      <TableHead>Description</TableHead>
                      <TableHead>Vintage</TableHead>
                      <TableHead>Colour</TableHead>
                      <TableHead>Country</TableHead>
                      <TableHead>Qty</TableHead>
                      <TableHead>Price</TableHead>
                      <TableHead>Issue</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {rows.map((r) => (
                      <TableRow key={r.row} className={r.error ? "opacity-60" : ""}>
                        <TableCell className="font-mono text-xs">{r.row}</TableCell>
                        <TableCell>
                          {r.data ? <CheckCircle2 className="w-4 h-4 text-primary" /> : <AlertCircle className="w-4 h-4 text-destructive" />}
                        </TableCell>
                        <TableCell className="max-w-[180px] truncate">{r.raw.producer}</TableCell>
                        <TableCell className="max-w-[200px] truncate">{r.raw.description}</TableCell>
                        <TableCell>{r.raw.vintage}</TableCell>
                        <TableCell>{r.data?.colour || r.raw.colour}</TableCell>
                        <TableCell>{r.raw.country}</TableCell>
                        <TableCell>{r.raw.quantity}</TableCell>
                        <TableCell>{r.raw.price_chf ?? r.raw.price}</TableCell>
                        <TableCell className="text-xs text-destructive max-w-[260px] truncate">{r.error}</TableCell>
                      </TableRow>
                    ))}
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
