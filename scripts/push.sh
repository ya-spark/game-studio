#!/usr/bin/env bash
# Push `main` of every submodule, move the master pins to those commits, push the master.
# Commit your work inside each submodule first; uncommitted changes are not pushed (warned).
# Only submodule pointers are committed in master; other master changes are left alone.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

paths=$(git submodule --quiet foreach 'echo $displaypath')

# Preflight: every repo must be on main before anything is pushed.
bad=0
master_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$master_branch" != "main" ]]; then
  echo "ERROR: master is on '$master_branch', not main." >&2
  bad=1
fi
for dir in $paths; do
  branch="$(git -C "$dir" rev-parse --abbrev-ref HEAD)"
  if [[ "$branch" != "main" ]]; then
    echo "ERROR: $dir is on '$branch', not main." >&2
    bad=1
  fi
done
if [[ "$bad" -ne 0 ]]; then
  echo "Aborting: nothing was pushed." >&2
  exit 1
fi

for dir in $paths; do
  if [[ -n "$(git -C "$dir" status --porcelain)" ]]; then
    echo "WARNING: $dir has uncommitted changes (not pushed)."
  fi
  echo "== $dir: push main"
  git -C "$dir" push origin main
done

echo "== master: update pins"
# shellcheck disable=SC2086
git add $paths
if git diff --cached --quiet; then
  echo "Pins already up to date."
else
  git commit -m "Update submodule pins

Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
fi

echo "== master: push"
git push origin main

git submodule status
