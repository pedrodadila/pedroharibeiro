# Pedro Ribeiro — portfólio e blog

Site de https://pedroribeiro.click: portfólio de freelancer do Pedro Ribeiro (SEO, sites, tráfego pago e processos) e blog em `/blog`. Objetivo: gerar contatos pelo WhatsApp e mostrar autoridade em SEO/GEO.

## Stack
- Site estático gerado por script próprio (`scripts/build.mjs`, Node ≥ 20, ES modules). Sem framework.
- Dependências: `gray-matter` (front matter) e `marked` (Markdown → HTML).
- Painel de conteúdo: Decap CMS em `/admin`, login pelo GitHub via funções em `api/` (`OAUTH_GITHUB_CLIENT_ID` / `OAUTH_GITHUB_CLIENT_SECRET` na Vercel).
- Deploy: Vercel (`vercel.json`: build `npm run build`, saída `dist/`). Push na `main` publica em ~1 min.

## Comandos
- `npm install` · `npm run build` → gera `dist/` (páginas, sitemap, RSS em `/blog/feed.xml`, robots.txt e llms.txt).

## Onde fica cada coisa
- `src/home.html` — modelo da página inicial; SEO vem de `content/pages/home.json`.
- `src/blog.css` — estilo do blog.
- `src/llms.txt` — resumo para IAs (a lista de posts é acrescentada no build).
- `content/posts/*.md` — posts. Front matter: `title`, `draft`, `date`, `description`, `cover`, `cover_alt`, `tags`, `seo{slug,title,description,og_image,canonical,noindex}`.
- `content/pages/` — SEO da home e da página do blog.
- `admin/config.yml` — campos do painel. Se mudar o front matter dos posts, atualize aqui e no `build.mjs` juntos.
- `img/` — imagens; `img/uploads/` recebe envios do painel.
- Constantes do site (URL, GTM, LinkedIn, GitHub, WhatsApp, fontes) ficam no topo de `scripts/build.mjs`.

## Regras
- O conteúdo é editado pelo painel, que faz commits direto na `main`: sempre `git pull` antes de mexer e não reescrever posts sem pedido.
- Posts com `draft: true` não são publicados; datas futuras só aparecem após novo build.
- SEO/GEO é o foco: título até 60 caracteres, meta descrição de 120–160, H2 para seções (o título do post já é o H1), `alt` em imagens, JSON-LD e llms.txt sempre atualizados.
- Domínio canônico é `pedroribeiro.click` (www e vercel.app redirecionam). Não remover os redirects nem o `noindex` do `/admin`.
- Rodar `npm run build` antes do push para garantir que gera sem erro.
- Textos e comentários em português do Brasil.
