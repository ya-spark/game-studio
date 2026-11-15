#!/usr/bin/env bash
# Build the public web versions of the games (games-web repo) and run them in their own container.
# Usage: scripts/deploy-games-web.sh [<ssh-alias>] [slug ...]     (slugs are in games-web/games.yaml, e.g. ember scout)
# Each slug is built by games-web/scripts/build_game.sh with base href <basePath>/<slug>/ and served at
# https://<domain>/games/<slug>/. The container is games-web on 127.0.0.1:<gamesWeb.port> (config.json), image
# games-web, deploy dir <gamesWeb.vpsDeployPath>. It is separate from the game-studio UAT container: this script
# never touches /appgames or the game-studio container. With no slugs, every game in games.yaml is built; with
# some, only those are replaced and the rest are copied out of the running container. DRY_RUN=1 builds only.
# Caddy (cloud-deploy repo, owner) routes /games/* to the port; the studio never changes it.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
GW_BASE="$(read_config_string gamesWeb.basePath)"
GW_PATH="$(read_config_string gamesWeb.vpsDeployPath)"
GW_PORT="$(read_config_port gamesWeb.port)"

FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
[ -x "$FLUTTER_HOME/bin/flutter" ] && export PATH="$FLUTTER_HOME/bin:$PATH"
command -v flutter >/dev/null 2>&1 || { echo "flutter not found"; exit 1; }
GW="$ROOT_DIR/games-web"
[ -f "$GW/scripts/build_game.sh" ] || { echo "games-web submodule is missing"; exit 1; }

slugs=(); alias_arg=""
all_slugs="$(awk '$1=="-" && $2=="slug:" {print $3}' "$GW/games.yaml")"
for arg in "$@"; do
  if grep -qx "$arg" <<<"$all_slugs"; then slugs+=("$arg")
  elif [ -z "$alias_arg" ]; then alias_arg="$arg"
  else echo "Unknown slug: $arg (available: $(echo $all_slugs))"; exit 1; fi
done
PARTIAL=0
if [ "${#slugs[@]}" -gt 0 ]; then PARTIAL=1; else read -ra slugs <<<"$(echo $all_slugs)"; fi

VPS_HOST="${alias_arg:-${VPS_HOST:-}}"
if [ -z "$VPS_HOST" ] && [ -z "${DRY_RUN:-}" ]; then echo "No target (set VPS_HOST)"; exit 1; fi
SSH=ssh; SCP=scp
SSH_OPTS=(-o BatchMode=yes)
if [ -n "${VPS_SSH_KEY_PATH:-}" ]; then
  [ -f "$VPS_SSH_KEY_PATH" ] || { echo "VPS_SSH_KEY_PATH is not a file"; exit 1; }
  SSH_OPTS=(-i "$VPS_SSH_KEY_PATH" -o BatchMode=yes)
fi
if [ -n "${VPS_USER:-}" ]; then SSH_TARGET="${VPS_USER}@${VPS_HOST}"; else SSH_TARGET="$VPS_HOST"; fi

IMAGE="games-web"
TAG="$(date +%Y%m%d%H%M%S)"
STAGE_DIR="$(mktemp -d)"
cleanup() { rm -rf "$STAGE_DIR" "$STAGE_DIR.tgz"; }
trap cleanup EXIT
mkdir -p "$STAGE_DIR/web"

flutter config --enable-web >/dev/null
built=(); failed=()
for slug in "${slugs[@]}"; do
  echo "==> Building $slug (base href $GW_BASE/$slug/)"
  if APPS_DIR="$APPS_DIR" BASE_HREF="$GW_BASE/$slug/" bash "$GW/scripts/build_game.sh" "$slug" "" "$STAGE_DIR/web/$slug"; then
    built+=("$slug")
  else
    echo "    build failed: $slug"; failed+=("$slug")
  fi
done
[ "${#built[@]}" -gt 0 ] || { echo "Nothing built."; exit 1; }

# The landing page: index.html, catalog.json (made from the app checkouts, live games only) and the card art.
# (Skipped while games-web main has no site/ yet.)
if [ -f "$GW/scripts/make_catalog.py" ] && [ -f "$GW/site/index.html" ]; then
  echo "==> Making the catalog page"
  python3 "$GW/scripts/make_catalog.py" --apps "$APPS_DIR" --games "$GW/games.yaml" --out "$STAGE_DIR/web/catalog.json"
  cp "$GW/site/index.html" "$STAGE_DIR/web/index.html"
  mkdir -p "$STAGE_DIR/web/_site" && cp -R "$GW/site/art" "$STAGE_DIR/web/_site/art"
fi

if [ -n "${DRY_RUN:-}" ]; then
  echo "DRY_RUN: built ${built[*]}; nothing uploaded."
  [ "${#failed[@]}" -eq 0 ] || { echo "Build failed or skipped: ${failed[*]}"; exit 1; }
  exit 0
fi

