import { createContext, useContext, ReactNode } from "react";
import { useAuth } from "@/features/auth/AuthContext";
import { useMembership, Membership } from "./queries";
import OnboardingPage from "./OnboardingPage";

// Liefert den aktiven Keller (E3: genau einer pro User). Ohne Mitgliedschaft
// sieht der eingeloggte User das Onboarding (Keller erstellen / beitreten).
const CellarContext = createContext<Membership | undefined>(undefined);

export const CellarGate = ({ children }: { children: ReactNode }) => {
  const { user } = useAuth();
  const { data: membership, isLoading } = useMembership();

  if (!user) return null; // Protected (Route-Guard) greift vorher
  if (isLoading)
    return (
      <div className="min-h-screen flex items-center justify-center text-muted-foreground italic">
        Pouring…
      </div>
    );
  if (!membership) return <OnboardingPage />;

  return <CellarContext.Provider value={membership}>{children}</CellarContext.Provider>;
};

export const useCellar = () => {
  const ctx = useContext(CellarContext);
  if (!ctx) throw new Error("useCellar must be used within CellarGate");
  return ctx;
};
