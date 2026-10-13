// Gera o site estático em dist/: página inicial, blog, posts, sitemap, RSS, robots e llms.txt.
// O conteúdo editável vem de content/ (editado pelo painel em /admin).
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import matter from "gray-matter";
import { marked } from "marked";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const OUT = path.join(ROOT, "dist");
const SITE = "https://pedroribeiro.click";
const GTM = "GTM-NJ9522X7";
const LINKEDIN = "https://www.linkedin.com/in/pedro-henrique-ribeiro/";
const GITHUB = "https://github.com/pedrodadila";
const WA = "https://wa.me/5537984125469?text=Ol%C3%A1%2C%20Pedro!%20Vi%20seu%20site%20e%20gostaria%20de%20conversar.";
const FONTS = "https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,500;12..96,700;12..96,800&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&display=swap";
const WA_ICON = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12.04 2C6.58 2 2.13 6.45 2.13 11.91c0 1.75.46 3.45 1.32 4.95L2.05 22l5.25-1.38a9.9 9.9 0 0 0 4.74 1.21h.01c5.46 0 9.91-4.45 9.91-9.91A9.85 9.85 0 0 0 12.04 2zm5.8 14.08c-.25.69-1.45 1.33-2 1.38-.51.05-1 .24-3.36-.7-2.84-1.12-4.65-4.04-4.79-4.22-.14-.19-1.15-1.53-1.15-2.92s.73-2.07.99-2.35c.26-.28.56-.35.75-.35h.54c.17 0 .41-.07.64.49.24.58.81 2 .88 2.14.07.14.12.31.02.5-.09.19-.14.31-.28.47-.14.17-.3.37-.42.5-.14.14-.29.29-.12.57.17.28.74 1.22 1.59 1.98 1.09.97 2.01 1.27 2.29 1.41.28.14.45.12.61-.07.17-.19.71-.82.9-1.11.19-.28.37-.24.63-.14.26.09 1.64.77 1.92.91.28.14.47.21.54.33.07.12.07.68-.18 1.37z"/></svg>';

