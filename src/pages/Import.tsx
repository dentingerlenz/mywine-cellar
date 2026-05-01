import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Papa from "papaparse";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { useBulkInsertWines } from "@/hooks/useWines";
import { wineSchema, WineInput, WINE_COLOURS, OCCASIONS } from "@/lib/wine";
import { toast } from "sonner";
import { ArrowLeft, Upload, Loader2, AlertCircle, CheckCircle2 } from "lucide-react";

type ParsedRow = { row: number; raw: any; data?: WineInput; error?: string };

const normaliseColour = (v: string | undefined) => {
  if (!v) return undefined;
  const s = v.toLowerCase().trim().replace(/[éè]/g, "e").replace(/[\s/-]+/g, "_");
  if (WINE_COLOURS.includes(s as any)) return s;
  if (s.startsWith("spa") || s.includes("champ") || s.includes("bub")) return "sparkling";
  if (s.startsWith("whi")) return "white";
  if (s.startsWith("red")) return "red";
  if (s.startsWith("ros") || s.startsWith("ora") || s.includes("orange")) return "orange_rose";
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
  const bulk = useBulkInsertWines();
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
            country: raw.country,
            region: raw.region,
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

  const onImport = async () => {
    if (valid.length === 0) return;
    setImporting(true);
    try {
      await bulk.mutateAsync(valid.map((r) => r.data!));
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
