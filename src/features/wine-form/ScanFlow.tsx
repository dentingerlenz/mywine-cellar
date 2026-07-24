import { useCallback, useEffect, useRef, useState } from "react";
import Cropper, { type Area } from "react-easy-crop";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Camera, Check, Loader2, RotateCcw, SkipForward, X } from "lucide-react";
import { toast } from "sonner";
import { supabase } from "@/integrations/supabase/client";
import type { ScanResult } from "./PhotoScanPanel";

// ── Helpers ─────────────────────────────────────────────────────────────────
const blobToBase64 = (blob: Blob) =>
  new Promise<string>((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => {
      const r = reader.result as string;
      resolve(r.split(",")[1] ?? r);
    };
    reader.onerror = reject;
    reader.readAsDataURL(blob);
  });

const loadImage = (src: string) =>
  new Promise<HTMLImageElement>((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(img);
    img.onerror = reject;
    img.src = src;
  });

/** Crop the selected region and downscale to <= maxEdge → JPEG blob (bounds tokens/upload). */
async function getCroppedBlob(src: string, area: Area, maxEdge = 1600): Promise<Blob> {
  const img = await loadImage(src);
  const scale = Math.min(1, maxEdge / Math.max(area.width, area.height));
  const w = Math.max(1, Math.round(area.width * scale));
  const h = Math.max(1, Math.round(area.height * scale));
  const canvas = document.createElement("canvas");
  canvas.width = w;
  canvas.height = h;
  const ctx = canvas.getContext("2d");
  if (!ctx) throw new Error("Canvas unavailable");
  ctx.drawImage(img, area.x, area.y, area.width, area.height, 0, 0, w, h);
  return new Promise((resolve, reject) =>
    canvas.toBlob((b) => (b ? resolve(b) : reject(new Error("Crop failed"))), "image/jpeg", 0.85),
  );
}

// ── Live camera with a guide frame; falls back to the native file picker. ─────
const CameraCapture = ({
  title, hint, onCapture, onCancel, extraAction,
}: {
  title: string;
  hint: string;
  onCapture: (blob: Blob) => void;
  onCancel: () => void;
  extraAction?: { label: string; icon: React.ReactNode; onClick: () => void };
}) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const [fallback, setFallback] = useState(false);

  useEffect(() => {
    let active = true;
    let stream: MediaStream | null = null;
    (async () => {
      try {
        stream = await navigator.mediaDevices.getUserMedia({
          video: { facingMode: { ideal: "environment" } }, audio: false,
        });
        if (!active) { stream.getTracks().forEach((t) => t.stop()); return; }
        if (videoRef.current) videoRef.current.srcObject = stream;
      } catch {
        if (active) setFallback(true);
      }
    })();
    return () => { active = false; stream?.getTracks().forEach((t) => t.stop()); };
  }, []);

  const capture = () => {
    const video = videoRef.current;
    if (!video || !video.videoWidth) return;
    const canvas = document.createElement("canvas");
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;
    ctx.drawImage(video, 0, 0);
    canvas.toBlob((b) => b && onCapture(b), "image/jpeg", 0.92);
  };

  if (fallback) {
    return (
      <div className="flex flex-col items-center gap-4 py-10 text-center">
        <Camera className="w-10 h-10 text-primary" />
        <p className="text-sm text-muted-foreground px-6">
          {title} — {hint}
        </p>
        <label className="inline-flex">
          <span className="inline-flex items-center gap-2 rounded-md bg-primary text-primary-foreground px-4 py-2 text-sm cursor-pointer">
            <Camera className="w-4 h-4" /> Open camera
          </span>
          <input
            type="file"
            accept="image/*"
            capture="environment"
            className="hidden"
            onChange={(e) => e.target.files?.[0] && onCapture(e.target.files[0])}
          />
        </label>
        <div className="flex gap-2">
          {extraAction && (
            <Button variant="outline" size="sm" onClick={extraAction.onClick}>
              {extraAction.icon} {extraAction.label}
            </Button>
          )}
          <Button variant="ghost" size="sm" onClick={onCancel}><X className="w-4 h-4" /> Cancel</Button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex flex-col items-center gap-3">
      <div className="relative w-full aspect-[3/4] max-h-[62vh] overflow-hidden rounded-md bg-black">
        <video ref={videoRef} autoPlay playsInline muted className="w-full h-full object-cover" />
        {/* Ziel-Rahmen */}
        <div className="pointer-events-none absolute inset-6 border-2 border-primary/80 rounded-md shadow-[0_0_0_9999px_rgba(0,0,0,0.35)]" />
        <div className="absolute top-2 inset-x-0 text-center">
          <span className="text-xs bg-background/70 text-foreground rounded-full px-3 py-1">{title}</span>
        </div>
      </div>
      <p className="text-xs text-muted-foreground text-center px-4">{hint}</p>
      <div className="flex items-center gap-2">
        <Button variant="ghost" size="sm" onClick={onCancel}><X className="w-4 h-4" /> Cancel</Button>
        <Button onClick={capture} className="gap-2"><Camera className="w-4 h-4" /> Capture</Button>
        {extraAction && (
          <Button variant="outline" size="sm" onClick={extraAction.onClick}>
            {extraAction.icon} {extraAction.label}
          </Button>
        )}
      </div>
    </div>
  );
};

