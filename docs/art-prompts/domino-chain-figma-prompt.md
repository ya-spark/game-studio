# Domino chain art kit: Figma prompt (owner runs it when the plan allows, hands the result back)

Code art ships first (`game-factory/games/domino_chain/lib/src/ui/domino_art.dart`). When the Figma result comes back, the painters are replaced by exported SVG (and listed in `assets/LICENSES.md`). The owner's Figma plan hit its tool limit on 22 Nov 2026 (see the Bridge builder prompt).

Hard rule (owner, 2026-11-22): no living beings. No people, no animals, no faces of creatures. Everything is a toy object: dominoes, a flag, a lever.

## Prompt

Design a small art kit "Domino chain" for a children's ordering game, cartoon style: thick dark outline #2B2A4C (3 px at 1x), flat bright colours, soft rounded shapes, toy-like, friendly, no text except where named.

1. **Domino.** A toy domino, cream face #FFF3D6, rounded corners, a coloured top band (20% of the height) with three white pips, hard drop shadow (0, 4, #2B2A4C at 35%). Component set "Domino" with variants: colour band (blue #3B82F6, orange #F59E0B, teal #14B8A6, purple #8B5CF6) x state (rest, tipped: green outline #2E9E5B and pale green face #D9F5E3, drawn flattened and leaning right; broken: red outline #D64545 and pale red face #FFE0E0) x size (short 120 x 92 tall-ish, long 190 x 92 wide). Leave the face empty for the step text.
2. **Slot.** A numbered slot on the table: translucent white #FFFFFF at 55%, dashed dark outline, a faded number. Variants: empty, next (thicker outline), hint (gold outline #FFB400).
3. **Table and sign.** A cream sign board #FFF3D6 (outline, rounded 12) for the prompt text, 600 x 90, sitting on top of the table.
4. **Toy flag.** A pole with a dark ball on top and an orange pennant with a cream stripe, 160 x 320, plus a lit and an unlit star (gold #FFD43D outlined, translucent white).
5. **"?" tag.** A red circle #D64545 with a white outline and a white bold question mark, 48 x 48.
6. **Spark and dust.** Eight yellow spark strokes in a burst; three white dust puffs along the floor.
7. **Go lever.** A small green toy lever: a white knob on a stick in a dark slot, 48 x 48, for the Go button.
8. **Three backdrops, 1200 x 560 each**, with the table surface from 30% of the height down:
   - **Playroom floor:** light-blue wall, warm wooden floor planks.
   - **Toy shelf:** cream wall with dots, a brown shelf board.
   - **Window sill:** blue sky with clouds, a white window cross, a pale sill.
9. **Results card, 600 x 300:** the sill backdrop with five tipped green dominoes and the flag with three lit stars.

Name layers like the item names. Reuse the domino and star components in the backdrops and the results card.

## What the result feeds
- `lib/src/ui/domino_art.dart`: `paintDomino`, `DominoBackdropPainter`, `ToyFlagPainter`, `SparkPainter`, `DustPainter`, `GoLeverPainter` and `DominoRowPainter` are replaced by exported SVG (or kept and redrawn to match).
- The catalog tile (`games-web/site/art/domino_chain.svg`, `game_art_data.dart`) stays a flat 96 by 96 tile in the site style.
