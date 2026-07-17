import { useEffect, useRef, useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Loader2, Send, Sparkles, Wine as WineIcon } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { type Wine, wineTitle, vintageDisplay } from "../model";

type Recommendation = { wine_id: string; reason: string };
type ChatMsg =
  | { role: "user"; content: string }
  | { role: "assistant"; content: string; recommendations: Recommendation[] };

const SUGGESTIONS = [
  "What should I open tonight?",
  "Which bottles are peaking now?",
  "Pair something with roast lamb",
];

type Props = {
  open: boolean;
  onOpenChange: (v: boolean) => void;
  wines: Wine[];
  onSelectWine: (w: Wine) => void;
};

export const SommelierDialog = ({ open, onOpenChange, wines, onSelectWine }: Props) => {
  const [messages, setMessages] = useState<ChatMsg[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const byId = new Map(wines.map((w) => [w.id, w]));

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" });
  }, [messages, loading]);

  const ask = async (question: string) => {
    const q = question.trim();
    if (!q || loading) return;
    const history = messages.map((m) => ({ role: m.role, content: m.content }));
    setMessages((m) => [...m, { role: "user", content: q }]);
    setInput("");
    setLoading(true);
    try {
      const { data, error } = await supabase.functions.invoke("claude-assistant", {
        body: { type: "sommelier", message: q, history },
      });
      if (error) throw error;
      if (!data?.success) throw new Error(data?.error ?? "Sommelier unavailable");
      setMessages((m) => [
        ...m,
        { role: "assistant", content: data.reply as string, recommendations: (data.recommendations ?? []) as Recommendation[] },
      ]);
    } catch (e) {
      setMessages((m) => [
        ...m,
        { role: "assistant", content: e instanceof Error ? e.message : "Something went wrong.", recommendations: [] },
      ]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg h-[80vh] flex flex-col bg-card gold-border p-0 gap-0">
        <DialogHeader className="px-5 pt-5 pb-3 border-b border-primary/15">
          <DialogTitle className="font-display text-2xl flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-primary" /> Sommelier
          </DialogTitle>
          <p className="text-xs text-muted-foreground italic">Ask about your own bottles — pairings, timing, tonight's pick.</p>
        </DialogHeader>

        <div ref={scrollRef} className="flex-1 overflow-y-auto px-5 py-4 space-y-4">
          {messages.length === 0 && !loading && (
            <div className="text-center py-8 space-y-4">
              <WineIcon className="w-12 h-12 text-primary/40 mx-auto" strokeWidth={1.2} />
              <p className="text-sm text-muted-foreground">Your personal sommelier knows what's in your cellar.</p>
              <div className="flex flex-wrap gap-2 justify-center">
                {SUGGESTIONS.map((s) => (
                  <Button key={s} variant="outline" size="sm" className="text-xs" onClick={() => ask(s)}>
                    {s}
                  </Button>
                ))}
              </div>
            </div>
          )}

          {messages.map((m, i) =>
            m.role === "user" ? (
              <div key={i} className="flex justify-end">
                <div className="max-w-[85%] rounded-2xl rounded-br-sm bg-primary/20 border border-primary/30 px-3 py-2 text-sm">
                  {m.content}
                </div>
              </div>
            ) : (
              <div key={i} className="flex justify-start">
                <div className="max-w-[90%] space-y-2">
                  <div className="rounded-2xl rounded-bl-sm bg-secondary/40 border border-primary/15 px-3 py-2 text-sm whitespace-pre-wrap">
                    {m.content}
                  </div>
                  {m.recommendations.length > 0 && (
                    <div className="space-y-1.5 pl-1">
                      {m.recommendations.map((r, j) => {
                        const w = byId.get(r.wine_id);
                        if (!w) return null;
                        const vin = vintageDisplay(w);
                        return (
                          <button
                            key={j}
                            type="button"
                            onClick={() => onSelectWine(w)}
                            className="block w-full text-left rounded-md border border-primary/30 bg-card hover:bg-primary/10 transition px-3 py-1.5"
                          >
                            <span className="text-sm text-primary font-medium">
                              {wineTitle(w)}{vin ? ` · ${vin}` : ""}
                            </span>
                            <span className="block text-xs text-muted-foreground">{r.reason}</span>
                          </button>
                        );
                      })}
                    </div>
                  )}
                </div>
              </div>
            ),
          )}

          {loading && (
            <div className="flex justify-start">
              <div className="rounded-2xl rounded-bl-sm bg-secondary/40 border border-primary/15 px-3 py-2">
                <Loader2 className="w-4 h-4 animate-spin text-primary" />
              </div>
            </div>
          )}
        </div>

        <form
          onSubmit={(e) => { e.preventDefault(); ask(input); }}
          className="flex items-center gap-2 border-t border-primary/15 p-3"
        >
          <Input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask your sommelier…"
            disabled={loading}
            className="flex-1"
          />
          <Button type="submit" size="icon" disabled={loading || !input.trim()}>
            {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
          </Button>
        </form>
      </DialogContent>
    </Dialog>
  );
};