const read = (p) => fs.readFileSync(path.join(ROOT, p), "utf8");
const readJSON = (p) => JSON.parse(read(p));
const write = (p, s) => { const f = path.join(OUT, p); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); };
const copy = (p) => { const s = path.join(ROOT, p); if (fs.existsSync(s)) fs.cpSync(s, path.join(OUT, p), { recursive: true }); };
const esc = (s) => String(s ?? "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
const abs = (u) => (!u ? "" : /^https?:\/\//.test(u) ? u : SITE + (u.startsWith("/") ? u : "/" + u));
const slugify = (s) => String(s).normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
const fmtDate = (d) => d.toLocaleDateString("pt-BR", { day: "numeric", month: "long", year: "numeric", timeZone: "America/Sao_Paulo" });
const isoDay = (d) => d.toISOString().slice(0, 10);
const jsonld = (o) => `<script type="application/ld+json">${JSON.stringify(o).replace(/</g, "\\u003c")}</script>`;

// ---------- conteúdo ----------
const home = readJSON("content/pages/home.json");
const blogPage = readJSON("content/pages/blog.json");
const postsDir = path.join(ROOT, "content/posts");
const now = new Date();
const posts = (fs.existsSync(postsDir) ? fs.readdirSync(postsDir) : [])
  .filter((f) => f.endsWith(".md"))
  .map((file) => {
    const { data, content } = matter(fs.readFileSync(path.join(postsDir, file), "utf8"));
    const seo = data.seo || {};
    const date = data.date ? new Date(data.date) : now;
    const words = content.split(/\s+/).filter(Boolean).length;
    return {
      file,
      title: data.title || file,
      slug: slugify(seo.slug || file.replace(/\.md$/, "")),
      date,
      updated: data.updated ? new Date(data.updated) : date,
      description: data.description || "",
      cover: data.cover || "",
      coverAlt: data.cover_alt || data.title || "",
      tags: Array.isArray(data.tags) ? data.tags.filter(Boolean) : [],
      draft: data.draft === true,
      html: marked.parse(content),
      minutes: Math.max(1, Math.round(words / 200)),
      seo: {
        title: seo.title || `${data.title} | Pedro Ribeiro`,
        description: seo.description || data.description || "",
        canonical: seo.canonical || "",
        ogImage: seo.og_image || data.cover || "/img/og-image.jpg",
        noindex: seo.noindex === true,
      },
    };
  })
  .filter((p) => !p.draft && p.date <= now)
  .sort((a, b) => b.date - a.date);

// ---------- partes comuns ----------
const topbar = (current) => `<header class="topbar">
  <div class="wrap">
    <a class="brand" href="/">Pedro Ribeiro</a>
    <nav class="topnav" aria-label="Principal">
      <a class="hide-sm" href="/#servicos">Serviços</a>
      <a class="hide-sm" href="/#cases">Cases</a>
      <a href="/blog"${current === "blog" ? ' aria-current="page"' : ""}>Blog</a>
      <a class="nav-wa" href="/#contato">Contato</a>
    </nav>
  </div>
</header>`;

const footer = `<footer>
  <div class="wrap">
    <span>Pedro Ribeiro · Performance, SEO e Growth · Pompéu, MG · (37) 98412-5469</span>
    <span><a href="/">Início</a><a href="/blog">Blog</a><a href="${LINKEDIN}" target="_blank" rel="noopener me">LinkedIn</a><a href="${GITHUB}" target="_blank" rel="noopener me">GitHub</a></span>
  </div>
</footer>`;

const head = ({ title, description, url, image, type = "website", noindex = false, extra = "" }) => `<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','${GTM}');</script>
<!-- End Google Tag Manager -->
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>${esc(title)}</title>
<meta name="description" content="${esc(description)}">
<meta name="robots" content="${noindex ? "noindex, follow" : "index, follow, max-image-preview:large"}">
<meta name="author" content="Pedro Henrique Ribeiro">
<link rel="canonical" href="${esc(url)}">
<meta name="theme-color" content="#0f5e63">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="/img/apple-touch-icon.png">
<link rel="alternate" type="application/rss+xml" title="Blog do Pedro Ribeiro" href="${SITE}/blog/feed.xml">
<meta property="og:type" content="${type}">
<meta property="og:locale" content="pt_BR">
<meta property="og:site_name" content="Pedro Ribeiro">
<meta property="og:url" content="${esc(url)}">
<meta property="og:title" content="${esc(title)}">
<meta property="og:description" content="${esc(description)}">
<meta property="og:image" content="${esc(abs(image))}">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="${esc(title)}">
<meta name="twitter:description" content="${esc(description)}">
<meta name="twitter:image" content="${esc(abs(image))}">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preload" as="style" href="${FONTS}">
<link rel="stylesheet" href="${FONTS}" media="print" onload="this.media='all'">
<noscript><link rel="stylesheet" href="${FONTS}"></noscript>
<link rel="stylesheet" href="/assets/blog.css">
${extra}
</head>
<body>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=${GTM}"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
`;

const personRef = { "@type": "Person", "@id": `${SITE}/#pedro`, name: "Pedro Henrique Ribeiro", url: `${SITE}/` };

// ---------- saída ----------
fs.rmSync(OUT, { recursive: true, force: true });
fs.mkdirSync(OUT, { recursive: true });
["img", "admin", "favicon.svg"].forEach(copy);
write("assets/blog.css", read("src/blog.css"));

// página inicial
const cards = posts.slice(0, 3).map((p) => `<a class="post-card" href="/blog/${p.slug}"><time datetime="${p.date.toISOString()}">${fmtDate(p.date)}</time><h3>${esc(p.title)}</h3><p>${esc(p.description)}</p></a>`).join("\n      ");
const latest = posts.length ? `<section id="blog">
  <div class="wrap">
    <header>
      <p class="eyebrow">Blog</p>
      <h2>Artigos recentes</h2>
    </header>
    <div class="posts">
      ${cards}
    </div>
    <p class="more"><a href="/blog">Ver todos os artigos →</a></p>
  </div>
</section>
` : "";
const homeHtml = read("src/home.html")
  .replaceAll("{{SEO_TITLE}}", esc(home.seo_title))
  .replaceAll("{{META_DESCRIPTION}}", esc(home.meta_description))
  .replaceAll("{{OG_TITLE}}", esc(home.og_title || home.seo_title))
  .replaceAll("{{OG_DESCRIPTION}}", esc(home.og_description || home.meta_description))
  .replaceAll("{{OG_IMAGE}}", esc(abs(home.og_image || "/img/og-image.jpg")))
  .replace("{{LATEST_POSTS}}", latest);
write("index.html", homeHtml);

// lista do blog
const blogUrl = `${SITE}/blog`;
const items = posts.map((p) => `<a class="post-item${p.cover ? "" : " no-cover"}" href="/blog/${p.slug}">
      ${p.cover ? `<img src="${esc(p.cover)}" alt="${esc(p.coverAlt)}" loading="lazy" decoding="async" width="440" height="275">` : ""}
      <div>
        <div class="meta"><time datetime="${p.date.toISOString()}">${fmtDate(p.date)}</time><span>${p.minutes} min de leitura</span></div>
        <h2>${esc(p.title)}</h2>
        <p>${esc(p.description)}</p>
      </div>
    </a>`).join("\n    ");
write("blog/index.html", head({
  title: blogPage.seo_title, description: blogPage.meta_description, url: blogUrl, image: blogPage.og_image || "/img/og-image.jpg",
  extra: jsonld({ "@context": "https://schema.org", "@graph": [
    { "@type": "Blog", "@id": `${blogUrl}#blog`, url: blogUrl, name: blogPage.title, description: blogPage.meta_description, inLanguage: "pt-BR", author: personRef,
      blogPost: posts.map((p) => ({ "@type": "BlogPosting", headline: p.title, url: `${SITE}/blog/${p.slug}`, datePublished: p.date.toISOString() })) },
    { "@type": "BreadcrumbList", itemListElement: [
      { "@type": "ListItem", position: 1, name: "Início", item: `${SITE}/` },
      { "@type": "ListItem", position: 2, name: "Blog", item: blogUrl } ] } ] }),
}) + `${topbar("blog")}
<main class="wrap">
  <header class="blog-head">
    <p class="eyebrow">Blog</p>
    <h1>${esc(blogPage.title)}</h1>
    <p>${esc(blogPage.intro)}</p>
  </header>
  <div class="post-list">
    ${items || '<p class="empty">Os primeiros artigos estão a caminho. Enquanto isso, <a href="/#formas">veja como posso ajudar</a>.</p>'}
  </div>
</main>
${footer}
</body>
</html>
`);

// posts
for (const p of posts) {
  const url = `${SITE}/blog/${p.slug}`;
  const related = posts.filter((o) => o !== p).slice(0, 2);
  write(`blog/${p.slug}/index.html`, head({
    title: p.seo.title, description: p.seo.description, url: p.seo.canonical || url, image: p.seo.ogImage, type: "article", noindex: p.seo.noindex,
    extra: `<meta property="article:published_time" content="${p.date.toISOString()}">
<meta property="article:modified_time" content="${p.updated.toISOString()}">
<meta property="article:author" content="${LINKEDIN}">
${p.tags.map((t) => `<meta property="article:tag" content="${esc(t)}">`).join("\n")}
${jsonld({ "@context": "https://schema.org", "@graph": [
      { "@type": "BlogPosting", "@id": `${url}#post`, headline: p.title, description: p.seo.description, image: abs(p.seo.ogImage),
        datePublished: p.date.toISOString(), dateModified: p.updated.toISOString(), inLanguage: "pt-BR", keywords: p.tags.join(", "),
        mainEntityOfPage: url, author: personRef, publisher: personRef, wordCount: undefined },
      { "@type": "BreadcrumbList", itemListElement: [
        { "@type": "ListItem", position: 1, name: "Início", item: `${SITE}/` },
        { "@type": "ListItem", position: 2, name: "Blog", item: blogUrl },
        { "@type": "ListItem", position: 3, name: p.title, item: url } ] } ] })}`,
  }) + `${topbar("blog")}
<main>
  <article class="narrow">
    <nav class="crumbs" aria-label="Você está em"><ol><li><a href="/">Início</a></li><li><a href="/blog">Blog</a></li><li aria-current="page">${esc(p.title)}</li></ol></nav>
    <header class="post-head">
      <h1>${esc(p.title)}</h1>
      ${p.description ? `<p class="lead">${esc(p.description)}</p>` : ""}
      <div class="meta"><span>Por Pedro Ribeiro</span><time datetime="${p.date.toISOString()}">${fmtDate(p.date)}</time><span>${p.minutes} min de leitura</span></div>
    </header>
    ${p.cover ? `<figure class="cover" style="margin-inline:0"><img src="${esc(p.cover)}" alt="${esc(p.coverAlt)}" fetchpriority="high" decoding="async"></figure>` : ""}
    <div class="prose">
${p.html}
    </div>
    ${p.tags.length ? `<div class="tags">${p.tags.map((t) => `<span>${esc(t)}</span>`).join("")}</div>` : ""}
    <aside class="author">
      <img src="/img/pedro-ribeiro.webp" alt="Pedro Ribeiro" width="72" height="72" loading="lazy">
      <div>
        <h2>Pedro Ribeiro</h2>
        <p>Gestor de Performance, SEO e Growth, com mais de 10 anos no digital. Aberto a projetos e a contratação CLT ou PJ.</p>
        <a class="btn btn-primary" href="/#contato">Vamos conversar</a>
      </div>
    </aside>
    ${related.length ? `<section class="related"><h2>Leia também</h2><div class="grid">${related.map((o) => `<a href="/blog/${o.slug}">${esc(o.title)}</a>`).join("")}</div></section>` : ""}
  </article>
</main>
${footer}
</body>
</html>
`);
}

// sitemap, RSS, robots, llms.txt
const indexable = posts.filter((p) => !p.seo.noindex && !p.seo.canonical);
const lastmod = isoDay(indexable.length ? new Date(Math.max(...indexable.map((p) => p.updated))) : now);
write("sitemap.xml", `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>${SITE}/</loc><lastmod>${isoDay(now)}</lastmod></url>
  <url><loc>${blogUrl}</loc><lastmod>${lastmod}</lastmod></url>
${indexable.map((p) => `  <url><loc>${SITE}/blog/${p.slug}</loc><lastmod>${isoDay(p.updated)}</lastmod></url>`).join("\n")}
</urlset>
`);
write("blog/feed.xml", `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
  <title>${esc(blogPage.title)}</title>
  <link>${blogUrl}</link>
  <description>${esc(blogPage.meta_description)}</description>
  <language>pt-BR</language>
  <atom:link href="${blogUrl}/feed.xml" rel="self" type="application/rss+xml"/>
${posts.map((p) => `  <item><title>${esc(p.title)}</title><link>${SITE}/blog/${p.slug}</link><guid>${SITE}/blog/${p.slug}</guid><pubDate>${p.date.toUTCString()}</pubDate><description>${esc(p.description)}</description></item>`).join("\n")}
</channel>
</rss>
`);
write("robots.txt", `User-agent: *\nAllow: /\nDisallow: /admin/\n\nSitemap: ${SITE}/sitemap.xml\n`);
write("llms.txt", read("src/llms.txt").trimEnd() + (posts.length ? `\n\n## Blog\n\n${posts.map((p) => `- [${p.title}](${SITE}/blog/${p.slug}): ${p.description}`).join("\n")}\n` : "\n"));

console.log(`Site gerado: ${posts.length} post(s) publicado(s).`);
