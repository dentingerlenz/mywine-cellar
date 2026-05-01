import { Bottle, COLOUR_LABEL, getDrinkStatus, WineColour } from "@/lib/wine";
import { Card } from "@/components/ui/card";
import { PieChart, Pie, Cell, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip } from "recharts";

const COLOUR_HEX: Record<WineColour, string> = {
  red: "hsl(350, 70%, 35%)",
  white: "hsl(48, 55%, 75%)",
  rose: "hsl(345, 60%, 70%)",
  sparkling: "hsl(45, 70%, 70%)",
  dessert: "hsl(30, 65%, 50%)",
};

export const Dashboard = ({ bottles }: { bottles: Bottle[] }) => {
  const totalBottles = bottles.reduce((s, b) => s + b.quantity, 0);
  const drinkNow = bottles.filter((b) => getDrinkStatus(b) === "drink_now" && (b.ready_from || b.drink_by));

  const byColour = (Object.keys(COLOUR_LABEL) as WineColour[]).map((c) => ({
    name: COLOUR_LABEL[c],
    value: bottles.filter((b) => b.colour === c).reduce((s, b) => s + b.quantity, 0),
    fill: COLOUR_HEX[c],
  })).filter((d) => d.value > 0);

  const byRegion = Object.entries(
    bottles.reduce<Record<string, number>>((acc, b) => {
      const key = b.region || b.country || "Unknown";
      acc[key] = (acc[key] || 0) + b.quantity;
      return acc;
    }, {})
  ).map(([name, value]) => ({ name, value })).sort((a, b) => b.value - a.value).slice(0, 8);

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
      <Card className="p-6 gold-border bg-card/80 shadow-card">
        <p className="text-xs uppercase tracking-widest text-muted-foreground">In the cellar</p>
        <p className="font-display text-5xl text-primary mt-2">{totalBottles}</p>
        <p className="text-sm text-muted-foreground mt-1">{bottles.length} {bottles.length === 1 ? "label" : "labels"}</p>
        <div className="mt-4 pt-4 border-t border-primary/20">
          <p className="text-xs uppercase tracking-widest text-muted-foreground">Drink now</p>
          <p className="font-display text-2xl text-foreground mt-1">{drinkNow.reduce((s, b) => s + b.quantity, 0)} bottles</p>
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
        <p className="text-xs uppercase tracking-widest text-muted-foreground mb-2">By region</p>
        {byRegion.length > 0 ? (
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={byRegion} layout="vertical" margin={{ left: 0 }}>
              <XAxis type="number" hide />
              <YAxis dataKey="name" type="category" width={90} tick={{ fill: "hsl(36 50% 93%)", fontSize: 11 }} axisLine={false} tickLine={false} />
              <Tooltip contentStyle={{ background: "hsl(350 40% 10%)", border: "1px solid hsl(44 30% 25%)", borderRadius: 6 }} cursor={{ fill: "hsl(44 53% 54% / 0.1)" }} />
              <Bar dataKey="value" fill="hsl(44 53% 54%)" radius={[0, 4, 4, 0]} />
            </BarChart>
          </ResponsiveContainer>
        ) : <p className="text-sm text-muted-foreground py-8 text-center">No data yet</p>}
      </Card>
    </div>
  );
};