cp "$SCRIPT_DIR/serve-static.cjs" "$STAGE_DIR/"
cp "$ROOT_DIR/deploy/Dockerfile" "$STAGE_DIR/Dockerfile"
cp "$ROOT_DIR/deploy/compose.games-web.yml" "$STAGE_DIR/compose.yml"
chmod -R a+rX "$STAGE_DIR"
tar -C "$STAGE_DIR" -czf "$STAGE_DIR.tgz" .

echo "Checking SSH access and Docker on $SSH_TARGET..."
"$SSH" "${SSH_OPTS[@]}" -o ConnectTimeout=15 "$SSH_TARGET" "docker compose version >/dev/null && docker info >/dev/null"
echo "Uploading ${built[*]}..."
"$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" "mkdir -p '$GW_PATH'"
"$SCP" "${SSH_OPTS[@]}" "$STAGE_DIR.tgz" "$SSH_TARGET:/tmp/games-web-deploy.tgz"

echo "Building the image and starting the container on the VPS..."
"$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" bash -s -- "$GW_PATH" "$IMAGE" "$TAG" "$GW_PORT" "$GW_BASE" "$PARTIAL" "$(IFS=,; echo "${built[*]}")" <<'REMOTE'
set -euo pipefail
DEPLOY="$1"; IMAGE="$2"; TAG="$3"; PORT="$4"; BASE="$5"; PARTIAL="$6"; BUILT="${7//,/ }"   # ssh joins its arguments, so the list travels comma-separated
ARCHIVE=/tmp/games-web-deploy.tgz
cd "$DEPLOY"
rm -rf "${DEPLOY:?}/.build"; mkdir -p "$DEPLOY/.build"
tar -xzf "$ARCHIVE" -C "$DEPLOY/.build"; rm -f "$ARCHIVE"
cp "$DEPLOY/.build/compose.yml" "$DEPLOY/compose.yml"
if [ "$PARTIAL" = 1 ]; then
  mkdir -p "$DEPLOY/.build/seed"
  if [ -n "$(docker ps -q -f name="^$IMAGE\$")" ]; then
    docker cp "$IMAGE:/app/web/." "$DEPLOY/.build/seed/"
  fi
  for g in $BUILT; do
    rm -rf "${DEPLOY:?}/.build/seed/$g"
    mv "$DEPLOY/.build/web/$g" "$DEPLOY/.build/seed/$g"
  done
  # The landing page files are always replaced (they are not games).
  if [ -f "$DEPLOY/.build/web/index.html" ]; then
    cp -f "$DEPLOY/.build/web/index.html" "$DEPLOY/.build/web/catalog.json" "$DEPLOY/.build/seed/"
    rm -rf "${DEPLOY:?}/.build/seed/_site"; mv "$DEPLOY/.build/web/_site" "$DEPLOY/.build/seed/_site"
  fi
  rm -rf "${DEPLOY:?}/.build/web"; mv "$DEPLOY/.build/seed" "$DEPLOY/.build/web"
fi
chmod -R a+rX "$DEPLOY/.build"
echo "Games in the image: $(ls "$DEPLOY/.build/web" | tr '\n' ' ')"
docker build -f "$DEPLOY/.build/Dockerfile" -t "$IMAGE:$TAG" -t "$IMAGE:latest" \
  --build-arg "SERVE_PORT=$PORT" --build-arg "SERVE_BASE=$BASE" --build-arg "SERVE_CACHE=1" "$DEPLOY/.build"
PREV="$(docker inspect -f '{{.Config.Image}}' "$IMAGE" 2>/dev/null || true)"
PREV_TAG="${PREV#*:}"
echo "Starting the container..."
TAG="$TAG" PORT="$PORT" docker compose up -d --remove-orphans
ok=0
for i in $(seq 1 30); do
  if curl -fsS -o /dev/null "http://127.0.0.1:$PORT$BASE/"; then ok=1; break; fi
  sleep 1
done
if [ "$ok" != 1 ]; then
  echo "Health check failed. Last logs:"; docker compose logs --tail 40 "$IMAGE" || true
  if [ -n "$PREV" ] && [ "$PREV_TAG" != "$TAG" ] && docker image inspect "$PREV" >/dev/null 2>&1; then
    echo "Starting the previous image $PREV again..."; TAG="$PREV_TAG" PORT="$PORT" docker compose up -d
  fi
  exit 1
fi
echo "Healthy."
rm -rf "${DEPLOY:?}/.build"
docker images "$IMAGE" --format '{{.Repository}}:{{.Tag}}' | grep -v -e ":$TAG\$" -e ':latest$' | xargs -r docker rmi || true
docker image prune -f >/dev/null
REMOTE
echo "Deployed: ${built[*]}"
[ "${#failed[@]}" -eq 0 ] || echo "NOT deployed: ${failed[*]}"
echo "Served at https://${DOMAIN}${GW_BASE}/<slug>/ once Caddy routes /games/* to 127.0.0.1:${GW_PORT}."
[ "${#failed[@]}" -eq 0 ]
