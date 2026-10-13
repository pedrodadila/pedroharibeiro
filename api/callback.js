// Retorno do GitHub: troca o código pelo token e o entrega ao painel (/admin) na mesma origem.
export default async function handler(req, res) {
  const params = new URL(req.url, "https://localhost").searchParams;
  const code = params.get("code");
  const state = params.get("state");
  const ghError = params.get("error");
  const cookie = (req.headers.cookie || "").split(";").map((s) => s.trim()).find((s) => s.startsWith("decap_oauth_state="));
  const expected = cookie ? cookie.split("=")[1] : "";

  let status = "error";
  let content;
  if (ghError) {
    content = { error: params.get("error_description") || ghError };
  } else if (!code || !state || state !== expected) {
    content = { error: "Sessão de login inválida ou expirada. Feche esta janela e tente entrar de novo." };
  } else {
    try {
      const r = await fetch("https://github.com/login/oauth/access_token", {
        method: "POST",
        headers: { Accept: "application/json", "Content-Type": "application/json" },
        body: JSON.stringify({
          client_id: process.env.OAUTH_GITHUB_CLIENT_ID,
          client_secret: process.env.OAUTH_GITHUB_CLIENT_SECRET,
          code,
        }),
      });
      const data = await r.json();
      if (data.access_token) {
        status = "success";
        content = { token: data.access_token, provider: "github" };
      } else {
        content = { error: data.error_description || data.error || "O GitHub não devolveu o token." };
      }
    } catch {
      content = { error: "Não foi possível falar com o GitHub. Tente de novo em instantes." };
    }
  }

  const message = JSON.stringify(`authorization:github:${status}:${JSON.stringify(content)}`).replace(/</g, "\\u003c");
  res.statusCode = 200;
  res.setHeader("Content-Type", "text/html; charset=utf-8");
  res.setHeader("Cache-Control", "no-store");
  res.setHeader("Set-Cookie", "decap_oauth_state=; Path=/api; HttpOnly; Secure; SameSite=Lax; Max-Age=0");
  res.end(`<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="robots" content="noindex"><title>Entrando…</title></head>
<body><p style="font-family:system-ui;padding:24px">Entrando no painel…</p>
<script>
(function () {
  var message = ${message};
  if (!window.opener) { document.body.innerHTML = '<p style="font-family:system-ui;padding:24px">Abra o painel em /admin e clique em Entrar com o GitHub.</p>'; return; }
  function receive(e) {
    if (e.origin !== window.location.origin) return;
    window.opener.postMessage(message, e.origin);
    window.removeEventListener("message", receive, false);
  }
  window.addEventListener("message", receive, false);
  window.opener.postMessage("authorizing:github", window.location.origin);
})();
</script></body></html>`);
}
