# Phase 6 — KI: Edge Function v2 + Etiketten-Scan-Fix + Sommelier (V7) + Trinkfenster (V8)

> Detaillierter Umsetzungsplan. Erstellt 2026-07-17 (nach Abschluss der Geografie/Phase 7).
> Modell-IDs/Preise/API-Muster via `claude-api`-Skill verifiziert (Stand 2026-07). Vor der
> Umsetzung ggf. erneut den `claude-api`-Skill konsultieren, falls Zeit vergangen ist.
>
> ✅ **IMPLEMENTIERT 2026-07-17 (commit `cfd6d48`).** Alle Schritte umgesetzt; Gates grün.
> **Eine bewusste Abweichung:** `output_config:{effort:"low"}` (Schritt 2) weggelassen —
> forced `tool_choice` ist mit Extended Thinking unverträglich (400-Risiko); reine
> forced-tool-use-Extraktion ist robuster. **Offen = nur Deploy** (Schritt 5): User setzt
> den `ANTHROPIC_API_KEY`-Secret + `functions deploy` + `git push` auf Abruf.

## Ziel

Die KI-Funktionen scharf schalten:
1. **Etiketten-Scan reparieren** (heute kaputt) → füllt das Wein-Formular inkl. Geo-FKs.
2. **V8 — KI-Trinkfenster** beim Scan/Erfassen (`ready_from`/`drink_by`-Vorschlag).
3. **V7 — Sommelier-Chat** mit Bestands-Kontext (Empfehlungen mit Flaschen-Links).
Alles über EINE gehärtete Edge Function `claude-assistant` v2 (JWT-verifiziert, Structured Output).

## Ausgangslage — die kaputte Function

`supabase/functions/claude-assistant/index.ts` (aktuell):
- **Env `cave_key`** statt eines sauberen `ANTHROPIC_API_KEY`-Secrets.
- **Keine Auth-Prüfung** — jeder kann auf Kosten des API-Keys scannen (Kostenrisiko!).
- **Fragile JSON-Extraktion** per Regex über Markdown-Fences (`replace(/```json/…)`).
- **Modell `claude-sonnet-4-6`** — existiert zwar noch (aktiv), sollte aber auf das
  aktuelle Sonnet migriert werden.
- Frontend-Aufrufer: `src/features/wine-form/PhotoScanPanel.tsx` (+ `WineFormDialog.tsx`);
  Geo-Namensauflösung liegt schon bereit in `src/features/geography/resolveGeoNames.ts`.

## Entscheidungen (fix)

### Modellwahl (kostenbewusst, per Env konfigurierbar)
Aktuelle IDs + Preise pro 1M Token (Input/Output):
| Modell | ID | Input | Output | Vision |
|---|---|---|---|---|
| Sonnet 5 | `claude-sonnet-5` | $3 ($2 intro bis 2026-08-31) | $15 ($10 intro) | Hi-Res 2576px |
| Haiku 4.5 | `claude-haiku-4-5` | $1 | $5 | ja |
| Opus 4.8 | `claude-opus-4-8` | $5 | $25 | Hi-Res 2576px |

- **Default (beide Modi): `claude-sonnet-5`** — bester Kompromiss aus Genauigkeit
  (kryptische Weinetiketten) und Kosten; per Env `ANTHROPIC_MODEL` überschreibbar.
- **Günstige Option** für den Scan: `claude-haiku-4-5` (falls Genauigkeit reicht).
- **Max-Genauigkeit**: `claude-opus-4-8` (teurer). Env-gesteuert, kein Code-Change nötig.
- Thinking: für den Scan `output_config: { effort: "low" }` (schnell/günstig, reine
  Extraktion). Sommelier: Default (Sonnet 5 läuft adaptiv) oder `effort: "medium"`.

### Structured Output = Tool-Use mit erzwungenem `tool_choice` (garantiert valides JSON)
Kein Fence-Stripping mehr. Ein Tool `extract_label` mit `input_schema` +
`tool_choice: { type: "tool", name: "extract_label" }` + `strict: true`.
Response: den `tool_use`-Block finden → `block.input` ist bereits validiertes JSON.
(Alternative: `output_config: { format: { type: "json_schema", schema } }` +
`client.messages.parse()` — beide von Sonnet 5 / Haiku 4.5 / Opus 4.8 unterstützt.
Tool-Use gewählt, weil im REBUILD_PLAN §7 bereits spezifiziert.)

### Auth-Härtung
- `supabase/config.toml`: Function mit `verify_jwt = true`.
- Im Code zusätzlich: Supabase-Client mit dem User-JWT (Authorization-Header) bauen,
  `auth.getUser()`, und Keller-Mitgliedschaft prüfen (`cellar_members` via
  `current_cellar_id()`-Logik) → unauthentifiziert/kein Keller ⇒ 401/403.

### Secrets
- `ANTHROPIC_API_KEY` als Supabase-Secret: `node_modules/.bin/supabase secrets set
  ANTHROPIC_API_KEY=<key> --project-ref czmjxsojbomkqtluzhru` (Key NIE committen).
- Env `ANTHROPIC_MODEL` optional (Default im Code = `claude-sonnet-5`).

## Umsetzungsschritte

### Schritt 1 — Edge Function v2 neu schreiben (`supabase/functions/claude-assistant/index.ts`)
Deno + `npm:@anthropic-ai/sdk`. Grundgerüst:

```ts
import Anthropic from "npm:@anthropic-ai/sdk";
import { createClient } from "npm:@supabase/supabase-js";

