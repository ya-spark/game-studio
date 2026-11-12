#!/usr/bin/env bash
# Build the games for web, upload the build files only, build the Docker image on the VPS and run it with Compose.
# Usage: scripts/deploy.sh [<ssh-alias>] [game-name ...]
#   scripts/deploy.sh hostinger-vps-2                    every apps/game-* with a pubspec.yaml
#   scripts/deploy.sh hostinger-vps-2 wingy              just one game (game-wingy also works; several allowed)
#   VPS_HOST=hostinger-vps-2 scripts/deploy.sh wingy   alias from VPS_HOST (environment or .env)
# An argument that is a folder under apps/ is a game; any other first argument is the ssh alias
# (from ~/.ssh/config). The image holds ALL games. Deploying only some games uploads just those games; the VPS
# copies the games deployed now out of the running container (or the old web/ folder) and replaces only the chosen
# ones, so the others are unchanged. No Docker is needed on this machine; the VPS needs Docker + Compose (user in
# the docker group). No .env is needed for this app.
# The container is named game-studio and publishes 127.0.0.1:<config.json ports.web> only. The login (basic
# auth) and the shared Caddy proxy live in the master cloud-deploy repo (apps.json + scripts/deploy.sh proxy).
# Each game is served at https://<domain><basePath>/<name>/ where <name> is the folder minus "game-"
# (game-wingy -> /appgames/wingy/), built with flutter build web --base-href <basePath>/<name>/.
# Builds use the submodule commits checked out here (the pins), not latest main. A game that fails to
# build is reported and skipped; its previous copy stays in the image. DRY_RUN=1 builds the games only
# (no SSH, no upload). Stops local run-web.sh processes (scripts/stop.sh) before building.
# Images are tagged with a timestamp and "latest"; old images are deleted after a healthy deploy; if the new
# container is not healthy the previous image is started again.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

ENV_FILE="$ROOT_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
[ -x "$FLUTTER_HOME/bin/flutter" ] && export PATH="$FLUTTER_HOME/bin:$PATH"
command -v flutter >/dev/null 2>&1 || { echo "flutter not found: run scripts/setup.sh first"; exit 1; }

# Arguments: game names (folders under apps/) and, at most, one ssh alias.
games=(); alias_arg=""
for arg in "$@"; do
  if [ -f "$APPS_DIR/$arg/pubspec.yaml" ]; then
    games+=("$arg")
  elif [ -f "$APPS_DIR/game-${arg#game-}/pubspec.yaml" ]; then
    games+=("game-${arg#game-}")
  elif [ -z "$alias_arg" ] && [ ! -e "$APPS_DIR/$arg" ] && [[ "$arg" != game-* ]]; then
    alias_arg="$arg"
  else
    echo "Unknown game: $arg (available: $(cd "$APPS_DIR" && ls -d game-*/ 2>/dev/null | tr -d / | tr '\n' ' '))"
    exit 1
  fi
done
PARTIAL=0
[ "${#games[@]}" -gt 0 ] && PARTIAL=1

# Target: the alias argument, else VPS_HOST (environment or .env). The alias from ~/.ssh/config supplies user/key/port.
VPS_HOST="${alias_arg:-${VPS_HOST:-}}"
if [ -z "$VPS_HOST" ] && [ -z "${DRY_RUN:-}" ]; then
  echo "No target. Usage: scripts/deploy.sh [<ssh-alias>] [game ...]   (or set VPS_HOST)"
  exit 1
fi

# WSL has no ssh config; use the Windows ssh/scp shims when the Linux ones have no alias.
SSH=ssh; SCP=scp
if [ "$(ssh -G "$VPS_HOST" 2>/dev/null | awk '/^hostname /{print $2}')" = "$VPS_HOST" ]; then
  command -v ssh.exe >/dev/null 2>&1 && { SSH=ssh.exe; SCP=scp.exe; }
fi
SSH_OPTS=(-o BatchMode=yes)
if [ -n "${VPS_SSH_KEY_PATH:-}" ]; then
  [ -f "$VPS_SSH_KEY_PATH" ] || { echo "VPS_SSH_KEY_PATH is not a file: $VPS_SSH_KEY_PATH"; exit 1; }
  SSH_OPTS=(-i "$VPS_SSH_KEY_PATH" -o BatchMode=yes)
