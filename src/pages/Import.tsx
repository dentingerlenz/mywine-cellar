import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Papa from "papaparse";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { useBulkInsertBottles } from "@/hooks/useBottles";
import { bottleSchema, BottleInput, WINE_COLOURS } from "@/lib/wine";
import { toast } from "sonner";
import { ArrowLeft, Upload, Loader2, AlertCircle, CheckCircle2 } from "lucide-react";

type ParsedRow = { row: number; raw: any; data?: BottleInput; error?: string };

const normaliseColour = (v: string | undefined) => {
  if (!v) return undefined;
  const s = v.toLowerCase().trim().replace("é", "e");
  if (s.startsWith("red")) return "red";
  if (s.startsWith("whi")) return "white";
  if (s.startsWith("ros")) return "rose";
  if (s.startsWith("spa") || s.includes("champ") || s.includes("bub")) return "sparkling";
  if (s.startsWith("des") || s.includes("sweet") || s.includes("port")) return "dessert";
  return WINE_COLOURS.find((c) => c === s);
};

export default function Import() {
  const navigate = useNavigate();
  const bulk = useBulkInsertBottles();
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
            name: raw.name,
            producer: raw.producer,
            vintage: raw.vintage ? Number(raw.vintage) : undefined,
            region: raw.region,
            country: raw.country,
            appellation: raw.appellation,
            grape: raw.grape,
            colour: normaliseColour(raw.colour ?? raw.color),
            format: raw.format,
            quantity: raw.quantity ? Number(raw.quantity) : 1,
            ready_from: raw.ready_from ? Number(raw.ready_from) : undefined,
            drink_by: raw.drink_by ? Number(raw.drink_by) : undefined,
            note: raw.note,
            rating: raw.rating ? Number(raw.rating) : undefined,
          };
          const result = bottleSchema.safeParse(candidate);
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

      <main className="container mx-auto px-4 py-8 max-w-5xl">
        <Card className="p-6 gold-border bg-card/80 mb-6">
          <h2 className="font-display text-xl mb-2">Expected columns</h2>
          <p className="text-sm text-muted-foreground mb-4 font-body">
            <code className="text-primary text-xs">name, producer, vintage, region, country, appellation, grape, colour, format, quantity, ready_from, drink_by, note, rating</code>
            <br />Only <em>name</em> is required. Headers are case-insensitive.
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
                      <TableHead>Status</TableHead>
                      <TableHead>Name</TableHead>
                      <TableHead>Producer</TableHead>
                      <TableHead>Vintage</TableHead>
                      <TableHead>Colour</TableHead>
                      <TableHead>Qty</TableHead>
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
                        <TableCell className="max-w-[200px] truncate">{r.raw.name || <span className="text-muted-foreground italic">—</span>}</TableCell>
                        <TableCell className="max-w-[150px] truncate">{r.raw.producer}</TableCell>
                        <TableCell>{r.raw.vintage}</TableCell>
                        <TableCell>{r.data?.colour || r.raw.colour}</TableCell>
                        <TableCell>{r.raw.quantity}</TableCell>
                        <TableCell className="text-xs text-destructive max-w-[300px] truncate">{r.error}</TableCell>
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
