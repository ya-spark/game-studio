# Work queue (tracker)

Tracker: one line per item (under 20 words), detail in `docs/queue/<item>.md`. Times AEDT (UTC+11). Read `docs/DECISIONS.md` and `docs/issue-drafts/README.md` first. Layout changed Sun Nov 22 14:24:47 AEDT 2026.

## How to use this file
- When an item changes, edit its own file in `docs/queue/` and its one line here (same commit, AEDT time). Dated detail goes at the top of `docs/QUEUE-LOG.md`; full item text in `docs/FEATURE-SPECS.md`; decisions in `docs/DECISIONS.md`.
- Keep each line under 20 words. Full procedure: [HOW-TO-USE](queue/HOW-TO-USE.md). Folder guide: [README](queue/README.md).

## Standing rules (never break)
- No release, tag, version bump or store upload.
- No secrets, keystores or AdMob IDs. Web AdSense ids and slots: edit freely; ask the owner only to create or delete ad units (owner, 2026-11-22).
- Nothing for Play Console, AdMob, prices or Cloudflare (owner only). The VPS web deploy by pin push is allowed (owner, 2026-11-22).
- Checks (analyze, format, tests, ad-safety) are not a gate: log failures, still push (owner, 2026-11-22).
- App games are PAUSED (owner, 2026-11-22): no changes to `apps/*`, no R2, no K1 for apps. Web work only.
- Do not touch the three old games' code (their workflows now call the shared ones, like every game).
- No living beings in the games (owner, 2026-11-22): no people or animals as characters or in art; toys, robots, shapes, objects.
- Content packs beyond Years 0 to 12 maths and English: the owner says when.
- Issues come from `yaseengem` only.

## Loop (`/run-queue`, started 10:35 AM AEDT 22 Nov 2026; detail: [LOOP](queue/LOOP.md))
- State: RUNNING. Deadline: 10:30 PM AEDT Mon 23 Nov 2026. Recurring task `trig_01LytVbHGqXbL6UeHP4pPLtT` at :20 each hour; disable at the deadline.
- Current: U3 built; planning W5 and M8 specs with owner, then U1 audit.
- Iteration 3 = web games and site; iteration 4 = app games (parked).

## Status board

