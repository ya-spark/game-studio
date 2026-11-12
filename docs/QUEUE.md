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
prices, Cloudflare or the VPS (owner only). Do not touch the three old games' CI or code. No people in any art.
Content packs beyond Years 0 to 12 maths and English: owner says when. Issues come from `yaseengem` only.

## Active
- #142 Fix template-ci (generator tests, engine lock, emulator job)

## Next (post in this order, as dependencies finish)
1. Screenshots: only when the owner asks (do not re-render on your own). Method below.
6. Ranger registry: memory match, balloon pop, word builder, cloze fix are not offered (owner to say if wanted).
7. Issue 10 (purchase check on the VPS): only after the owner has set up VPS and Cloudflare.

## Done
Design phase and Figma file; factory 1A to 1D, 2A, 2B1, 2B2; minigames M1 to M4b; five apps generated (#113 to #117, #121,
#122, #130, #131); content Scout Years 0 to 6 (70 packs), Ranger Years 7 to 10 (40), Champion Years 11 to 12 (20);
hub sync script and Block Puzzle, Blockfall (#120, #129), Wingy (#133); Ember Sudoku, Solitaire, Ball sort (#134), Mahjong, Merge (#135); Presto Snake, Brick breaker, Stack tower, Runner (#136); hubs no longer learning apps (#137, art left to #138);
Craft screen fixes (#132); hub art and game-based challenges (#138); Craft Settings and Parent area (#139); Craft Challenges payouts (#140); AppImage loader in the template (#141; copying into the five apps left for regeneration).

## Owner items (not for runs)
Review content packs and each app's `docs/SPEC.md`; copy game-content workflows and add secrets; Cloudflare and VPS;
prices, AdMob, Play Console; name and trademark checks; set `CI_ENABLED` when CI should run.

## Screenshots without an emulator
Flutter 3.47.8 can be unpacked from `https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.8-stable.tar.xz`.
A temporary widget test (not committed) pumps `GameApp` with fake services, loads the app font and the SDK's
`MaterialIcons-Regular.otf`, builds a `LearningService` over `assets/content/` for Craft apps and calls
`refreshRelease`, then saves each tab through a `RepaintBoundary`. The web build does not start; use the test method.
