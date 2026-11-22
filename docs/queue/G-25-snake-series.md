# G-25 Snake series (`snake_series`)

- Status: NEW 7:55 PM AEDT 22 Nov (owner chose to give it its own item when answering G-15 question 5). NOT STARTED; needs its own rewrite spec first, nothing is built now.
- Owner decisions: none yet. The G-15 answers apply as the pattern: rename to the new title (folder, package, id = title), toys or objects only, no title bar, keys shown on every button, responsive, no rewarded Continue or Remove ads on web.
- Next step: look at the game (a Mind app game: steer a snake with arrows or swipe, eat items in the right order, walls wrap, bumping into yourself only makes you shorter; question contract: ordered items), propose 2 or 3 concepts (for example a train or a toy caterpillar-free object chain, never an animal), owner picks, write the spec in `docs/FEATURE-SPECS.md`, build only when the owner says start.
- Links: rules in `docs/queue/GAMES-REWRITE.md`; sibling rewrite: `docs/queue/G-15-snake.md` (Parcel train, built); web rules text in `games-web/overlay/common/lib/web_product/web_rules_data.dart` still says "Snake" and "snake" for `snake_series` (left alone on purpose in G-15; the G-15 `renamedGameIds` and `patch_renamed_games.py` use word boundaries so this id is untouched).

## Why
- `snake_series` is a snake, an animal, so the title, the web rules text and the art break the no-living-beings rule (owner, 2026-11-22). Its Mind id and title are flagged in `GAMES-REWRITE.md`.
