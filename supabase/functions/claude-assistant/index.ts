// Edge Function v2 — "claude-assistant" (Phase 6)
// Two modes, one hardened function:
//   type:"scan"      → wine-label OCR + knowledge fill → structured wine fields
//                      (incl. V8 drinking window ready_from / drink_by), returned
//                      as a forced tool-use block (guaranteed valid JSON, no fences).
//   type:"sommelier" → cellar-aware chat; the bottle context is read SERVER-SIDE
//                      from the DB (RLS), never trusted from the client.
//
// Auth: verify_jwt=true (config.toml) is the hard gate — unauthenticated calls are
// rejected by the platform before this code runs. Inside, we resolve the user +
// cellar membership from the forwarded JWT and refuse otherwise.
// Model: scan uses ANTHROPIC_MODEL (default claude-sonnet-5); the sommelier uses
// ANTHROPIC_SOMMELIER_MODEL (defaults to the same) so it can be switched to a cheaper
// model (e.g. claude-haiku-4-5) independently. Secret: ANTHROPIC_API_KEY.
//
// Error contract: handled outcomes return HTTP 200 with { success:false, error }.
// (supabase-js `functions.invoke` discards the JSON body on non-2xx and surfaces a
// generic error, so 200 is how the friendly message reaches the client.)
import Anthropic from "npm:@anthropic-ai/sdk";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const MODEL = Deno.env.get("ANTHROPIC_MODEL") ?? "claude-sonnet-5";
const SOMMELIER_MODEL = Deno.env.get("ANTHROPIC_SOMMELIER_MODEL") ?? MODEL;

