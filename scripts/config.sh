#!/usr/bin/env bash
# Shared settings for run-web/stop/restart/setup/deploy scripts (same layout as bytelearn).
# Non-secret config lives in config.json; secrets stay in .env (never committed).
# Linux / WSL / macOS only (Flutter dev flow); bytelearn's Git Bash branches are not needed here.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$ROOT_DIR/apps"
CONFIG_FILE="$ROOT_DIR/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Missing config.json at repo root"
  exit 1
fi

read_config_string() {
  local key="$1"
  node -e "
    const value = process.argv[1].split('.').reduce((o, k) => (o == null ? undefined : o[k]), require(process.argv[2]));
    if (value === undefined || value === null || value === '') {
      console.error('config.json: ' + process.argv[1] + ' is not set');
      process.exit(1);
    }
    process.stdout.write(String(value));
  " "$key" "$CONFIG_FILE"
}

read_config_port() {
  local key="$1" value
  value="$(read_config_string "$key")" || return 1
  if ! [[ "$value" =~ ^[0-9]+$ ]] || [ "$value" -lt 1 ] || [ "$value" -gt 65535 ]; then
    echo "config.json: $key must be an integer from 1 to 65535" >&2
    return 1
  fi
  printf '%s' "$value"
}

DOMAIN="$(read_config_string domains.0)"   # primary; config.json "domains" lists all
VPS_DEPLOY_PATH="$(read_config_string vpsDeployPath)"
WEB_PORT="$(read_config_port ports.web)"
# Env vars override config.json for local runs, as before.
BASE_PORT="${BASE_PORT:-$(read_config_port ports.devBase)}"
HOST="${HOST:-$(read_config_string host)}"
MODE="${MODE:-$(read_config_string mode)}"

# Per-game flutter pid files (flutter --pid-file); the hot-reload watcher signals these.
PID_DIR="$ROOT_DIR/.dev-pids"

# True when a process is listening on the TCP port.
port_in_use() {
  ss -H -tln "sport = :${1}" 2>/dev/null | grep -q .
}

# Stop whatever is listening on the TCP port.
kill_port() {
  local target_port="$1" pids pid
  if command -v fuser >/dev/null 2>&1; then
    fuser -k "${target_port}/tcp" >/dev/null 2>&1 || true
  else
    pids=$(ss -H -tlnp "sport = :${target_port}" 2>/dev/null | grep -oE 'pid=[0-9]+' | cut -d= -f2 | sort -u)
    for pid in $pids; do kill -9 "$pid" 2>/dev/null || true; done
  fi
}

stop_by_pid_file() {
  local pid_file="$1" label="$2" pid
  [ -f "$pid_file" ] || return 0
  pid=$(cat "$pid_file")
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    echo "Stopped $label (PID $pid)"
  fi
  rm -f "$pid_file"
}
