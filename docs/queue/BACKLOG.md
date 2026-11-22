# Backlog (owner: nothing here starts until the owner says start; created 3:12 PM AEDT 22 Nov 2026)

Each item: what, why, where, state. Items with a spec are marked; the rest need a short discussion first.

## From the owner's reports and requests
- **B-01 Bridge builder: Space selects, not pause.** Owner: Space is not necessarily pause in every game; in Bridge builder Space should select the choice (same as Enter: place the chosen tile, then Go/Next). Pause stays on the pause button and Esc. Then review every game's Space role one by one (each game's SPEC "Keyboard" says what Space does; the U2 item 2 change made Space = Next/Start/Leave outside play and = pause in play in the choice kit). Files: `game-factory/games/bridge_builder` (screen, keyboard, SPEC, tests), `docs/KEYBOARD.md`.
- **B-02 Bridge builder: boxes 4 and 5 not shown after a selection.** Owner: the 4th and 5th slots do not show the chosen tile (older levels have 5 slots). Likely a layout or paint bug in the slot row. Reproduce at several sizes, fix, add a test. Files: `games/bridge_builder/lib/src/...`.
- **B-03 Domino chain build (G-13).** Spec drafted (`docs/FEATURE-SPECS.md`, commit d9792b8). Build was STARTED and STOPPED by the owner (3:11 PM AEDT); the half-done rename `series_builder` -> `domino_chain` is saved as a git stash in `game-factory` (`git stash list`: "STOPPED Domino chain build"). Restart from the stash or from scratch when the owner says start.
- **B-04 Unsupported-topic screen: three improvements.** (1) message plus year buttons when the game has no topics in this year, (2) topics list above the games row, (3) fit 1280x720 without scrolling. Reproduction: `https://activemindcraft.com/ranger/#/play/word_grid/maths/7/integer_operations`. STARTED and STOPPED by the owner (3:11 PM AEDT); the partial change is a git stash in `games-web` ("STOPPED unsupported-topic screen improvement"). Files: `games-web/overlay/craft/lib/web_product/craft_shell.dart`, `overlay/craft/test/web_shell_test.dart`.
- **B-05 Web bar overlap at 390 px.** The Rules button overlaps the Game menu button (`games-web/overlay/common/lib/web_product/web_bar.dart`). Folded into W7 step 1 unless the owner wants it sooner.
- **B-06 Bridge builder catalog tile art.** The card still shows the old tiles icon; draw a bridge tile in the site's tile style (`games-web/site/art/bridge_builder.svg`, `game_art_data.dart`).
- **B-07 Bridge builder Figma art.** The art is code art. Owner runs `docs/art-prompts/bridge-builder-figma-prompt.md` in Figma when the plan allows, then hands the result back.

## Specs written, waiting for the owner's start
- **W5 browser notifications** (proposals confirmed; builds behind `REMIND_ENABLED = false` until the owner's child-directed check C9).
- **M8 web coins** (owner has 4 open questions).
- **W7 web game layout with side panels** (decisions applied; 4 questions answered).
- **G-13c ordering content** (132 new series items for 2 per topic, 425 for 4): content, not code.

## Needs a discussion, then a spec
- **W8 web shows games only** (no Craft/Scout/Ranger/Champion/Mind/Ember/Presto wording; web addresses, year/topic flow, version label, "From ..." labels).
- **G-01 to G-24 game rewrites** (one game at a time; start with True or false, Balloon pop, Sort bins, Tug of war). Tug of war is not on the web today (coin-locked in the apps): add it as a free web game when it is rewritten.
- **Games whose folder differs from their title:** rename only when each is rewritten (owner): cloze_fix ("Fill the gap"), sort_bins, mahjong, word_grid, block_puzzle (case), brick_breaker (Mind id `bricks`), stack_tower (Mind id `stack`), snake_series (titled "Snake").
- **Constellation:** wire `BrowserProgress` into My stars and the games; the W7 left panel uses it.
- **U1 audit of the 23 games:** needs the owner's look-and-feel target, known-bad games and tile art choice.
- **Topic list review** (owner names the first year).
- **Site look refresh** after W7 and W8.

## Owner items (not Claude)
- AdSense: Verify (parked 1:00 PM AEDT 22 Nov), slot ids, consent message, child-directed check C9, ad units, Families rules.
- Review the how-to-play texts and listen to the M4 sound packs; Scout coin question; resume #148 when ready.
- Play on a real keyboard (K1 and Space changes) and look at Bridge builder live.
