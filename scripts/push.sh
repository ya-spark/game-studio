#!/usr/bin/env bash
# Push every submodule's main, then update the master pins and push the master.
#
# Usage: ./scripts/push.sh ["pin commit message"]
#
# Submodules are pushed first so the master never pins a commit that is not
# on the submodule's main. Uncommitted work is never committed here; the
# script only pushes existing commits and commits the pointer changes.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
MSG="${1:-Update submodule pins}"

git submodule foreach --quiet '
  echo "==> $sm_path"
  [ "$(git rev-parse --abbrev-ref HEAD)" = main ] || { echo "not on main, skipping"; exit 0; }
  [ -z "$(git status --porcelain)" ] || echo "warning: uncommitted changes (not pushed)"
  git push origin main
'

echo "==> game-studio"
pins=$(git diff --name-only --ignore-submodules=none | while read -r p; do [ -e "$p/.git" ] && echo "$p"; done || true)
if [ -n "$pins" ]; then
  # shellcheck disable=SC2086
  git add $pins
  git commit -m "$MSG

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
fi
git push origin main

echo
git submodule status
