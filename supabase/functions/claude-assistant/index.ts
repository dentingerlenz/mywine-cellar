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

Current cellar context:
${cellarContext ? JSON.stringify(cellarContext) : "No cellar data provided."}

When scanning a label, extract and return a JSON object with these fields (use null for unknown fields):
{"name": string, "producer": string, "vintage": number, "region": string, "country": string, "appellation": string, "grape_varieties": string, "alcohol": string, "notes": string}

For chat messages, respond conversationally and helpfully about wine.`;

    let response;

    if (type === "scan") {
      response = await client.messages.create({
        model: "claude-sonnet-4-6",
        max_tokens: 1024,
        system: systemPrompt,
        messages: [{
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type: "image/jpeg", data: imageBase64 } },
            { type: "text", text: "Please scan this wine label and extract all available information. Return a JSON object with the wine details." }
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

    const content = response.content[0].type === "text" ? response.content[0].text : "";
    return new Response(JSON.stringify({ success: true, content }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });

  } catch (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
