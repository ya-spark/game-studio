# Bridge builder art kit: Figma prompt (owner runs it, hands the result back)

The Figma MCP limit blocks writes (22 Nov 2026: `use_figma` answered "tool call limit on the Starter plan"; the plan also has a View seat). A blank file was created: https://www.figma.com/design/SWayJx5Gv0KIshgXzs2u6n ("Bridge builder kit"). Paste the prompt below into Figma (AI, Make or First Draft), then give Claude the result (share the file link or export the frames as SVG). The game works today with the same art drawn in code (`game-factory/games/equation_builder/lib/src/ui/bridge_art.dart`); the Figma result replaces or refines it.

Hard rule (owner, 2026-11-22): no living beings. No people, no animals, no faces of creatures. The character is a toy robot.

## Prompt

Design a small art kit "Bridge builder" for a children's maths game, cartoon style: thick dark outline #2B2A4C (3 px at 1x), flat bright colours, soft rounded shapes, toy-like, friendly, no text except where listed. One page, one frame per item, each frame named as below, everything an editable vector layer (shapes and auto layout, no raster images), exportable as SVG.

1. **Character: "Wind-up robot".** A little toy robot on one wheel, 128 x 160. Orange body #FF9F2E (rounded square), cream face screen #FFF3D6 with two round dark eyes and a smile, a red ball on a short antenna #FF4D6D, a gold wind-up key on its back #FFD43D, two tiny stub arms, a dark blue-grey wheel #4B4F7A with three light spokes. Make three variants as a component set "Robot": normal, happy (closed smiling eyes), wondering (flat mouth).
2. **Planks.** A wooden plank 120 x 120 (wood #C98B4A, darker grain lines #8E5A2B, outline, two nails) in three states as a component set "Plank": empty slot (translucent white, dashed outline, small number), filled (wood), laid (green #7BDC8A with the same grain). Also a long deck strip 640 x 24 with vertical plank lines, and a bridge end post 16 x 60.
3. **Tiles.** Toy blocks 120 x 120 with a hard drop shadow (0, 8, #2B2A4C at 50%): "Number tile" blue #5AA9FF with a big white bold digit, "Sign tile" orange #FFB02E with a dark bold sign. Show the signs + − × ÷ as four variants of "Sign tile".
4. **Sign.** A hanging cream board #FFF3D6 (outline, rounded 12) on two short ropes, 300 x 150, with the word "make" small on top and a large number "12" under it.
5. **Flag and stars.** A flag on a pole with a gold ball on top, red flag #FF4D6D with a wavy edge, 160 x 320; and a star (gold #FFD43D, outlined) in two variants: lit and unlit (translucent white).
6. **Three backdrops, 1200 x 560 each**, with the left and right banks and the bridge deck at 62% of the height, an open gap between the banks about 76% of the width:
   - **River:** light-blue sky gradient #8FD8FF to #DFF6FF, yellow sun, white clouds, green hills, blue river with white wave lines, a lily pad, grass-topped brown banks.
   - **Canyon:** warm orange sky #FFC86B to #FFEBC2, big orange sun, sand-coloured mesas, deep layered canyon walls dark brown at the bottom, striped orange rock banks.
   - **Sky:** dusk gradient #3B4BA8 to #8A6FD1 to #FFB3C7, stars, a rainbow arc behind the gap, soft clouds below, the banks are white puffy cloud islands.
7. **Results card, 600 x 300:** the Sky backdrop with a laid deck, the robot (happy) beside the flag and three lit stars.

Name layers like the item names. Reuse the plank, tile and star components in the backdrops and the results card.

## What the result feeds
- `lib/src/ui/bridge_art.dart`: the painters (`paintToyRobot`, `BridgeScenePainter`) are replaced by exported SVG (or kept and redrawn to match).
- Any exported file goes under `game-factory/games/equation_builder/assets/` and gets a row in `assets/LICENSES.md` (original art, made for the studio).
