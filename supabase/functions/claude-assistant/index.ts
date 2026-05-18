import Anthropic from "npm:@anthropic-ai/sdk";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { type, message, imageBase64, cellarContext } = await req.json();
    const client = new Anthropic({ apiKey: Deno.env.get("cave_key") });

    const systemPrompt = `You are a knowledgeable wine cellar assistant built into "My Wine Cellar" app. You help the user manage their wine collection, suggest food pairings, identify wines from label photos, and give drinking window advice.

When scanning a label, read visible text first, then use your wine knowledge to fill in any missing details. Return ONLY a raw JSON object with no markdown, no code fences, no extra text - just the JSON:
{"name": "string or null", "producer": "string or null", "vintage": "string or null", "region": "string or null", "country": "string or null", "appellation": "string or null", "grape_varieties": "string or null", "alcohol": "string or null", "dosage": "string or null", "notes": "string or null"}`;

    let response;

    if (type === "scan") {
      response = await client.messages.create({
        model: "claude-sonnet-4-6",
        max_tokens: 2048,
        system: systemPrompt,
        messages: [{
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type: "image/jpeg", data: imageBase64 } },
            { type: "text", text: "Scan this wine label. Read all visible text, then use your knowledge to complete any missing fields. Return only the JSON object." }
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

    const rawContent = response.content[0].type === "text" ? response.content[0].text : "";
    const clean = rawContent.replace(/```json\n?/g, "").replace(/```\n?/g, "").trim();

    return new Response(
      JSON.stringify({ success: true, content: clean }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
