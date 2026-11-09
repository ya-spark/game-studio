# [change] factory: shared minigames, series builder and word builder (M3 of 3)

**Repo:** game-factory (`lib/engine/minigames/`). **Depends on:** 1C (the framework) and issue 2 (themes). These games are shared by Craft Scout, Ranger and Champion.

## Goal
Series builder and word builder as reusable minigames that read content items through the engine, so each Craft app only chooses them from its registry.

## Common rules for every minigame
- Pure-Dart rules in `lib/engine/minigames/<game>/rules/` (no Flutter or Flame imports); Flame or Flutter views separate; the random source is injected.
- Implements the `MiniGame` interface (item types, `minPool`, modes, `access`, `coinPrice`) and scores through `QuizSession` (stars on the first pass of an item).
- Two difficulty levels driven by the child's level (younger: pictures and voice where the item has them, no timer, no failing; older: text and a gentle timer). Champion uses the older level with a harder setting and mature art.
- Reads aloud on request through `SpeechService`; screen-reader labels on every control; no layout break at 150 percent text; contrast of at least 4.5 to 1; reduce motion honoured.
- Ads: the banner is shown only on the game's menu, start and results screens, never during play. No interstitials.
- Test IDs for every control in `lib/ui/test_ids.dart`; unit tests for the rules and widget tests for the screens.

## Games
- **Series builder:** put steps or numbers in order. Uses `series` items. Younger level: count 1 to 20 and big picture steps; older level: patterns, sequences and longer series. Works in Game and Study mode.
- **Word builder:** build the answer from letter tiles with a hint. Uses `word` items and `cloze` items. Younger level: short words with a picture and speech; older level: spelling, prefixes and suffixes. Works in Game and Study mode.


## Acceptance
`flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` and the safety scripts pass; each game has rule tests, a widget test and a registry test that the game appears only when enough items are open.

## Out of scope
The other minigames, the apps themselves (issues 03 to 05), real content, real artwork beyond the design phase files.
