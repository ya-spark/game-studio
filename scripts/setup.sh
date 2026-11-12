#!/usr/bin/env bash
# One-time local setup: apt prerequisites, Flutter SDK, web support, submodules, .env template.
# Usage: bash scripts/setup.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Prerequisites: install any missing tools (Debian/Ubuntu/WSL via apt).
declare -A pkg_for=([git]=git [curl]=curl [unzip]=unzip [zip]=zip [xz]=xz-utils [which]=debianutils [node]=nodejs)
missing_pkgs=()
for cmd in "${!pkg_for[@]}"; do
  command -v "$cmd" >/dev/null 2>&1 || missing_pkgs+=("${pkg_for[$cmd]}")
done
if [ "${#missing_pkgs[@]}" -gt 0 ]; then
  echo "Installing missing prerequisites: ${missing_pkgs[*]}"
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y && sudo apt-get install -y "${missing_pkgs[@]}"
  else
    echo "No apt-get found; install manually: ${missing_pkgs[*]}" >&2
    exit 1
  fi
fi

FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
    echo "flutter not found; installing stable SDK to $FLUTTER_HOME (one-time, a few minutes)..."
    git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_HOME"
  fi
  export PATH="$FLUTTER_HOME/bin:$PATH"
  echo "Using $FLUTTER_HOME. To use flutter in your shell too:"
  echo "  echo 'export PATH=\"$FLUTTER_HOME/bin:\$PATH\"' >> ~/.bashrc"
fi
flutter --version
flutter config --enable-web >/dev/null

echo "Initialising submodules..."
git -C "$ROOT_DIR" submodule update --init --recursive -- apps

if [ ! -f "$ROOT_DIR/.env" ]; then
  cat > "$ROOT_DIR/.env" <<'ENV'
# Optional local deploy settings (never committed). VPS_HOST is an alias from ~/.ssh/config.
# VPS_HOST=hostinger-vps-2
ENV
  echo "Created .env (see scripts/deploy.sh)"
fi

echo "Setup complete. Run locally with: bash scripts/run-web.sh   Deploy with: bash scripts/deploy.sh <ssh-alias>"
