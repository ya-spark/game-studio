#!/usr/bin/env bash
# Stop everything started by run-web.sh: the script itself, its file watchers, and the
# `flutter run` web servers. Safe to run when nothing is running.
#
# Usage: ./stop.sh
set -uo pipefail

# Match on the command line; [r]/[f] keeps this script's own pgrep out of the results.
patterns=(
  '[r]un-web\.sh'
  '[f]lutter_tools.*run.* web-server'
  '[f]lutter run .*web-server'
)

# Never kill this script or anything that launched it (e.g. restart.sh, or a `bash -c` whose
# command line merely mentions run-web.sh).
skip=" $$ "
p=$$
while [ "$p" -gt 1 ]; do
  p="$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ')"
  [ -n "$p" ] && skip+="$p "
done

pids=()
for pat in "${patterns[@]}"; do
  while read -r pid; do
    [ -n "$pid" ] && [[ "$skip" != *" $pid "* ]] && pids+=("$pid")
  done < <(pgrep -f -- "$pat" || true)
done

if [ "${#pids[@]}" -eq 0 ]; then
  echo "Nothing to stop."
  exit 0
fi

mapfile -t pids < <(printf '%s\n' "${pids[@]}" | sort -un)
echo "Stopping: ${pids[*]}"
kill "${pids[@]}" 2>/dev/null || true

# Give them a moment to exit cleanly, then force whatever is left.
for _ in 1 2 3 4 5; do
  alive=()
  for p in "${pids[@]}"; do kill -0 "$p" 2>/dev/null && alive+=("$p"); done
  [ "${#alive[@]}" -eq 0 ] && { echo "Stopped."; exit 0; }
  sleep 1
done
echo "Forcing: ${alive[*]}"
kill -9 "${alive[@]}" 2>/dev/null || true
echo "Stopped."