| Item | Status | Next |
|---|---|---|
| [Games at the domain root + AdSense root files](queue/ROOT-DOMAIN-ADSENSE.md) | DONE; waiting on AdSense Verify | Owner picks Meta tag option, clicks Verify; noindex removal needs owner yes |
| [W3 Web ads and browser-saved progress](queue/W3-web-ads-progress.md) | Progress store BUILT 12:37 PM 22 Nov; ads spec to write | Wait for owner AdSense ids; wire store to a web page |
| [M8 Rung opening by purchase or ad, coins](queue/M8-rung-opening-coins.md) | SPEC DRAFTED 2:21 PM 22 Nov | Owner answers 4 questions |
| [W5 Browser notifications](queue/W5-notifications.md) | SPEC DRAFTED 1:56 PM 22 Nov; owner confirmed proposals 2:00 PM | Owner child-directed check, then says start |
| [U2 Owner change list (22 Nov 1:20 PM)](queue/U2-owner-change-list.md) | Items 1, 2, 3 DONE; item 4 dropped | None open |
| [W7 Web game layout: side panels](queue/W7-web-game-layout.md) | Spec drafted 2:54 PM AEDT 22 Nov | Owner answers 4 questions, then says start |
| [U3 Bridge builder (Equation builder rewrite)](queue/U3-bridge-builder.md) | BUILT, pushed 1:50 PM 22 Nov | Owner looks live, sends changes |
| [Trail look: Constellation](queue/TRAIL-constellation.md) | Web page built 1:05 PM 22 Nov; Flutter component pushed | Push when site is up, W3 progress store, then apps (iteration 4) |
| [K1 Keyboard play (web)](queue/K1-keyboard-play.md) | MOSTLY DONE, live 11:11 AM 22 Nov | Owner plays on a real keyboard; apps get it in iteration 4 |
| [W6 Games-first web flow](queue/W6-games-first-flow.md) | DONE, live 3:27 PM 21 Nov | Owner opens `/games/` and reports |
| [DR1 Door runner rewrite](queue/DR1-door-runner.md) | DONE, live at /games/scout/ 4:39 PM 21 Nov | Owner tries it live and on a device; Ranger and Champion copy later |
| [SH1 One copy of the games](queue/SH1-shared-games-package.md) | STEPS 1 TO 6 DONE, live 22 Nov | None open |
| [W2 / W2.1 Landing page redesign](queue/W2-1-landing-redesign.md) | BUILT 2:50 AM 21 Nov, not browser-tested | Owner looks at `/games/`, then testing agent if wanted |
| [Topic list and order review](queue/TOPIC-LIST-REVIEW.md) | BACKLOG (owner deferred) | Review later; order lives in `game-content/topics.yaml` |
| [X2 AdSense](queue/X2-adsense.md) | Code in apps (#165), switched OFF | Owner steps later: account, ids, privacy pages |
| [#148 Curriculum coverage](queue/148-curriculum-coverage.md) | PAUSED since 12 Nov at Maths Year 3 | Resume with `@claude Please continue` on #148 when owner says |
| [Issue 10 purchase check on the VPS](queue/ISSUE-10-purchase-check.md) | WAITING on the owner | Owner sets up VPS and Cloudflare first |
| [Screenshots](queue/SCREENSHOTS.md) | LAST, at the very end | Do once, when the owner says (method in `docs/SCREENSHOTS.md`) |
| [R2 Rewrite earlier Craft apps and games](queue/R2-rewrite-craft-apps.md) | SPEC IN PROGRESS; parked (iteration 4) | Waiting for Figma result, apps' own screens, Constellation |
| [Done items](queue/DONE.md) | 23 items finished (hosting, W1, M6, M7, R1, T1-T7, SH1 steps) | Detail in file |

## Game rewrite list (owner, 2:00 PM AEDT 22 Nov)
- Reimagine, discuss, spec, build only on owner start; one game at a time. Rules: [GAMES-REWRITE](queue/GAMES-REWRITE.md).

| Game | Status |
|---|---|
| [G-01 Ball sort](queue/G-01-ball-sort.md) | not started |
| [G-02 Balloon pop](queue/G-02-balloon-pop.md) | not started |
| [G-03 Block puzzle](queue/G-03-block-puzzle.md) | not started |
| [G-04 Blockfall](queue/G-04-blockfall.md) | not started |
| [G-05 Brick breaker](queue/G-05-brick-breaker.md) | not started |
| [G-06 Cloze fix](queue/G-06-cloze-fix.md) | not started |
| [G-07 Door runner](queue/G-07-door-runner.md) | not started |
| [G-08 Flash review](queue/G-08-flash-review.md) | not started |
| [G-09 Mahjong](queue/G-09-mahjong.md) | not started |
| [G-10 Memory match](queue/G-10-memory-match.md) | not started |
| [G-11 Merge](queue/G-11-merge.md) | not started |
| [G-12 Runner](queue/G-12-runner.md) | not started |
| [G-13 Domino chain (was Series builder)](queue/G-13-series-builder.md) | concept agreed; spec next |
| [G-14 Shooter](queue/G-14-shooter.md) | not started |
| [G-15 Snake](queue/G-15-snake.md) | not started |
| [G-16 Solitaire](queue/G-16-solitaire.md) | not started |
| [G-17 Sort bins](queue/G-17-sort-bins.md) | not started |
| [G-18 Stack tower](queue/G-18-stack-tower.md) | not started |
| [G-19 Sudoku](queue/G-19-sudoku.md) | not started |
| [G-20 True or false](queue/G-20-true-false.md) | not started |
| [G-21 Tug of war](queue/G-21-tug-of-war.md) | not started |
| [G-22 Wingy](queue/G-22-wingy.md) | not started |
| [G-23 Word builder](queue/G-23-word-builder.md) | not started |
| [G-24 Word grid](queue/G-24-word-grid.md) | not started |

## Iteration 4: app games (parked, owner 2026-11-22)
- R2, K1 for apps, app screens, Constellation in apps, DR1 follow-ups; Issue 10, Play Console, AdMob, screenshots, old three games. Starts when the owner says. Active and Next lists: [NEXT-AND-ACTIVE](queue/NEXT-AND-ACTIVE.md).

## Waiting on the owner (full text: [WAITING-ON-OWNER](queue/WAITING-ON-OWNER.md))
- Decide whether `/appgames` gets version info too.
- Scout: docs (Door runner, Balloon pop coin-locked) or code (free; only Tug of war locked)?
- AdSense account, approval, then Families check go-ahead (M8, W3).
- Review how-to-play text, content packs and each app's `docs/SPEC.md`.
- Listen to the M4 sound packs.
- Decide what replaces coins and whether they survive reinstall.
- Turn off the `noindex` header when the site is public.
- Accounts and setup: AdSense, Play Console, AdMob, Play Games, trademark, Cloudflare, VPS, tokens, `CI_ENABLED`.
- Say when to resume #148 (stays paused).
- Block Puzzle: what replaces the paid coin packs.
