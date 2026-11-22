# Game rewrite list (owner, 2:00 PM AEDT 22 Nov 2026)

- Every game is reimagined, discussed with the owner, specified, then rewritten (like U3 Bridge builder, DONE: formerly the sum game). One item per game below; Bridge builder is not in the list.
- Each rewrite gets everything a new game gets: `game-factory/docs/BEST_PRACTICES.md`, keyboard (Space goes on), frame and chrome, responsive web layout, question and skill contracts, SPEC with a test map, Figma art (code art if Figma is blocked), no living beings (toys, robots, shapes, objects only), cartoon look unless the owner says otherwise.
- Discuss ONE game at a time with the owner; code only when the owner says start for that game. Suggested first picks (owner to say): the boring ones that most children meet first: Tug of war, True or false, Balloon pop, Sort bins.

One file per game: `G-NN-<name>.md`.

## Naming rule (owner, 2026-11-22)

A game's folder, package and id are its name; the web shows the game's title. So **each rewrite also renames its folder, package (`game_<name>`) and id to the new title**, together with the saved-data migration (game_core `renamedGameIds`, the web's `amc.state`; the old link is aliased in `web_link.dart`) and the web build patch (`games-web/scripts/patch_renamed_games.py`, which keeps the paused apps untouched). Done for U3: `equation_builder` -> `bridge_builder` (game-factory a0d6a52).

- G-13 Series builder becomes Domino chain: rename folder, package and id `series_builder` -> `domino_chain` in that rewrite (this replaces "the id stays").
- Titles that differ from the folder or id today (flagged, NOT renamed now; rename in each game's rewrite): `cloze_fix` (title "Fill the gap"; web catalogue "Cloze and grammar fix"), `sort_bins` ("Sort into bins"), `mahjong` ("Mahjong solitaire"), `word_grid` ("Word search and crossword"), `block_puzzle` ("Block Puzzle", same words, only the case differs), `brick_breaker` (title "Brick breaker", but the Mind app id is `bricks`), `stack_tower` (title "Stack tower", Mind app id `stack`), `series_builder` (title becomes "Domino chain"), `snake_series` (Mind id, title "Snake"; own item G-25). `snake` was renamed `parcel_train` in G-15 (22 Nov). Others match their title: balloon_pop, door_runner, flash_review, memory_match, true_false, tug_of_war, word_builder, shooter, runner, sudoku, solitaire, merge, wingy, blockfall, ball_sort.
