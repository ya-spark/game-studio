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
name without `game-`, with any underscore turned into a hyphen (for example `/appgames/wingy/`, and `game-craft_highteen` is
served at `/appgames/craft-highteen/`; owner, 2026-11-15: URL names use hyphens only). Other apps share the domain under their own paths
(astro-writer is `/writer`).

## Owner setup
- **Secrets in this repo:** `CROSS_REPO_TOKEN`, `VPS_SSH_KEY`, `VPS_SSH_HOST`, `VPS_SSH_USER`, `VPS_SSH_KNOWN_HOSTS`
  (all set). The deploy key must be a normal login for the deploy user (the script runs docker), so keep it dedicated
  to this workflow. Never put these in a file.
- **Login and Caddy route:** basic auth (user `web`) and the Caddy route live in the cloud-deploy master repo
  (`apps.json`, hosts from `config.json` `domains`). Add them once with `scripts/deploy.sh proxy` there.
- **Local deploy:** `scripts/deploy.sh <ssh-alias> [game ...]` (`wingy` or `game-wingy`), or
  `DRY_RUN=1 scripts/deploy.sh wingy` to build only.

## Version
Every app gets `<base>/build-info.json` (appCommit, gamesCommit, studioCommit, builtAt) and a small bottom-left label in its page, written by `scripts/deploy.sh`. `/appgames/*/build-info.json` is served without the login (public path in the cloud-deploy Caddy route); check what is deployed with `curl https://activemindcraft.com/appgames/<name>/build-info.json` (names follow the repos: craft-preteen, craft-lowteen, craft-highteen, mind-1, mind-9, wingy, block-puzzle, block-fall).

## What the web copy does and does not do
Billing, Play Games and notifications are not available in a browser and are stubbed (purchases disabled with a clear
message; ads are off until AdSense is switched on, see below), so the web copy covers screens, learning content, progress and the games, not store
features. Test ad IDs only; no real AdMob IDs ever. Access control is in Caddy, never in the apps.
`platforms.web.enabled` stays false in `app.config.yaml` unless an issue says otherwise.

## AdSense on the web copies (X2b, issue 165): in the code, switched off
`AdSenseAdService` (web only, behind `AdService`) shows display units only at the menu, before a game and after a
game, in a fixed-height slot outside the game. No rewarded ads, no interstitials, nothing in play. Every build from the
repo is ad-free until the owner adds a publisher id, because `scripts/web_shell.py` writes the AdSense script tag only
when `adsense.enabled` is `true` AND `adsense.publisher_id` is a real `ca-pub-` + 16 digits value. The owner's steps
(never in a file that goes to git except the one config edit below):
1. Create the AdSense account, add the sites, set up Google's certified consent message in the account (the apps have
   no consent logic of their own; Settings has a web-only "Ad privacy choices" row that reopens that message).
2. In each game's `app.config.yaml` `adsense:` section set `enabled: true`, `publisher_id: ca-pub-...` and the three
   `slots` (`menu`, `pre_game`, `post_game`). `ad_safety_check.sh` fails CI on a real `ca-pub-` id anywhere in the repo,
   so a real id has to be injected at deploy time (a deploy-only edit of the config or a deploy secret) and is a
   follow-up decision, not part of X2b. `test_mode: true` (`data-adtest="on"`) must stay on in every repo build.
3. `age_treatment` (Google's Tag for Age Treatment, `data-tag-for-age-treatment` on the ad element: 1 child, 2 teen):
   Scout and Ranger `child`, Champion `teen` (both also request non-personalised ads only), Mind Ember and Mind Presto
   `none`. `profile_check.sh` fails CI when AdSense is enabled in a child or teen app without the matching value.
4. `ads.txt`, DNS, Caddy and hosting are the owner's and are not part of this change. Source of the attribute values:
   AdSense Help, "Tag for age treatment" (support.google.com/adsense/answer/9009582).

## Old design (removed)
The per-game `web-vps.yml` workflows (rsync into `/srv/web`, host `web.activemindcraft.com`) are gone; see git history
of `docs/WEB-VPS.md` if you need the old Caddy block.