const cors = { "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type" };
const MODEL = Deno.env.get("ANTHROPIC_MODEL") ?? "claude-sonnet-5";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: cors });
  // --- Auth: User + Keller aus dem JWT auflösen ---
  const authHeader = req.headers.get("Authorization") ?? "";
  const supa = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authHeader } } });
  const { data: { user } } = await supa.auth.getUser();
  if (!user) return json({ success:false, error:"unauthorized" }, 401);
  // Keller-Mitgliedschaft prüfen (nur eigene Zeile! .eq user_id + maybeSingle — s. CLAUDE.md Fallstrick)
  const { data: membership } = await supa.from("cellar_members")
    .select("cellar_id").eq("user_id", user.id).maybeSingle();
  if (!membership) return json({ success:false, error:"no_cellar" }, 403);

  const client = new Anthropic({ apiKey: Deno.env.get("ANTHROPIC_API_KEY") });
  const { type, message, imageBase64, imageMediaType } = await req.json();

  if (type === "scan") { /* Schritt 2 */ }
  else { /* Schritt 4 — Sommelier */ }
});
```

### Schritt 2 — Scan mit Tool-Use (V8-Trinkfenster inklusive)
Ein Tool `extract_label`, dessen Schema die v2-Wein-Felder + `ready_from`/`drink_by`
(V8) enthält. `strict: true`, `additionalProperties: false`, alle Felder `required`
(Werte dürfen `null` sein — via `type: ["string","null"]`).

```ts
const extractLabel = {
  name: "extract_label",
  description: "Structured data extracted from a wine label photo.",
  strict: true,
  input_schema: {
    type: "object", additionalProperties: false,
    properties: {
      producer:  { type: ["string","null"] },
      name:      { type: ["string","null"] },
      vintage:   { type: ["integer","null"] },   // Jahr; NV → null
      country:   { type: ["string","null"] },     // Klartext-Name → resolveGeoNames im Client
      region:    { type: ["string","null"] },
      sub_region:{ type: ["string","null"] },
      appellation:{ type: ["string","null"] },
      classification:{ type: ["string","null"] }, // AOC/DOCG/VDP.Grosse Lage …
      variety:   { type: ["string","null"] },
      alcohol_pct:{ type: ["number","null"] },
      dosage:    { type: ["string","null"] },
      ready_from:{ type: ["integer","null"] },     // V8 — KI-Schätzung Trinkfenster
      drink_by:  { type: ["integer","null"] },     // V8
      notes:     { type: ["string","null"] },
    },
    required: ["producer","name","vintage","country","region","sub_region","appellation",
               "classification","variety","alcohol_pct","dosage","ready_from","drink_by","notes"],
  },
} as const;

