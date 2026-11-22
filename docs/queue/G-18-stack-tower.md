# G-18 Stack tower -> Crane tower (`stack_tower` -> `crane_tower`)

- Status: SPEC DRAFTED 4:02 PM AEDT 22 Nov (docs only, `docs/FEATURE-SPECS.md` section "G-18 Crane tower"); owner answers 5 questions, then build only on owner start
- Owner decisions: none yet (rules of the rewrite list apply: toys only, no title bar, folder/package/id = title)
- Next step: owner answers the 5 questions (title, courses and free climb, Space = drop, Mend and spares, course stars); then build steps 1 to 5 in the spec (1 rename and migration first).
- Links: rules in `docs/queue/GAMES-REWRITE.md`; review in `docs/queue/GAME-REVIEW.md` (look 2, feel 2, depth 2); spec in `docs/FEATURE-SPECS.md`; current game `game-factory/games/stack_tower` (SPEC and rules code kept, renamed).

## Summary of the proposal
- Idea: toy tower crane on a playroom table drops wooden blocks; the overhang breaks off and tumbles; the camera climbs; 5 fixed towers with a flag plus the old endless free climb.
- Kept: rules code (100-unit world, 1/120 s step, base 40, speed 40 + 2.5 per block cap 120, perfect 1.2 snap, score 10 + 5 x streak, stars 200/600/1500, coins 1 per 25 at most 20, attention skill).
- New: courses (5 backdrops, base width, speed and target height each), spare crates (3; a miss costs one, 5 perfects give one back), checkpoints every 10 blocks, Mend (3 perfects widen the next block, courses 3 to 5), course stars by perfect drops (30 / 60 percent), ready beat, input buffer, sway, tumble, sparkle ring, sound hooks.
- Rename: folder, package `game_crane_tower`, id (also the `stack` Mind id), library, classes, tests, registry, cognitive skill key, how-to catalogue, `renamedGameIds` (`stack_tower` and `stack`), web alias and `patch_renamed_games.py`.
- Contracts: no question contract (arcade), skill `attention`; keys: Enter or Space starts and Space drops, P or Esc pauses, keys shown on buttons; web hides rewarded Continue and Remove ads (B-18).
- Open questions: title; courses plus free climb; Space = drop; Mend and spares; course stars rule.

## Detail (verbatim from the old queue row)
- Note: Mind arcade.
- Steps: 1 ideas (2 or 3 concepts) in chat, 2 owner picks, 3 spec in `docs/FEATURE-SPECS.md`, 4 build only when the owner says start.
