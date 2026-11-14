# Work queue (owner approved, 2026-11-12)

A fresh session or scheduled run can continue the new-apps work from this file alone. Read `docs/DECISIONS.md`
and `docs/issue-drafts/README.md` first. Times are AEDT (UTC+11). Update this file in the same session as any change.

## How to continue
1. List `game-studio` workflow runs (`claude` workflow). Count active (in progress or queued).
2. Read the latest comment of every issue in "Active". A run that finished with a summary is done; one that
   failed with no comment stopped early (usage limit or turns): comment `@claude Please continue` on that issue.
3. Move pins only if a run did not (`git submodule status` must match each repo's `origin/main`).
4. Post the next item from "Next" when its dependency is done. Keep at most 3 runs active (usage limits).
5. Move finished items to "Done" with the issue number, then commit and push this file to `main`.

## Standing rules (never break)
No release, tag, version bump or store upload. No secrets, keystores or real ad IDs. Nothing for Play Console, AdMob,
prices, Cloudflare or the VPS (owner only). Do not touch the three old games' code (their workflows now call the shared ones, like every game). No people in any art.
Content packs beyond Years 0 to 12 maths and English: owner says when. Issues come from `yaseengem` only.

## Active
- #156 M1: first run (2026-11-14 01:05 UTC) ended with no comment and nothing pushed; `@claude Please continue` commented (2026-11-14, owner asked). Check its result.
- DEPLOYS (web UAT, automatic since 14 Nov 2026): run 1 (all five new apps, started 12:12 pm AEDT) SUCCEEDED at 12:18 pm AEDT; it did not include C8 (landed 12:17 pm). Run 2 (Scout, Ranger, Champion, for C8) started about 12:21 pm AEDT. Next deploys: Mind Ember and Mind Presto after #156, #157 and #159 land; the Craft apps again after #159, #160 and #161.
- 12:25 pm AEDT 14 Nov: #158 C8 DONE. #159 X2a first run failed with no comment at 12:15 pm AEDT after pushing only the template (639ad3e): `@claude Please continue` commented. #157 M4 steps 2 to 4 are on game-factory (69adece, 12:15 pm AEDT), apps still to come. #156 M1 rules and save pushed to game-mind-1 (a970cf9, 81ee9f1). #161 C5 posted. Deploy run 1 (started 12:12 pm AEDT) still running.
- DONE 2026-11-14: #155 C2. #157 M4 step 1 done, steps 2 to 4 continuing. #160 C3 posted. #156 M1 restarted (run 8). #158 C8 and #159 X2a still running. Monitoring: the studio session re-checks every 20 to 30 minutes and posts the next item when its dependency is done (C5 after #158; C4 after #160; M2 after #156; X2b after #159).
- RUNNING (2026-11-14): #155 C2 spaced repetition, #156 M1 daily puzzle, #157 M4 themes and sound packs, #158 C8 family mode, #159 X2a web shell. That is 5 at once, above the usual limit of 3: the owner asked for more in parallel; if a run fails with no comment (usage limit), comment `@claude Please continue` on it. Overlaps: #155 and #158 and #157 touch game-factory; #156 and #157 touch game-mind-1; runs must pull and rebase, never force-push.
- None running. #148 curriculum coverage is PAUSED by the owner (2026-11-12) after batch 2: Maths Y0 to Y3 gaps filled (152 packs, Scout 92). Resume with `@claude Please continue` on #148 (Maths Y4 to 12, English all years, Y1 planned rows, accuracy read). Map: content/docs/CURRICULUM-GAPS.md (unverified).
- template-ci manual re-run on game-factory main (after #145): DONE, passed (run 169, 2026-11-12).
- #149 DONE (2026-11-13): web build on all five apps; Playwright smoke PASS for all five (hubs skip the Settings check). Real bugs fixed on the way: daily release never ran, Craft year picker range, Champion packs asset line.
- #150 DONE; web smoke PASS for all five. Owner (2026-11-13) replaced the per-game web design with ONE studio-level workflow, `deploy-to-vps-as-web` (see `docs/DEPLOY-TO-VPS-AS-WEB.md`). The per-game `web-vps.yml` files are removed. The VPS is owner only; Claude may run a `dry_run` build-only run if asked. The `games-web` submodule (ya-spark/games-web) was added by the owner.
- Screenshots: last, when the owner says.

## Next (post in this order, as dependencies finish)
1. Screenshots: owner wants them once, at the very end after #145, #146 and #148 are done (2026-11-12). Method below.
2. Issue 10 (purchase check on the VPS): only after the owner has set up VPS and Cloudflare.

## Done
Workflow streamlining (2026-11-13): clear names, shared pipelines in game-factory with thin callers in the five new apps and the template, per-game web-vps removed, one `change-agent`, shared agent rules, issue handling in INBOX.md (see DECISIONS.md, "Workflow structure and names"). The three older games were converted too (owner, 2026-11-13).
Privacy pages in ya-spark/public for Craft Scout, Craft Champion and Mind Presto (copied from each app's store policy; index lists all eight games). #145 (game_challenges moved to core/retention; all four generated audiences pass); #146 Ranger four minigames registered; #147 Science cancelled by owner. Design phase and Figma file; factory 1A to 1D, 2A, 2B1, 2B2; minigames M1 to M4b; five apps generated (#113 to #117, #121,
#122, #130, #131); content Scout Years 0 to 6 (70 packs), Ranger Years 7 to 10 (40), Champion Years 11 to 12 (20);
hub sync script and Block Puzzle, Blockfall (#120, #129), Wingy (#133); Ember Sudoku, Solitaire, Ball sort (#134), Mahjong, Merge (#135); Presto Snake, Brick breaker, Stack tower, Runner (#136); hubs no longer learning apps (#137, art left to #138);
Craft screen fixes (#132); engine lock fixes, engine.exclude, hubs and Craft apps synced (#142 to #144); hub art and game-based challenges (#138); Craft Settings and Parent area (#139); Craft Challenges payouts (#140); AppImage loader in the template (#141; copying into the five apps left for regeneration).

## Backlog (owner to think and decide; not for runs until moved to "Next")
- **Purchased coins after a reinstall (2026-11-13).** Today coins are one local number in the save. Coin packs are
  consumables, `deliverPurchase` skips restored consumables, and there is no purchase or spend record. A reinstall
  therefore loses the balance unless the save is restored some other way. Play Games cloud save is off, and Scout and
  Ranger players are under 13 (check the Play policy on saved games for children's profiles). No backend allowed.
  Options: (1) configure and test Android Auto Backup (no `allowBackup` setting exists today); (2) recovery code in the
  Parent area (signed save export and import); (3) purchase and spend ledger in the save with a "bought, spent,
  remaining" view for parents; (4) make coins matter less (minigame unlocks and shop items restorable, balance rebuyable).
  Leaning: 1 plus 3 first, 2 later. Decision needed: should coins survive a reinstall at all?

## Backlog: games-web (owner, 2026-11-14; later, after the owner connects the repo)
- **Move the web code into `ya-spark/games-web`.** Owner: that repo is supposed to hold the games' web code. Today the web code lives in game-factory (`template/.../lib/core/platform/*_web.dart`, `web/`, `web_shell.py`)
  and is copied into each app (#149, #150, #159 X2a); the deploy workflow `deploy-to-vps-as-web` and `scripts/deploy.sh` build each `apps/game-*` main and do not read `games-web`. `games-web` is a submodule of
  `game-studio` pinned at ca856a3 and has not been read in a session. Not started: the owner connects the repo first, then Claude READS it before any change, then a plan decides what moves (web platform
  stubs, web shell, AdSense code from X2b, per-app `web/` files, the deploy path) and what the deploy workflow reads. Until then X2a and X2b keep the web code where it is; if the owner wants X2b to wait for
  this move, say so before X2b is posted. Open questions for the owner: what the repo already contains; whether it replaces the per-app web files or only the deploy side; whether the three older games' web builds
  move into it too.

## Feature backlog (owner picked these, 2026-11-13; order and go-ahead still to be decided, not for runs)
Craft apps (Scout, Ranger, Champion):
- **C1 Mistakes notebook**: DONE as #154 (2026-11-13; game-factory acd70de, cf12881, Scout d464641, Ranger 0ddfd04, Champion cc39ca7, pins 0bcfb42; CI generator job not run; Ranger and Champion round is multiple-choice only). Was: a Practise my mistakes round (quiz; Flash review for Scout's younger level), mistakes clear after two correct answers in a row, `lastSeenDay` added for C2. Small.
- **C2 Spaced repetition** (DONE as #155, 2026-11-14: game-factory 7c7df3b, Scout 522aa9d, Ranger 5cafd85, Champion aedd9e7, pins a8d905e; save v6; CI generator job not run; the apps' engine lock is behind the template after #158's engine commits, re-run `sync_engine.py`; was POSTED as #155; decisions made 2026-11-13): every answered item gets a
  `box` 0 to 4 (correct +1, wrong back to 0; moves at most once a day). Due when `today - lastSeenDay >= [1, 3, 7, 21, 45]` days by box (separate
  field, not the #154 streak). Old saves: box from `passes` and `lastCorrect` (wrong 0, passed 1). #154's round becomes ONE merged "Today's review"
  entry: due items first (mistakes first, then most overdue), 10 per round, Home count capped at 20, calm "Nothing due today" at 0, Flash review cards
  for Scout's younger level. The "Revise your mistakes" challenge counts due items answered right. Parent area switch to turn it off (default on).
  Clock back: nothing due; clock forward: the cap handles it. Update SPEC.md with exact values. Medium.
- **C3 Parent progress report** (POSTED as #160, 2026-11-14; decisions made 2026-11-13; was: post after C2, they touch `child_profile.dart` and the Parent area): today `ChildReport`
  shows this-week time plus ALL-TIME topic count and accuracy under a "This week" heading, with no history, weak spots or sharing. Scope: an 8-week
  per-child daily activity log on device (answers, correct, newly passed, topic keys; migration, old saves start empty); report sections this week vs last
  week (time, answers, accuracy, newly passed, days-in-a-row), strongest topics (mastered), "Needs attention" (up to 3 topics with most mistakes, each
  linking to practise); calm wording, no comparison between children. "Share this week's summary" as plain text through the system share sheet (new
  `ShareService.shareText`; the app sends nothing itself). Nickname in the shared text: default OFF in Scout and Ranger, ON in Champion, with a switch.
  Pure-Dart `ProgressReport` in `lib/engine/`, behind the parent gate, SPEC.md updated with exact values. Out of scope: CSV or PDF export, per-question
  detail, the mastery map (C5). Medium.
- **C4 Goals and gentle reminders** (PLANNED, decisions made 2026-11-13; post after C3, they touch `settings_screen.dart`, `parent_area_screen.dart` and the save):
  today one device-wide repeating "Daily reminder" (fixed text, child-reachable Settings, no skip when the goal is met, never stops) and fixed
  goals in app config. Scope: Parent area (behind the gate) gets "Goals and reminders". Goals per child, presets Light, Steady, Big = 3, 5, 8
  items a day and 15, 25, 40 a week (Steady = today's values); coin payouts unchanged and still under the weekly coin cap. Reminders per device:
  switch, time (07:00 to 20:00 in child apps), days of the week; system permission asked when the parent turns it on (Android 13+), a calm note
  if denied. `NotificationService` gains scheduled-at-time with an id: schedule the next 7 days as one-offs, reschedule on app open and close,
  cancel today's once the daily goal is met, stop silently after 3 days without opening (next open restores). 3 or 4 neutral rotating texts: no
  streak-loss wording, no coins, no nickname, no due counts. Verify the Android boot receiver is declared (only POST_NOTIFICATIONS found), add it
  if missing; no new permission. Scout and Ranger: the Settings reminder row moves into the Parent area; Champion keeps its Settings switch too.
  Web unchanged (reminders do nothing). Pure-Dart schedule builder in `lib/engine/` with an injected clock, test IDs, SPEC.md exact values. Out
  of scope: push, server anything, topic or due-item reminders, exact alarms. Small to medium.
- **C5 Mastery map per topic** (POSTED as #161, 12:25 pm AEDT 14 Nov 2026; decisions made 2026-11-13; was: post after C2 so the revise badge counts due items; it only reads progress, no new save
  fields): today Study mode shows a flat card list sorted by year then alphabetically by topic id, only topics with open items, and `topics.yaml` has no
  order or prerequisites. Scope: a "Map" page in Study mode next to Learn, Progress and Revise, with a Maths and English switch, a path of topic nodes
  for the child's year (year switch lists only years with content, `contentYears()`). Node order is the order in `topics.yaml`, documented there as the
  teaching order, covered by a test and added to the owner's content review. States, each with its own icon and text (never colour alone): Not open yet
  (dimmed, "Opens as you go", tappable, just explains), Learning, Getting there, Mastered (existing rule, three pips), and a "Ready to revise" badge with
  the topic's mistakes (plus due items after C2). Nothing is locked; any open topic starts practice. Tapping a node opens a sheet: progress, mastery,
  revise count, accuracy (not Scout), buttons Practise and Revise this topic (only when there is something to revise). Winding vertical path, original
  shapes and icons, no people; bigger nodes for Scout and Ranger; ordered-list semantics for screen readers, 150 percent text, reduce motion, contrast 4.5
  to 1. Pure-Dart `TopicMap` in `lib/engine/`, test IDs, SPEC.md exact values. Out of scope: locking or prerequisites, a Game-mode map, animation beyond
  a pip fill, new content, changing mastery thresholds. Medium.
- **C7 Exam-style practice (Champion)** (PLANNED, decisions made 2026-11-13; post after C5, it touches `study_tab.dart` like C5 and the child profile like C3):
  today Champion has Quick quiz only (10 items, instant feedback, untimed in Study mode) and items come only from the open pool (daily release). Scope: "Exam practice"
  in Study mode. Setup: subject, topic or mixed, 10, 20 or 30 questions (capped by open items; under 10 open: "Open a few more questions first" with a link to
  practice), 10, 20 or 30 minutes or no timer. Exam screen: one overall countdown, no feedback while answering, previous and next, a grid of answered, skipped
  and flagged questions, Flag, submit confirmation listing unanswered, auto-submit at time up. Results: score and percent, time used, per-topic breakdown,
  review of every question (student answer, correct answer, explanation), links to practise the weakest topics. Study mode only: no coins or stars, but
  answers update accuracy, passes and mistakes like a quiz round (feeds C1 and C2); unanswered questions are not recorded as wrong. Last 10 exams per child on
  device (date, subject, count, score, seconds; save migration, old saves start empty) with a trend on the Progress page. Timer counts in-app time only
  (pauses in the background); "Extra time" none, +25 percent, +50 percent in the Parent area behind the gate. Calm wording, no rankings. v1 item types:
  multiple choice (incl. true or false) and numeric only. Config flag `exam_practice.enabled`: on for Champion, off for Scout, Ranger and the Mind hubs. Pure-Dart
  `ExamSession` in `lib/engine/` with injected clock and random; the quiz item widgets show feedback at once, so the run wraps or reuses them to return an answer
  without feedback (the main work). Test IDs, Champion SPEC.md exact values. Out of scope: coins, stars, leaderboards, sharing results (C3), Game mode, new
  content, other item types. Medium to large.
- **C8 Family mode** (DONE as #158, 12:17 pm AEDT 14 Nov 2026: game-factory 8c60812, eda902c, 429d10d, Scout 77bb4f5, Ranger e07d027, Champion cdb82f7, pins 882ebee; generator unittests not re-run after the final rebase, `no_secrets_check`, `network_safety_check`, `check_asset_licenses` not run, CI generator job not run; was POSTED as #158; decisions made 2026-11-13; independent of C1 to C7, no new save fields; put after C7): today Tug of war is single player
  (child against "the quiz"), mcq only, Game mode only, coin-locked at 200 as a device-wide unlock, Scout from Year 3, younger and older levels. Scope: a
  "Play with a sibling" button on the Tug of war start screen, shown only when the game is unlocked and at least two profiles on the device are eligible;
  second-player picker lists the other eligible profiles. Turn-based, pass the device: players alternate, each turn is one mcq from that player's OWN open
  items (own year), a right answer pulls the rope one step toward that player; between turns a "Pass to <nickname>" screen with the next avatar and an
  "I'm ready" button hides the question. First to win 2 rounds (a round ends when the rope reaches an end); subject (Maths or English) chosen jointly. Fair
  settings: if either player would get the younger level, the gentler rules apply to both (no timer, a wrong answer never pulls back). Each answer is
  recorded to its own profile as in solo play (accuracy, first-pass stars, mistakes, normal capped coin trickle); NO winner bonus, no extra stars, no new
  price (needs Tug of war unlocked, both players eligible). Play time is credited to the player whose turn it is (small `ProfileStore` addition; today it
  counts the active child only). Calm wording, never labels a loser. Screen reader announces whose turn it is, 150 percent text, reduce motion, test IDs.
  Config flag `family_mode.enabled`: on for Scout, Ranger and Champion. Pure-Dart `FamilyTugRun` in `lib/engine/` reusing `TugOfWarRun`, two
  `QuizSession`s (one per child), SPEC.md exact values. Out of scope: simultaneous split-screen (maybe a tablet follow-up), online play, other
  minigames, winner prizes, changing the 200-coin price. Small to medium.
Mind apps (Ember, Presto):
- **M1 Daily puzzle** (POSTED as #156, 2026-11-14; decisions made 2026-11-13; Mind Ember only in v1, repo `game-mind-1`; do BEFORE M3 and M2, they touch the same puzzle screens and M2 reuses its
  history): today the Games tab only puts a "Daily" badge on one tile (`today % playable games`), with no special puzzle and no completion record; the play-day streak,
  game challenges and daily reward already exist. Scope: one daily puzzle from a day seed (local calendar date, so everyone on the same date gets the same puzzle; no
  server, no leaderboard). Ember's four puzzle games rotate by day (Sudoku, Ball sort, Solitaire, Mahjong); difficulty by weekday mapped to each game's own levels
  (easy early in the week, hardest at the weekend); Merge and Presto's arcade games are out of v1. A "Today's puzzle" card at the top of the Games tab replaces the
  Daily badge: game, difficulty, Play or Solved with time, streak, 7-day strip of solved days (shapes only, no people). Solved = the game's own win condition; leaving
  mid-puzzle keeps the existing autosave and resumes the same day; unfinished expires at the end of the day (no archive, no catch-up). Save: today's record (day, game,
  status, seconds, mistakes), streak and best streak, 30-day history of solves (migration, old saves start empty; M2 reuses it). Separate daily-puzzle streak that resets
  after a missed day, best streak kept, plus a calm "Solved this month" count; no streak freeze in v1. Reward: 15 coins on the first solve each day, +30 on every 7th
  consecutive day, once a day; no new ad placements (existing pacing applies). The Mind hubs' daily reminder text becomes "Today's puzzle is ready." Clock guard: a
  solved day is keyed by day, so moving the clock back cannot re-award it. Pure-Dart `DailyPuzzle` (seed, game and difficulty by day, streak update, injected clock) in
  Ember's hub files; each of the four puzzle screens gets an entry point (start from a given seed and difficulty, report solved with time and mistakes). The run must
  prove each generator gives the same puzzle for the same seed and that every daily deal is solvable (search over 30 seeds per game, like the existing specs). Test IDs,
  SPEC.md exact values. Out of scope: Merge, Presto's games (a Runner "daily run" later), archive, leaderboards or sharing, streak freezes, new ad placements. Small to medium.
- **M2 Personal bests and stats** (PLANNED, decisions made 2026-11-13; both Mind hubs; do AFTER M1 (reuses its daily-puzzle history and the solved callback) and BEFORE M3
  and M6): today the hub keeps only a best score and a `passed` count per game (`GameStat`), `LifetimeStats` are block-game counters, games report a score only (no time,
  win, mistakes or difficulty) and there is no stats screen; the copied games (Block Puzzle, Blockfall, Wingy) can only be reached through their `host/` adapters. Scope: one
  richer report per finished run (game id, score, won, active seconds, mistakes where the game has them, variant such as Sudoku Hard) next to the existing score call. Per game,
  on device: plays, wins and win rate where a game has wins, best score, average of the last 20 plays, fastest solve per variant (puzzles), active time, last played day, last 20
  runs (day, score, seconds, won). Timer rule shared with M1: active seconds count only in the foreground, a resumed puzzle continues from its saved seconds, measured by the hub
  so no game needs its own timer. Copied games get plays, best, average and host-measured time only. A Stats page opened from the Challenges tab (new section next to achievements,
  not a new bottom tab): overview (time played this week and total, days played, daily puzzles solved and best daily streak from M1) and one card per game with a small trend
  line drawn in code plus a text equivalent for screen readers. A calm one-line "New personal best" message at hub level when a best score or fastest time improves. "Reset game
  stats" in Settings with a confirm: clears history, averages and times; keeps tile bests, coins and achievements. Device-only, no sharing in v1; elapsed time clamped at zero if the
  clock moves back. Built in the factory template (stats rules, save addition with migration, report hook, Stats page, flag `game_stats.enabled`: on for Mind Ember and Mind
  Presto, off for the Craft apps) and synced to both hubs through `engine.lock`; then each hub-native game screen reports time, wins and mistakes (Ember: Sudoku, Solitaire, Ball
  sort, Mahjong, Merge; Presto: its four arcade games, confirm the screens follow the same score pattern) and the host adapters report the copied games. Test IDs, both hubs'
  SPEC.md exact values. Out of scope: sharing or export, leaderboards, comparisons, cloud sync of stats, any Craft app. Small to medium.
- **M3 Difficulty and hints** (PLANNED, decisions made 2026-11-13; Mind Ember only, repo `game-mind-1`, hub-native games, no factory change; do AFTER M1 and M2): Ember's spec
  already has Sudoku levels by clue count (Easy 40, Medium 34, Hard 30, Expert 26) with 3 fill-in hints, and Mahjong with nine small layouts (24 to 34 tiles), a hint (-40) and a shuffle (-80);
  Solitaire has Draw one or three and a "Winnable deals" switch but NO levels and NO hint. Scope: Solitaire levels as presets (Easy: draw one, winnable, 3 hints, win bonus 300; Medium:
  draw one, plain shuffle, 3 hints, 500; Hard: draw three, winnable, 1 hint, 800; Expert: draw three, plain shuffle, no hints, 1200); the win bonus replaces today's flat 500, stars stay
  500, 1000, 1500; the Draw and Winnable switches stay under "Custom". Solitaire hint: pure-Dart best-move finder (foundation, then turn a face-down card, then king to an empty column,
  then other column moves, then draw from the stock), highlights source and target, says so when nothing useful exists, costs 10 points (never below 0). Sudoku stepped hint: first
  highlight where to look (free), then explain in words, e.g. "Only one place for 7 in this row" (free), then fill the digit (counts as one of the 3 hints, -100 as today); v1 explains
  naked and hidden singles only, harder puzzles fall back to the reveal; levels stay by clue count. Mahjong tiers: Easy = today's layouts, unlimited hints at -40, as now; Medium = today's
  layouts, 3 hints, 2 shuffles; Hard = new layouts of about 48 to 64 tiles, 3 hints, 1 shuffle; Expert = new layouts up to about 72 tiles, 1 hint, 1 shuffle; solvable by construction,
  each layout proven by search over 25 seeds; tiles at least 40 dp or the board scrolls. A per-game "Hints" on/off switch in all three menus (default on; off hides the hint button, no
  scoring change). M2's variant labels use the new level names; M1's weekday mapping for Solitaire and Mahjong is updated to the new levels in the same commit. Old saved menu choices
  (draw, winnable, layout) map to a level on first load. Pure-Dart `SolitaireLevel`, hint finder and `SudokuHintStep` rules with injected randomness; test IDs; SPEC.md 4.2, 4.3 and 4.5
  exact values. Out of scope: technique-based Sudoku grading (pairs, X-wing), hints for Ball sort or Merge, rewarded-ad hints (the only rewarded placement stays the Continue), Presto,
  profile save changes. Medium.
- **M4 Themes and sound packs bought with coins** (POSTED as #157, 2026-11-14; STEP 1 DONE: game-factory 18ce35b, Scout 05a0408, Ranger 5990ed7, Champion 86b831b, Ember 3be4ebf, Presto bc8941d, themes apply and cost 60; steps 2 to 4 not done, `@claude Please continue` commented 2026-11-14; decisions made 2026-11-14; factory template first, then synced to all five apps; new content for the Mind hubs only; independent of M1 to
  M3, no profile save migration): FOUND: the shop already sells colour themes (Sunset, Forest, Ocean at 50) and stores `colorTheme` on the profile, but nothing reads it, so a bought theme changes no
  colours (checked in Ember and Scout; the Craft apps share the same shop code). DECISIONS.md says a colour theme costs 60 and an avatar 40; the code charges 50 for themes. Step 1 (all five apps, factory
  template): apply the active player's equipped theme (seed colour plus light or dark) when the app builds its colour scheme, the design system recomputes from it, scene art unchanged; a test checks
  contrast (text and button, at least 4.5 to 1) for every theme; correct the three existing themes to 60. Step 2 (Mind hubs): four new themes beside Classic, Sunset, Forest and Ocean (for example
  Midnight (dark), Lavender, Sand, Slate), 60 coins each; the Craft apps keep their four. Step 3 (Mind hubs): four new ambience packs (for example Rain, Waves, Forest wind, Fireplace), 80 coins each;
  the five existing loops stay free; owned packs appear in the Settings ambience list, locked ones show a lock and "Get it in the Shop"; a saved ambience that is not owned falls back to the default;
  new Shop section "Sounds". Voice and sound-effect packs are out of v1. Step 4: preview before buying: a sheet with swatches and a small sample (card and button in that theme) with Buy or Use; a
  10-second sample button for sound packs (new preview call on `AudioService`; the vendor audio package stays in its one implementation file). Save: no migration; new items reuse `ownedItems` (a new
  `sound` kind) and the existing `ambience` setting. Audio: the run makes four original loops (mono, about 64 kbps like the existing ones) and logs each in `assets/LICENSES.md` (made by a script, or
  from a source whose licence allows it); if a pack cannot be made to a good standard it ships fewer and says so; the OWNER REVIEWS the sound before release. Flags `shop.extra_themes` and
  `shop.sound_packs`: on for Mind Ember and Mind Presto, off for the Craft apps. Test IDs on every control, both hubs' SPEC.md (Shop and prices) exact values. Out of scope: real-money items, avatar
  changes, voice packs, sound-effect packs, new art beyond theme swatches, Craft content. Medium. Step 1 could also go out alone as a small fix (nothing is released yet).
- **M5 Zen mode** (PLANNED, decisions made 2026-11-14; Mind Ember only, repo `game-mind-1`; do AFTER M1, M2 and M3: needs M3's hints, M2's run report and M1's daily puzzle, and touches the same five
  puzzle screens; M7 must skip Zen runs): Ember's five hub-native games (Sudoku, Solitaire, Ball sort, Mahjong, Merge) are already calm and untimed, Merge has Relaxed, and ads never show in play
  (banners only on the menu and results, no interstitials; the rewarded Continue exists only in the copied block games). What still shows: scores, move and mistake counters, stars, "Best N", coin and
  best-score messages, voice cues, vibration, tips, and (after M2) "New personal best". Scope: a Zen switch in Settings plus a quick leaf toggle in the Games tab top bar; remembered across launches;
  applies to the next game started. In the five native games Zen shows NO score, move count, mistake count, stars, best, coin messages or personal-best messages during play or on results (results say
  "Finished. Well played."); no timer anywhere; Merge always Relaxed; UNLIMITED FREE hints (Sudoku, Mahjong, and the Solitaire hint from M3); no tips dialogs, no voice cues, no vibration; the player's
  chosen ambience still plays (Off stays Off); reduce motion on; ads unchanged. The quiet settings apply for the run only and never overwrite the player's saved volume, voice or vibration choices.
  Counted in Zen: plays, solves, active time, the daily puzzle (M1) and its streak, the play-day streak, the "play N different games" challenge. NOT counted: scores, stars, best scores, fastest-solve records,
  the "score points" challenge, leaderboards (M7), because unlimited hints and endless Merge are not comparable with normal runs. Nothing is lost by choosing Zen: earned progress and coins show later in
  Challenges and Stats. The three copied games (Block Puzzle, Blockfall, Wingy) and Mind Presto play as usual, with a one-line note on their menus: "Zen mode: this game plays as usual". Pure-Dart rules for
  what a Zen run records (a Zen flag on M2's run report); config flag `zen_mode.enabled`: on for Mind Ember, off for Mind Presto and the Craft apps; test IDs on every new control; Ember SPEC.md gets a Zen
  section with exact values. Out of scope: Presto, the copied games, a zen-only game, new ambience (M4), "take a break" nudges, changes to ad placements. Small to medium.
- **M6 Achievements (local)** (PLANNED, decisions made 2026-11-14; both Mind hubs; do AFTER M1, M2 and M3, best after M4 and M5 too; independent of M7): FOUND: the engine has 9 achievements (First Steps,
  Regular, Line Cleaner, Line Master, Four Digits, High Roller, Combo Starter, Builder, Week Warrior; 25 to 250 coins) built on block-game counters; only Block Puzzle and Blockfall call `recordGameFinished`, so
  Sudoku, Solitaire, Ball sort, Mahjong and Merge never count (not traced: whether the copied games' adapters feed the hub's counters); and the shipped hub never shows achievements: the list lives on the old
  `ChallengesScreen`, reached only from the legacy `HomeScreen`, while `AppShell` and its Challenges tab have none. IDs are the key for a possible Play Games mapping, so they stay stable. Scope: a data-driven
  catalogue (an id, title, description, stat metric, target and tier) reading M2's per-game stats and M1's history; the 9 existing IDs untouched; about 30 for Ember in groups: Getting started (first game, try N
  different games, first win, first daily puzzle), Puzzles solved (Sudoku 1, 10, 50 and an Expert solve, Solitaire wins, Mahjong clears, Ball sort levels 10, 50, 100, a Merge stage milestone), Skill (clean win
  with no mistakes and no hints, fast solve per game; the M2 run report gains a hints count), Habit (daily-puzzle streaks 3, 7, 30; daily puzzles solved 10, 50, 100; days played 10, 50, 100; the existing 7-day
  streak), Collection (own N shop items, unlock a coin-locked game). Mind Presto: the generic ones plus auto-generated per-game ones (first play, 10 plays, best score reaching 3 stars). Craft apps excluded.
  Rewards: coin tiers 25, 50, 100, 250, paid once and automatically at unlock. A calm message on the results screen when a run unlocks something, never mid-play; in Zen (M5) the message is held back and shows
  later as a "New" marker; Zen counts only plays, solves, time, the daily puzzle and streaks, so score, speed and clean-run achievements do not progress in Zen. A new Achievements page reached from the
  Challenges tab, grouped by category, each row with progress ("7 of 10") including locked ones; a "New" dot on the Challenges tab for unseen unlocks; the existing share button and share card stay. At first
  start after the update, achievements already earned by old data unlock together with one summary message and their coins. Save: `unlockedAchievements` stays; a small `seenAchievements` set is added (old saves
  start empty). Pure-Dart catalogue and evaluator, test IDs, both hubs' SPEC.md get the full list and exact values; calm adult wording, shapes only, no people. Out of scope: Play Games achievement sync (M7 may use
  the stable IDs later), Craft apps, secret achievements, time-limited events, sharing beyond the existing card. Medium.
- **M7 Play Games leaderboards (optional, adults only)** (PLANNED, decisions made 2026-11-14; Mind Ember and Mind Presto; do AFTER M2 (Stats page entry) and M5 (Zen flag), ideally after M6 (stable
  achievement IDs); cannot be tested on a device until the owner does the Play Console steps below): FOUND: the optional Play Games sign-in row in Settings, `LeaderboardService`
  (`submitScore`, `showLeaderboard`, `unlockAchievement`, `showAchievements`) and `PlayGamesLeaderboardService` (best effort, always writes to a local fallback) exist, `play_games.enabled` is `false`;
  `app.config.yaml` has only ONE slot (`leaderboard_high_score`) and after sign-in the hub submits one overall best score; Ember's spec says "No Play Games leaderboard from the hub for these games" and
  Presto's section 9 says "A leaderboard per game later; IDs go in `app.config.yaml`"; the three copied games stub `submitScore` as a no-op in `host/services.dart`; hub-native games report a score to the hub
  but submit nothing per game. Scope: ONE leaderboard per game, IDs in `app.config.yaml` as a map from game id to Play leaderboard ID (public IDs; a game with no ID submits nothing). Ember: Sudoku, Solitaire,
  Ball sort, Mahjong, Merge (Classic only, Relaxed has no game over) plus Block Puzzle, Blockfall and Wingy through their host adapters (synced code untouched). Presto: Snake, Brick breaker, Stack tower,
  Runner plus the copied games it hosts. Submit after a finished run only when the score is a new personal best on the device and the player is signed in; failures are silent and every write goes to the
  local fallback first; Zen runs (M5) NEVER submit; on first sign-in submit all current bests once (replaces the single overall submit). Entries: a "See leaderboard" trophy on each game's results screen
  (only when signed in), a row on the Stats page (M2), the existing Settings row; no nagging, signed out shows one line "Sign in to see leaderboards" inside those entries only. Optional achievements
  mirror: a config mapping from M6's stable achievement IDs to Play achievement IDs, off by default until the owner picks which to mirror (Play Console limits apply); the existing `unlockAchievement` is used.
  Update each hub's `store/google-play/privacy_policy.md` and `data_safety.md` drafts and the matching page in `public/` if it exists (signing in submits scores and a player ID to Google), and replace the
  specs' "no leaderboard" lines with the real behaviour. Web unchanged. Pure-Dart `LeaderboardPlan` (which games submit, new-best rule, sign-in catch-up) behind the existing interface; `play_games.enabled`
  stays `false` in the repo; fake-service tests per rule; test IDs; both hubs' SPEC.md exact values. Out of scope: Craft apps, the daily puzzle (M1), a Play daily or weekly puzzle board (Play's time
  windows follow its own clock, not the local date), anti-cheat (client trusted, no backend), friends, challenges, cloud-save changes. Medium.
Cross-cutting:
- **X2 Web version of the apps, funded by AdSense** (PLANNED, decisions made 2026-11-14, split into two issues; nothing goes live until the owner steps below are done). FOUND: the web copy is a UAT
  copy behind Caddy basic auth (`platforms.web.enabled: false`, DECISIONS says "test harness only"); `platform_services_web.dart` stubs ads, purchases, notifications and Play Games; the page title still says
  "Web test copy of the Android game."; saves use fixed `shared_preferences` keys (`save.json`, `save.backup.json`, `lb.*`, `ach.*`) with NO per-game prefix, and every game is served from the same origin
  (`activemindcraft.com/appgames/<name>/`), so games in one browser most likely OVERWRITE each other's saves (code reading only, not run; check whether the three older games' web builds use the same
  keys, they are outside this change). Owner direction: the web save stays in the browser and is never moved to or from the Android app; the web copy earns from ads only (AdSense, IDs added later by the
  owner). Owner decision 2026-11-14 (option B): AdSense on ALL FIVE apps for v1, child-directed apps tagged: Scout and Ranger `CHILD`, Champion `TEEN`, Mind Ember and Mind Presto no child tag; Google's age
  tag is TFAT (`data-tag-for-age-treatment`, replaces the deprecated TFCD and TFUA, announced May 2026); child and teen treatment means non-personalised ads only. Scout is included (owner confirmed, 2026-11-14).
  **X2a (POSTED as #159, 2026-11-14; independent, worth doing even for the test copies; medium; game-factory then the five apps):** (1) per-game storage namespace on web: set the prefix from the app id before first
  use, native unchanged; (2) Settings note on web: "Progress is saved in this browser only. Clearing site data, or using another browser or device, starts fresh. The Android app keeps its own save."; no
  sync; (3) hide real-money items on web (no coin packs, no Remove Ads) instead of today's "not available" message; (4) public-ready page: real title and description per game, social preview tags,
  "Get the Android app" link read from config (empty until live), loading screen, `platforms.web.enabled: true` for the five apps. **X2b (after X2a; medium):** AdSense behind the existing `AdService`
  interface: a web implementation chosen by conditional import in `lib/core/platform/` using `dart:js_interop`, the vendor script only there and in a build-time `index.html` injection; placements `menu`,
  `pre_game`, `post_game` ONLY, banner or display units in a slot outside the Flutter canvas (`HtmlElementView`), never in play, none near game controls, no interstitials, no rewarded ads (no Continue on
  web). Config: an `adsense:` section in `app.config.yaml` (`enabled: false`, placeholder publisher and slot ids, test-mode flag giving `data-adtest="on"` in non-release builds, `age_treatment: child|teen|none`
  per audience profile); the script tag is injected only when enabled AND a real publisher id is present, so repo builds stay ad-free; real ids are added by the owner only and never committed by Claude.
  Checks: `scripts/ad_safety_check.sh` rejects a real AdSense publisher id in the repo; a compliance check FAILS CI if AdSense is enabled for a child or teen audience profile without the matching age
  treatment, and never allows personalised ads there. Consent: a web "Ad privacy choices" Settings row that reopens Google's consent dialog when present (the EEA and UK need a certified consent tool,
  set up in the AdSense account by the owner). Docs: a web section in each app's `store/google-play/privacy_policy.md` and the matching page in `public/` (AdSense cookies, local storage, ad treatment),
  `docs/DEPLOY-TO-VPS-AS-WEB.md`, SPEC.md of each app (web section). Out of scope: AdSense for Games or H5 rewarded and interstitial ads, cloud sync of the web save, real-money items on web, the three
  older games' code, any VPS, DNS, Caddy or Cloudflare change. Owner steps (not for runs): AdSense account and site approval (the site must be public with a privacy page); publish a consent message for
  the EEA and UK; `ads.txt` at the domain root; remove Caddy basic auth for the public games and decide the public URLs and any Cloudflare setup; put the publisher and slot ids in `app.config.yaml`; review
  the privacy text and the COPPA and local-law side (Claude has not assessed them); confirm Google's current child-directed AdSense policy page.
Not picked: C6 read-aloud and hints (read-aloud is already in issue 01c2), C9 content editor (editor type still unclear), X3 accessibility pass, X4 localisation.

## Owner items (not for runs)
- **Play Games for the Mind hubs (before M7 can go live, once per hub; steps in `game-factory/docs/PLAY_GAMES_SETUP.md`):** create the Play Games Services project and one leaderboard per game
  (integer, larger is better) plus the achievements to mirror; add credentials for the Play App Signing key and the upload key; add testers, then publish; put the IDs in `app.config.yaml` and set
  `play_games.enabled: true`; confirm the Data safety form lists Player ID and leaderboard scores.
Review content packs and each app's `docs/SPEC.md`; copy game-content workflows and add secrets; Cloudflare and VPS;
prices, AdMob, Play Console; name and trademark checks; set `CI_ENABLED` when CI should run.

## Screenshots without an emulator
Flutter 3.47.8 can be unpacked from `https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.8-stable.tar.xz`.
A temporary widget test (not committed) pumps `GameApp` with fake services, loads the app font and the SDK's
`MaterialIcons-Regular.otf`, builds a `LearningService` over `assets/content/` for Craft apps and calls
`refreshRelease`, then saves each tab through a `RepaintBoundary`. The web build does not start; use the test method.
