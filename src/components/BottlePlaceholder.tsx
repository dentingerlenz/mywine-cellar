import { cn } from "@/lib/utils";

export const BottlePlaceholder = ({ className }: { className?: string }) => (
  <div className={cn("flex items-center justify-center bg-gradient-to-br from-secondary to-background", className)}>
    <img src="/LogoDesign1.png" alt="Cave" className="w-[70px] h-[70px] object-contain opacity-100" />
  </div>
);
