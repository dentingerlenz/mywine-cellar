import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Loader2, Sparkles, Upload, X } from "lucide-react";
import { toast } from "sonner";
import { supabase } from "@/integrations/supabase/client";

const MAX_PHOTO_SIZE = 5 * 1024 * 1024;

// Spiegelt das `extract_label`-Tool-Schema der Edge Function v2 (Phase 6).
export type ScanResult = {
  producer?: string | null;
  name?: string | null;
  vintage?: number | null;
  is_non_vintage?: boolean | null;
  country?: string | null;
  region?: string | null;
  sub_region?: string | null;
  appellation?: string | null;
  classification?: string | null;
  variety?: string | null;
  alcohol_pct?: number | null;
  dosage?: string | null;
  ready_from?: number | null; // V8 — KI-Trinkfenster
  drink_by?: number | null;
  notes?: string | null;
};

export type PhotoState = {
  file: File | null;
  preview: string | null;
  remove: boolean;
};

export const emptyPhotoState: PhotoState = { file: null, preview: null, remove: false };

/** Foto-Upload + KI-Scan, aus dem Formular herausgelöst (Plan §6.1). */
export const PhotoScanPanel = ({
  photo, onPhotoChange, onScanResult,
}: {
  photo: PhotoState;
  onPhotoChange: (next: PhotoState) => void;
  onScanResult: (parsed: ScanResult) => void;
}) => {
  const [scanning, setScanning] = useState(false);

  const handlePhoto = (file: File) => {
    if (file.size > MAX_PHOTO_SIZE) {
      toast.error("Photo must be under 5 MB");
      return;
    }
    if (!["image/jpeg", "image/png", "image/webp"].includes(file.type)) {
      toast.error("Use JPEG or PNG");
      return;
    }
    onPhotoChange({ file, preview: URL.createObjectURL(file), remove: false });
  };

  const toBase64 = (blob: Blob) =>
    new Promise<string>((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => {
        const result = reader.result as string;
        resolve(result.split(",")[1] ?? result);
      };
      reader.onerror = reject;
      reader.readAsDataURL(blob);
    });

  const handleScan = async () => {
    if (!photo.file && !photo.preview) return;
    try {
      setScanning(true);
      let blob: Blob;
      if (photo.file) {
        blob = photo.file;
      } else {
        blob = await (await fetch(photo.preview!)).blob();
      }
      const base64 = await toBase64(blob);
      const mediaType = blob.type || "image/jpeg";

      const { data, error } = await supabase.functions.invoke("claude-assistant", {
        body: { type: "scan", imageBase64: base64, imageMediaType: mediaType },
      });
      if (error) throw error;
      if (!data?.success) throw new Error(data?.error ?? "Scan failed");

      // Edge Function v2 liefert bereits validiertes JSON (forced tool-use).
      onScanResult(data.data as ScanResult);
      toast.success("Label scanned ✓");
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not scan label");
    } finally {
      setScanning(false);
    }
  };

  return (
    <div className="w-32 shrink-0">
      <div className="aspect-[3/4] rounded-md overflow-hidden gold-border bg-secondary relative group">
        {photo.preview ? (
          <>
            <img src={photo.preview} alt="" className="w-full h-full object-cover" />
            <button
              type="button"
              onClick={() => onPhotoChange({ file: null, preview: null, remove: true })}
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
      {photo.preview && (
        <>
          <label className="block mt-2 text-xs text-center text-primary cursor-pointer hover:underline">
            Replace
            <input
              type="file"
              accept="image/jpeg,image/png,image/webp"
              className="hidden"
              onChange={(e) => e.target.files?.[0] && handlePhoto(e.target.files[0])}
            />
          </label>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={handleScan}
            disabled={scanning}
            className="w-full mt-2 text-xs gap-1"
          >
            {scanning ? <Loader2 className="w-3 h-3 animate-spin" /> : <Sparkles className="w-3 h-3" />}
            Scan with AI 🍷
          </Button>
        </>
      )}
    </div>
  );
};
