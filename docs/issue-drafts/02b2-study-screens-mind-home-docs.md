# [change] factory: Study mode screens, Mind home and docs (issue 2B2)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 2A (done: factory `0ce3043`, CI green; the theme system, tokens, shared widgets in `lib/ui/kit/`, the theme gallery and `docs/DESIGN_SYSTEM.md` exist). Read `docs/DECISIONS.md` ("Design phase done"), `template/flutter-game-template/design/README.md` and `docs/DESIGN_SYSTEM.md` first.
Part 2 of 2 of the old issue 2B. **Depends on 2B1 being done** (modes, data, Game mode screens).

## Goal
The Study mode screens, the Mind hub home, and the docs.

## Decisions already made (owner)
- Craft apps open in **Game mode** on first launch and then remember the last mode, per child. A mode toggle sits in the top bar on every screen. A parent can lock a child to one mode (behind the parent gate, with a lock icon while locked).
- Bottom bar changes with the mode: Game: Play, Challenges, Shop. Study: Learn, Progress, Revise. The Mind hubs have no modes (Games, Challenges, Shop).
- The interface level of Scout and Ranger follows the child's year level (Scout Foundation to Year 2 and Years 3 to 6; Ranger Years 7 to 8 and Years 9 to 10).
- Card content: Scout shows stars, bars and chips with no percentages; Ranger and Champion also show accuracy. Mastery levels Learning, Getting there, Mastered (rule in `design/tokens.json`, `mastery`). Pack cards show "Preview free" and a locked "Full pack" with no price; the price only appears behind the parent gate. A "try next" card tops Play and Learn.
- No human figures or faces in any art.

## Scope
- **Study mode screens:** Learn (goal card, "try next", topics by year with progress, mastery chip and "to revise" chip, accuracy for Ranger and Champion only, extra packs the parent has downloaded, pack cards with no price), Progress (per topic: items passed, still to pass, next release, stars earned), Revise (the "revise mistakes" list). Untimed practice with explanations, using the Quick quiz from 1C. They replace the Study placeholder from 2B1.
- **Mind hubs:** the home with the hero, a "continue" card and the game tiles (stars, best score, coin price on locked games), tabs Games, Challenges and Shop. No modes, no study content.
- **Screens not in Figma** (Progress, Revise, parent area, settings) follow the same widgets and tokens; keep them simple and consistent.
- **Docs:** `docs/DESIGN_SYSTEM.md` and the template `docs/SPEC.md` updated (modes, mastery, the new data and where it is stored), `ENGINE.md` if the engine changed.
- Test IDs for every new screen in `lib/ui/test_ids.dart`.

## Acceptance
All template checks pass and the factory CI is green on every sample. Tests: the Study tabs and screens build for every Craft app and every year level; cards show accuracy only for Ranger and Champion; pack cards show no price; the Mind home builds with no mode toggle; no layout overflow at 150 percent text on the new screens; screen-reader labels present.

## Out of scope
The real minigames (the app issues), real artwork beyond the design files, real AdMob IDs, any AI feature.

## Lessons from 2A (read these)
- 2A used up its turns before it could comment, and its CI was red on the generated sample games (craft and mind) until fixed by hand. Generated games run the same tests as the template: a test must not assume an app id, a mode or a file that a generated game may not carry (the template has all five designs; a generated game has only its own). The factory CI generates samples for puzzle, craft child, craft teen and mind and runs every test in each.
- Aim for at most 5 steps. After each step run `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test`, the template scripts and `python3 -m unittest discover -s scripts/tests`, then commit and push and move the pin. Do not push on red.
- Keep tests short and few per feature; write the final summary comment while you still have turns (about 15 turns before the end). If the work is not finished, comment exactly what is done and what remains.
- The `@claude` token cannot push `.github/workflows` files; put any workflow YAML in your final comment.
