#!/usr/bin/env bash
# Enable web support for each Flutter game in apps/ and serve them all.
#
# Usage: ./run-web.sh [game-name ...]     (default: every game-* folder here)
# Env:   BASE_PORT=8081  HOST=0.0.0.0  MODE=debug|release  NO_PULL=1 (skip git pull)
#
# Step 1 is a fresh pull: the parent repo is fast-forwarded, then each game
# submodule is checked out at the commit the parent pins (not latest main).
#
# Each game gets its own port (BASE_PORT, BASE_PORT+1, ...). Open the printed
# URLs in a browser (Chrome recommended). Ctrl+C stops everything.
#
# Note: this generates an untracked web/ folder inside each game submodule.
# Don't commit it unless you intend to.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_DIR="$ROOT_DIR/apps"
BASE_PORT="${BASE_PORT:-8081}"
HOST="${HOST:-0.0.0.0}"
MODE="${MODE:-debug}"
LOG_DIR="$(mktemp -d)"

# Prerequisites: install any missing tools (Debian/Ubuntu/WSL via apt).
declare -A pkg_for=([git]=git [curl]=curl [unzip]=unzip [zip]=zip [xz]=xz-utils [which]=debianutils)
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

if [ "$#" -gt 0 ]; then
  games=("$@")
else
  games=()
  for d in "$APPS_DIR"/game-*/; do
    [ -f "$d/pubspec.yaml" ] && games+=("$(basename "$d")")
  done
fi
[ "${#games[@]}" -gt 0 ] || { echo "No games found in $APPS_DIR" >&2; exit 1; }

# Step 1: pull the latest parent repo, then check out the submodule commits it pins.
if [ -z "${NO_PULL:-}" ]; then
  # Keep this script out of git's way: exclude it locally (not committed) so pulls never conflict with it.
  exclude_file="$(git -C "$ROOT_DIR" rev-parse --git-path info/exclude)"
  case "$exclude_file" in /*) ;; *) exclude_file="$ROOT_DIR/$exclude_file" ;; esac
  mkdir -p "$(dirname "$exclude_file")"
  grep -qxF 'run-web.sh' "$exclude_file" 2>/dev/null || echo 'run-web.sh' >> "$exclude_file"
  echo "==> Pulling parent repo"
  if git -C "$ROOT_DIR" rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
    git -C "$ROOT_DIR" pull --ff-only || echo "    parent pull failed, continuing with current checkout" >&2
  else
    echo "    no upstream for the current branch; fetching only"
    git -C "$ROOT_DIR" fetch origin || true
  fi
  echo "==> Updating submodules to the pinned commits"
  git -C "$ROOT_DIR" submodule update --init --recursive -- apps \
    || echo "    submodule update failed (local changes?), continuing" >&2
fi

pids=()
cleanup() {
  echo; echo "Stopping games..."
  for p in "${pids[@]:-}"; do [ -n "$p" ] && kill "$p" 2>/dev/null || true; done
  wait 2>/dev/null || true
}
trap cleanup EXIT INT TERM

port="$BASE_PORT"
for game in "${games[@]}"; do
  dir="$APPS_DIR/$game"
  [ -f "$dir/pubspec.yaml" ] || { echo "Skipping $game: no pubspec.yaml" >&2; continue; }

  echo "==> $game"
  if [ ! -d "$dir/web" ]; then
    echo "    adding web platform"
    (cd "$dir" && flutter create --platforms=web --project-name "$(sed -n 's/^name: *//p' pubspec.yaml | head -1)" . >"$LOG_DIR/$game.create.log" 2>&1) \
      || { echo "    flutter create failed, see $LOG_DIR/$game.create.log" >&2; continue; }
  fi
  (cd "$dir" && flutter pub get >"$LOG_DIR/$game.pub.log" 2>&1) \
    || { echo "    pub get failed, see $LOG_DIR/$game.pub.log" >&2; continue; }

  (cd "$dir" && exec flutter run -d web-server --web-hostname "$HOST" --web-port "$port" "--$MODE" \
      >"$LOG_DIR/$game.run.log" 2>&1) &
  pids+=("$!")
  echo "    starting on http://localhost:$port  (log: $LOG_DIR/$game.run.log)"
  port=$((port + 1))
done

[ "${#pids[@]}" -gt 0 ] || { echo "Nothing started." >&2; exit 1; }
echo
echo "Compiling... first build takes a minute or two. Tail a log to watch progress."
echo "Ctrl+C to stop all."
wait
