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
- **C4 Goals and gentle reminders**: parent sets a weekly goal, local notification at a chosen time, no pressure wording. Small.
- **C5 Mastery map per topic**: visual path of topics with stars and "ready to revise" markers. Medium; after C1 and C2.
- **C7 Exam-style practice (Champion)**: timed sets across a topic, result review with explanations. Medium.
- **C8 Family mode**: two siblings on one device in a tug-of-war round. Small.
Mind apps (Ember, Presto):
- **M1 Daily puzzle**: one puzzle a day seeded by the day, with a streak. Small.
- **M2 Personal bests and stats**: per-game best, average and streak on device. Small.
- **M3 Difficulty and hints** in Sudoku, Solitaire and Mahjong (easy to expert, optional hint). Medium.
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
