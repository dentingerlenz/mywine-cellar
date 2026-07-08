import { useEffect, useMemo, useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import type { z } from "zod";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { toast } from "sonner";
import { AlertTriangle, Loader2 } from "lucide-react";
import {
  type Wine, type WineInput, wineSchema, OCCASIONS, OCCASION_LABEL,
  SIZE_ML_OPTIONS, DOSAGE_LEVELS, findDuplicates, dateToMonthYear, monthsOnLees,
} from "@/features/wines/model";
import { useUpsertWine, useWines, uploadLabelPhoto, labelPhotoUrl } from "@/features/wines/queries";
import { useColours, useColourLookup } from "@/features/colours/queries";
import { useCellar } from "@/features/cellar/CellarContext";
import { useGeoLookups } from "@/features/geography/queries";
import { GeographyPicker, type GeoSelection } from "@/features/geography/GeographyPicker";
import { resolveGeoNames } from "@/features/geography/resolveGeoNames";
import { PhotoScanPanel, type PhotoState, type ScanResult, emptyPhotoState } from "./PhotoScanPanel";

type Props = {
  open: boolean;
  onOpenChange: (v: boolean) => void;
  wine?: Wine | null;
};

const FIELD_LABELS: Record<string, string> = {
  producer: "Producer",
  name: "Name",
  vintage: "Vintage",
  size_ml: "Bottle size",
  colour_id: "Colour",
  variety: "Variety",
  residual_sugar_gl: "Residual sugar",
  dosage: "Dosage",
  alcohol_pct: "Alcohol",
  country_id: "Country",
  region_id: "Region",
  sub_region_id: "Sub-region",
  appellation_id: "Appellation",
  terroir_notes: "Terroir / Vinification",
  notes: "Notes",
  occasion: "Occasion",
  quantity: "Quantity",
  price_chf: "Price",
  purchased_from: "Purchased from",
  storage_location: "Storage location",
  ready_from: "Ready from",
  drink_by: "Drink by",
  rating: "Rating",
};

export const WineFormDialog = ({ open, onOpenChange, wine }: Props) => {
  const { cellarId } = useCellar();
  const upsert = useUpsertWine();
  const { data: colours = [] } = useColours();
  const { kindFor } = useColourLookup();
  const { data: wines = [] } = useWines();
  const geo = useGeoLookups();

  // Vorschlagslisten für die Freitext-Felder (aus dem Bestand).
  const classificationOptions = useMemo(
    () => Array.from(new Set(wines.map((w) => w.classification).filter(Boolean) as string[])).sort(),
    [wines],
  );
  const locationOptions = useMemo(
    () => Array.from(new Set(wines.map((w) => w.location).filter(Boolean) as string[])).sort(),
    [wines],
  );
  const [photo, setPhoto] = useState<PhotoState>(emptyPhotoState);
  const [uploading, setUploading] = useState(false);

  // Formularwerte = Schema-INPUT (vor coerce/preprocess), Submit = OUTPUT.
  type WineFormValues = z.input<typeof wineSchema>;
  const {
    register, handleSubmit, reset, setValue, watch,
    formState: { errors },
  } = useForm<WineFormValues, unknown, WineInput>({
    resolver: zodResolver(wineSchema),
    defaultValues: { quantity: 1, size_ml: 750 },
  });

  const errClass = (name: keyof WineFormValues) =>
    errors[name] ? "border-destructive focus-visible:ring-destructive" : "";
  const errMsg = (name: keyof WineFormValues) => {
    const e = errors[name];
    return e?.message ? <p className="text-xs text-destructive mt-1">{String(e.message)}</p> : null;
  };

  const onInvalid = () => {
    setTimeout(() => {
      const el = document.querySelector('[aria-invalid="true"]') as HTMLElement | null;
      el?.scrollIntoView({ behavior: "smooth", block: "center" });
      el?.focus?.();
    }, 0);
  };

  const wineId = wine?.id ?? null;

  useEffect(() => {
    if (!open) return;
    if (wine) {
      reset({
        producer: wine.producer ?? "",
        name: wine.name ?? "",
        vintage: wine.vintage ?? null,
        is_non_vintage: wine.is_non_vintage ?? false,
        base_vintage: wine.base_vintage ?? null,
        aging_indication: wine.aging_indication ?? "",
        size_ml: wine.size_ml ?? null,
        colour_id: wine.colour_id ?? undefined,
        variety: wine.variety ?? "",
        classification: wine.classification ?? "",
        residual_sugar_gl: wine.residual_sugar_gl ?? null,
        dosage_level: wine.dosage_level ?? "",
        dosage_gl: wine.dosage_gl ?? null,
        tirage_date: dateToMonthYear(wine.tirage_date),
        disgorgement_date: dateToMonthYear(wine.disgorgement_date),
        alcohol_pct: wine.alcohol_pct ?? null,
        country_id: wine.country_id,
        region_id: wine.region_id,
        sub_region_id: wine.sub_region_id,
        appellation_id: wine.appellation_id,
        location: wine.location ?? "",
        terroir_notes: wine.terroir_notes ?? "",
        notes: wine.notes ?? "",
        occasion: (wine.occasion as WineInput["occasion"]) ?? null,
        quantity: wine.quantity,
        price_chf: wine.price_chf ?? null,
        purchased_from: wine.purchased_from ?? "",
        storage_location: wine.storage_location ?? "",
        ready_from: wine.ready_from ?? null,
        drink_by: wine.drink_by ?? null,
        rating: wine.rating ?? null,
      });
      setPhoto({ file: null, preview: labelPhotoUrl(wine.label_photo_path), remove: false });
    } else {
      reset({ quantity: 1, size_ml: 750, is_non_vintage: false, occasion: null, rating: null });
      setPhoto(emptyPhotoState);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, wineId]);

  const applyScan = (parsed: ScanResult) => {
    const setIfPresent = (field: keyof WineFormValues, v: string | number | null | undefined) => {
      if (v !== null && v !== undefined && v !== "") {
        setValue(field, v as never, { shouldValidate: true });
      }
    };
    setIfPresent("producer", parsed.producer);
    setIfPresent("name", parsed.name);
    if (parsed.vintage && /^\d{4}$/.test(String(parsed.vintage))) {
      setIfPresent("vintage", Number(parsed.vintage));
    } else if (parsed.vintage && /^nv/i.test(String(parsed.vintage))) {
      setValue("is_non_vintage", true);
    }
    setIfPresent("variety", parsed.grape_varieties);
    setIfPresent("dosage_level", parsed.dosage);
    setIfPresent("notes", parsed.notes);
    setIfPresent("ready_from", parsed.ready_from); // V8 — ab Edge Function v2
    setIfPresent("drink_by", parsed.drink_by);

    const alc = parsed.alcohol;
    if (alc !== null && alc !== undefined && alc !== "") {
      const n = typeof alc === "number" ? alc : parseFloat(String(alc).replace(",", ".").replace(/[^\d.]/g, ""));
      if (!Number.isNaN(n)) setValue("alcohol_pct", n, { shouldValidate: true });
    }

    // Geo-Namen → FK-IDs über den geteilten Resolver
    const resolved = resolveGeoNames(
      {
        country: parsed.country,
        region: parsed.region,
        sub_region: parsed.sub_region,
        appellation: parsed.appellation,
      },
      geo,
    );
    if (resolved.country_id) setValue("country_id", resolved.country_id);
    if (resolved.region_id) setValue("region_id", resolved.region_id);
    if (resolved.sub_region_id) setValue("sub_region_id", resolved.sub_region_id);
    if (resolved.appellation_id) setValue("appellation_id", resolved.appellation_id);
    if (resolved.unresolved.length) {
      toast.info(
        `Not matched: ${resolved.unresolved.map((u) => u.value).join(", ")} — pick manually.`,
      );
    }
  };

  const onSubmit = async (values: WineInput) => {
    try {
      setUploading(true);
      let label_photo_path: string | null | undefined = undefined;
      if (photo.file) label_photo_path = await uploadLabelPhoto(photo.file, cellarId);
      else if (photo.remove) label_photo_path = null;
      await upsert.mutateAsync({ id: wine?.id, values, label_photo_path });
      toast.success(wine ? "Bottle updated" : "Bottle added to cellar");
      onOpenChange(false);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not save bottle");
    } finally {
      setUploading(false);
    }
  };

  const colourId = watch("colour_id");
  const kind = kindFor(colourId);
  const occasion = watch("occasion");
  const rating = watch("rating") as number | null | undefined;
  const sizeMl = watch("size_ml") as number | null | undefined;
  const isNonVintage = !!watch("is_non_vintage");
  const dosageLevel = watch("dosage_level") as string | undefined;
  const lees = monthsOnLees(watch("tirage_date"), watch("disgorgement_date"));
  const geoSelection: GeoSelection = {
    country_id: (watch("country_id") as string | null | undefined) ?? null,
    region_id: (watch("region_id") as string | null | undefined) ?? null,
    sub_region_id: (watch("sub_region_id") as string | null | undefined) ?? null,
    appellation_id: (watch("appellation_id") as string | null | undefined) ?? null,
  };

  // V3 — Duplikat-Warnung live (inkl. Flaschengröße)
  const producer = watch("producer");
  const name = watch("name");
  const vintage = watch("vintage") as number | null | undefined;
  const duplicates = useMemo(
    () => findDuplicates(wines, { producer, name, vintage: vintage ?? null, size_ml: sizeMl ?? null }, wine?.id),
    [wines, producer, name, vintage, sizeMl, wine?.id],
  );

  // Weinart-spezifische Trinkfenster-/Jahrgang-Zeile (wiederverwendet je kind)
  const readyDrink = (
    <>
      <div>
        <Label>Ready from (year)</Label>
        <Input type="number" {...register("ready_from")} placeholder="2025" />
      </div>
      <div>
        <Label>Drink by (year)</Label>
        <Input type="number" {...register("drink_by")} placeholder="2040" />
      </div>
    </>
  );

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto bg-card gold-border">
        <DialogHeader>
          <DialogTitle className="font-display text-2xl">{wine ? "Edit bottle" : "Add a bottle"}</DialogTitle>
        </DialogHeader>
        <form
          onSubmit={handleSubmit(onSubmit, onInvalid)}
          className="space-y-4 [&_input::placeholder]:text-xs [&_input::placeholder]:opacity-[0.35] [&_textarea::placeholder]:text-xs [&_textarea::placeholder]:opacity-[0.35] [&_[data-placeholder]]:text-xs [&_[data-placeholder]]:opacity-[0.35]"
        >
          <div className="flex gap-4">
            <PhotoScanPanel photo={photo} onPhotoChange={setPhoto} onScanResult={applyScan} />
            <div className="flex-1 space-y-3">
              <div>
                <Label>Producer *</Label>
                <Input
                  {...register("producer")}
                  placeholder="e.g. Egly-Ouriet"
                  aria-invalid={!!errors.producer}
                  className={errClass("producer")}
                />
                {errMsg("producer")}
              </div>
              <div>
                <Label>Name / Cuvée</Label>
                <Input
                  {...register("name")}
                  placeholder="e.g. Les Vignes de Vrigny Brut"
                  aria-invalid={!!errors.name}
                  className={errClass("name")}
                />
                {errMsg("name")}
              </div>
              <div>
                <Label>Quantity *</Label>
                <Input
                  type="number"
                  {...register("quantity")}
                  aria-invalid={!!errors.quantity}
                  className={errClass("quantity")}
                />
                {errMsg("quantity")}
              </div>
            </div>
          </div>

          {!wine && duplicates.length > 0 && (
            <div className="rounded-md border border-primary/50 bg-primary/10 px-3 py-2 flex items-start gap-2">
              <AlertTriangle className="w-4 h-4 text-primary shrink-0 mt-0.5" />
              <p className="text-xs text-foreground">
                Already in your cellar: <strong>{duplicates.length}</strong>{" "}
                {duplicates.length === 1 ? "entry" : "entries"} with the same producer, name,
                vintage and bottle size (stock: {duplicates.reduce((s, d) => s + d.quantity, 0)}).
                Consider increasing its quantity instead of adding a duplicate.
              </p>
            </div>
          )}

          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div>
              <Label>Colour *</Label>
              <Select
                value={colourId ?? ""}
                onValueChange={(v) => setValue("colour_id", v, { shouldValidate: true })}
              >
                <SelectTrigger aria-invalid={!!errors.colour_id} className={errClass("colour_id")}>
                  <SelectValue placeholder="Select" />
                </SelectTrigger>
                <SelectContent>
                  {colours.map((c) => (
                    <SelectItem key={c.id} value={c.id}>{c.display_name}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {errMsg("colour_id")}
            </div>
            <div>
              <Label>Bottle</Label>
              <Select
                value={sizeMl ? String(sizeMl) : ""}
                onValueChange={(v) => setValue("size_ml", Number(v))}
              >
                <SelectTrigger><SelectValue placeholder="Size" /></SelectTrigger>
                <SelectContent>
                  {SIZE_ML_OPTIONS.map((n) => (
                    <SelectItem key={n} value={String(n)}>{n % 10 === 0 ? n / 10 : (n / 10).toFixed(1)} cl</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label>Occasion</Label>
              <Select
                value={occasion ?? "none"}
                onValueChange={(v) =>
                  setValue("occasion", v === "none" ? null : (v as WineInput["occasion"]), { shouldValidate: true })
                }
              >
                <SelectTrigger><SelectValue placeholder="—" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">None</SelectItem>
                  {OCCASIONS.map((o) => (
                    <SelectItem key={o} value={o}>{OCCASION_LABEL[o]}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label>Rating</Label>
              <Select
                value={rating ? String(rating) : "none"}
                onValueChange={(v) =>
                  setValue("rating", v === "none" ? null : Number(v), { shouldValidate: true })
                }
              >
                <SelectTrigger><SelectValue placeholder="—" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">No rating</SelectItem>
                  {[1, 2, 3, 4, 5].map((n) => (
                    <SelectItem key={n} value={String(n)}>{"★".repeat(n)}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Weinart-spezifische Felder (aus der Farbkategorie abgeleitet) */}
          <div className="rounded-md border border-primary/15 bg-secondary/20 p-3 space-y-3">
            {kind === "sparkling" ? (
              <>
                <div className="flex items-center gap-2">
                  <Switch
                    id="nv"
                    checked={isNonVintage}
                    onCheckedChange={(v) => {
                      setValue("is_non_vintage", v);
                      if (v) setValue("vintage", null);
                      else setValue("base_vintage", null);
                    }}
                  />
                  <Label htmlFor="nv" className="cursor-pointer">Non-vintage (NV)</Label>
                </div>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                  {isNonVintage ? (
                    <div>
                      <Label>Base vintage</Label>
                      <Input type="number" {...register("base_vintage")} placeholder="2020" />
                    </div>
                  ) : (
                    <div>
                      <Label>Vintage</Label>
                      <Input type="number" {...register("vintage")} placeholder="2018" />
                    </div>
                  )}
                  <div>
                    <Label>Dosage</Label>
                    <Select
                      value={dosageLevel || "none"}
                      onValueChange={(v) => setValue("dosage_level", v === "none" ? "" : v)}
                    >
                      <SelectTrigger><SelectValue placeholder="—" /></SelectTrigger>
                      <SelectContent>
                        <SelectItem value="none">—</SelectItem>
                        {DOSAGE_LEVELS.map((d) => <SelectItem key={d} value={d}>{d}</SelectItem>)}
                      </SelectContent>
                    </Select>
                  </div>
                  <div>
                    <Label>Dosage (g/L)</Label>
                    <Input type="number" step="0.1" {...register("dosage_gl")} placeholder="e.g. 3" />
                  </div>
                </div>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-3 items-end">
                  <div>
                    <Label>Tirage (month)</Label>
                    <Input type="month" {...register("tirage_date")} />
                  </div>
                  <div>
                    <Label>Disgorgement (month)</Label>
                    <Input type="month" {...register("disgorgement_date")} />
                  </div>
                  {lees != null && (
                    <p className="text-xs text-muted-foreground pb-2 md:col-span-2">
                      ≈ <span className="text-primary font-display">{lees}</span> months on lees
                    </p>
                  )}
                </div>
                <div className="grid grid-cols-2 gap-3">{readyDrink}</div>
              </>
            ) : kind === "sweet_fortified" ? (
              <>
                <div className="flex items-center gap-2">
                  <Switch
                    id="solera"
                    checked={isNonVintage}
                    onCheckedChange={(v) => {
                      setValue("is_non_vintage", v);
                      if (v) setValue("vintage", null);
                      else setValue("aging_indication", "");
                    }}
                  />
                  <Label htmlFor="solera" className="cursor-pointer">Solera / non-vintage</Label>
                </div>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                  {isNonVintage ? (
                    <div className="md:col-span-2">
                      <Label>Aging indication</Label>
                      <Input {...register("aging_indication")} placeholder="~25 years · Solera 2013+ · VORS" />
                    </div>
                  ) : (
                    <div>
                      <Label>Vintage</Label>
                      <Input type="number" {...register("vintage")} placeholder="1979" />
                    </div>
                  )}
                  <div>
                    <Label>Residual sugar (g/L)</Label>
                    <Input type="number" step="0.1" {...register("residual_sugar_gl")} />
                  </div>
                  {readyDrink}
                </div>
              </>
            ) : (
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                <div>
                  <Label>Vintage</Label>
                  <Input type="number" {...register("vintage")} placeholder="2019" />
                </div>
                {readyDrink}
              </div>
            )}
          </div>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div>
              <Label>Variety / Grape</Label>
              <Input {...register("variety")} placeholder="Pinot Noir" />
            </div>
            {kind !== "sweet_fortified" && (
              <div>
                <Label>Residual sugar (g/L)</Label>
                <Input type="number" step="0.1" {...register("residual_sugar_gl")} />
              </div>
            )}
            <div>
              <Label>Alcohol (%)</Label>
              <Input type="number" step="0.1" {...register("alcohol_pct")} placeholder="12.5" />
            </div>
            <div>
              <Label>Price (CHF)</Label>
              <Input type="number" step="0.01" {...register("price_chf")} />
            </div>
            <div>
              <Label>Purchased from</Label>
              <Input {...register("purchased_from")} />
            </div>
          </div>

          <GeographyPicker
            value={geoSelection}
            onChange={(next) => {
              setValue("country_id", next.country_id, { shouldValidate: true });
              setValue("region_id", next.region_id, { shouldValidate: true });
              setValue("sub_region_id", next.sub_region_id, { shouldValidate: true });
              setValue("appellation_id", next.appellation_id, { shouldValidate: true });
            }}
          />

          <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
            <div>
              <Label>Classification</Label>
              <Input
                {...register("classification")}
                list="classification-options"
                placeholder="AOC · DOCG · VDP.Grosse Lage · Grand Cru"
              />
              <datalist id="classification-options">
                {classificationOptions.map((o) => <option key={o} value={o} />)}
              </datalist>
            </div>
            <div>
              <Label>Location (village / vineyard)</Label>
              <Input
                {...register("location")}
                list="location-options"
                placeholder="e.g. Ambonnay"
              />
              <datalist id="location-options">
                {locationOptions.map((o) => <option key={o} value={o} />)}
              </datalist>
            </div>
            <div>
              <Label>Storage location</Label>
              <Input {...register("storage_location")} placeholder="e.g. Rack B / Shelf 3" />
            </div>
          </div>

          <div>
            <Label>Terroir / Vinification</Label>
            <Textarea {...register("terroir_notes")} rows={2} placeholder="Vinification, soil, élevage…" />
          </div>
          <div>
            <Label>Tasting notes</Label>
            <Textarea {...register("notes")} rows={3} placeholder="Personal notes…" />
          </div>

          {Object.keys(errors).length > 0 && (
            <div className="rounded-md border border-destructive/50 bg-destructive/10 px-3 py-2">
              <p className="text-xs text-destructive font-medium">
                Please fix: {Object.keys(errors).map((k) => FIELD_LABELS[k] ?? k).join(", ")}
              </p>
            </div>
          )}

          <DialogFooter>
            <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit" disabled={uploading || upsert.isPending}>
              {(uploading || upsert.isPending) && <Loader2 className="w-4 h-4 animate-spin" />}
              {wine ? "Save changes" : "Add to cellar"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
};
