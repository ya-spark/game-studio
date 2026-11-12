#!/usr/bin/env bash
# Build the games for web, bake them into one Docker image, stream it to the VPS, run it with Docker Compose.
# Usage: scripts/deploy.sh [<ssh-alias>] [game-name ...]
#   scripts/deploy.sh hostinger-vps-2                    every apps/game-* with a pubspec.yaml
#   scripts/deploy.sh hostinger-vps-2 wingy              just one game (game-wingy also works; several allowed)
#   VPS_HOST=hostinger-vps-2 scripts/deploy.sh wingy   alias from VPS_HOST (environment or .env)
# An argument that is a folder under apps/ is a game; any other first argument is the ssh alias
# (from ~/.ssh/config). The image holds ALL games. Deploying only some games first copies the games that are
# deployed now out of the running container (or the old web/ folder on the VPS) into the build, then replaces
# just the chosen ones, so the others are unchanged. Needs Docker on this machine (or run the web-vps workflow)
# and Docker + Compose on the VPS (user in the docker group). No .env is needed for this app.
# The container is named game-studio and publishes 127.0.0.1:<config.json ports.web> only. The login (basic
# auth) and the shared Caddy proxy live in the master cloud-deploy repo (apps.json + scripts/deploy.sh proxy).
# Each game is served at https://<domain><basePath>/<name>/ where <name> is the folder minus "game-"
# (game-wingy -> /appgames/wingy/), built with flutter build web --base-href <basePath>/<name>/.
# Builds use the submodule commits checked out here (the pins), not latest main. A game that fails to
# build is reported and skipped; its previous copy stays in the image. DRY_RUN=1 builds the games only
# (no Docker, no SSH, no upload). Stops local run-web.sh processes (scripts/stop.sh) before building.
# Images are tagged with a timestamp and "latest"; old images are deleted after a healthy deploy.

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
  command -v docker >/dev/null 2>&1 || { echo "Docker is not installed on this machine. Install it, or run the web-vps GitHub workflow."; exit 1; }
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

# Deploying only some games: start from the games that are deployed now, so the others stay as they are.
if [ "$PARTIAL" = 1 ] && [ -z "${DRY_RUN:-}" ]; then
  echo "Copying the games deployed now from the VPS..."
  if ! "$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" bash -s <<REMOTE | tar -xf - -C "$STAGE_DIR/web"
set -e
if [ -n "\$(docker ps -q -f name='^$IMAGE\$')" ]; then
  docker exec $IMAGE tar -C /app/web -cf - .
elif [ -d '$VPS_DEPLOY_PATH/web' ]; then
  tar -C '$VPS_DEPLOY_PATH/web' -cf - .
else
  exit 3
fi
REMOTE
  then
    echo "Could not read the deployed games from the VPS. Deploy all games first (no game names)."
    exit 1
  fi
fi

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
echo "Building image $IMAGE:$TAG (games in image: $(ls "$STAGE_DIR/web" | tr '\n' ' '))..."
docker build -f "$ROOT_DIR/Dockerfile" -t "$IMAGE:$TAG" -t "$IMAGE:latest" \
  --build-arg "SERVE_PORT=$WEB_PORT" --build-arg "SERVE_BASE=$BASE_PATH" "$STAGE_DIR"

echo "Streaming image to $SSH_TARGET (docker save | gzip | ssh | docker load)..."
"$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" "mkdir -p '$VPS_DEPLOY_PATH'"
docker save "$IMAGE:$TAG" "$IMAGE:latest" | gzip | "$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" "gunzip | docker load"

echo "Uploading compose.yml..."
"$SCP" "${SSH_OPTS[@]}" "$ROOT_DIR/compose.yml" "$SSH_TARGET:$VPS_DEPLOY_PATH/compose.yml"

echo "Starting the container and checking health..."
"$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" bash -s <<REMOTE
set -e
cd '$VPS_DEPLOY_PATH'
printf 'TAG=%s\nPORT=%s\n' '$TAG' '$WEB_PORT' > .env
# One-time hand-off: the old PM2 process (named game-studio-web before this was a container) holds the port.
. "\$HOME/.nvm/nvm.sh" 2>/dev/null || true
if command -v pm2 >/dev/null 2>&1 && pm2 describe game-studio-web >/dev/null 2>&1; then
  pm2 delete game-studio-web && pm2 save
fi
docker compose up -d --remove-orphans
for i in \$(seq 1 30); do
  if curl -fsS -o /dev/null "http://127.0.0.1:$WEB_PORT$BASE_PATH/"; then
    echo "Healthy."
    # Remove every other $IMAGE image and any dangling layers.
    docker images $IMAGE --format '{{.Repository}}:{{.Tag}}' | grep -v -e ":$TAG\$" -e ':latest\$' | xargs -r docker rmi || true
    docker image prune -f >/dev/null
    exit 0
  fi
  sleep 1
done
echo "Health check failed: docker compose logs $IMAGE"
docker compose logs --tail 40 $IMAGE || true
exit 1
REMOTE

echo "Deployed: ${built[*]}"
[ "${#failed[@]}" -eq 0 ] || echo "NOT deployed (build failed or skipped): ${failed[*]}"
echo "Served at https://${DOMAIN}${BASE_PATH}/<name>/ (and www.) once the master proxy has the route (cloud-deploy: scripts/deploy.sh proxy)."
echo "Rollback: deploy the earlier commit again; old images are not kept."
[ "${#failed[@]}" -eq 0 ]
