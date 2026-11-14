# Deploy to the VPS as web (owner decisions 2026-11-12 and 2026-11-13)

The web copy of every game is a UAT copy on the owner's Hostinger VPS. The product stays Android-only.
Claude does not touch the VPS directly, DNS, Cloudflare, Caddy or secrets. **Owner decision 2026-11-14:** Claude MAY start real deploys of
the web UAT copies by running this workflow (`deploy-to-vps-as-web`, Run workflow) without asking: after a run reports a game done, its checks
pass and the pin matches the game's `main`, Claude deploys the affected games (the `games` input), one deploy at a time, batched per
monitoring round. The workflow uses the repo secrets itself; Claude never reads or changes them. If a deploy fails because of the VPS, SSH
or secrets, Claude stops deploying and tells the owner; if the build of one game fails, Claude sends it back to that game's issue
(`@claude Please continue`). Not covered: DNS, Caddy, Cloudflare, login changes, store releases, tags, version bumps.

## How it works
One workflow in this repo, `.github/workflows/deploy-to-vps-as-web.yml` (Actions, `deploy-to-vps-as-web`, Run workflow),
builds each game's `main` and runs `scripts/deploy.sh`. Optional inputs: `games` (space separated, empty = all) and `dry_run`.

1. Each game's `main` is built with `flutter build web`.
2. The built games are uploaded over SSH. No Docker is needed on the machine that deploys.
3. The VPS builds one Docker image with all games and restarts the container `game-studio` (port 7000, `config.json`)
   on the new VPS (`hostinger-vps-2`).
4. Deploying only some games uploads just those: the VPS copies the deployed ones out of the running container first,
   so the other games stay.

Games are served at `https://activemindcraft.com/appgames/<name>/` and the same under `www.` The name is the folder
name without `game-` (for example `/appgames/wingy/`). Other apps share the domain under their own paths
(astro-writer is `/writer`).

## Owner setup
- **Secrets in this repo:** `CROSS_REPO_TOKEN`, `VPS_SSH_KEY`, `VPS_SSH_HOST`, `VPS_SSH_USER`, `VPS_SSH_KNOWN_HOSTS`
  (all set). The deploy key must be a normal login for the deploy user (the script runs docker), so keep it dedicated
  to this workflow. Never put these in a file.
- **Login and Caddy route:** basic auth (user `web`) and the Caddy route live in the cloud-deploy master repo
  (`apps.json`, hosts from `config.json` `domains`). Add them once with `scripts/deploy.sh proxy` there.
- **Local deploy:** `scripts/deploy.sh <ssh-alias> [game ...]` (`wingy` or `game-wingy`), or
  `DRY_RUN=1 scripts/deploy.sh wingy` to build only.

## What the web copy does and does not do
Ads, billing, Play Games and notifications are not available in a browser and are stubbed (no ads shown, purchases
disabled with a clear message), so the web copy covers screens, learning content, progress and the games, not store
features. Test ad IDs only; no real AdMob IDs ever. Access control is in Caddy, never in the apps.
`platforms.web.enabled` stays false in `app.config.yaml` unless an issue says otherwise.

## Old design (removed)
The per-game `web-vps.yml` workflows (rsync into `/srv/web`, host `web.activemindcraft.com`) are gone; see git history
of `docs/WEB-VPS.md` if you need the old Caddy block.
