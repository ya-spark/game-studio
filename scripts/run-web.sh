#!/usr/bin/env bash
# Enable web support for each Flutter game in apps/ and serve them all.
#
# Usage: ./run-web.sh [game-name ...]     (default: every game-* folder here)
# Env:   BASE_PORT=7001  HOST=0.0.0.0  MODE=debug|release  NO_PULL=1 (skip git pull)
#        NO_OPEN=1 (don't open the browser automatically)
#        HOT=reload|restart|off (what to do when a source file is saved; default reload)
#
# Step 1 is a fresh pull: the parent repo is fast-forwarded, then each game
# submodule is checked out at the commit the parent pins (not latest main).
#
# Hot reload on save: each game runs with --pid-file and a watcher sends it SIGUSR1 (hot
# reload) whenever a file under lib/ or assets/ changes. HOT=restart sends SIGUSR2 (hot
# restart) instead; HOT=off disables the watcher. Keep the browser tab open: it reloads itself.
#
# With exactly one game (./run-web.sh game-block-puzzle) flutter runs in the foreground, so
# hot reload works: press r (hot reload), R (hot restart), q (quit) in this terminal, then
# refresh the browser tab (windows open only once, at startup). With several games they run in the background; r / R / q typed in this terminal are forwarded to every game.
#
# Each game gets its own port (BASE_PORT, BASE_PORT+1, ...). Open the printed
# URLs in a browser (Chrome recommended). Ctrl+C stops everything.
#
# Note: this generates an untracked web/ folder inside each game submodule.
# Don't commit it unless you intend to.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Shared settings: ROOT_DIR, APPS_DIR, BASE_PORT / HOST / MODE (from config.json, env overrides), PID_DIR.
source "$SCRIPT_DIR/config.sh"
LOG_DIR="$(mktemp -d)"
rm -rf "$PID_DIR"; mkdir -p "$PID_DIR"

# Prerequisites (apt tools, Flutter SDK, web support) are installed once by scripts/setup.sh.
FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
[ -x "$FLUTTER_HOME/bin/flutter" ] && export PATH="$FLUTTER_HOME/bin:$PATH"
command -v flutter >/dev/null 2>&1 || { echo "flutter not found: run scripts/setup.sh first" >&2; exit 1; }

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

# Phone-sized browser windows with DevTools. Chrome has no flag for the DevTools device
# toolbar, so this approximates it: window = phone viewport + DevTools dock, mobile user agent.
# Samsung Galaxy A-series viewport (~412x915 CSS px) is assumed for the A57.
DEVICE_W="${DEVICE_W:-412}"
DEVICE_H="${DEVICE_H:-915}"
DEVTOOLS_W="${DEVTOOLS_W:-500}"
MOBILE_UA="Mozilla/5.0 (Linux; Android 15; Samsung Galaxy A57) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36"

find_chrome() {
  local c
  for c in "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" \
           "/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
           "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"; do
    [ -x "$c" ] && { echo "$c"; return; }
  done
  command -v google-chrome || command -v chromium || true
}

