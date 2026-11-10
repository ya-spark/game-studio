# [change] factory: Game and Study modes, parent lock, card data and Game mode screens (issue 2B1)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 2A (done: factory `0ce3043`, CI green; the theme system, tokens, shared widgets in `lib/ui/kit/`, the theme gallery and `docs/DESIGN_SYSTEM.md` exist). Read `docs/DECISIONS.md` ("Design phase done"), `template/flutter-game-template/design/README.md` and `docs/DESIGN_SYSTEM.md` first.
Part 1 of 2 of the old issue 2B (2B2 follows).

## Goal
The mode system with the parent lock, the new local data the cards need, the Game mode screens, and the 1C1 leftovers, all built from the 2A shared widgets.

## Decisions already made (owner)
- Craft apps open in **Game mode** on first launch and then remember the last mode, per child. A mode toggle sits in the top bar on every screen. A parent can lock a child to one mode (behind the parent gate, with a lock icon while locked).
- Bottom bar changes with the mode: Game: Play, Challenges, Shop. Study: Learn, Progress, Revise. The Mind hubs have no modes (Games, Challenges, Shop).
- The interface level of Scout and Ranger follows the child's year level (Scout Foundation to Year 2 and Years 3 to 6; Ranger Years 7 to 8 and Years 9 to 10).
- Card content: Scout shows stars, bars and chips with no percentages; Ranger and Champion also show accuracy. Mastery levels Learning, Getting there, Mastered (rule in `design/tokens.json`, `mastery`). Pack cards show "Preview free" and a locked "Full pack" with no price; the price only appears behind the parent gate. A "try next" card tops Play and Learn.
- No human figures or faces in any art.

## Scope
- **Mode system:** Game and Study mode stored per child in the 1B profile (default Game); the mode toggle in the top bar (the 2A top bar has a slot); the parent lock behind the parent gate with a lock icon while locked; the bottom bar and pages respond to the mode (Study screens come in 2B2: until then Study shows a simple "Learn" placeholder that lists topics).
- **Data the cards need (new, small and local):** per topic accuracy (correct over answers given), items passed per game and best score per game, the mastery level from the rule in `design/tokens.json`, the topic with the most items to revise (for "try next"). Persist with the existing save service; no new services. Pure Dart where possible, with tests.
- **Game mode screens:** Play (the registered minigames; the hero, "try next", daily challenge and game tiles as in the design; games shown only when enough items are open; coin-locked games show their price), Challenges (learning goals that pay stars and a few coins), Shop (avatars, colour themes and coin-locked games bought with coins; coin packs, Remove Ads and Full Unlock behind the parent gate; avatars are shapes, no people). Build them from the 2A widgets (game tile, suggested-next card, hero header, stat chips).
- **Left over from 1C1** (the run reported these as not done): the Play tab and the game menu listing the games in the app's registry (locked games show their coin price and unlock with coins); registering Quick quiz and each app's games in its registry; routing the template's daily reward and daily challenges through `RewardsEngine.grantCapped` in the Craft apps (today they still pay uncapped). `ENGINE.md` notes this.
- Test IDs for the toggle, the lock, the tabs and every new screen in `lib/ui/test_ids.dart`.

## Acceptance
All template checks pass and the factory CI is green on every sample. Tests: mode persistence per child; the lock blocks switching and shows its icon; the tab set changes with the mode; the level follows the year level (including a change of year); mastery levels computed by the rule; the Play tab lists registry games and locked games show their price; daily reward and challenges are capped in the Craft apps; no layout overflow at 150 percent text on the new screens; screen-reader labels present; no price on any content card.

## Out of scope
Study mode screens, the Mind home, docs updates beyond a note (2B2); the real minigames; real artwork beyond the design files; real AdMob IDs; any AI feature.

## Lessons from 2A (read these)
- 2A used up its turns before it could comment, and its CI was red on the generated sample games (craft and mind) until fixed by hand. Generated games run the same tests as the template: a test must not assume an app id, a mode or a file that a generated game may not carry (the template has all five designs; a generated game has only its own). The factory CI generates samples for puzzle, craft child, craft teen and mind and runs every test in each.
- Aim for at most 5 steps. After each step run `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test`, the template scripts and `python3 -m unittest discover -s scripts/tests`, then commit and push and move the pin. Do not push on red.
- Keep tests short and few per feature; write the final summary comment while you still have turns (about 15 turns before the end). If the work is not finished, comment exactly what is done and what remains.
- The `@claude` token cannot push `.github/workflows` files; put any workflow YAML in your final comment.
