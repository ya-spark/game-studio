#!/usr/bin/env bash
# Push the unpushed commits of every submodule's main to its origin.
#   scripts/push-all.sh              every submodule whose main is ahead of origin
#   scripts/push-all.sh <path> [...] only these submodules (e.g. game-factory)
#   scripts/push-all.sh -n           dry run: show what would be pushed, change nothing
# Plain `git push origin main`: never forced. A submodule that is not on main (e.g. a detached HEAD),
# or whose main is behind or has diverged from origin, is skipped with a warning (CLAUDE.md: submodule
# changes go to its main). Uncommitted changes are not pushed. game-studio is not touched: afterwards
# run scripts/bump.sh to record the new commits as pins.

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
BRANCH=main

DRY=0
ARGS=()
for a in "$@"; do
  case "$a" in
    -h|--help) sed -n 2,9p "$0"; exit 0 ;;
    -n|--dry-run) DRY=1 ;;
    -*) echo "Unknown option: $a"; exit 1 ;;
    *) ARGS+=("$a") ;;
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

PUSHED=(); SKIPPED=(); FAILED=()

for p in "${PATHS[@]}"; do
  echo "==> $p"
  if ! { [ -d "$p/.git" ] || [ -f "$p/.git" ]; }; then
    echo "    skipped: not initialised"; SKIPPED+=("$p"); continue
  fi

  cur="$(git -C "$p" branch --show-current)"
  if [ "$cur" != "$BRANCH" ]; then
    echo "    skipped: not on $BRANCH (${cur:-detached HEAD}); run scripts/pull-all.sh or check out $BRANCH"
    SKIPPED+=("$p"); continue
  fi

  git -C "$p" fetch -q origin || { echo "    fetch failed"; FAILED+=("$p"); continue; }
  ahead="$(git -C "$p" rev-list --count "origin/$BRANCH..HEAD")"
  behind="$(git -C "$p" rev-list --count "HEAD..origin/$BRANCH")"

  if [ "$ahead" -eq 0 ]; then
    if [ "$behind" -gt 0 ]; then echo "    nothing to push ($BRANCH is $behind behind origin; run scripts/pull-all.sh)"
    else echo "    nothing to push"; fi
    continue
  fi
  if [ "$behind" -gt 0 ]; then
    echo "    skipped: $BRANCH diverged ($ahead ahead, $behind behind); rebase or merge in $p first"
    SKIPPED+=("$p"); continue
  fi

  git -C "$p" log --format='      %h %s' "origin/$BRANCH..HEAD"
  if [ "$DRY" -eq 1 ]; then
    echo "    would push $ahead commit(s) to origin/$BRANCH"; PUSHED+=("$p"); continue
  fi
  if git -C "$p" push -q origin "$BRANCH"; then
    echo "    pushed $ahead commit(s) to origin/$BRANCH"; PUSHED+=("$p")
  else
    echo "    push failed"; FAILED+=("$p")
  fi
done

echo
verb="Pushed"; [ "$DRY" -eq 1 ] && verb="Would push"
echo "$verb: ${#PUSHED[@]}   Skipped: ${#SKIPPED[@]}   Failed: ${#FAILED[@]}"
[ ${#SKIPPED[@]} -eq 0 ] || echo "  skipped: ${SKIPPED[*]}"
[ ${#FAILED[@]} -eq 0 ] || echo "  failed:  ${FAILED[*]}"
[ "$DRY" -eq 1 ] || [ ${#PUSHED[@]} -eq 0 ] || echo "Run scripts/bump.sh to record the new commits as pins."
[ ${#FAILED[@]} -eq 0 ]
