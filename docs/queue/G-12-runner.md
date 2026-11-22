# G-12 Runner -> Wind-up dash (`runner` -> `wind_up_dash`)

- Status: SPEC DRAFTED 4:15 PM AEDT 22 Nov (docs only, `docs/FEATURE-SPECS.md` section "G-12 Wind-up dash"); owner answers 5 questions, then build only on owner start
- Owner decisions: none yet (rules of the rewrite list apply: toys only, no title bar, folder/package/id = title)
- Next step: owner answers the 5 questions (title, courses and free run, Space = jump, spring meter, star thresholds); then build steps 1 to 5 in the spec (1 rename and migration first).
- Links: rules in `docs/queue/GAMES-REWRITE.md`; review in `docs/queue/GAME-REVIEW.md` (look 1, feel 1, depth 2); spec in `docs/FEATURE-SPECS.md`; current game `game-factory/games/runner` (SPEC and rules code kept, renamed).

## Summary of the proposal
- Idea: toy wind-up car (no driver) on a playroom floor collecting paper stars, hopping toy bricks and floor gaps; 5 fixed courses with checkpoints and a flag, plus the old endless free run.
- Kept: all rules code, speed curve, jump arc, fair seeded track and bot test, score, coins, best score, stars 100/250/500.
- New: courses (5 backdrops, hazard mix and start speed per course), stars to collect (+5 points), 0 to 3 course stars (70 and 90 percent), spring meter shield (10 stars = one brick bounce), free checkpoint restart, ready beat, input buffer and coyote time, parallax, shake, tumble, dust, sound hooks.
- Rename: folder, package `game_wind_up_dash`, id, library, classes, tests, registry, cognitive skill key, how-to catalogue, `renamedGameIds` (best score), web alias and `patch_renamed_games.py`.
- Contracts: no question contract (arcade), skill `speed`; keys: Enter or Space starts and Space jumps, P or Esc pauses, keys shown on buttons; web hides rewarded Continue and Remove ads (B-18).

## Detail (verbatim from the old queue row)
- Note: Mind arcade.
- Steps: 1 ideas (2 or 3 concepts) in chat, 2 owner picks, 3 spec in `docs/FEATURE-SPECS.md`, 4 build only when the owner says start.
