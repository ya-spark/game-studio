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

## Feature backlog (owner picked these, 2026-11-13; order and go-ahead still to be decided, not for runs)
Craft apps (Scout, Ranger, Champion):
- **C1 Mistakes notebook**: POSTED as #154 (2026-11-13): a Practise my mistakes round (quiz; Flash review for Scout's younger level), mistakes clear after two correct answers in a row, `lastSeenDay` added for C2. Small.
- **C2 Spaced repetition** (PLANNED, decisions made 2026-11-13; post only after #154 is done, they share `ItemResult`): every answered item gets a
  `box` 0 to 4 (correct +1, wrong back to 0; moves at most once a day). Due when `today - lastSeenDay >= [1, 3, 7, 21, 45]` days by box (separate
  field, not the #154 streak). Old saves: box from `passes` and `lastCorrect` (wrong 0, passed 1). #154's round becomes ONE merged "Today's review"
  entry: due items first (mistakes first, then most overdue), 10 per round, Home count capped at 20, calm "Nothing due today" at 0, Flash review cards
  for Scout's younger level. The "Revise your mistakes" challenge counts due items answered right. Parent area switch to turn it off (default on).
  Clock back: nothing due; clock forward: the cap handles it. Update SPEC.md with exact values. Medium.
- **C3 Parent progress report** (PLANNED, decisions made 2026-11-13; post after C2, they touch `child_profile.dart` and the Parent area): today `ChildReport`
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
- **C5 Mastery map per topic** (PLANNED, decisions made 2026-11-13; post after C2 so the revise badge counts due items; it only reads progress, no new save
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
- **C8 Family mode** (PLANNED, decisions made 2026-11-13; independent of C1 to C7, no new save fields; put after C7): today Tug of war is single player
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
- **M1 Daily puzzle** (PLANNED, decisions made 2026-11-13; Mind Ember only in v1, repo `game-mind-1`; do BEFORE M3 and M2, they touch the same puzzle screens and M2 reuses its
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
- **M4 Themes and sound packs bought with coins**: extends the shop. Small.
- **M5 Zen mode**: no timer, no score, no ads during play (Ember's calm brand). Small.
- **M6 Achievements (local)**: badge list across all games. Medium.
- **M7 Optional Play Games leaderboards**: adults only (Mind apps), needs the owner's Play Games setup. Medium.
Cross-cutting:
- **X2 Web version of the apps**: the web builds exist (#149, #150). Direction (owner, 2026-11-13): the web save stays on the web and
  is never moved to or from the Android app; the web copy earns from ads only (Google AdSense, added later by the owner). Open
  points: AdSense is probably not allowed in the child-directed Scout and Ranger apps (check the policy), so those may need to stay
  ad-free on the web or use the child-safe path; web ads and purchases are honest stubs today; the AdService interface must hold
  the AdSense code (no vendor SDK in game or UI code).
Not picked: C6 read-aloud and hints (read-aloud is already in issue 01c2), C9 content editor (editor type still unclear), X3 accessibility pass, X4 localisation.

## Owner items (not for runs)
Review content packs and each app's `docs/SPEC.md`; copy game-content workflows and add secrets; Cloudflare and VPS;
prices, AdMob, Play Console; name and trademark checks; set `CI_ENABLED` when CI should run.

## Screenshots without an emulator
Flutter 3.47.8 can be unpacked from `https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.8-stable.tar.xz`.
A temporary widget test (not committed) pumps `GameApp` with fake services, loads the app font and the SDK's
`MaterialIcons-Regular.otf`, builds a `LearningService` over `assets/content/` for Craft apps and calls
`refreshRelease`, then saves each tab through a `RepaintBoundary`. The web build does not start; use the test method.
