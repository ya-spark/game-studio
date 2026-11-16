#!/usr/bin/env bash
# Push every submodule's main, then move the pins and push game-studio.
#
# Usage: ./scripts/push.sh ["pin commit message"]
#
# Shorthand for scripts/push-all.sh followed by scripts/bump.sh (run those directly for dry runs or
# to limit to some submodules). Submodules are pushed first so the pins never point at a commit that
# is not on the submodule's main.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$DIR/push-all.sh" || exit 1
echo
if [ -n "${1:-}" ]; then exec "$DIR/bump.sh" -m "$1"; else exec "$DIR/bump.sh"; fi
