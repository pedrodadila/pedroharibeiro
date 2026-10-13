# Pedro Ribeiro · Portfólio e blog

Site de https://pedroribeiro.click: portfólio de freelancer (SEO, sites, tráfego pago e processos) e blog em /blog.

## Como editar

Entre em https://pedroribeiro.click/admin com a sua conta do GitHub. Lá você:

- cria, edita e publica posts do blog (desmarque "Rascunho" para publicar);
- edita o SEO de cada post (título para o Google, meta descrição, slug, imagem para redes sociais, canônica, noindex);
- edita o SEO da página inicial e da página do blog em "Páginas e SEO".

Cada alteração salva vira um commit neste repositório e a Vercel publica o site de novo em cerca de 1 minuto.

## Estrutura

- `src/home.html`: modelo da página inicial (o SEO vem de `content/pages/home.json`)
- `src/blog.css`: estilo do blog
- `src/llms.txt`: resumo para ferramentas de IA (a lista de posts é acrescentada no build)
- `content/posts/`: posts em Markdown
- `content/pages/`: SEO da página inicial e do blog
- `admin/`: painel (Decap CMS)
- `api/`: login do painel com o GitHub (precisa de `OAUTH_GITHUB_CLIENT_ID` e `OAUTH_GITHUB_CLIENT_SECRET` na Vercel)
- `scripts/build.mjs`: gera o site em `dist/`, com sitemap, RSS, robots.txt e llms.txt
- `img/`: imagens; `img/uploads/` recebe as imagens enviadas pelo painel

Para gerar localmente: `npm install` e `npm run build`.