fi
if [ -n "${VPS_USER:-}" ]; then SSH_TARGET="${VPS_USER}@${VPS_HOST}"; else SSH_TARGET="$VPS_HOST"; fi

if [ "${#games[@]}" -eq 0 ]; then
  for d in "$APPS_DIR"/game-*/; do
    [ -f "$d/pubspec.yaml" ] && games+=("$(basename "$d")")
  done
fi
[ "${#games[@]}" -gt 0 ] || { echo "No games found in $APPS_DIR"; exit 1; }

IMAGE="game-studio"
TAG="$(date +%Y%m%d%H%M%S)"
STAGE_DIR=""
cleanup_local() {
  if [ -n "$STAGE_DIR" ] && [ -d "$STAGE_DIR" ]; then rm -rf "$STAGE_DIR"; fi
}
trap cleanup_local EXIT

if [ -z "${DRY_RUN:-}" ]; then
  echo "Checking SSH access and Docker on $SSH_TARGET..."
  if ! "$SSH" "${SSH_OPTS[@]}" -o ConnectTimeout=15 "$SSH_TARGET" "docker compose version >/dev/null && docker info >/dev/null"; then
    echo "SSH or Docker failed for $SSH_TARGET."
    echo "  - Pass an alias from ~/.ssh/config that sets User and IdentityFile: scripts/deploy.sh <alias>"
    echo "  - The VPS user must be in the docker group (sudo usermod -aG docker <user>, then log in again)."
    exit 1
  fi
fi

echo "Stopping local run-web processes..."
"$SCRIPT_DIR/stop.sh"

STAGE_DIR="$(mktemp -d)"
mkdir -p "$STAGE_DIR/web"

flutter config --enable-web >/dev/null
built=(); failed=()
for game in "${games[@]}"; do
  dir="$APPS_DIR/$game"
  [ -f "$dir/pubspec.yaml" ] || { echo "Skipping $game: no pubspec.yaml"; failed+=("$game"); continue; }
  slug="${game#game-}"
  echo "==> Building $game (base href $BASE_PATH/$slug/)"
  if (
    cd "$dir"
    if [ ! -d web ]; then
      flutter create --platforms=web --project-name "$(sed -n 's/^name: *//p' pubspec.yaml | head -1)" . >/dev/null
    fi
    flutter pub get >/dev/null
    flutter build web --release --no-web-resources-cdn --base-href "$BASE_PATH/$slug/"
  ); then
    rm -rf "${STAGE_DIR:?}/web/$slug"   # replace, don't nest inside, a game copied from the VPS
    cp -R "$dir/build/web" "$STAGE_DIR/web/$slug"
    built+=("$slug")
  else
    echo "    build failed: $game"
    failed+=("$game")
  fi
done
[ "${#built[@]}" -gt 0 ] || { echo "Nothing built."; exit 1; }

if [ -n "${DRY_RUN:-}" ]; then
  echo "DRY_RUN: built ${built[*]}; nothing uploaded."
  [ "${#failed[@]}" -eq 0 ] || { echo "Build failed or skipped: ${failed[*]}"; exit 1; }
  exit 0
fi

cp "$SCRIPT_DIR/serve-static.cjs" "$STAGE_DIR/"
cp "$ROOT_DIR/Dockerfile" "$ROOT_DIR/compose.yml" "$STAGE_DIR/"
# The workflow runs with umask 077 and mktemp makes a 0700 dir: make everything readable for the image's non-root user.
chmod -R a+rX "$STAGE_DIR"
LOCAL_ARCHIVE="$STAGE_DIR.tgz"
tar -C "$STAGE_DIR" -czf "$LOCAL_ARCHIVE" .
trap 'cleanup_local; rm -f "$LOCAL_ARCHIVE"' EXIT

echo "Uploading ${built[*]} to $SSH_TARGET..."
"$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" "mkdir -p '$VPS_DEPLOY_PATH'"
"$SCP" "${SSH_OPTS[@]}" "$LOCAL_ARCHIVE" "$SSH_TARGET:/tmp/game-studio-deploy.tgz"

