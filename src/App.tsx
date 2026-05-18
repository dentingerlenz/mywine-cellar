import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes, Navigate } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { AuthProvider, useAuth } from "@/contexts/AuthContext";
import { WineColoursProvider } from "@/contexts/WineColoursContext";
import Auth from "./pages/Auth";
import Cellar from "./pages/Cellar";
import ImportPage from "./pages/Import";
import Settings from "./pages/Settings";
import History from "./pages/History";
import NotFound from "./pages/NotFound";
import { supabase } from "@/integrations/supabase/client";

const queryClient = new QueryClient();

const Protected = ({ children }: { children: React.ReactNode }) => {
  const { user, loading, approved } = useAuth();
  if (loading) return <div className="min-h-screen flex items-center justify-center text-muted-foreground italic">Pouring…</div>;
  if (!user) return <Navigate to="/auth" replace />;
  if (!approved) return (
    <div className="min-h-screen flex flex-col items-center justify-center gap-4 text-center px-6">
      <div className="text-4xl">🍷</div>
      <h1 className="text-2xl font-semibold">Your account is pending approval</h1>
      <p className="text-muted-foreground max-w-sm">
        Thanks for signing up! The cellar keeper will review your request and grant access shortly.
      </p>
      <button
        onClick={() => supabase.auth.signOut()}
        className="text-sm text-muted-foreground underline mt-4"
      >
        Sign out
      </button>
    </div>
  );
  return <>{children}</>;
};

const PublicOnly = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuth();
  if (loading) return <div className="min-h-screen flex items-center justify-center text-muted-foreground italic">Pouring…</div>;
  if (user) return <Navigate to="/" replace />;
  return <>{children}</>;
};

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <AuthProvider>
          <WineColoursProvider>
            <Routes>
              <Route path="/auth" element={<PublicOnly><Auth /></PublicOnly>} />
              <Route path="/" element={<Protected><Cellar /></Protected>} />
              <Route path="/import" element={<Protected><ImportPage /></Protected>} />
              <Route path="/history" element={<Protected><History /></Protected>} />
              <Route path="/settings" element={<Protected><Settings /></Protected>} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </WineColoursProvider>
        </AuthProvider>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
