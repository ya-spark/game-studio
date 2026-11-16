#!/usr/bin/env bash
# Pull game-studio and every submodule (game-factory, apps/*, games-web, content, public) to the
# latest main.
#   scripts/pull-all.sh              game-studio (ff-only), then each submodule on main (ff-only)
#   scripts/pull-all.sh <path> [...] only these submodules (e.g. apps/game-mind-1)
# Missing submodules are initialised first. A submodule on a detached HEAD (the state after
# `git submodule update`) is moved onto main, as CLAUDE.md asks, but only if its commit is already
# on origin/main. A submodule with uncommitted changes, or whose main cannot fast-forward, is skipped
# with a warning; nothing is merged, stashed or reset. This does not commit anything: to record
# moved pins, run scripts/bump.sh.

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
BRANCH=main

case "${1:-}" in -h|--help) sed -n 2,10p "$0"; exit 0 ;; esac

ALL=()
while IFS= read -r p; do ALL+=("$p"); done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' | awk '{print $2}')
if [ $# -gt 0 ]; then
  for t in "$@"; do
    printf '%s\n' "${ALL[@]}" | grep -qx "$t" || { echo "Unknown submodule: $t (known: ${ALL[*]})"; exit 1; }
  done
  PATHS=("$@")
else
  PATHS=("${ALL[@]}")
fi

OK=(); SKIPPED=(); FAILED=()

echo "==> game-studio"
if git pull --ff-only -q; then   # git itself refuses if local changes would be overwritten
  OK+=("game-studio")
else
  echo "    skipped: game-studio cannot fast-forward"; SKIPPED+=("game-studio")
fi
git submodule sync -q

for p in "${PATHS[@]}"; do
  echo "==> $p"
  if ! { [ -d "$p/.git" ] || [ -f "$p/.git" ]; }; then
    git submodule update --init -- "$p" || { FAILED+=("$p"); continue; }
  fi

  if [ -n "$(git -C "$p" status --porcelain)" ]; then
    echo "    skipped: uncommitted changes"; SKIPPED+=("$p"); continue
  fi

  git -C "$p" fetch -q origin || { echo "    fetch failed"; FAILED+=("$p"); continue; }

  cur="$(git -C "$p" branch --show-current)"
  if [ -z "$cur" ]; then
    # Detached: only leave it if its commit is on origin/main (otherwise it would be orphaned).
    if ! git -C "$p" merge-base --is-ancestor HEAD "origin/$BRANCH"; then
      echo "    skipped: detached at a commit that is not on origin/$BRANCH"; SKIPPED+=("$p"); continue
    fi
    git -C "$p" checkout -q "$BRANCH" 2>/dev/null \
      || git -C "$p" checkout -q -b "$BRANCH" "origin/$BRANCH" \
      || { echo "    cannot check out $BRANCH"; FAILED+=("$p"); continue; }
  elif [ "$cur" != "$BRANCH" ]; then
    echo "    skipped: on branch $cur, not $BRANCH"; SKIPPED+=("$p"); continue
  fi

  before="$(git -C "$p" rev-parse --short=7 HEAD)"
  if git -C "$p" merge --ff-only -q "origin/$BRANCH" 2>/dev/null; then
    after="$(git -C "$p" rev-parse --short=7 HEAD)"
    if [ "$before" = "$after" ]; then echo "    up to date ($BRANCH @ $after)"
    else echo "    $BRANCH: $before -> $after"; fi
    OK+=("$p")
  else
    echo "    skipped: $BRANCH cannot fast-forward to origin/$BRANCH (local commits or diverged)"
    SKIPPED+=("$p")
  fi
done

echo
echo "Updated/up to date: ${#OK[@]}   Skipped: ${#SKIPPED[@]}   Failed: ${#FAILED[@]}"
[ ${#SKIPPED[@]} -eq 0 ] || echo "  skipped: ${SKIPPED[*]}"
[ ${#FAILED[@]} -eq 0 ] || echo "  failed:  ${FAILED[*]}"
if ! git diff --quiet --ignore-submodules=dirty -- "${PATHS[@]}"; then
  echo "Pins moved in game-studio. Run scripts/bump.sh to commit and push them."
fi
[ ${#FAILED[@]} -eq 0 ]
