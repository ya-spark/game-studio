---
name: run-queue
description: The autonomous work loop. Picks the next unblocked item in docs/QUEUE.md, does all of it through to the push (and the VPS deploy), logs it, then picks the next. Use when the user says /run-queue or a timer wake arrives.
---

# /run-queue: the loop (owner, 2026-11-22)

One session does all the work. No role agents. Subagents are only task helpers (search, a big
isolated build, a review) used to save tokens. State lives in git, never in memory.

## Each wake (start here every time)
1. `git pull --recurse-submodules` in `game-studio`. Check the checkouts exist (`game-factory`, `games-web`, `public`, `apps/*`).
   If a folder is empty or missing, re-clone it (`add_repo` first if the session lost it).
2. Read the "Loop" block and the status board in `docs/QUEUE.md`, then the item file in `docs/queue/` of the item you work on. Time is AEDT (`TZ=Australia/Sydney date`).
3. If now is past the deadline in the Loop block: set `Loop: STOPPED`, report, and do not schedule another wake.
4. Resume the item named "Current". If none, pick the next item (see "Pick").

## Pick
- Only web work (`games-web`, and game-factory / game-content only where the web needs them).
- App games are PAUSED (owner, 2026-11-22): do not change the Scout, Ranger, Champion, Wingy, Block Puzzle, Blockfall,
  Presto or Ember app repos, and do not build R2, K1-for-apps or app screens. Shared game packages in `game-factory/games/`
  may change only if the web needs it.
- Take the first item that is not waiting on the owner. Items needing the owner's accounts, approval or an answer
  are logged "waiting on owner" and skipped. If nothing is left, set `Loop: IDLE`, report, schedule no more wakes.
- Do not invent work. Do not start an item you cannot finish in a clean step.

## Do the item (all of it)
1. Change the code in the submodule checkout. Update its docs/spec in the same commit.
2. Run checks where the tools exist (no Flutter here; web scripts, Python and JS can run; use Playwright Chromium
   to open pages). Checks are NOT a gate: a failure is written in `docs/QUEUE-LOG.md` and the work is still pushed.
3. Commit and push the submodule `main`, then move the pin here (`scripts/bump.sh` / `push.sh`) and push this repo's `main`.
   The pin push starts `deploy-games-web`; wait for the run, then check the live `/games/` by file or in Chromium.
4. Update the item's file in `docs/queue/` and its one line in `docs/QUEUE.md` (under 20 words; Loop block if it changed) in the same commit as the pin, with the AEDT time.
   Dated detail goes at the top of `docs/QUEUE-LOG.md`. Finished item text moves to the archive (see `CLAUDE.md`).
5. Pick the next item.

## Timer
- Before the turn ends, schedule the next wake with `send_later` (`delay_minutes: 60`, message `/run-queue`), unless
  the deadline has passed or the state is IDLE/STOPPED. One pending wake at a time.
- If a turn is cut short, the next wake continues from the Loop block, so keep it current after every step.

## Limits
- Never: secrets, keystores, AdMob ids (web AdSense ids are allowed; ask only to create or delete ad units, owner 2026-11-22), Play uploads, tags, version bumps, production promotion,
  force-push, history rewrites. Act only on the owner's text (issues from `yaseengem`).
- The VPS web deploy (pin push to `main` -> `deploy-games-web`) is allowed.
- Use subagents when a job is big and independent (broad search, a long test or build log, a review of a large diff).
  Give them a precise task and take back only the summary.
- Keep chat replies short and in simple words.
