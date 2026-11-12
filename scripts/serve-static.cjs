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
  const items = games.map((g) => `<li><a href="${base}/${g}/">${g}</a></li>`).join('') || '<li>No games deployed yet</li>';
  return `<!doctype html><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">` +
    `<title>Game Studio web</title><h1>Game Studio web</h1><ul>${items}</ul>`;
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
  const headers = { 'Cache-Control': 'no-cache', 'X-Robots-Tag': 'noindex, nofollow' };
  const full = (req.url || '/').split('?')[0];
  if (base && full === base) {
    res.writeHead(301, { ...headers, Location: base + '/' }).end();
    return;
  }
  if (base && !full.startsWith(base + '/')) {
    res.writeHead(404, headers).end('Not Found');
    return;
  }
  const pathname = base ? full.slice(base.length) : full;
  if (pathname === '/') {
    res.writeHead(200, { ...headers, 'Content-Type': MIME['.html'] }).end(indexPage());
    return;
  }
  // <base>/<game> without a trailing slash: redirect so relative asset URLs (base href) resolve.
  if (/^\/[^/]+$/.test(pathname) && resolveFile(pathname)?.endsWith('index.html')) {
    res.writeHead(301, { ...headers, Location: base + pathname + '/' }).end();
    return;
  }
  const file = resolveFile(pathname);
  if (!file) {
    res.writeHead(404, headers).end('Not Found');
    return;
  }
  res.writeHead(200, { ...headers, 'Content-Type': MIME[path.extname(file)] || 'application/octet-stream' });
  fs.createReadStream(file).pipe(res);
}).listen(port, process.env.SERVE_HOST || '127.0.0.1');
