#!/usr/bin/env bash
# Move the pins: record moved submodule commits in game-studio, commit "Update submodule pins" and push.
#   scripts/bump.sh                  every submodule whose checked-out commit differs from the pin
#   scripts/bump.sh <path> [...]     only these submodules (e.g. apps/game-mind-1)
#   scripts/bump.sh -m "message"     use this commit message instead of "Bump <submodules>"
#   scripts/bump.sh -n               dry run: show what would be bumped, change nothing
# Run it after scripts/pull-all.sh, or after scripts/push-all.sh. It never pulls or touches submodules.
# Only the pin paths are committed (other staged work is left alone). Per CLAUDE.md a pin must be a
# commit on the submodule's origin/main, so anything else is refused (push the submodule's main first).
# A pin only ever moves forward: a checkout that is behind the current pin is refused (pull first).

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
BRANCH=main

DRY=0; MSG=""
ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) sed -n 2,10p "$0"; exit 0 ;;
    -n|--dry-run) DRY=1; shift ;;
    -m) [ $# -ge 2 ] || { echo "-m needs a message"; exit 1; }; MSG="$2"; shift 2 ;;
    -*) echo "Unknown option: $1"; exit 1 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done
set -- ${ARGS[@]+"${ARGS[@]}"}

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

MOVED=(); REFUSED=()
for p in "${PATHS[@]}"; do
  { [ -d "$p/.git" ] || [ -f "$p/.git" ]; } || continue      # not initialised
  [ "$(git rev-parse "HEAD:$p")" = "$(git -C "$p" rev-parse HEAD)" ] && continue                        # pin already matches
  pin="$(git rev-parse "HEAD:$p")"
  if ! git -C "$p" fetch -q origin 2>/dev/null; then
    echo "note: fetch failed in $p"; REFUSED+=("$p")
  elif ! git -C "$p" merge-base --is-ancestor HEAD "origin/$BRANCH"; then
    REFUSED+=("$p")                                           # HEAD not on origin/main
  elif ! git -C "$p" merge-base --is-ancestor "$pin" HEAD 2>/dev/null; then
    echo "note: $p checkout is behind or unrelated to the pin; bumping would move it backwards (run scripts/pull-all.sh)"
    REFUSED+=("$p")
  else
    MOVED+=("$p")
  fi
  [ -z "$(git -C "$p" status --porcelain)" ] || echo "note: $p has uncommitted changes (not part of the pin)"
done

[ ${#REFUSED[@]} -eq 0 ] || echo "Not bumping (not on origin/$BRANCH, or not ahead of the pin; see notes above): ${REFUSED[*]}"
[ ${#MOVED[@]} -gt 0 ] || { echo "Nothing to bump."; [ ${#REFUSED[@]} -eq 0 ]; exit; }

if [ -z "$MSG" ]; then
  names="$(IFS=,; echo "${MOVED[*]}" | sed 's/,/, /g')"
  MSG="Bump $names"
  [ ${#MOVED[@]} -eq 1 ] && MSG="$MSG ($(git -C "${MOVED[0]}" log -1 --format=%s))"
fi

if [ "$DRY" -eq 1 ]; then echo "Would commit and push: $MSG"; exit 0; fi

git add -- "${MOVED[@]}" && git commit -q -m "$MSG" -- "${MOVED[@]}" || { echo "Commit failed."; exit 1; }
if git push -q; then
  echo "Pushed: $MSG"
else
  echo "Committed locally but push failed (pull game-studio and retry: git pull --rebase && git push)."; exit 1
fi
[ ${#REFUSED[@]} -eq 0 ]
