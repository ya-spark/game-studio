# [change] factory: Game and Study modes, navigation, screens and parent lock (issue 2B)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 2A done. Read `docs/DECISIONS.md` ("Design phase done"), `design/README.md` and `docs/DESIGN_SYSTEM.md` first.

## Goal
The Craft apps' Game and Study modes, the navigation, the screens in the Figma design and the parent lock; the Mind hubs' home. All built from the 2A shared widgets.

## Decisions already made (owner)
- Craft apps open in **Game mode** on first launch and then remember the last mode, per child. A mode toggle sits in the top bar on every screen. A parent can lock a child to one mode (behind the parent gate, with a lock icon while locked).
- Bottom bar changes with the mode: Game: Play, Challenges, Shop. Study: Learn, Progress, Revise. The Mind hubs have no modes (Games, Challenges, Shop).
- The interface level of Scout and Ranger follows the child's year level (Scout Foundation to Year 2 and Years 3 to 6; Ranger Years 7 to 8 and Years 9 to 10).
- Card content: Scout shows stars, bars and chips with no percentages; Ranger and Champion also show accuracy. Mastery levels Learning, Getting there, Mastered (rule in `design/tokens.json`, `mastery`). Pack cards show "Preview free" and a locked "Full pack" with no price; the price only appears behind the parent gate. A "try next" card tops Play and Learn.
- No human figures or faces in any art.

## Scope
- **Mode system:** Game and Study mode stored per child in the 1B profile; toggle in the top bar; parent lock and lock icon; the bottom bar and pages respond to the mode.
- **Game mode screens:** Play (the registered minigames; the hero, "try next", daily challenge and game tiles as in the design; shown only when enough items are open; coin-locked games show their price), Challenges (learning goals that pay stars and a few coins), Shop (avatars, colour themes and coin-locked games bought with coins; coin packs, Remove Ads and Full Unlock behind the parent gate; avatars are shapes, no people).
- **Study mode screens:** Learn (goal card, "try next", topics by year with progress, extra packs the parent has downloaded, pack cards), Progress (per topic: items passed, still to pass, next release, stars earned), Revise (the "revise mistakes" list). Untimed practice with explanations using the Quick quiz from 1C.
- **Data the cards need (new, keep it small and local):** per topic accuracy (correct over answers given), items passed per game and best score per game, the mastery level from the rule in the tokens, the topic with the most items to revise (for "try next"). Persist with the existing save service; no new services.
- **Mind hubs:** the home with hero, "continue" and the game tiles (stars, best score, coin price on locked games). Games and Challenges and Shop tabs.
- **Left over from 1C1** (the run reported these as not done): the Play tab and the game menu listing the games in the app's registry (locked games show their coin price and unlock with coins); registering Quick quiz and each app's games in its registry; routing the template's daily reward and daily challenges through `RewardsEngine.grantCapped` in the Craft apps (today they still pay uncapped). `ENGINE.md` notes this.
- **Screens not in Figma** (Shop, Challenges, Progress, Revise, parent area, settings) follow the same widgets and tokens; keep them simple and consistent.
- Test IDs for the toggle, the lock, the tabs and every new screen in `lib/ui/test_ids.dart`.
- **Docs:** `docs/DESIGN_SYSTEM.md` and the template `docs/SPEC.md` updated (modes, mastery, new data).

## Run discipline
Same as 2A: small steps, commit and push each passing step, move the pin, comment what remains if low on turns; workflow YAML goes in your final comment.

## Acceptance
All template checks pass. Tests: mode persistence per child; the lock blocks switching and shows its icon; the tab set changes with the mode; the level follows the year level (including a change of year); mastery levels computed by the rule; cards show accuracy only for Ranger and Champion; pack cards show no price; the Play tab lists registry games and locked games show price; daily reward and challenges are capped in the Craft apps; no layout overflow at 150 percent text on the main screens; screen-reader labels present.

## Out of scope
The real minigames (the app issues), real artwork beyond the design files, real AdMob IDs, any AI feature.
