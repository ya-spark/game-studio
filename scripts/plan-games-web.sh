#!/usr/bin/env bash
# Which live web games are out of date? For each slug in games-web/games.yaml that already has a build on the site,
# compare the commits in its https://<domain>/games/<slug>/build-info.json (app commit, games-web commit) with the
# current `main` of the app repo and of games-web. Prints the slugs to rebuild, space separated (nothing = up to date).
# A slug with no build on the site is NOT picked up (a new game is deployed by hand first).
# Env: GAMES_YAML (path to games.yaml), SITE (default https://activemindcraft.com/games), GH_TOKEN (read access to the
# repos), REMOTE_BASE (default https://x-access-token:$GH_TOKEN@github.com/; a test can point it at a folder).
set -euo pipefail
GAMES_YAML="${GAMES_YAML:?path to games.yaml}"
SITE="${SITE:-https://activemindcraft.com/games}"
REMOTE_BASE="${REMOTE_BASE:-https://x-access-token:${GH_TOKEN:-}@github.com/}"
tip() { git ls-remote "$REMOTE_BASE$1" refs/heads/main | awk '{print $1}'; }
WEB_TIP="$(tip ya-spark/games-web)"
[ -n "$WEB_TIP" ] || { echo "cannot read games-web main" >&2; exit 1; }
out=()
while read -r slug repo; do
  info="$(curl -fsS -m 20 "$SITE/$slug/build-info.json" 2>/dev/null || true)"
  [[ "$info" == '{"slug"'* ]] || continue   # not live (or no build-info yet): leave it
  live_app="$(sed -n 's/.*"appCommit":"\([0-9a-f]*\)".*/\1/p' <<<"$info")"
  live_web="$(sed -n 's/.*"gamesWebCommit":"\([0-9a-f]*\)".*/\1/p' <<<"$info")"
  app_tip="$(tip "$repo")"
  [ -n "$app_tip" ] || { echo "cannot read $repo main" >&2; exit 1; }
  if [ "$live_app" != "$app_tip" ] || [ "$live_web" != "$WEB_TIP" ]; then out+=("$slug"); fi
done < <(awk '$1=="-" && $2=="slug:" {s=$3} $1=="app:" {print s, $2}' "$GAMES_YAML")
echo "${out[*]:-}"
