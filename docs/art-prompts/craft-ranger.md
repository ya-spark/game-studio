# Craft Ranger games: art prompts and status

App: `apps/game-craft-lowteen` (registry `lib/ui/game_registry.dart`). Workflow, rules and the **shared style block** are in
`README.md`; every prompt below starts with that style block (paste it first). Text in the games is drawn in code.

## Status

| # | Game (id) | Status | Pieces it needs | Notes |
|---|---|---|---|---|
| 1 | Balloon pop (`balloon_pop`) | DONE 2026-11-21 (sheet `sheets/craft-ranger_balloon_pop.png`) | 6 coloured balloons, grey balloon (7 cut, used) | Wired in Scout (`game-craft-preteen`, uncommitted); same screen file in Ranger, not applied yet. Pop frames, hearts, clouds, sky are on the sheet, unused. |
| 2 | Quick quiz (`quick_quiz`) | PROMPT READY, waiting for the owner's sheet | answer plates, right/wrong marks, timer, streak flames, stars | prompt below |
| 3 | Door runner (`door_runner`) | TODO | doors, runner, zap, slow, hearts | Scout has a rewrite (DR1, code-drawn glowing look); art for Ranger only after the owner decides |
| 4 | Tug of war (`tug_of_war`) | TODO | rope, centre flag, two team mascots (animals), pull effects | |
| 5 | Series builder (`series_builder`) | TODO | number/item tiles, empty slot, track | |
| 6 | Word search and crossword (`word_grid`) | TODO | letter tile, selected tile, found highlight, word chips | |
| 7 | Equation builder (`equation_builder`) | TODO | blank tiles, operator plates, equals bar, balance | |
| 8 | Sort into bins (`sort_bins`) | TODO | 3 bins, item cards, drop glow | |
| 9 | True or false (`true_false`) | TODO | big true/false buttons, statement card | |
| 10 | Flash review (`flash_review`) | TODO | card front/back, know it / again buttons, deck | |
| 11 | Memory match (`memory_match`) | TODO | card back, blank card face, matched glow, pairs | |
| 12 | Word builder (`word_builder`) | TODO | letter tiles, tray, check button, hint | |
| 13 | Cloze fix (`cloze_fix`) | TODO | sentence strip with a blank gap, word chips | |
| 14 | Shooter (`shooter`) | TODO | cannon, targets, shot, hit burst | tile art also missing (U1 in QUEUE) |

When a game's turn comes, Claude first reads its screen in `apps/game-craft-lowteen/lib/ui/minigames/` and writes the prompt
here, so the prompt matches what the game really shows.

## 1. Balloon pop (DONE): reference prompt used
Rows: 6 coloured balloons; pop animation (5 frames); wrong-answer feedback (grey wobble, half deflated, flat, X badge, tick
badge, broken heart); UI icons (heart, empty heart, star, coin, bulb, pause, exit, flame); background bits (3 clouds, sun,
sparkles, confetti, string curls); one tall sky panel. Result: `sheets/craft-ranger_balloon_pop.png`,
boxes `tools/balloon_pop_boxes.json`.

## 2. Quick quiz (next): prompt to paste
```
<paste the shared style block from README.md here>

Sprite sheet for the game "Quick quiz" (a question, four answer plates, a timer, a streak).

Row 1 - ANSWER PLATES, blank (big empty centre for text), rounded rectangles, same size, 4 colours: blue, orange, green,
purple, each with a small round empty badge on the left (for a letter drawn later).
Row 2 - PLATE STATES, same shape in: selected (thicker outline and a soft glow ring), correct (green with a big white tick
on the right), wrong (red with a white cross on the right), disabled (grey, flat), pressed (slightly smaller, darker).
Row 3 - QUESTION BOARD: one wide blank rounded panel with a small tab on top, one blank speech-bubble panel, one blank
scroll banner.
Row 4 - TIMER: a round stopwatch in 4 stages (full green ring, three-quarters yellow, half orange, almost empty red with
a tiny shake line), plus an hourglass and a small alarm bell.
Row 5 - STREAK AND REWARD: flame level 1 (small), level 2 (medium), level 3 (big with sparkles); 3 stars earned (gold)
and 3 stars empty (grey outline); a trophy cup; a gold coin; a heart; an empty heart.
Row 6 - EFFECTS: a green sparkle burst (right), a red soft shake mark (wrong), confetti pieces in mixed colours, three
small sparkles, a round badge with a tick.
Row 7 - one tall soft background panel (pale blue to white) with a faint pattern of tiny stars, visible border.
```
