#!/usr/bin/env bash
# Trigger the release workflow of a game repo (`release-to-closed-testing`; `release` in the three
# older games): build the signed AAB and upload it to the Play CLOSED testing (alpha) track.
# Usage: publish.sh <game> [--no-watch] [--test-apk]
#   <game>       a folder name under apps/, for example game-wingy  (or "all")
#   --no-watch   trigger only; do not follow the run
#   --test-apk   also build an installable release APK
# `all` triggers every game's workflow first (they build in parallel on GitHub), then watches
# them together; exit status is non-zero if any game fails.
# Requires: gh (authenticated). The workflow runs on the repo's `main` (push it first: push.sh).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW=""  # set per game by trigger_one: release-to-closed-testing.yml, or release.yml in the older games

game=""
watch=1
test_apk=false
for arg in "$@"; do
  case "$arg" in
    --no-watch) watch=0 ;;
    --test-apk) test_apk=true ;;
    -h|--help) sed -n '2,11p' "${BASH_SOURCE[0]}"; exit 0 ;;
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

repo_of() {
  git -C "$ROOT/apps/$1" remote get-url origin | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##'
}

latest_run_id() {
  gh run list --repo "$1" --workflow "$WORKFLOW" --event workflow_dispatch \
    --limit 1 --json databaseId --jq '.[0].databaseId // empty'
}

# Phase 1: trigger the workflow of one game and print the id of the run it started.
# Progress goes to stderr so the caller can capture the id from stdout.
trigger_one() {
  local name="$1" dir="$ROOT/apps/$1"
  [[ -d "$dir" ]] || { echo "ERROR: no such game: $name" >&2; return 1; }

  local repo
  repo=$(repo_of "$name")
  if [[ -f "$dir/.github/workflows/release-to-closed-testing.yml" ]]; then
    WORKFLOW="release-to-closed-testing.yml"
  else
    WORKFLOW="release.yml"
  fi

  git -C "$dir" fetch -q origin main
  if [[ "$(git -C "$dir" rev-parse HEAD)" != "$(git -C "$dir" rev-parse origin/main)" ]]; then
    echo "WARN: $name local HEAD differs from origin/main; the workflow builds origin/main." >&2
  fi

  local before
  before=$(latest_run_id "$repo")
  echo "== $name ($repo): trigger $WORKFLOW (track=alpha, upload=true)" >&2
  gh workflow run "$WORKFLOW" --repo "$repo" --ref main \
    -f track=alpha -f upload=true -f test_apks="$test_apk" >&2

  # Wait for GitHub to register the new run (its id differs from the previous latest).
  local id="" tries=0
  while [[ $tries -lt 30 ]]; do
    id=$(latest_run_id "$repo")
    [[ -n "$id" && "$id" != "$before" ]] && break
    id=""
    tries=$((tries + 1))
    sleep 2
  done
  [[ -n "$id" ]] || { echo "ERROR: $name: triggered run not found" >&2; return 1; }
  echo "$id"
}

# Phase 2: follow one run, prefixing every line with the game name.
watch_one() {
  local name="$1" repo="$2" id="$3"
  local attempt status conclusion
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    gh run watch "$id" --repo "$repo" --exit-status 2>&1 | sed -u "s/^/[$name] /"
    [[ "${PIPESTATUS[0]}" -eq 0 ]] && return 0
    # The watch can die from a network blip while the run is fine; ask GitHub for the real
    # outcome and only fail on a genuine failure.
    status="" conclusion=""
    { read -r status conclusion; } < <(gh run view "$id" --repo "$repo" \
      --json status,conclusion --jq '"\(.status) \(.conclusion)"' 2>/dev/null)
    if [[ "$status" == "completed" ]]; then
      [[ "$conclusion" == "success" ]] && return 0
      echo "[$name] run finished: $conclusion" >&2
      return 1
    fi
    echo "[$name] watch interrupted (run still ${status:-unknown}); reconnecting (attempt $attempt)..." >&2
    sleep 5
  done
  return 1
}

declare -A run_ids=()
failed=()

# Trigger every game first so all the cloud workflows run in parallel.
for g in $games; do
  if id=$(trigger_one "$g"); then
    run_ids[$g]="$id"
  else
    failed+=("$g")
  fi
done

if [[ "$watch" -eq 0 ]]; then
  for g in "${!run_ids[@]}"; do
    echo "Triggered $g (run ${run_ids[$g]}). Follow with: gh run watch ${run_ids[$g]} --repo $(repo_of "$g")"
  done
else
  # Then monitor them all at once.
  declare -A pids=()
  for g in "${!run_ids[@]}"; do
    watch_one "$g" "$(repo_of "$g")" "${run_ids[$g]}" &
    pids[$g]=$!
  done
  for g in "${!pids[@]}"; do
    wait "${pids[$g]}" || failed+=("$g")
  done
fi

echo
if [[ ${#failed[@]} -gt 0 ]]; then
  echo "FAILED: ${failed[*]}" >&2
  exit 1
fi
if [[ "$watch" -eq 1 ]]; then
  echo "All workflows finished OK: ${!run_ids[*]}"
fi