# Open "$1" (URL); "$2" is the game index, used to offset windows so they don't overlap.
open_url() {
  local url="$1" idx="${2:-0}" chrome profile
  chrome="$(find_chrome)"
  if [ -n "$chrome" ]; then
    # A separate profile is required, otherwise Chrome hands the URL to the running
    # instance and ignores the flags.
    if [[ "$chrome" == /mnt/c/* ]]; then
      # Run cmd.exe from /mnt/c: from a WSL path it prints a UNC warning to stdout.
      profile="$(cd /mnt/c && cmd.exe /c 'echo %TEMP%' 2>/dev/null | tr -d '\r')\\run-web-profile-$idx"
    else
      profile="/tmp/run-web-profile-$idx"
    fi
    "$chrome" --user-data-dir="$profile" --new-window --no-first-run --no-default-browser-check \
      --auto-open-devtools-for-tabs --user-agent="$MOBILE_UA" \
      --window-size="$((DEVICE_W + DEVTOOLS_W)),$((DEVICE_H + 90))" \
      --window-position="$((idx * 60)),$((idx * 40))" \
      "$url" >/dev/null 2>&1 &
    return
  fi
  # Fallback: default browser, no phone sizing.
  if command -v wslview >/dev/null 2>&1; then wslview "$url"
  elif grep -qi microsoft /proc/version 2>/dev/null && command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url" || true
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$url"
  elif command -v open >/dev/null 2>&1; then open "$url"
  else echo "    no browser opener found; open $url manually" >&2
  fi >/dev/null 2>&1
}

# Wait (up to ~10 min, first build is slow) until the server answers, then open the browser.
open_when_ready() {
  local url="$1" idx="$2" i
  for ((i = 0; i < 300; i++)); do
    if curl -s -o /dev/null "$url"; then open_url "$url" "$idx"; return; fi
    sleep 2
  done
}

HOT="${HOT:-reload}"

# Poll a game's sources and signal its flutter process (pid file) on change.
watch_game() {
  local dir="$1" pidfile="$2" stamp sig=USR1
  [ "$HOT" = restart ] && sig=USR2
  stamp="$(mktemp)"
  while sleep 1; do
    [ -s "$pidfile" ] || continue
    if [ -n "$(find "$dir/lib" "$dir/assets" "$dir/pubspec.yaml" -type f -newer "$stamp" -print -quit 2>/dev/null)" ]; then
      touch "$stamp"
      sleep 0.5   # let the editor finish writing
      kill "-$sig" "$(cat "$pidfile")" 2>/dev/null || true
    fi
  done
}

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

  if port_in_use "$port"; then
    echo "Port $port is already in use: run scripts/stop.sh first" >&2
    exit 1
  fi

  pidfile="$PID_DIR/$game.pid"
  pidargs=(--pid-file "$pidfile")
  if [ "$HOT" != off ]; then
    watch_game "$dir" "$pidfile" &
    pids+=("$!")
  fi

  if [ "${#games[@]}" -eq 1 ]; then
    # Single game: foreground, so stdin reaches flutter (r / R / q).
    echo "    starting on http://localhost:$port  (r = hot reload, R = hot restart, q = quit)"
    # Opened once when the server is ready; r / R never open another window.
    if [ -z "${NO_OPEN:-}" ]; then
      open_when_ready "http://localhost:$port" 0 &
      pids+=("$!")
    fi
    (cd "$dir" && flutter run -d web-server --web-hostname "$HOST" --web-port "$port" "--$MODE" "${pidargs[@]}")
    exit 0
  fi

  (cd "$dir" && exec flutter run -d web-server --web-hostname "$HOST" --web-port "$port" "--$MODE" "${pidargs[@]}" \
      >"$LOG_DIR/$game.run.log" 2>&1) &
  pids+=("$!")
  echo "    starting on http://localhost:$port  (log: $LOG_DIR/$game.run.log)"
  if [ -z "${NO_OPEN:-}" ]; then
    open_when_ready "http://localhost:$port" "$((port - BASE_PORT))" &
    pids+=("$!")
  fi
  port=$((port + 1))
done

[ "${#pids[@]}" -gt 0 ] || { echo "Nothing started." >&2; exit 1; }
echo
echo "Compiling... first build takes a minute or two. Tail a log to watch progress."
echo "Ctrl+C to stop all."
if [ -t 0 ]; then
  # Several games run in the background, so forward keys to all of them.
  echo "Keys: r = hot reload all, R = hot restart all, q = quit"
  signal_all() {
    local f
    for f in "$PID_DIR"/*.pid; do
      [ -s "$f" ] && kill "-$1" "$(cat "$f")" 2>/dev/null || true
    done
  }
  while IFS= read -rsn1 key; do
    case "$key" in
      r) echo "Hot reload (all games)"; signal_all USR1 ;;
      R) echo "Hot restart (all games)"; signal_all USR2 ;;
      q) exit 0 ;;
    esac
  done
fi
wait