const resp = await client.messages.create({
  model: MODEL, max_tokens: 2048,
  output_config: { effort: "low" },
  system: SCAN_SYSTEM,           // "Lies sichtbaren Text zuerst, dann Weinwissen; schätze ready_from/drink_by konservativ."
  tools: [extractLabel],
  tool_choice: { type: "tool", name: "extract_label" },
  messages: [{ role: "user", content: [
    { type: "image", source: { type: "base64", media_type: imageMediaType ?? "image/jpeg", data: imageBase64 } },
    { type: "text", text: "Scan this wine label. Fill every field; use null where unknown." },
  ] }],
});
const toolUse = resp.content.find((b) => b.type === "tool_use");
return json({ success: true, data: toolUse?.input ?? null });
```
Refusal absichern: wenn `resp.stop_reason === "refusal"` → sauberer Fehler statt Crash.

### Schritt 3 — Client-Integration Scan
- `PhotoScanPanel.tsx`: Aufruf über `supabase.functions.invoke("claude-assistant", { body:{ type:"scan", imageBase64, imageMediaType } })` (JWT wird automatisch mitgeschickt).
- Ergebnis (Klartext-Geo-Namen) → `resolveGeoNames()` → FK-IDs (country/region/sub/appellation) + Restfelder ins Formular (`setValue`), inkl. `ready_from`/`drink_by`-Vorschlag (überschreibbar).
- Vintage-Handling: `parseVintageInput` (NV/Reifeangabe) aus `model.ts` wiederverwenden.

### Schritt 4 — V7 Sommelier-Chat
- Zweiter Modus `type: "sommelier"`. Request = `{ type, message }` (Chat-Frage).
- **Bestands-Kontext serverseitig** aus der DB lesen (nicht vom Client schicken!):
  Weine mit `quantity > 0` des Kellers → kompaktes JSON (id, producer, name, colour,
  region, vintage, ready_from, drink_by). Über den User-JWT-Supabase-Client (RLS greift).
- `client.messages.create({ model: MODEL, max_tokens: 1024, system: SOMMELIER_SYSTEM,
  messages:[{ role:"user", content: `${message}\n\n<cellar>${JSON.stringify(context)}</cellar>` }] })`.
- Antwort: Empfehlungen mit `wine_id`-Referenzen, damit das UI Flaschen verlinken kann
  (entweder Freitext + erwähnte IDs, oder ein `recommend`-Tool mit `wine_ids[]`).
- UI: eigener Chat-Dialog auf der Cellar-Seite (`src/features/wines/…`). Streaming
  optional (Edge + SSE komplexer) — v1 non-streaming mit `max_tokens` genügt.

### Schritt 5 — config.toml + Secrets + Deploy
- `supabase/config.toml`: `[functions.claude-assistant] verify_jwt = true`.
- `supabase secrets set ANTHROPIC_API_KEY=…` (+ optional `ANTHROPIC_MODEL`).
- Lokal testen: `supabase functions serve claude-assistant --env-file …` gegen den
  lokalen Stack; echtes Etikett scannen; Sommelier-Frage stellen.
- Deploy: `supabase functions deploy claude-assistant --project-ref czmjxsojbomkqtluzhru`.

## Verifikation
- **Auth**: unauthentifizierter Aufruf → 401; Nicht-Keller-User → 403.
- **Scan**: reales Etikett → Formular gefüllt (Geo-FKs korrekt aufgelöst via
  resolveGeoNames), Trinkfenster-Vorschlag gesetzt, valides JSON (kein Fence-Bug).
- **Sommelier**: Frage („Was passt zu Lamm?") → Antwort referenziert echte Bestands­
  flaschen; UI verlinkt sie.
- **Quality-Gates**: `npx tsc --noEmit -p tsconfig.app.json` · `npm run lint` ·
  `npm run build` · `npm test` grün. Browser-Verifikation von Scan + Chat.
- Commit(s) englisch, pro logischer Einheit; danach Prod-Deploy der Function + `git push`.

## Offene Punkte / Hinweise
- Kostenobergrenze/Rate-Limit pro User erwägen (Missbrauch trotz Auth).
- `wine_colours.kind` steuert weiterhin die Formularfelder — Scan-Mapping respektiert das.
- Fehler-Handling: getypte SDK-Exceptions (RateLimit/APIError) im Client-Toast sauber zeigen.
- Deploy-Muster (DB): Session-Pooler eu-west-1; git-Push braucht frischen PAT (~7 Tage gültig).
```
