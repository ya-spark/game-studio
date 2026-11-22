# G-15 Snake -> Parcel train (`snake` -> `parcel_train`)

- Status: SPEC DRAFTED 4:02 PM AEDT 22 Nov (docs only, `docs/FEATURE-SPECS.md` section "G-15 Parcel train"); owner answers 5 questions, then build only on owner start
- Owner decisions: none yet (rules of the rewrite list apply: toys only, no title bar, folder/package/id = title)
- Next step: owner answers the 5 questions (title, courses and bumpers, tunnels, Games-tab score, speed and `snake_series`); then build steps 1 to 5 in the spec (1 rename and migration first).
- Links: rules in `docs/queue/GAMES-REWRITE.md`; review in `docs/queue/GAME-REVIEW.md` (look 2, feel 2, depth 4); spec in `docs/FEATURE-SPECS.md`; current game `game-factory/games/snake` (SPEC and rules code kept, renamed).

## Summary of the proposal
- Idea: a toy train (no driver, no face) collects gift parcels on a play mat; each parcel couples a wagon; 5 fixed courses with drawn rails, block walls, fences, pond, tunnels and a station gate; the old endless game stays as Free ride. A snake is an animal, so title and art change.
- Kept: rules code (grid steps, turn queue, no reverse, tail cell free, grow, 10 points, filled board, edge wrap switch), Free ride speed curve, stars 50/150/300, coins 1 per 20, best score, swipe and arrow buttons, arcade frame.
- New: courses (5 maps, goal, golden parcel, station gate), 3 bumpers (a hit waits, the 4th derails and restarts), tunnels, course stars (deliver, golden, no bumper), ready beat, parcel placement rules (first parcel ahead, no dead ends), smooth movement, smoke, couple spring, confetti, sound hooks, arrow pad with keys shown.
- Rename: folder, package `game_parcel_train`, id, library, classes (`TrainGame` ...), tests, registry, cognitive skill key, how-to catalogue, web rules text, `renamedGameIds` (best score, edge setting), web alias and `patch_renamed_games.py`. `snake_series` not touched (flagged).
- Contracts: no question contract (arcade), skill `spatial`; keys: arrows and W A S D steer, Enter or Space starts, Space or P or Esc pauses, keys shown on every button; web hides rewarded Continue and Remove ads (B-18).

## Detail (verbatim from the old queue row)
- Note: Mind Presto only.
- Steps: 1 ideas (2 or 3 concepts) in chat, 2 owner picks, 3 spec in `docs/FEATURE-SPECS.md`, 4 build only when the owner says start.
