#!/usr/bin/env bash
# Trigger the `release` GitHub Actions workflow of a game repo: build the signed AAB and
# upload it to the Play INTERNAL testing track.
# Usage: publish.sh <game> [--no-watch] [--test-apk]
#   <game>       game-block-fall | game-block-puzzle | game-wingy  (or "all")
#   --no-watch   trigger only; do not follow the run
#   --test-apk   also build an installable release APK
# Requires: gh (authenticated). The workflow runs on the repo's `main` (push it first: push.sh).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW="release.yml"

game=""
watch=1
test_apk=false
for arg in "$@"; do
  case "$arg" in
    --no-watch) watch=0 ;;
    --test-apk) test_apk=true ;;
    -h|--help) sed -n '2,9p' "${BASH_SOURCE[0]}"; exit 0 ;;
    -*) echo "Unknown option: $arg" >&2; exit 1 ;;
    *) game="$arg" ;;
  esac
done

if [[ -z "$game" ]]; then
  echo "Usage: publish.sh <game|all> [--no-watch] [--test-apk]" >&2
  exit 1
fi

if [[ "$game" == "all" ]]; then
  games=$(cd "$ROOT/apps" && ls -d game-*/ | tr -d /)
else
  games="$game"
fi

command -v gh >/dev/null || { echo "ERROR: gh CLI not found." >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "ERROR: gh is not authenticated (gh auth login)." >&2; exit 1; }

publish_one() {
  local name="$1" dir="$ROOT/apps/$1"
  [[ -d "$dir" ]] || { echo "ERROR: no such game: $name" >&2; return 1; }

  local repo
  repo=$(git -C "$dir" remote get-url origin | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##')

  git -C "$dir" fetch -q origin main
  if [[ "$(git -C "$dir" rev-parse HEAD)" != "$(git -C "$dir" rev-parse origin/main)" ]]; then
    echo "WARN: $name local HEAD differs from origin/main; the workflow builds origin/main."
  fi

  echo "== $name ($repo): trigger $WORKFLOW (track=internal, upload=true)"
  gh workflow run "$WORKFLOW" --repo "$repo" --ref main \
    -f track=internal -f upload=true -f test_apks="$test_apk"

  if [[ "$watch" -eq 1 ]]; then
    sleep 5 # let GitHub register the run
    local run_id
    run_id=$(gh run list --repo "$repo" --workflow "$WORKFLOW" --event workflow_dispatch \
      --limit 1 --json databaseId --jq '.[0].databaseId')
    gh run watch "$run_id" --repo "$repo" --exit-status
  else
    echo "Triggered. Follow with: gh run list --repo $repo --workflow $WORKFLOW"
  fi
}

for g in $games; do
  publish_one "$g"
done
