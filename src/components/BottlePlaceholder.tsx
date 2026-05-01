import { Wine } from "lucide-react";
import { cn } from "@/lib/utils";

export const BottlePlaceholder = ({ className }: { className?: string }) => (
  <div className={cn("flex items-center justify-center bg-gradient-to-br from-secondary to-background", className)}>
    <Wine className="w-12 h-12 text-primary/40" strokeWidth={1.2} />
  </div>
);
