# [change] factory: shared minigames, door runner and balloon pop (M1 of 3)

**Repo:** game-factory (`lib/engine/minigames/`). **Depends on:** 1C (the framework) and issue 2 (themes). These games are shared by Craft Scout, Ranger and Champion.

## Goal
Door runner and balloon pop as reusable minigames that read content items through the engine, so each Craft app only chooses them from its registry.

## Common rules for every minigame
- Pure-Dart rules in `lib/engine/minigames/<game>/rules/` (no Flutter or Flame imports); Flame or Flutter views separate; the random source is injected.
- Implements the `MiniGame` interface (item types, `minPool`, modes, `access`, `coinPrice`) and scores through `QuizSession` (stars on the first pass of an item).
- Two difficulty levels driven by the child's level (younger: pictures and voice where the item has them, no timer, no failing; older: text and a gentle timer). Champion uses the older level with a harder setting and mature art.
- Reads aloud on request through `SpeechService`; screen-reader labels on every control; no layout break at 150 percent text; contrast of at least 4.5 to 1; reduce motion honoured.
- Ads: the banner is shown only on the game's menu, start and results screens, never during play. No interstitials.
- Test IDs for every control in `lib/ui/test_ids.dart`; unit tests for the rules and widget tests for the screens.

## Games
- **Door runner:** the player runs forward and chooses the door with the right answer. Uses `mcq` items. Younger level: slow, few doors, no timer, a gentle retry; older level: faster with a timer and streaks. Game mode only.
- **Balloon pop:** balloons float up and the player pops the right one. Uses `mcq` and `numeric` items (the answer is shown as balloons). Younger level: large balloons, pictures, no losing; older level: more balloons and a timer. Game mode only.


## Acceptance
`flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` and the safety scripts pass; each game has rule tests, a widget test and a registry test that the game appears only when enough items are open.

## Out of scope
The other minigames, the apps themselves (issues 03 to 05), real content, real artwork beyond the design phase files.
