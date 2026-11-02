#!/usr/bin/env bash
# Stop any running web servers, then start run-web.sh again.
# All arguments and env vars are passed through, e.g.:
#   ./restart.sh game-block-puzzle
#   NO_PULL=1 ./restart.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$DIR/stop.sh"
exec "$DIR/run-web.sh" "$@"
