#!/usr/bin/env bash
# Pull the master repo and every submodule to the latest code on main.
#
# Usage: ./scripts/pull-all.sh
#
# Fast-forwards the master repo, then checks out and fast-forwards each
# submodule to origin/main. The master pin changes if a submodule moved;
# the script reports it but does not commit (see CLAUDE.md: move the pin
# and commit only the pointer change).
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> game-studio"
git pull --ff-only
git submodule sync --recursive
git submodule update --init

git submodule foreach --quiet 'echo "==> $sm_path"; git fetch origin && git checkout main && git pull --ff-only origin main'

echo
echo "==> Status"
git submodule status
if ! git diff --quiet; then
  echo
  echo "Submodule pins are out of date (moved to latest main). To record:"
  echo "  git add -A apps game-factory && git commit -m 'Update submodule pins'"
fi
