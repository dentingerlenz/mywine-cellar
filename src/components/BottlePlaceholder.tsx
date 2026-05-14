import { cn } from "@/lib/utils";

export const BottlePlaceholder = ({ className }: { className?: string }) => (
  <div className={cn("flex items-center justify-center bg-gradient-to-br from-secondary to-background", className)}>
    <img src="/LogoDesign1.png" alt="Cave" className="w-16 h-16 object-contain opacity-40" />
  </div>
);
