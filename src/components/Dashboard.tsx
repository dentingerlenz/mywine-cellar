import { Wine, COLOUR_LABEL, getDrinkStatus, WineColour, wineTitle } from "@/lib/wine";
import { Card } from "@/components/ui/card";
import { PieChart, Pie, Cell, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip } from "recharts";

const COLOUR_HEX: Record<WineColour, string> = {
  sparkling: "hsl(45, 70%, 70%)",
  white: "hsl(48, 55%, 75%)",
  red: "hsl(350, 70%, 35%)",
  orange_rose: "hsl(25, 70%, 60%)",
  dessert_fortified: "hsl(30, 65%, 50%)",
};

export const Dashboard = ({ wines }: { wines: Wine[] }) => {
  const inStock = wines.filter((b) => b.quantity > 0);
  const totalBottles = inStock.reduce((s, b) => s + b.quantity, 0);
  const totalValue = inStock.reduce((s, b) => s + (b.price_chf ?? 0) * b.quantity, 0);
  const labelCount = inStock.length;
  const drinkNow = inStock.filter((b) => getDrinkStatus(b) === "drink_now" && (b.ready_from || b.drink_by));
  const layDown = inStock.filter((b) => b.occasion === "l");

  const byColour = (Object.keys(COLOUR_LABEL) as WineColour[]).map((c) => ({
    name: COLOUR_LABEL[c],
    value: inStock.filter((b) => b.colour === c).reduce((s, b) => s + b.quantity, 0),
    fill: COLOUR_HEX[c],
  })).filter((d) => d.value > 0);

  const byCountry = Object.entries(
    inStock.reduce<Record<string, number>>((acc, b) => {
      const key = b.country || "Unknown";
      acc[key] = (acc[key] || 0) + b.quantity;
      return acc;
    }, {})
  ).map(([name, value]) => ({ name, value })).sort((a, b) => b.value - a.value).slice(0, 8);

  return (
    <div className="space-y-4 mb-8">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="p-6 gold-border bg-card/80 shadow-card">
          <p className="text-xs uppercase tracking-widest text-muted-foreground">In the cellar</p>
          <p className="font-display text-5xl text-primary mt-2">{totalBottles}</p>
          <p className="text-sm text-muted-foreground mt-1">{labelCount} {labelCount === 1 ? "label" : "labels"}</p>
          <div className="mt-4 pt-4 border-t border-primary/20">
            <p className="text-xs uppercase tracking-widest text-muted-foreground">Total value</p>
            <p className="font-display text-2xl text-foreground mt-1">{totalValue.toFixed(0)} <span className="text-sm text-muted-foreground">CHF</span></p>
          </div>
        </Card>

        <Card className="p-6 gold-border bg-card/80 shadow-card">
          <p className="text-xs uppercase tracking-widest text-muted-foreground mb-2">By colour</p>
          {byColour.length > 0 ? (
            <ResponsiveContainer width="100%" height={180}>
              <PieChart>
                <Pie data={byColour} dataKey="value" nameKey="name" innerRadius={45} outerRadius={70} paddingAngle={2}>
                  {byColour.map((d, i) => <Cell key={i} fill={d.fill} />)}
                </Pie>
                <Tooltip contentStyle={{ background: "hsl(350 40% 10%)", border: "1px solid hsl(44 30% 25%)", borderRadius: 6 }} />
              </PieChart>
            </ResponsiveContainer>
          ) : <p className="text-sm text-muted-foreground py-8 text-center">No data yet</p>}
          <div className="flex flex-wrap gap-2 mt-2">
            {byColour.map((d) => (
              <span key={d.name} className="text-xs flex items-center gap-1">
                <span className="w-2 h-2 rounded-full" style={{ background: d.fill }} />
                {d.name} ({d.value})
              </span>
            ))}
          </div>
        </Card>

        <Card className="p-6 gold-border bg-card/80 shadow-card">
          <p className="text-xs uppercase tracking-widest text-muted-foreground mb-2">By country</p>
          {byCountry.length > 0 ? (
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={byCountry} layout="vertical" margin={{ left: 0 }}>
                <XAxis type="number" hide />
                <YAxis dataKey="name" type="category" width={90} tick={{ fill: "hsl(36 50% 93%)", fontSize: 11 }} axisLine={false} tickLine={false} />
                <Tooltip contentStyle={{ background: "hsl(350 40% 10%)", border: "1px solid hsl(44 30% 25%)", borderRadius: 6 }} cursor={{ fill: "hsl(44 53% 54% / 0.1)" }} />
                <Bar dataKey="value" fill="hsl(44 53% 54%)" radius={[0, 4, 4, 0]} />
              </BarChart>
            </ResponsiveContainer>
          ) : <p className="text-sm text-muted-foreground py-8 text-center">No data yet</p>}
        </Card>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card className="p-5 gold-border bg-card/80 shadow-card">
          <p className="text-xs uppercase tracking-widest text-muted-foreground mb-3">Drink now</p>
          {drinkNow.length === 0 ? (
            <p className="text-sm text-muted-foreground italic">Nothing in window yet.</p>
          ) : (
            <ul className="space-y-1.5 max-h-40 overflow-y-auto">
              {drinkNow.slice(0, 8).map((w) => (
                <li key={w.id} className="flex justify-between text-sm gap-3">
                  <span className="truncate">{wineTitle(w)}</span>
                  <span className="text-primary shrink-0">{w.vintage}</span>
                </li>
              ))}
            </ul>
          )}
        </Card>
        <Card className="p-5 gold-border bg-card/80 shadow-card">
          <p className="text-xs uppercase tracking-widest text-muted-foreground mb-3">Lay down</p>
          {layDown.length === 0 ? (
            <p className="text-sm text-muted-foreground italic">No bottles set aside to age.</p>
          ) : (
            <ul className="space-y-1.5 max-h-40 overflow-y-auto">
              {layDown.slice(0, 8).map((w) => (
                <li key={w.id} className="flex justify-between text-sm gap-3">
                  <span className="truncate">{wineTitle(w)}</span>
                  <span className="text-primary shrink-0">{w.ready_from ?? w.vintage}</span>
                </li>
              ))}
            </ul>
          )}
        </Card>
      </div>
    </div>
  );
};
