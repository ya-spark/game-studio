'use strict';

/**
 * Serves the Flutter web builds: SERVE_PATH/<game>/ per game, plus an index page listing them, all under
 * the URL prefix SERVE_BASE (e.g. /appgames, so a game is at /appgames/wingy/). Caddy forwards the prefix unchanged.
 * Flutter web uses hash URLs, so no SPA rewrite is needed; unknown paths are 404.
 * No auth here: the login is enforced by Caddy (basic_auth on the route in cloud-deploy apps.json).
 * Listens on SERVE_HOST (default 127.0.0.1, so Caddy is the only way in; the container sets 0.0.0.0 and
 * publishes the port on 127.0.0.1 only).
 */
const http = require('http');
const fs = require('fs');
const path = require('path');

const root = process.env.SERVE_PATH;
const port = Number(process.env.SERVE_PORT);
if (!root) throw new Error('SERVE_PATH is not set');
if (!Number.isInteger(port) || port < 1 || port > 65535) {
  throw new Error('SERVE_PORT must be an integer 1-65535');
}
const base = (process.env.SERVE_BASE || '').replace(/\/+$/, '');
const rootAbs = path.resolve(root);
const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.mjs': 'application/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.ico': 'image/x-icon',
  '.wasm': 'application/wasm',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.mp3': 'audio/mpeg',
  '.ogg': 'audio/ogg',
  '.wav': 'audio/wav',
  '.txt': 'text/plain; charset=utf-8',
};

function indexPage() {
  const games = fs.readdirSync(rootAbs, { withFileTypes: true })
    .filter((d) => d.isDirectory() && fs.existsSync(path.join(rootAbs, d.name, 'index.html')))
    .map((d) => d.name).sort();
  const ver = (g) => {
    try {
      const v = JSON.parse(fs.readFileSync(path.join(rootAbs, g, 'build-info.json'), 'utf8'));
      return ` <small>app ${String(v.appCommit).slice(0, 7)}, web ${String(v.gamesWebCommit).slice(0, 7)}, built ${v.builtAt}</small>`;
    } catch { return ''; }
  };
  const items = games.map((g) => `<li><a href="${base}/${g}/">${g}</a>${ver(g)}</li>`).join('') || '<li>No games deployed yet</li>';
  return `<!doctype html><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">` +
    `<title>Game Studio web</title><h1>Game Studio web</h1><ul>${items}</ul>`;
}

// Friendly page for unknown addresses (instead of a bare "Not Found").
function notFound(res, headers) {
  const body = `<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">` +
    `<title>Page not found</title><style>body{margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;` +
    `background:#0f1226;color:#eef;font-family:system-ui,sans-serif;text-align:center}a{display:inline-block;margin-top:18px;` +
    `padding:12px 28px;border-radius:999px;background:#ffd166;color:#222;font-weight:700;text-decoration:none}</style>` +
    `<main><h1>We could not find that page</h1><p>It may have moved, or the address is mistyped.</p>` +
    `<a href="${base}/">Games</a></main></html>`;
  res.writeHead(404, { ...headers, 'Content-Type': MIME['.html'] }).end(body);
}

function resolveFile(urlPath) {
  let rel;
  try { rel = decodeURIComponent((urlPath || '/').split('?')[0]).replace(/^\/+/, ''); } catch { return null; }
  const file = path.resolve(rootAbs, rel);
  const r = path.relative(rootAbs, file);
  if (r.startsWith('..') || path.isAbsolute(r)) return null;
  try {
    const st = fs.statSync(file);
    if (st.isFile()) return file;
    if (st.isDirectory()) {
      const idx = path.join(file, 'index.html');
      if (fs.existsSync(idx)) return idx;
    }
  } catch { /* miss */ }
  return null;
}

http.createServer((req, res) => {
  const headers = { 'Cache-Control': 'no-cache' }; // public site: no noindex (owner yes, 2026-11-22, for AdSense)
  const full = (req.url || '/').split('?')[0];
  if (base && full === base) {
    res.writeHead(301, { ...headers, Location: base + '/' }).end();
    return;
  }
  if (base && !full.startsWith(base + '/')) {
    notFound(res, headers);
    return;
  }
  const pathname = base ? full.slice(base.length) : full;
  if (pathname === '/') {
    // A landing page deployed at the root (games-web: index.html + catalog.json) wins over the plain list of games.
    const landing = path.join(rootAbs, 'index.html');
    if (fs.existsSync(landing)) {
      res.writeHead(200, { ...headers, 'Content-Type': MIME['.html'] });
      fs.createReadStream(landing).pipe(res);
      return;
    }
    res.writeHead(200, { ...headers, 'Content-Type': MIME['.html'] }).end(indexPage());
    return;
  }
  // <base>/<game> without a trailing slash: redirect so relative asset URLs (base href) resolve.
  if (/^\/[^/]+$/.test(pathname) && resolveFile(pathname)?.endsWith('index.html')) {
    res.writeHead(301, { ...headers, Location: base + pathname + '/' }).end();
    return;
  }
  let file = resolveFile(pathname);
  if (!file && /^\/[^/.]+$/.test(pathname)) file = resolveFile(pathname + '.html'); // /trail -> /trail.html
  if (!file) {
    notFound(res, headers);
    return;
  }
  // ETag from size and mtime: a repeat visit revalidates with a 304 instead of downloading the whole bundle again.
  const st = fs.statSync(file);
  const etag = `W/"${st.size.toString(16)}-${Math.floor(st.mtimeMs).toString(16)}"`;
  const h = { ...headers, ETag: etag, 'Content-Type': MIME[path.extname(file)] || 'application/octet-stream' };
  // SERVE_CACHE=1 (the public games-web container): content packs and the CanvasKit files may be reused for a while,
  // so a page can fetch them in parallel ahead of the app and the app's one-by-one reads then come from the browser cache.
  if (process.env.SERVE_CACHE === '1' && /\/(assets|canvaskit)\//.test(pathname)) {
    h['Cache-Control'] = 'public, max-age=300';
  }
  if (req.headers['if-none-match'] === etag) {
    res.writeHead(304, h).end();
    return;
  }
  res.writeHead(200, h);
  fs.createReadStream(file).pipe(res);
}).listen(port, process.env.SERVE_HOST || '127.0.0.1');
