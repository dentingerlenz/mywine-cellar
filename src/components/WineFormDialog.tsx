import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import {
  Wine,
  WineInput,
  wineSchema,
  OCCASIONS,
  OCCASION_LABEL,
  CL_OPTIONS,
} from "@/lib/wine";
import { useWineColoursCtx } from "@/contexts/WineColoursContext";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useUpsertWine, uploadLabelPhoto } from "@/hooks/useWines";
import { useAuth } from "@/contexts/AuthContext";
import { toast } from "sonner";
import { Loader2, Upload, X } from "lucide-react";

type Props = {
  open: boolean;
  onOpenChange: (v: boolean) => void;
  wine?: Wine | null;
};

const MAX_PHOTO_SIZE = 5 * 1024 * 1024;

export const WineFormDialog = ({ open, onOpenChange, wine }: Props) => {
  const { user } = useAuth();
  const upsert = useUpsertWine();
  const [photoFile, setPhotoFile] = useState<File | null>(null);
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const [removePhoto, setRemovePhoto] = useState(false);
  const [uploading, setUploading] = useState(false);

  const { register, handleSubmit, reset, setValue, watch, formState: { errors } } = useForm<any>({
    resolver: zodResolver(wineSchema) as any,
    defaultValues: { quantity: 1, cl: 75 },
  });

  const FIELD_LABELS: Record<string, string> = {
    producer: "Producer",
    description: "Description",
    vintage: "Vintage",
    cl: "Bottle size",
    colour: "Colour",
    variety: "Variety",
    residual_sugar_gl: "Residual sugar",
    dosage: "Dosage",
    alcohol_pct: "Alcohol",
    country: "Country",
    region: "Region",
    sub_region: "Sub-region",
    appellation: "Appellation",
    ausbau_terroir: "Ausbau / Terroir",
    notes: "Notes",
    occasion: "Occasion",
    quantity: "Quantity",
    price_chf: "Price",
    purchased_from: "Purchased from",
    ready_from: "Ready from",
    drink_by: "Drink by",
    rating: "Rating",
  };

  const errClass = (name: string) => (errors as any)[name] ? "border-destructive focus-visible:ring-destructive" : "";
  const errMsg = (name: string) => {
    const e = (errors as any)[name];
    return e?.message ? <p className="text-xs text-destructive mt-1">{String(e.message)}</p> : null;
  };

  const onInvalid = () => {
    setTimeout(() => {
      const el = document.querySelector('[aria-invalid="true"]') as HTMLElement | null;
      el?.scrollIntoView({ behavior: "smooth", block: "center" });
      el?.focus?.();
    }, 0);
  };

  useEffect(() => {
    if (open) {
      if (wine) {
        reset({
          producer: wine.producer ?? "",
          description: wine.description ?? "",
          vintage: wine.vintage ?? "",
          cl: wine.cl ?? undefined,
          colour: wine.colour ?? undefined,
          variety: wine.variety ?? "",
          residual_sugar_gl: wine.residual_sugar_gl ?? undefined,
          dosage: wine.dosage ?? "",
          alcohol_pct: wine.alcohol_pct ?? undefined,
          country: wine.country ?? "",
          region: wine.region ?? "",
          sub_region: wine.sub_region ?? "",
          appellation: wine.appellation ?? "",
          ausbau_terroir: wine.ausbau_terroir ?? "",
          notes: wine.notes ?? "",
          occasion: wine.occasion ?? undefined,
          quantity: wine.quantity,
          price_chf: wine.price_chf ?? undefined,
          purchased_from: wine.purchased_from ?? "",
          ready_from: wine.ready_from ?? undefined,
          drink_by: wine.drink_by ?? undefined,
          rating: wine.rating ?? undefined,
        });
        setPhotoPreview(wine.label_photo_url);
      } else {
        reset({ quantity: 1, cl: 75, rating: undefined, occasion: undefined });
        setPhotoPreview(null);
      }
      setPhotoFile(null);
      setRemovePhoto(false);
    }
  }, [open, wine, reset]);

  const handlePhoto = (file: File) => {
    if (file.size > MAX_PHOTO_SIZE) { toast.error("Photo must be under 5 MB"); return; }
    if (!["image/jpeg", "image/png", "image/webp"].includes(file.type)) { toast.error("Use JPEG or PNG"); return; }
    setPhotoFile(file);
    setPhotoPreview(URL.createObjectURL(file));
    setRemovePhoto(false);
  };

  const onSubmit = async (values: WineInput) => {
    if (!user) return;
    try {
      setUploading(true);
      let label_photo_url: string | null | undefined = undefined;
      if (photoFile) label_photo_url = await uploadLabelPhoto(photoFile, user.id);
      else if (removePhoto) label_photo_url = null;
      await upsert.mutateAsync({ id: wine?.id, values, label_photo_url });
      toast.success(wine ? "Bottle updated" : "Bottle added to cellar");
      onOpenChange(false);
    } catch (e: any) {
      toast.error(e.message ?? "Could not save bottle");
    } finally {
      setUploading(false);
    }
  };

  const colour = watch("colour");
  const occasion = watch("occasion");
  const rating = watch("rating");
  const cl = watch("cl");

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto bg-card gold-border">
        <DialogHeader>
          <DialogTitle className="font-display text-2xl">{wine ? "Edit bottle" : "Add a bottle"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit, onInvalid)} className="space-y-4">
          <div className="flex gap-4">
            <div className="w-32 shrink-0">
              <div className="aspect-[3/4] rounded-md overflow-hidden gold-border bg-secondary relative group">
                {photoPreview ? (
                  <>
                    <img src={photoPreview} alt="" className="w-full h-full object-cover" />
                    <button type="button" onClick={() => { setPhotoFile(null); setPhotoPreview(null); setRemovePhoto(true); }}
                      className="absolute top-1 right-1 bg-background/80 rounded-full p-1 opacity-0 group-hover:opacity-100 transition">
                      <X className="w-3 h-3" />
                    </button>
                  </>
                ) : (
                  <label className="flex flex-col items-center justify-center w-full h-full cursor-pointer hover:bg-secondary/70 transition">
                    <Upload className="w-6 h-6 text-primary mb-1" />
                    <span className="text-[10px] text-muted-foreground text-center px-1">Label photo</span>
                    <input type="file" accept="image/jpeg,image/png,image/webp" className="hidden"
                      onChange={(e) => e.target.files?.[0] && handlePhoto(e.target.files[0])} />
                  </label>
                )}
              </div>
              {photoPreview && (
                <label className="block mt-2 text-xs text-center text-primary cursor-pointer hover:underline">
                  Replace
                  <input type="file" accept="image/jpeg,image/png,image/webp" className="hidden"
                    onChange={(e) => e.target.files?.[0] && handlePhoto(e.target.files[0])} />
                </label>
              )}
            </div>
            <div className="flex-1 space-y-3">
              <div>
                <Label>Producer *</Label>
                <Input {...register("producer")} placeholder="e.g. Egly-Ouriet" aria-invalid={!!errors.producer} className={errClass("producer")} />
                {errMsg("producer")}
              </div>
              <div>
                <Label>Description</Label>
                <Input {...register("description")} placeholder="e.g. Les Vignes de Vrigny Brut" aria-invalid={!!errors.description} className={errClass("description")} />
                {errMsg("description")}
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <Label>Vintage</Label>
                  <Input {...register("vintage")} placeholder='NV, 2015, ~15 years…' aria-invalid={!!errors.vintage} className={errClass("vintage")} />
                  {errMsg("vintage")}
                </div>
                <div>
                  <Label>Quantity *</Label>
                  <Input type="number" {...register("quantity")} aria-invalid={!!errors.quantity} className={errClass("quantity")} />
                  {errMsg("quantity")}
                </div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div>
              <Label>Colour *</Label>
              <Select value={colour ?? ""} onValueChange={(v) => setValue("colour", v as any, { shouldValidate: true })}>
                <SelectTrigger aria-invalid={!!errors.colour} className={errClass("colour")}><SelectValue placeholder="Select" /></SelectTrigger>
                <SelectContent>
                  {WINE_COLOURS.map((c) => <SelectItem key={c} value={c}>{COLOUR_LABEL[c]}</SelectItem>)}
                </SelectContent>
              </Select>
              {errMsg("colour")}
            </div>
            <div>
              <Label>Bottle (cl)</Label>
              <Select value={cl ? String(cl) : ""} onValueChange={(v) => setValue("cl", Number(v))}>
                <SelectTrigger><SelectValue placeholder="cl" /></SelectTrigger>
                <SelectContent>
                  {CL_OPTIONS.map((n) => <SelectItem key={n} value={String(n)}>{n} cl</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label>Occasion</Label>
              <Select
                value={occasion ?? "none"}
                onValueChange={(v) => setValue("occasion", v === "none" ? (undefined as any) : (v as any), { shouldValidate: true })}
              >
                <SelectTrigger><SelectValue placeholder="—" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">None</SelectItem>
                  {OCCASIONS.map((o) => <SelectItem key={o} value={o}>{OCCASION_LABEL[o]}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label>Rating</Label>
              <Select
                value={rating ? String(rating) : "none"}
                onValueChange={(v) => setValue("rating", v === "none" ? (undefined as any) : (Number(v) as any), { shouldValidate: true })}
              >
                <SelectTrigger><SelectValue placeholder="—" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">No rating</SelectItem>
                  {[1,2,3,4,5].map((n) => <SelectItem key={n} value={String(n)}>{"★".repeat(n)}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
            <div>
              <Label>Variety / Grape</Label>
              <Input {...register("variety")} placeholder="Pinot Noir" />
            </div>
            <div>
              <Label>Dosage (sparkling)</Label>
              <Input {...register("dosage")} placeholder="Brut Nature" />
            </div>
            <div>
              <Label>Residual sugar (g/L)</Label>
              <Input type="number" step="0.1" {...register("residual_sugar_gl")} />
            </div>
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

          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div>
              <Label>Country</Label>
              <Input {...register("country")} placeholder="France" />
            </div>
            <div>
              <Label>Region</Label>
              <Input {...register("region")} placeholder="FR - Champagne" />
            </div>
            <div>
              <Label>Sub-region</Label>
              <Input {...register("sub_region")} />
            </div>
            <div>
              <Label>Appellation</Label>
              <Input {...register("appellation")} />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label>Ready from (year)</Label>
              <Input type="number" {...register("ready_from")} placeholder="2025" />
            </div>
            <div>
              <Label>Drink by (year)</Label>
              <Input type="number" {...register("drink_by")} placeholder="2040" />
            </div>
          </div>

          <div>
            <Label>Ausbau / Terroir</Label>
            <Textarea {...register("ausbau_terroir")} rows={2} placeholder="Vinification, soil, élevage…" />
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
            <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>Cancel</Button>
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
