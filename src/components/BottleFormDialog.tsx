import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Bottle, BottleInput, bottleSchema, WINE_COLOURS, COLOUR_LABEL, FORMATS } from "@/lib/wine";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useUpsertBottle, uploadWinePhoto } from "@/hooks/useBottles";
import { useAuth } from "@/contexts/AuthContext";
import { toast } from "sonner";
import { Loader2, Upload, X } from "lucide-react";

type Props = {
  open: boolean;
  onOpenChange: (v: boolean) => void;
  bottle?: Bottle | null;
};

const MAX_PHOTO_SIZE = 5 * 1024 * 1024;

export const BottleFormDialog = ({ open, onOpenChange, bottle }: Props) => {
  const { user } = useAuth();
  const upsert = useUpsertBottle();
  const [photoFile, setPhotoFile] = useState<File | null>(null);
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const [removePhoto, setRemovePhoto] = useState(false);
  const [uploading, setUploading] = useState(false);

  const { register, handleSubmit, reset, setValue, watch, formState: { errors } } = useForm<any>({
    resolver: zodResolver(bottleSchema) as any,
    defaultValues: { quantity: 1, format: "75cl" },
  });

  useEffect(() => {
    if (open) {
      if (bottle) {
        reset({
          name: bottle.name,
          producer: bottle.producer ?? "",
          vintage: bottle.vintage ?? undefined,
          region: bottle.region ?? "",
          country: bottle.country ?? "",
          appellation: bottle.appellation ?? "",
          grape: bottle.grape ?? "",
          colour: bottle.colour ?? undefined,
          format: bottle.format ?? "75cl",
          quantity: bottle.quantity,
          note: bottle.note ?? "",
          rating: bottle.rating ?? undefined,
          ready_from: bottle.ready_from ?? undefined,
          drink_by: bottle.drink_by ?? undefined,
        });
        setPhotoPreview(bottle.photo_url);
      } else {
        reset({ quantity: 1, format: "75cl" });
        setPhotoPreview(null);
      }
      setPhotoFile(null);
      setRemovePhoto(false);
    }
  }, [open, bottle, reset]);

  const handlePhoto = (file: File) => {
    if (file.size > MAX_PHOTO_SIZE) {
      toast.error("Photo must be under 5 MB");
      return;
    }
    if (!["image/jpeg", "image/png", "image/webp"].includes(file.type)) {
      toast.error("Use JPEG or PNG");
      return;
    }
    setPhotoFile(file);
    setPhotoPreview(URL.createObjectURL(file));
    setRemovePhoto(false);
  };

  const onSubmit = async (values: BottleInput) => {
    if (!user) return;
    try {
      setUploading(true);
      let photo_url: string | null | undefined = undefined;
      if (photoFile) {
        photo_url = await uploadWinePhoto(photoFile, user.id);
      } else if (removePhoto) {
        photo_url = null;
      }
      await upsert.mutateAsync({ id: bottle?.id, values, photo_url });
      toast.success(bottle ? "Bottle updated" : "Bottle added to cellar");
      onOpenChange(false);
    } catch (e: any) {
      toast.error(e.message ?? "Could not save bottle");
    } finally {
      setUploading(false);
    }
  };

  const colour = watch("colour");
  const format = watch("format");
  const rating = watch("rating");

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto bg-card gold-border">
        <DialogHeader>
          <DialogTitle className="font-display text-2xl">
            {bottle ? "Edit bottle" : "Add a bottle"}
          </DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <div className="flex gap-4">
            <div className="w-32 shrink-0">
              <div className="aspect-[3/4] rounded-md overflow-hidden gold-border bg-secondary relative group">
                {photoPreview ? (
                  <>
                    <img src={photoPreview} alt="" className="w-full h-full object-cover" />
                    <button
                      type="button"
                      onClick={() => { setPhotoFile(null); setPhotoPreview(null); setRemovePhoto(true); }}
                      className="absolute top-1 right-1 bg-background/80 rounded-full p-1 opacity-0 group-hover:opacity-100 transition"
                    >
                      <X className="w-3 h-3" />
                    </button>
                  </>
                ) : (
                  <label className="flex flex-col items-center justify-center w-full h-full cursor-pointer hover:bg-secondary/70 transition">
                    <Upload className="w-6 h-6 text-primary mb-1" />
                    <span className="text-[10px] text-muted-foreground text-center px-1">Label photo</span>
                    <input
                      type="file"
                      accept="image/jpeg,image/png,image/webp"
                      className="hidden"
                      onChange={(e) => e.target.files?.[0] && handlePhoto(e.target.files[0])}
                    />
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
                <Label>Name *</Label>
                <Input {...register("name")} placeholder="e.g. Château Margaux" />
                {errors.name && <p className="text-xs text-destructive mt-1">{String(errors.name.message)}</p>}
              </div>
              <div>
                <Label>Producer / Domaine</Label>
                <Input {...register("producer")} />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <Label>Vintage</Label>
                  <Input type="number" {...register("vintage")} placeholder="2015" />
                </div>
                <div>
                  <Label>Quantity *</Label>
                  <Input type="number" {...register("quantity")} />
                </div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label>Colour</Label>
              <Select value={colour ?? ""} onValueChange={(v) => setValue("colour", v as any)}>
                <SelectTrigger><SelectValue placeholder="Select" /></SelectTrigger>
                <SelectContent>
                  {WINE_COLOURS.map((c) => <SelectItem key={c} value={c}>{COLOUR_LABEL[c]}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label>Format</Label>
              <Select value={format ?? "75cl"} onValueChange={(v) => setValue("format", v)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {FORMATS.map((f) => <SelectItem key={f} value={f}>{f}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label>Country</Label>
              <Input {...register("country")} placeholder="France" />
            </div>
            <div>
              <Label>Region</Label>
              <Input {...register("region")} placeholder="Bordeaux" />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label>Appellation</Label>
              <Input {...register("appellation")} />
            </div>
            <div>
              <Label>Grape variety</Label>
              <Input {...register("grape")} placeholder="Cabernet Sauvignon" />
            </div>
          </div>

          <div className="grid grid-cols-3 gap-3">
            <div>
              <Label>Ready from</Label>
              <Input type="number" {...register("ready_from")} placeholder="2025" />
            </div>
            <div>
              <Label>Drink by</Label>
              <Input type="number" {...register("drink_by")} placeholder="2040" />
            </div>
            <div>
              <Label>Rating</Label>
              <Select value={rating ? String(rating) : ""} onValueChange={(v) => setValue("rating", Number(v) as any)}>
                <SelectTrigger><SelectValue placeholder="—" /></SelectTrigger>
                <SelectContent>
                  {[1,2,3,4,5].map((n) => <SelectItem key={n} value={String(n)}>{"★".repeat(n)}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div>
            <Label>Tasting note</Label>
            <Textarea {...register("note")} rows={3} placeholder="Notes from tasting…" />
          </div>

          <DialogFooter>
            <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>Cancel</Button>
            <Button type="submit" disabled={uploading || upsert.isPending}>
              {(uploading || upsert.isPending) && <Loader2 className="w-4 h-4 animate-spin" />}
              {bottle ? "Save changes" : "Add to cellar"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
};
