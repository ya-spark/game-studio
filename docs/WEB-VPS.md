# Hostinger VPS web hosting (owner decision 2026-11-12)

Goal: a web copy of each new app on the owner's Hostinger VPS, behind Caddy.
The product stays Android-only; the web copy is for testing on the Hostinger VPS. Auth is in Caddy, not in the apps. Builds are uploaded by a
GitHub workflow over SSH, the same pattern as `game-content` publish.

## Layout
One web host on the Hostinger VPS, one folder per app (Flutter web uses hash URLs, so no rewrite rules are needed):

| App | Address | Folder on the VPS |
|---|---|---|
| Craft Scout | `https://web.activemindcraft.com/scout/` | `/srv/web/scout` |
| Craft Ranger | `https://web.activemindcraft.com/ranger/` | `/srv/web/ranger` |
| Craft Champion | `https://web.activemindcraft.com/champion/` | `/srv/web/champion` |
| Mind Ember | `https://web.activemindcraft.com/ember/` | `/srv/web/ember` |
| Mind Presto | `https://web.activemindcraft.com/presto/` | `/srv/web/presto` |

Host name and folder are suggestions; change them in the workflow variables if you prefer others.

## Owner steps (Claude does not touch the VPS, DNS, Cloudflare or secrets)
1. **DNS.** Everything under `activemindcraft.com` points at the Hostinger VPS (owner, 2026-11-12). Add an A record for the VPS
   address on `web` (or one wildcard `*` record), next to the existing `content` record. One Caddy covers every host.
   If the free Cloudflare proxy is in front later, leave `web` DNS-only or set a cache bypass for it; the web copy must not be cached.
2. **Caddy.** Add a site block like this and reload Caddy. Create the password hash with `caddy hash-password`.
   ```
   web.activemindcraft.com {
       basic_auth {
           web <bcrypt-hash>
       }
       root * /srv/web
       encode gzip
       header {
           Cache-Control "no-cache"
           X-Robots-Tag "noindex, nofollow"
       }
       file_server
   }
   ```
   The apps fetch content from `https://content.activemindcraft.com/v1/`. Browsers need CORS for that, so in the
   content site block add (free content only; keep the paid folder and `/auth` as they are):
   ```
   header Access-Control-Allow-Origin "https://web.activemindcraft.com"
   ```
3. **Deploy key.** Create a separate deploy-only SSH key pair (not the content key if you prefer separation, or reuse the
   same user). In that user's `~/.ssh/authorized_keys`:
   `restrict,command="rrsync -wo /srv/web" ssh-ed25519 AAAA... vps-web-deploy`
4. **Secrets.** In each app repo (Settings, Secrets and variables, Actions) add:

   | Secret | What |
   |---|---|
   | `VPS_SSH_KEY` | private half of the deploy key |
   | `VPS_SSH_HOST` | server host name |
   | `VPS_SSH_USER` | SSH user |
   | `VPS_SSH_KNOWN_HOSTS` | output of `ssh-keyscan -t ed25519 <host>` |

   (If you prefer one set of secrets for all five apps, put them at organisation level for `ya-spark`.)
5. **Run it.** Actions, `web-vps`, Run workflow. The workflow builds `flutter build web --release --base-href /<app>/`
   and uploads to `<app>/` under the restricted folder. Never put these secrets in the repos.

## What the web copy does and does not do
Ads, billing, Play Games and notifications are not available in a browser and are stubbed (no ads shown, purchases
disabled with a clear message), so testing on the Hostinger VPS covers screens, learning content, progress and the games, not store features.
Test ad IDs only; no real AdMob IDs ever.
