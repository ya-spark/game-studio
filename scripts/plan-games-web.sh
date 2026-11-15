#!/usr/bin/env bash
# Which live web games are behind? Run by deploy-games-web after the submodules are on their `main`.
# For each slug in games-web/games.yaml that already has a build on the site, compare the commits in its
# https://<domain>/games/<slug>/build-info.json (app commit, games-web commit) with the checked-out `main` of its app
# repo (apps/<repo name>) and of games-web. Prints the slugs to rebuild, space separated (nothing = up to date).
# A slug with no build on the site is NOT picked up (a new game is deployed by hand once first). Safe to run any
# number of times: it only looks at what is live, so a deploy that was replaced in the queue is caught by the next one.
# Env: ROOT (game-studio checkout, default: this repo), SITE (default https://activemindcraft.com/games).
set -euo pipefail
ROOT="${ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SITE="${SITE:-https://activemindcraft.com/games}"
YAML="$ROOT/games-web/games.yaml"
[ -f "$YAML" ] || { echo "no games-web/games.yaml" >&2; exit 1; }
WEB_TIP="$(git -C "$ROOT/games-web" rev-parse HEAD)"
out=()
while read -r slug repo; do
  info="$(curl -fsS -m 20 "$SITE/$slug/build-info.json" 2>/dev/null || true)"
  [[ "$info" == '{"slug"'* ]] || continue   # not live yet: leave it to a manual first deploy
  live_app="$(sed -n 's/.*"appCommit":"\([0-9a-f]*\)".*/\1/p' <<<"$info")"
  live_web="$(sed -n 's/.*"gamesWebCommit":"\([0-9a-f]*\)".*/\1/p' <<<"$info")"
  app_tip="$(git -C "$ROOT/apps/${repo#*/}" rev-parse HEAD)"
  if [ "$live_app" != "$app_tip" ] || [ "$live_web" != "$WEB_TIP" ]; then out+=("$slug"); fi
done < <(awk '$1=="-" && $2=="slug:" {s=$3} $1=="app:" {print s, $2}' "$YAML")
echo "${out[*]:-}"
