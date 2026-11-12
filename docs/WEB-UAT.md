# Web UAT hosting (owner decision 2026-11-12)

Goal: a web copy of each new app for user acceptance testing on the owner's Hostinger VPS, behind Caddy.
The product stays Android-only; web is a UAT copy. Auth is in Caddy, not in the apps. Builds are uploaded by a
GitHub workflow over SSH, the same pattern as `game-content` publish.

## Layout
One UAT host, one folder per app (Flutter web uses hash URLs, so no rewrite rules are needed):

| App | Address | Folder on the VPS |
|---|---|---|
| Craft Scout | `https://uat.activemindcraft.com/scout/` | `/srv/uat/scout` |
| Craft Ranger | `https://uat.activemindcraft.com/ranger/` | `/srv/uat/ranger` |
| Craft Champion | `https://uat.activemindcraft.com/champion/` | `/srv/uat/champion` |
| Mind Ember | `https://uat.activemindcraft.com/ember/` | `/srv/uat/ember` |
| Mind Presto | `https://uat.activemindcraft.com/presto/` | `/srv/uat/presto` |

Host name and folder are suggestions; change them in the workflow variables if you prefer others.

## Owner steps (Claude does not touch the VPS, DNS, Cloudflare or secrets)
1. **DNS.** Add `uat.activemindcraft.com` pointing at the VPS (in Cloudflare, leave it DNS-only or set a cache bypass; UAT must not be cached).
2. **Caddy.** Add a site block like this and reload Caddy. Create the password hash with `caddy hash-password`.
   ```
   uat.activemindcraft.com {
       basic_auth {
           uat <bcrypt-hash>
       }
       root * /srv/uat
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
   header Access-Control-Allow-Origin "https://uat.activemindcraft.com"
   ```
3. **Deploy key.** Create a separate deploy-only SSH key pair (not the content key if you prefer separation, or reuse the
   same user). In that user's `~/.ssh/authorized_keys`:
   `restrict,command="rrsync -wo /srv/uat" ssh-ed25519 AAAA... web-uat-deploy`
4. **Secrets.** In each app repo (Settings, Secrets and variables, Actions) add:

   | Secret | What |
   |---|---|
   | `UAT_SSH_KEY` | private half of the deploy key |
   | `UAT_SSH_HOST` | server host name |
   | `UAT_SSH_USER` | SSH user |
   | `UAT_SSH_KNOWN_HOSTS` | output of `ssh-keyscan -t ed25519 <host>` |

   (If you prefer one set of secrets for all five apps, put them at organisation level for `ya-spark`.)
5. **Run it.** Actions, `web-uat`, Run workflow. The workflow builds `flutter build web --release --base-href /<app>/`
   and uploads to `<app>/` under the restricted folder. Never put these secrets in the repos.

## What the web copy does and does not do
Ads, billing, Play Games and notifications are not available in a browser and are stubbed (no ads shown, purchases
disabled with a clear message), so UAT covers screens, learning content, progress and the games, not store features.
Test ad IDs only; no real AdMob IDs ever.
