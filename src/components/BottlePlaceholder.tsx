import { cn } from "@/lib/utils";

export const BottlePlaceholder = ({ className }: { className?: string }) => (
  <div className={cn("flex items-center justify-center bg-gradient-to-br from-secondary to-background", className)}>
    <img src="/LogoDesign1.png" alt="Cave" className="w-[80px] h-[80px] object-contain opacity-100" />
  </div>
);
