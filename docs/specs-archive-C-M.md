# Feature specs archive: C1 to C8 and M1 to M7

Verbatim text of the finished backlog items, moved out of `docs/FEATURE-SPECS.md` on 2026-11-21 to save tokens. Open it only when you need the detail of one of these items (grep for its id, for example `C3`). All are DONE or posted; the live items stay in `FEATURE-SPECS.md`.

- **C1 Mistakes notebook**: DONE as #154 (2026-11-13; game-factory acd70de, cf12881, Scout d464641, Ranger 0ddfd04, Champion cc39ca7, pins 0bcfb42; CI generator job not run; Ranger and Champion round is multiple-choice only). Was: a Practise my mistakes round (quiz; Flash review for Scout's younger level), mistakes clear after two correct answers in a row, `lastSeenDay` added for C2. Small.
- **C2 Spaced repetition** (DONE as #155, 2026-11-14: game-factory 7c7df3b, Scout 522aa9d, Ranger 5cafd85, Champion aedd9e7, pins a8d905e; save v6; CI generator job not run; the apps' engine lock is behind the template after #158's engine commits, re-run `sync_engine.py`; was POSTED as #155; decisions made 2026-11-13): every answered item gets a
  `box` 0 to 4 (correct +1, wrong back to 0; moves at most once a day). Due when `today - lastSeenDay >= [1, 3, 7, 21, 45]` days by box (separate
  field, not the #154 streak). Old saves: box from `passes` and `lastCorrect` (wrong 0, passed 1). #154's round becomes ONE merged "Today's review"
  entry: due items first (mistakes first, then most overdue), 10 per round, Home count capped at 20, calm "Nothing due today" at 0, Flash review cards
  for Scout's younger level. The "Revise your mistakes" challenge counts due items answered right. Parent area switch to turn it off (default on).
  Clock back: nothing due; clock forward: the cap handles it. Update SPEC.md with exact values. Medium.
- **C3 Parent progress report** (DONE as #160, 12:35 pm AEDT 14 Nov 2026: game-factory 662393d, d727dee, Scout 109683d, Ranger 7f100a0, Champion 8bb7888, pins 802ce31; save v7; Champion's full test suite was not re-run after its rebase onto #159, CI generator job not run; was POSTED as #160; decisions made 2026-11-13; was: post after C2, they touch `child_profile.dart` and the Parent area): today `ChildReport`
  shows this-week time plus ALL-TIME topic count and accuracy under a "This week" heading, with no history, weak spots or sharing. Scope: an 8-week
  per-child daily activity log on device (answers, correct, newly passed, topic keys; migration, old saves start empty); report sections this week vs last
  week (time, answers, accuracy, newly passed, days-in-a-row), strongest topics (mastered), "Needs attention" (up to 3 topics with most mistakes, each
  linking to practise); calm wording, no comparison between children. "Share this week's summary" as plain text through the system share sheet (new
  `ShareService.shareText`; the app sends nothing itself). Nickname in the shared text: default OFF in Scout and Ranger, ON in Champion, with a switch.
  Pure-Dart `ProgressReport` in `lib/engine/`, behind the parent gate, SPEC.md updated with exact values. Out of scope: CSV or PDF export, per-question
  detail, the mastery map (C5). Medium.
- **C4 Goals and gentle reminders** (DONE as #162, 8:26 pm AEDT 14 Nov 2026: game-factory 4c55725, Scout 7adefa5, Ranger 4c5b6a1, Champion f0d53de, pins 44a7309; save v8; boot receiver was already declared; real notification delivery untested on a device; a generated craft sample fails 2 `web_shell_test` tests that predate C4 (fix is in #164); was POSTED as #162; decisions made 2026-11-13; post after C3, they touch `settings_screen.dart`, `parent_area_screen.dart` and the save):
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
- **C5 Mastery map per topic** (DONE as #161, 8:10 pm AEDT 14 Nov 2026: game-factory 8252227, Scout 7147f3c, Ranger 1858e7d, Champion 6e4832d, pins eaf0adf; the Map opens from a "Topic map" card on Learn, not a fourth tab; each app's `topics.yaml` order now sets the path, OWNER to check topic order per year; not run on a device; was POSTED as #161; decisions made 2026-11-13; was: post after C2 so the revise badge counts due items; it only reads progress, no new save
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
- **C7 Exam-style practice (Champion)** (DONE as #163, 1:37 am AEDT 15 Nov 2026: game-factory cea45a9, 619df77, 3a78c4c, Champion 60baaa9 (save v9, flag on), Scout 109de24 and Ranger 6d48a3f (engine sync only), pins ed0ee74; CI generator job not run; ALL CRAFT ITEMS C1 to C5, C7, C8 ARE NOW DONE; was POSTED as #163; decisions made 2026-11-13; post after C5, it touches `study_tab.dart` like C5 and the child profile like C3):
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
- **M1 Daily puzzle** (DONE as #156, 8:11 pm AEDT 14 Nov 2026: game-mind-1 81ee9f1, a970cf9, 684a7ac, 7eaf7b9, pin 8b89b25; 754 tests; the card's tap-through from Play to a puzzle is not covered end to end by a widget test; CI generator job not run; was POSTED as #156; decisions made 2026-11-13; Mind Ember only in v1, repo `game-mind-1`; do BEFORE M3 and M2, they touch the same puzzle screens and M2 reuses its
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
- **M2 Personal bests and stats** (DONE as #166, 3:26 pm AEDT 15 Nov 2026: game-factory 3940a91, 8b8c5d1 (save v10, `lib/engine/stats/game_stats.dart`, `RunReportScope`, `StandaloneRun`, `ActiveTimeScope`, flag `game_stats.enabled`), Ember 332c3ae (save v10), Presto 8ce1a26 (save v9), Craft engine sync 89124ec, 667376c, c1caff9, pins 41cc2cc; a resumed non-daily puzzle is timed from when it is reopened; daily solves show only in the overview; CI generator job not run; was POSTED as #166, 1:52 am AEDT 15 Nov 2026; first run failed at start (usage limit), `@claude Please continue` at 2:52 pm AEDT 15 Nov; decisions made 2026-11-13; both Mind hubs; do AFTER M1 (reuses its daily-puzzle history and the solved callback) and BEFORE M3
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
- **M3 Difficulty and hints** (DONE as #168, 8:37 pm AEDT 15 Nov 2026: game-mind-1 bdc8653 (Solitaire), a Sudoku commit, 567bb16 (Mahjong), pins 26c465a, 6031d57, 7f5daf4; 917 tests; six new Mahjong layouts (Terrace 56, Castle 60, Mound 52, Fortress 72, Tower block 66, Brick wall 68 tiles); daily Solitaire uses only the winnable presets (Easy, Easy, Hard, Hard); daily Medium Mahjong plays the 5th smallest layout (the run's choice); CI generator job not run; was POSTED as #168, 3:58 pm AEDT 15 Nov 2026; decisions made 2026-11-13; Mind Ember only, repo `game-mind-1`, hub-native games, no factory change; do AFTER M1 and M2): Ember's spec
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
- **M4 Themes and sound packs bought with coins** (POSTED as #157, 2026-11-14; ALL STEPS DONE 12:31 pm AEDT 14 Nov 2026 (steps 2 to 4: game-factory 69adece, Ember f62c83d, Presto 9d4b3e9, pins 6fa8f06; themes Midnight, Lavender, Sand, Slate; packs Rain, Waves, Forest wind, Fireplace made by `scripts/make_ambience.py` from synthesised noise; OWNER MUST LISTEN to the four packs before any release; CI generator job not run). STEP 1: game-factory 18ce35b, Scout 05a0408, Ranger 5990ed7, Champion 86b831b, Ember 3be4ebf, Presto bc8941d, themes apply and cost 60; steps 2 to 4 not done, `@claude Please continue` commented 2026-11-14; decisions made 2026-11-14; factory template first, then synced to all five apps; new content for the Mind hubs only; independent of M1 to
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
- **M5 Zen mode** (DONE as #170, 8:57 pm AEDT 15 Nov 2026, game-mind-1 a822f33; was POSTED 8:50 pm; decisions made 2026-11-14; Mind Ember only, repo `game-mind-1`; do AFTER M1, M2 and M3: needs M3's hints, M2's run report and M1's daily puzzle, and touches the same five
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
- **M6 Achievements (local)** (POSTED as #171, 4:38 am AEDT 16 Nov 2026; was PLANNED, decisions made 2026-11-14; both Mind hubs; do AFTER M1, M2 and M3, best after M4 and M5 too; independent of M7): FOUND: the engine has 9 achievements (First Steps,
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
