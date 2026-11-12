#!/usr/bin/env bash
# Build the games for web locally, zip, upload one archive, unzip on the VPS, reload PM2.
# Usage: scripts/deploy.sh [<ssh-alias>] [game-name ...]
#   scripts/deploy.sh hostinger-vps-2                    every apps/game-* with a pubspec.yaml
#   scripts/deploy.sh hostinger-vps-2 game-wingy         just one game (or several, space separated)
#   VPS_HOST=hostinger-vps-2 scripts/deploy.sh game-wingy   alias from VPS_HOST (environment or .env)
# An argument that is a folder under apps/ is a game; any other first argument is the ssh alias
# (from ~/.ssh/config). Deploying one game leaves the other games on the VPS untouched.
# The VPS needs Node, PM2 and unzip. The login (basic auth) and the shared Caddy proxy live in the master
# cloud-deploy repo (apps.json + scripts/deploy.sh proxy); no .env is needed for this app.
# Each game is served at https://<domain>/<game>/ (flutter build web --base-href /<game>/).
# Builds use the submodule commits checked out here (the pins), not latest main. A game that fails to
# build is reported and skipped; its previous copy on the VPS is left alone. Other games' folders on the
# VPS are never removed. DRY_RUN=1 builds only (no SSH, no upload). Stops local run-web.sh processes (scripts/stop.sh) before building.

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
  elif [ -z "$alias_arg" ] && [ ! -e "$APPS_DIR/$arg" ] && [[ "$arg" != game-* ]]; then
    alias_arg="$arg"
  else
    echo "Unknown game: $arg (available: $(cd "$APPS_DIR" && ls -d game-*/ 2>/dev/null | tr -d / | tr '\n' ' '))"
    exit 1
  fi
done

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

REMOTE_ZIP="/tmp/game-studio-deploy.zip"
LOCAL_ZIP="$ROOT_DIR/.deploy-artifacts.zip"
STAGE_DIR=""
cleanup_local() {
  rm -f "$LOCAL_ZIP"
  if [ -n "$STAGE_DIR" ] && [ -d "$STAGE_DIR" ]; then rm -rf "$STAGE_DIR"; fi
}
trap cleanup_local EXIT

if [ -z "${DRY_RUN:-}" ]; then
echo "Checking SSH access to $SSH_TARGET..."
if ! "$SSH" "${SSH_OPTS[@]}" -o ConnectTimeout=15 "$SSH_TARGET" "true"; then
  echo "SSH failed for $SSH_TARGET."
  echo "  - Pass an alias from ~/.ssh/config that sets User and IdentityFile: scripts/deploy.sh <alias>"
  exit 1
fi
fi

echo "Stopping local run-web processes..."
"$SCRIPT_DIR/stop.sh"

flutter config --enable-web >/dev/null
STAGE_DIR="$(mktemp -d)"
mkdir -p "$STAGE_DIR/web" "$STAGE_DIR/scripts"
built=(); failed=()
for game in "${games[@]}"; do
  dir="$APPS_DIR/$game"
  [ -f "$dir/pubspec.yaml" ] || { echo "Skipping $game: no pubspec.yaml"; failed+=("$game"); continue; }
  echo "==> Building $game (base href /$game/)"
  if (
    cd "$dir"
    if [ ! -d web ]; then
      flutter create --platforms=web --project-name "$(sed -n 's/^name: *//p' pubspec.yaml | head -1)" . >/dev/null
    fi
    flutter pub get >/dev/null
    flutter build web --release --no-web-resources-cdn --base-href "/$game/"
  ); then
    cp -R "$dir/build/web" "$STAGE_DIR/web/$game"
    built+=("$game")
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

cp "$SCRIPT_DIR/ecosystem.config.cjs" "$SCRIPT_DIR/serve-static.cjs" "$STAGE_DIR/scripts/"
cp "$CONFIG_FILE" "$STAGE_DIR/"

echo "Packing deploy artifacts..."
rm -f "$LOCAL_ZIP"
(cd "$STAGE_DIR" && zip -r -q "$LOCAL_ZIP" .)
echo "Uploading archive to $SSH_TARGET:$REMOTE_ZIP..."
"$SCP" "${SSH_OPTS[@]}" "$LOCAL_ZIP" "$SSH_TARGET:$REMOTE_ZIP"

echo "Extracting on VPS and restarting the web server..."
"$SSH" "${SSH_OPTS[@]}" "$SSH_TARGET" bash -s <<REMOTE
set -e
DEPLOY_PATH='$VPS_DEPLOY_PATH'
REMOTE_ZIP='$REMOTE_ZIP'
GAMES='${built[*]}'
command -v unzip >/dev/null 2>&1 || { echo "unzip is not installed on the VPS"; exit 1; }
mkdir -p "\$DEPLOY_PATH/web" "\$DEPLOY_PATH/scripts"
for g in \$GAMES; do rm -rf "\$DEPLOY_PATH/web/\$g"; done
unzip -o "\$REMOTE_ZIP" -d "\$DEPLOY_PATH"
rm -f "\$REMOTE_ZIP"
. "\$HOME/.nvm/nvm.sh"
pm2 delete game-studio-web 2>/dev/null || true
pm2 start "\$DEPLOY_PATH/scripts/ecosystem.config.cjs" --only game-studio-web --update-env
pm2 save
REMOTE

echo "Deployed: ${built[*]}"
[ "${#failed[@]}" -eq 0 ] || echo "NOT deployed (build failed or skipped): ${failed[*]}"
echo "Served at https://${DOMAIN}/<game>/ once the master proxy has the route (cloud-deploy: scripts/deploy.sh proxy)."
[ "${#failed[@]}" -eq 0 ]
