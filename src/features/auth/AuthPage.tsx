import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "./AuthContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { toast } from "sonner";
import { Wine, Loader2 } from "lucide-react";

export default function AuthPage() {
  const { signIn, signUp } = useAuth();
  const navigate = useNavigate();
  const [mode, setMode] = useState<"signin" | "signup">("signin");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    const fn = mode === "signin" ? signIn : signUp;
    const { error } = await fn(email, password);
    setLoading(false);
    if (error) {
      toast.error(error.message);
      return;
    }
    if (mode === "signup") {
      toast.success("Check your email to confirm your account.");
    } else {
      navigate("/");
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-12">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-14 h-14 rounded-full gold-border bg-card mb-4">
            <Wine className="w-7 h-7 text-primary" strokeWidth={1.5} />
          </div>
          <h1 className="font-display text-5xl text-foreground tracking-tight">Cave</h1>
          <p className="text-muted-foreground italic mt-2 font-body">Your family cellar journal</p>
        </div>

        <Card className="p-8 gold-border bg-card/90 shadow-warm backdrop-blur">
          <h2 className="font-display text-2xl mb-6 text-center">
            {mode === "signin" ? "Welcome back" : "Create your account"}
          </h2>
          <form onSubmit={submit} className="space-y-4">
            <div>
              <Label>Email</Label>
              <Input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} className="bg-input/60" />
            </div>
            <div>
              <Label>Password</Label>
              <Input type="password" required minLength={6} value={password} onChange={(e) => setPassword(e.target.value)} className="bg-input/60" />
            </div>
            <Button type="submit" className="w-full" disabled={loading}>
              {loading && <Loader2 className="w-4 h-4 animate-spin" />}
              {mode === "signin" ? "Enter the cellar" : "Sign up"}
            </Button>
          </form>
          <div className="text-center mt-6 text-sm text-muted-foreground">
            {mode === "signin" ? "New here?" : "Already have an account?"}{" "}
            <button
              onClick={() => setMode(mode === "signin" ? "signup" : "signin")}
              className="text-primary hover:underline font-medium"
            >
              {mode === "signin" ? "Create an account" : "Sign in"}
            </button>
          </div>
        </Card>

        <p className="text-center text-xs text-muted-foreground mt-8 font-body italic">
          "Wine is bottled poetry." — R.L. Stevenson
        </p>
      </div>
    </div>
  );
}