const ok = (body: Record<string, unknown>) =>
  new Response(JSON.stringify({ success: true, ...body }), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
const fail = (error: string) =>
  new Response(JSON.stringify({ success: false, error }), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

// ── Scan tool — every field required, values may be null (type: [..,"null"]). ──
const extractLabel = {
  name: "extract_label",
  description: "Structured data extracted from a wine-label photo.",
  strict: true,
  input_schema: {
    type: "object",
    additionalProperties: false,
    properties: {
      producer: { type: ["string", "null"], description: "Producer / estate / winery." },
      name: { type: ["string", "null"], description: "Cuvée or wine name (without the producer)." },
      colour: { type: ["string", "null"], description: "Wine category — EXACTLY one of: red, white, rose, sparkling, orange, dessert_fortified." },
      vintage: { type: ["integer", "null"], description: "Vintage year; null if non-vintage or unreadable." },
      is_non_vintage: { type: ["boolean", "null"], description: "true for NV sparkling / solera / multi-vintage blends." },
      country: { type: ["string", "null"], description: "Country in English (e.g. France)." },
      region: { type: ["string", "null"], description: "Wine region (e.g. Burgundy, Champagne, Tuscany)." },
      sub_region: { type: ["string", "null"], description: "Recognised sub-region of the region if applicable (e.g. Cote de Nuits, Aube for Champagne)." },
      appellation: { type: ["string", "null"], description: "Appellation / GI (e.g. Gevrey-Chambertin, Barolo)." },
      location: { type: ["string", "null"], description: "Village / vineyard / lieu-dit (e.g. Ambonnay, Buxeuil). NOT the region or appellation." },
      classification: { type: ["string", "null"], description: "Quality tier (AOC, DOCG, VDP.Grosse Lage, Grand Cru …). NOT the place." },
      variety: { type: ["string", "null"], description: "Grape variety/varieties, comma-separated." },
      alcohol_pct: { type: ["number", "null"], description: "Alcohol by volume in percent (e.g. 12.5)." },
      dosage: { type: ["string", "null"], description: "Sparkling dosage: a level (Brut, Extra Brut …) or g/L." },
      ready_from: { type: ["integer", "null"], description: "V8 — earliest good drinking year (conservative estimate)." },
      drink_by: { type: ["integer", "null"], description: "V8 — latest good drinking year (conservative estimate)." },
      terroir_notes: { type: ["string", "null"], description: "Vinification / terroir facts you know: soil, élevage, dosage context, lees ageing, farming. Short; null if nothing solid." },
    },
    required: [
      "producer", "name", "colour", "vintage", "is_non_vintage", "country", "region", "sub_region",
      "appellation", "location", "classification", "variety", "alcohol_pct", "dosage", "ready_from",
      "drink_by", "terroir_notes",
    ],
  },
};

const SCAN_SYSTEM =
  "You identify wines from label photos for a personal cellar app. Read the visible " +
  "text first (producer, cuvée, vintage, appellation, ABV, grape, dosage), then use your " +
  "wine knowledge to fill fields the label implies but does not spell out (country/region " +
  "for a known appellation, typical grape for a classic appellation, classification tier). " +
  "colour: pick the single best-fitting category from the fixed set. sub_region: fill it " +
  "when the wine belongs to a recognised subdivision of the region (e.g. Aube / Cote des " +
  "Bar for a Champagne from that area). location: the village, vineyard or lieu-dit — NOT " +
  "the region or appellation. terroir_notes: put any vinification/terroir facts you know " +
  "here (soil, élevage, dosage context, lees ageing, farming), kept short. " +
  "For ready_from/drink_by, give a conservative drinking-window estimate from vintage, " +
  "appellation and style; use null when you truly cannot tell. Prefer null over guessing " +
  "producer or cuvée names. Return country and region names in English. " +
  "NEVER include meta-information anywhere (bottle size, how you read the vintage, " +
  "packaging) and NEVER write tasting or drinking impressions — the user writes those.";

// ── Sommelier tool — a markdown reply plus links back to real bottles. ──────────
const recommendTool = {
  name: "recommend",
  description: "Answer the user and, when relevant, point to specific bottles from their cellar.",
  strict: true,
  input_schema: {
    type: "object",
    additionalProperties: false,
    properties: {
      reply: { type: "string", description: "Answer to the user (concise, friendly, sommelier tone)." },
      recommendations: {
        type: "array",
        description: "Bottles from the provided cellar context that fit the request. Empty if none apply.",
        items: {
          type: "object",
          additionalProperties: false,
          properties: {
            ref: { type: "integer", description: "The `ref` number of a bottle from the cellar context." },
            reason: { type: "string", description: "One short sentence on why this bottle fits." },
          },
          required: ["ref", "reason"],
        },
      },
    },
    required: ["reply", "recommendations"],
  },
};

const SOMMELIER_SYSTEM =
  "You are the house sommelier inside a private wine-cellar app. The user's current " +
  "in-stock bottles are given as JSON in the <cellar> block, each with a short numeric " +
  "`ref`. Answer their question — food pairings, what to drink tonight, what is peaking, " +
  "cellaring advice — and when you recommend bottles, choose ONLY from the provided cellar " +
  "and reference them by their `ref` in the recommendations array. If the cellar has " +
  "nothing suitable, say so honestly and leave recommendations empty. Keep the reply " +
  "concise and warm. Prefer bottles whose drinking window (ready_from/drink_by) matches " +
  "the occasion.";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    // ── Auth: resolve the user + their cellar from the forwarded JWT ──────────
    const authHeader = req.headers.get("Authorization") ?? "";
    const supa = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );
    const { data: { user } } = await supa.auth.getUser();
    if (!user) return fail("Please sign in first.");

    // Own membership row only (RLS returns all cellar members otherwise) — see CLAUDE.md.
    const { data: membership } = await supa
      .from("cellar_members")
      .select("cellar_id")
      .eq("user_id", user.id)
      .maybeSingle();
    if (!membership) return fail("No cellar found for this account.");

    const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (!apiKey) return fail("AI is not configured yet (missing API key).");
    const client = new Anthropic({ apiKey });

    const { type, message, imageBase64, imageMediaType, history } = await req.json();

    // ── Mode: label scan ─────────────────────────────────────────────────────
    if (type === "scan") {
      if (!imageBase64) return fail("No image supplied.");
      const allowed = ["image/jpeg", "image/png", "image/webp", "image/gif"];
      const mediaType = allowed.includes(imageMediaType) ? imageMediaType : "image/jpeg";

      const resp = await client.messages.create({
        model: MODEL,
        max_tokens: 2048,
        system: SCAN_SYSTEM,
        tools: [extractLabel],
        tool_choice: { type: "tool", name: "extract_label" },
        messages: [{
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type: mediaType, data: imageBase64 } },
            { type: "text", text: "Scan this wine label. Fill every field; use null where unknown." },
          ],
        }],
      });

      if (resp.stop_reason === "refusal") return fail("The image could not be processed.");
      const block = resp.content.find((b) => b.type === "tool_use");
      if (!block) return fail("Could not read the label.");
      return ok({ data: (block as { input: unknown }).input });
    }

    // ── Mode: sommelier chat ─────────────────────────────────────────────────
    if (!message || typeof message !== "string") return fail("Empty question.");

    // In-stock bottles, read server-side under the user's RLS. Ordered by id so the
    // serialised context is byte-stable across questions → the prompt cache can hit.
    const { data: rows, error: cellarErr } = await supa
      .from("wines")
      .select(
        "id, producer, name, vintage, is_non_vintage, base_vintage, aging_indication, variety, " +
        "ready_from, drink_by, occasion, " +
        "wine_colours(display_name), regions(name), appellations(name)",
      )
      .gt("quantity", 0)
      .order("id", { ascending: true });
    if (cellarErr) throw cellarErr;

    type Rel = { name: string | null } | null;
    type Row = {
      id: string; producer: string | null; name: string | null; vintage: number | null;
      is_non_vintage: boolean | null; base_vintage: number | null; aging_indication: string | null;
      variety: string | null; ready_from: number | null; drink_by: number | null; occasion: string | null;
      wine_colours: { display_name: string | null } | null;
      regions: Rel; appellations: Rel;
    };
    // Trim the payload and reference each bottle by a short `ref` (1..N) rather than its
    // 36-char UUID; map the model's refs back to real ids for the client afterwards.
    const refToId = new Map<number, string>();
    const context = ((rows as Row[]) ?? []).map((w, i) => {
      const ref = i + 1;
      refToId.set(ref, w.id);
      return {
        ref,
        producer: w.producer,
        name: w.name,
        vintage: w.vintage ?? (w.is_non_vintage ? (w.base_vintage ? `NV (${w.base_vintage})` : "NV") : null) ?? w.aging_indication,
        colour: w.wine_colours?.display_name ?? null,
        region: w.regions?.name ?? null,
        appellation: w.appellations?.name ?? null,
        variety: w.variety,
        ready_from: w.ready_from,
        drink_by: w.drink_by,
        occasion: w.occasion,
      };
    });

    // Prior turns from the client; keep it well-formed (start on a user turn).
    let priorTurns: { role: "user" | "assistant"; content: string }[] = Array.isArray(history)
      ? history
          .filter((m) => m && (m.role === "user" || m.role === "assistant") && typeof m.content === "string")
          .slice(-8)
          .map((m) => ({ role: m.role as "user" | "assistant", content: m.content as string }))
      : [];
    while (priorTurns.length && priorTurns[0].role === "assistant") priorTurns = priorTurns.slice(1);

    const resp = await client.messages.create({
      model: SOMMELIER_MODEL,
      max_tokens: 1500,
      // System prompt + cellar context are a stable prefix → cache them, so follow-up
      // questions in the same session pay ~0.1x for the (large) bottle list.
      system: [
        { type: "text", text: SOMMELIER_SYSTEM },
        { type: "text", text: `<cellar>\n${JSON.stringify(context)}\n</cellar>`, cache_control: { type: "ephemeral" } },
      ],
      tools: [recommendTool],
      tool_choice: { type: "tool", name: "recommend" },
      messages: [...priorTurns, { role: "user", content: message }],
    });

    if (resp.stop_reason === "refusal") return fail("I can't help with that one.");
    const block = resp.content.find((b) => b.type === "tool_use");
    const out = block ? (block as { input: { reply?: string; recommendations?: { ref?: number; reason?: string }[] } }).input : null;
    const recommendations = Array.isArray(out?.recommendations)
      ? out!.recommendations!
          .map((r) => ({ wine_id: refToId.get(Number(r?.ref)), reason: r?.reason ?? "" }))
          .filter((r): r is { wine_id: string; reason: string } => typeof r.wine_id === "string")
      : [];
    return ok({
      reply: out?.reply ?? "Sorry, I couldn't come up with anything.",
      recommendations,
    });
  } catch (error) {
    // Surface the real message (200 so the client can read it — see contract above).
    return fail(error instanceof Error ? error.message : "Unexpected error.");
  }
});
