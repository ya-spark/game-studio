#!/usr/bin/env bash
# Discard all local changes and pull every repo (master + submodules) from origin/main.
# WARNING: permanently deletes uncommitted and untracked work inside the submodules.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== master: discard tracked changes, pull"
# No `git clean` in master: it holds untracked work (e.g. app-factory/).
git reset --hard HEAD
git pull --ff-only origin main

git submodule update --init
for dir in $(git submodule --quiet foreach 'echo $displaypath'); do
  echo "== $dir: discard all changes, pull main"
  git -C "$dir" fetch origin
  git -C "$dir" checkout -f main
  git -C "$dir" reset --hard origin/main
  git -C "$dir" clean -fd
done
