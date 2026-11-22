# G-12 Runner -> Wind-up dash (`runner` -> `wind_up_dash`)

- Status: BUILT 12:20 AM AEDT 23 Nov (game-factory 79e5196..271c023 as pushed, games-web 0b6a3dc, factory.ref 271c023). Browser check done (real course arrival by keyboard, 390x844, 844x390, 1280x720, no page scroll).
- Owner decisions (22 Nov, answered to the builder): 1 title Wind-up dash (id wind_up_dash, package game_wind_up_dash); 2 yes: 5 courses each unlocked by 1 star plus always-open free run, free checkpoint restart, no rewarded Continue on the web; 3 Space = jump in play, pause P or Esc; 4 keep the spring meter; 5 star thresholds 150 / 350 / 700.
- Next step: owner plays it live and answers feel questions (course 5 speed, spring). Not done: Figma art (code art only), real sounds (hooks only), rewarded Continue in paused apps.
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