echo "Building the image and starting the container on the VPS..."
"$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" bash -s -- "$VPS_DEPLOY_PATH" "$IMAGE" "$TAG" "$WEB_PORT" "$BASE_PATH" "$PARTIAL" "${built[*]}" <<'REMOTE'
set -euo pipefail
DEPLOY="$1"; IMAGE="$2"; TAG="$3"; PORT="$4"; BASE="$5"; PARTIAL="$6"; BUILT="$7"
ARCHIVE=/tmp/game-studio-deploy.tgz

cd "$DEPLOY"
rm -rf "${DEPLOY:?}/.build"
mkdir -p "$DEPLOY/.build"
tar -xzf "$ARCHIVE" -C "$DEPLOY/.build"
rm -f "$ARCHIVE"
cp "$DEPLOY/.build/compose.yml" "$DEPLOY/compose.yml"

if [ "$PARTIAL" = 1 ]; then
  echo "Keeping the games deployed now (only $BUILT is replaced)..."
  mkdir -p "$DEPLOY/.build/seed"
  if [ -n "$(docker ps -q -f name="^$IMAGE\$")" ]; then
    docker cp "$IMAGE:/app/web/." "$DEPLOY/.build/seed/"
  elif [ -d "$DEPLOY/web" ]; then
    cp -a "$DEPLOY/web/." "$DEPLOY/.build/seed/"
  else
    echo "No deployed games to keep (no running container and no web/ folder). Deploy all games first (no game names)."
    exit 1
  fi
  for g in $BUILT; do
    rm -rf "${DEPLOY:?}/.build/seed/$g"
    mv "$DEPLOY/.build/web/$g" "$DEPLOY/.build/seed/$g"
  done
  rm -rf "${DEPLOY:?}/.build/web"
  mv "$DEPLOY/.build/seed" "$DEPLOY/.build/web"
fi
chmod -R a+rX "$DEPLOY/.build"
echo "Games in the image: $(ls "$DEPLOY/.build/web" | tr '\n' ' ')"

echo "docker build $IMAGE:$TAG..."
docker build -f "$DEPLOY/.build/Dockerfile" -t "$IMAGE:$TAG" -t "$IMAGE:latest" \
  --build-arg "SERVE_PORT=$PORT" --build-arg "SERVE_BASE=$BASE" "$DEPLOY/.build"

# Remember what is running now, so a failed deploy can go back to it.
PREV="$(docker inspect -f '{{.Config.Image}}' "$IMAGE" 2>/dev/null || true)"
PREV_TAG="${PREV#*:}"

# One-time hand-off: an old PM2 process (named game-studio-web before this was a container) would hold the port.
. "$HOME/.nvm/nvm.sh" 2>/dev/null || true
if command -v pm2 >/dev/null 2>&1 && pm2 describe game-studio-web >/dev/null 2>&1; then
  pm2 delete game-studio-web && pm2 save
fi

echo "Starting the container..."
TAG="$TAG" PORT="$PORT" docker compose up -d --remove-orphans
ok=0
for i in $(seq 1 30); do
  if curl -fsS -o /dev/null "http://127.0.0.1:$PORT$BASE/"; then ok=1; break; fi
  sleep 1
done
if [ "$ok" != 1 ]; then
  echo "Health check failed. Last logs:"
  docker compose logs --tail 40 "$IMAGE" || true
  if [ -n "$PREV" ] && [ "$PREV_TAG" != "$TAG" ] && docker image inspect "$PREV" >/dev/null 2>&1; then
    echo "Starting the previous image $PREV again..."
    TAG="$PREV_TAG" PORT="$PORT" docker compose up -d
  fi
  exit 1
fi
echo "Healthy."
rm -rf "${DEPLOY:?}/.build"
# Remove every other image of this app and any dangling layers.
docker images "$IMAGE" --format '{{.Repository}}:{{.Tag}}' | grep -v -e ":$TAG\$" -e ':latest$' | xargs -r docker rmi || true
docker image prune -f >/dev/null
REMOTE

echo "Deployed: ${built[*]}"
[ "${#failed[@]}" -eq 0 ] || echo "NOT deployed (build failed or skipped): ${failed[*]}"
echo "Served at https://${DOMAIN}${BASE_PATH}/<name>/ (and www.) once the master proxy has the route (cloud-deploy: scripts/deploy.sh proxy)."
echo "Rollback: deploy the earlier commit again; old images are not kept."
[ "${#failed[@]}" -eq 0 ]
