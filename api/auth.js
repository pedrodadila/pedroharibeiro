// Login do painel (/admin): envia para a autorização do GitHub.
// Precisa das variáveis OAUTH_GITHUB_CLIENT_ID e OAUTH_GITHUB_CLIENT_SECRET na Vercel.
import crypto from "node:crypto";

export default function handler(req, res) {
  const clientId = process.env.OAUTH_GITHUB_CLIENT_ID;
  if (!clientId) {
    res.statusCode = 500;
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.end("Falta configurar a variável OAUTH_GITHUB_CLIENT_ID na Vercel.");
    return;
  }
  const state = crypto.randomBytes(16).toString("hex");
  const host = req.headers["x-forwarded-host"] || req.headers.host;
  const url = new URL("https://github.com/login/oauth/authorize");
  url.searchParams.set("client_id", clientId);
  url.searchParams.set("redirect_uri", `https://${host}/api/callback`);
  url.searchParams.set("scope", process.env.OAUTH_GITHUB_SCOPE || "repo,user");
  url.searchParams.set("state", state);
  res.setHeader("Set-Cookie", `decap_oauth_state=${state}; Path=/api; HttpOnly; Secure; SameSite=Lax; Max-Age=600`);
  res.statusCode = 302;
  res.setHeader("Location", url.toString());
  res.end();
}
