import Anthropic from "npm:@anthropic-ai/sdk";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function cleanAndParseJson(raw: string): string {
  let cleaned = raw
    .replace(/^```json\s*/im, "")
    .replace(/^```\s*/im, "")
    .replace(/```\s*$/im, "")
    .trim();

  if (!cleaned.startsWith("{") && !cleaned.startsWith("[")) {
    const start = cleaned.indexOf("{");
    const end = cleaned.lastIndexOf("}");
    if (start !== -1 && end > start) {
      cleaned = cleaned.slice(start, end + 1);
    }
  }

  let parsed: Record<string, any>;
  try {
    parsed = JSON.parse(cleaned);
  } catch {
    cleaned = cleaned
      .replace(/,\s*}/g, "}")
      .replace(/,\s*]/g, "]")
      .replace(/[\x00-\x1F\x7F]/g, "");
    parsed = JSON.parse(cleaned);
  }

  if (parsed.vintage !== undefined && parsed.vintage !== null) {
    const v = parseInt(String(parsed.vintage), 10);
    parsed.vintage = isNaN(v) ? null : v;
  }
  if (parsed.alcohol_pct !== undefined && parsed.alcohol_pct !== null) {
    const a = parseFloat(String(parsed.alcohol_pct));
    parsed.alcohol_pct = isNaN(a) ? null : a;
  }

  return JSON.stringify(parsed);
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { type, message, imageBase64, cellarContext } = await req.json();
    const client = new Anthropic({ apiKey: Deno.env.get("cave_key") });

    const systemPrompt = `You are a knowledgeable wine cellar assistant built into "My Wine Cellar" app. You help the user manage their wine collection, suggest food pairings, identify wines from label photos, and give drinking window advice.

Current cellar context:
${cellarContext ? JSON.stringify(cellarContext) : "No cellar data provided."}

When scanning a label, extract and return a JSON object with these fields (use null for unknown fields):
{"name": string, "producer": string, "vintage": number, "region": string, "country": string, "appellation": string, "grape_varieties": string, "alcohol_pct": number, "notes": string}

Return ONLY raw JSON, no markdown code fences. For chat messages, respond conversationally and helpfully about wine.`;

    let response;

    if (type === "scan") {
      response = await client.messages.create({
        model: "claude-sonnet-4-6",
        max_tokens: 4096,
        system: systemPrompt,
        tools: [{ type: "web_search_20250305", name: "web_search" }],
        messages: [{
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type: "image/jpeg", data: imageBase64 } },
            { type: "text", text: "Read all visible information from this wine label, then search the web to find any missing details about this wine including vintage, region, appellation, grape varieties, alcohol percentage, dosage, and drinking window. Return a complete JSON object with all fields filled in as accurately as possible." }
          ]
        }]
      });
    } else {
      response = await client.messages.create({
        model: "claude-sonnet-4-6",
        max_tokens: 1024,
        system: systemPrompt,
        messages: [{ role: "user", content: message }]
      });
    }

    let content = response.content[0].type === "text" ? response.content[0].text : "";

    if (type === "scan") {
      try {
        content = cleanAndParseJson(content);
      } catch (e) {
        return new Response(JSON.stringify({ success: false, error: `JSON parse failed: ${e.message}`, raw: content }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
      }
    }

    return new Response(JSON.stringify({ success: true, content }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });

  } catch (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
