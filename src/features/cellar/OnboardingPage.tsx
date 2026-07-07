import { useState } from "react";
import { useAuth } from "@/features/auth/AuthContext";
import { useCreateCellar, useJoinCellar } from "./queries";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { toast } from "sonner";
import { Wine, Loader2, KeyRound, PlusCircle } from "lucide-react";

export default function OnboardingPage() {
  const { signOut } = useAuth();
  const createCellar = useCreateCellar();
  const joinCellar = useJoinCellar();
  const [name, setName] = useState("");
  const [code, setCode] = useState("");

  const onCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await createCellar.mutateAsync(name);
      toast.success("Your cellar is ready!");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Could not create cellar");
    }
  };

  const onJoin = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await joinCellar.mutateAsync(code.trim().toUpperCase());
      toast.success("Welcome to the cellar!");
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Could not join cellar");
    }
  };

  const busy = createCellar.isPending || joinCellar.isPending;

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-12">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-14 h-14 rounded-full gold-border bg-card mb-4">
            <Wine className="w-7 h-7 text-primary" strokeWidth={1.5} />
          </div>
          <h1 className="font-display text-4xl text-foreground tracking-tight">Almost there</h1>
          <p className="text-muted-foreground italic mt-2 font-body">
            Create your family cellar — or join one with an invite code.
          </p>
        </div>

        <Card className="p-8 gold-border bg-card/90 shadow-warm backdrop-blur">
          <Tabs defaultValue="create">
            <TabsList className="grid w-full grid-cols-2 mb-6">
              <TabsTrigger value="create">
                <PlusCircle className="w-4 h-4 mr-2" /> Create
              </TabsTrigger>
              <TabsTrigger value="join">
                <KeyRound className="w-4 h-4 mr-2" /> Join
              </TabsTrigger>
            </TabsList>

            <TabsContent value="create">
              <form onSubmit={onCreate} className="space-y-4">
                <div>
                  <Label>Cellar name</Label>
                  <Input
                    required
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="e.g. Dentinger Family Cellar"
                    className="bg-input/60"
                  />
                </div>
                <Button type="submit" className="w-full" disabled={busy || !name.trim()}>
                  {createCellar.isPending && <Loader2 className="w-4 h-4 animate-spin" />}
                  Create cellar
                </Button>
              </form>
            </TabsContent>

            <TabsContent value="join">
              <form onSubmit={onJoin} className="space-y-4">
                <div>
                  <Label>Invite code</Label>
                  <Input
                    required
                    value={code}
                    onChange={(e) => setCode(e.target.value)}
                    placeholder="8-character code"
                    className="bg-input/60 font-mono tracking-widest uppercase"
                    maxLength={8}
                  />
                </div>
                <Button type="submit" className="w-full" disabled={busy || code.trim().length < 8}>
                  {joinCellar.isPending && <Loader2 className="w-4 h-4 animate-spin" />}
                  Join cellar
                </Button>
              </form>
            </TabsContent>
          </Tabs>

          <div className="text-center mt-6">
            <button onClick={() => signOut()} className="text-sm text-muted-foreground underline">
              Sign out
            </button>
          </div>
        </Card>
      </div>
    </div>
  );
}