// ── Manual crop step (react-easy-crop). ───────────────────────────────────────
const CropStep = ({
  src, onDone, onRetake,
}: {
  src: string;
  onDone: (blob: Blob) => void;
  onRetake: () => void;
}) => {
  const [crop, setCrop] = useState({ x: 0, y: 0 });
  const [zoom, setZoom] = useState(1);
  const [pixels, setPixels] = useState<Area | null>(null);
  const [busy, setBusy] = useState(false);
  const onComplete = useCallback((_a: Area, p: Area) => setPixels(p), []);

  const confirm = async () => {
    if (!pixels) return;
    try {
      setBusy(true);
      onDone(await getCroppedBlob(src, pixels));
    } catch {
      toast.error("Could not crop image");
      setBusy(false);
    }
  };

  return (
    <div className="flex flex-col gap-3">
      <div className="relative w-full aspect-[3/4] max-h-[62vh] bg-black rounded-md overflow-hidden">
        <Cropper
          image={src}
          crop={crop}
          zoom={zoom}
          aspect={3 / 4}
          onCropChange={setCrop}
          onZoomChange={setZoom}
          onCropComplete={onComplete}
        />
      </div>
      <input
        type="range" min={1} max={4} step={0.01} value={zoom}
        onChange={(e) => setZoom(Number(e.target.value))}
        className="w-full accent-primary"
        aria-label="Zoom"
      />
      <div className="flex items-center justify-center gap-2">
        <Button variant="ghost" size="sm" onClick={onRetake}><RotateCcw className="w-4 h-4" /> Retake</Button>
        <Button onClick={confirm} disabled={busy} className="gap-2">
          {busy ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />} Use photo
        </Button>
      </div>
    </div>
  );
};

// ── Orchestration ─────────────────────────────────────────────────────────────
type Step = "front-cam" | "front-crop" | "back-cam" | "back-crop" | "processing";

export const ScanFlow = ({
  open, onOpenChange, onComplete,
}: {
  open: boolean;
  onOpenChange: (v: boolean) => void;
  onComplete: (scan: ScanResult, frontPhoto: File) => void;
}) => {
  const [step, setStep] = useState<Step>("front-cam");
  const [rawSrc, setRawSrc] = useState<string | null>(null); // last raw capture (for the crop step)
  const [frontBlob, setFrontBlob] = useState<Blob | null>(null);

  useEffect(() => {
    if (open) { setStep("front-cam"); setRawSrc(null); setFrontBlob(null); }
  }, [open]);

  const toCrop = (blob: Blob, next: "front-crop" | "back-crop") => {
    if (rawSrc) URL.revokeObjectURL(rawSrc);
    setRawSrc(URL.createObjectURL(blob));
    setStep(next);
  };

  const runScan = async (front: Blob, back: Blob | null) => {
    setStep("processing");
    try {
      const body: Record<string, unknown> = {
        type: "scan",
        frontImageBase64: await blobToBase64(front),
        frontMediaType: "image/jpeg",
      };
      if (back) {
        body.backImageBase64 = await blobToBase64(back);
        body.backMediaType = "image/jpeg";
      }
      const { data, error } = await supabase.functions.invoke("claude-assistant", { body });
      if (error) throw error;
      if (!data?.success) throw new Error(data?.error ?? "Scan failed");
      onComplete(data.data as ScanResult, new File([front], "label.jpg", { type: "image/jpeg" }));
      toast.success("Label scanned ✓");
      onOpenChange(false);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "Could not scan label");
      setStep("front-cam");
      setFrontBlob(null);
    }
  };

  const title =
    step === "processing" ? "Scanning…"
    : step.startsWith("front") ? "Front label"
    : "Back label";

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md bg-card gold-border">
        <DialogHeader>
          <DialogTitle className="font-display text-2xl">{title}</DialogTitle>
        </DialogHeader>

        {step === "front-cam" && (
          <CameraCapture
            title="Front label"
            hint="Include the vintage if it's printed on the neck above the label."
            onCapture={(b) => toCrop(b, "front-crop")}
            onCancel={() => onOpenChange(false)}
          />
        )}

        {step === "front-crop" && rawSrc && (
          <CropStep
            src={rawSrc}
            onRetake={() => setStep("front-cam")}
            onDone={(b) => { setFrontBlob(b); setStep("back-cam"); }}
          />
        )}

        {step === "back-cam" && (
          <CameraCapture
            title="Back label"
            hint="Grape, alcohol and vinification are often here. Skip if there's no back label."
            onCapture={(b) => toCrop(b, "back-crop")}
            onCancel={() => onOpenChange(false)}
            extraAction={{
              label: "Skip back",
              icon: <SkipForward className="w-4 h-4" />,
              onClick: () => frontBlob && runScan(frontBlob, null),
            }}
          />
        )}

        {step === "back-crop" && rawSrc && (
          <CropStep
            src={rawSrc}
            onRetake={() => setStep("back-cam")}
            onDone={(b) => frontBlob && runScan(frontBlob, b)}
          />
        )}

        {step === "processing" && (
          <div className="flex flex-col items-center gap-3 py-12 text-center">
            <Loader2 className="w-10 h-10 animate-spin text-primary" />
            <p className="text-sm text-muted-foreground">Reading the labels and looking up details…</p>
            <p className="text-xs text-muted-foreground/70">This can take a few seconds.</p>
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
};
