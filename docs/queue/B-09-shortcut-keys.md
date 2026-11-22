# B-09 / B-16 / B-17: every button has a shortcut key (owner request 3:25 PM AEDT 22 Nov 2026)

Rule (docs/KEYBOARD.md in game-factory, section "B-09"): Enter and Space go forward (Start, Next, Play again, Done, Got it); Esc leaves or closes (pauses in play); 1 to 4 choose (5 to 9 where a game has more); Backspace takes a step back; H hint; P pause where Space is an action; L leaves a round; Q reads aloud. Every button prints its key: "Next (Enter / Space)".

State: DONE 8:10 PM AEDT 22 Nov 2026. game-factory 86435a2 (kit and 20 games), 7dac94c (Block puzzle, Blockfall, Wingy, B-17), 9902f7b (keyHintsFit), 5f1c327 (Merge Undo, New garden); games-web ccafec6 and 4d0e2b4 (Got it dialog, factory.ref 9902f7b).

## How it was fixed (shared kit first)
| Kit piece | Change | Games fixed at once |
|---|---|---|
| `kit/keys/key_labels.dart` (new) | `keyedLabel`, `KeyedText`, `withKey`, `KeyedIconButton`, `KeyedBackButton`, `keyNameOf` | all |
| `GameKeyboard.shortcuts`, `KeyedBody.shortcuts/extraHints`, `KeyHints.extra` | fixed keys (L, H, Backspace, letters) beside the map, with hint chips | all keyed games |
| `GameTopBar`, `PauseOverlay` | exit prints L, pause prints Esc; "Resume (Esc / Space)", "Leave game (L)" | Tug of war, Memory match, Bridge builder, Domino chain, choice kit |
| `ChoiceGameScreen` + `ChoiceLabel` | Start, Next, See results, Done print keys; answers show number caps; L leaves; intro extra keys | Balloon pop, Shooter, True or false, Cloze fix, Tug of war |
| `ArcadeFrame` | Play, Play again, Done (Esc), Continue (C); L leaves a round; `hintWords` | Brick breaker, Runner, Stack tower, Parcel train |
| `CalmResults`, `MiniGameSummary` | Play again (Enter / Space), Done (Esc) | Ball sort, Mahjong, Merge, Solitaire, Sudoku, Sort into bins, Memory match, Word builder, Flash review |
| web `RulesGate` dialog (games-web overlay/common) | "Got it (Enter / Esc)", autofocused so Enter closes it (B-16) | every web game |

## Audit: every screen and button (before, now)
"Before" says what was missing. Keys in the "Now" column are what the button prints.

| Game | Screen / button | Before | Now |
|---|---|---|---|
| Balloon pop, Shooter, True or false, Cloze fix (choice kit) | Start | Enter worked, button had no key | Start (Enter / Space) |
| | answers | keys 1-4, no numbers (Shooter had) | number cap on each answer |
| | Next / See results | key worked, not printed | Next (Enter / Space) |
| | Done | key worked, not printed | Done (Enter / Space) |
| | X exit, pause icon | no key printed | L, Esc under the icon; L leaves from anywhere |
| | pause screen Resume, Leave game | Esc/Space resumed, no L | Resume (Esc / Space), Leave game (L) |
| | read aloud icon | Q, not printed | Q printed |
| Tug of war | same as kit + Head to head | no key | Head to head (2 players) (H) |
| Tug of war head to head | Start, Play again, Leave | "Start (Enter)" only | Start / Play again (Enter / Space), Leave (Esc / L), L leaves |
| Door runner | start screen | NO keyboard at all: Enter did nothing (B-16) | Enter or Space starts, 2 races, Esc or L leaves; Start (Enter / Space) |
| | results Done | no keys | Done (Enter / Space), Esc, L |
| | exit X, pause | no key printed | L, Esc; Quit (L), Resume (Esc / Space) |
| | question dialog | keys 1-4 did nothing inside the dialog | 1-4 answer, Q reads, Esc / Space / Enter back; buttons print keys |
| | wrong-answer Next | worked, not printed | Next (Enter / Space) |
| | race: Start, Play again, Leave | "Start (Enter)" | Start / Play again (Enter / Space), Leave (Esc / L) |
| Memory match | Next, See results | not printed | printed |
| | 1 player / 2 players | no keys | (1), (2) |
| | Leave, pause, exit, speaker | partly | L, Esc, Q printed; two players Play again, Leave (Esc / L) |
| Bridge builder | Done, Next bridge / stage | not printed | (Enter / Space) |
| | Clear, Lay plank | NO key | Clear (R), Lay plank (G) |
| | exit, pause, speaker | tooltip only | L, Esc / P, Q under the icon; P pauses (Space selects) |
| | hint row | "1-4 tile" although 5-9 work (B-17) | "1-N tile" (N = tiles), Backspace, G, R, P, L |
| Domino chain | exit, speaker, pause | exit tooltip said Esc (Esc pauses) | L, Q, Esc / P printed; P pauses; hint row adds L, P |
| | Start, Next, Done, Hint, Go | already printed | unchanged |
| Brick breaker | Play, Play again, Done, Continue | Play / Done / Continue no key | Play, Play again (Enter / Space), Done (Esc), Continue (C) |
| | Launch | none | Launch (Enter / ↑); hint says "launch" |
| Runner | Jump | hint said "select", no jump key (B-16) | Jump (↑ / Enter), hint says "jump"; arcade buttons as above |
| Stack tower | Drop | hint chip "go" | Drop (Enter / ↑ / ↓), hint "drop"; arcade buttons as above |
| Parcel train (other agent) | arcade frame buttons | as Brick breaker | fixed through `ArcadeFrame`; its own file not touched |
| Ball sort | Play level, Start from level 1 | Enter/1, no print | (Enter / Space), (R) |
| | Undo, Add a tube, Restart level | NO key | Undo (Backspace), Add a tube (T), Restart (R) |
| | results, back | not printed | Play again (Enter / Space), Done (Esc), back arrow prints Esc |
| Mahjong | layout buttons | Enter/1-4 worked, not printed | (1) to (4) |
| | Hint, Undo, Shuffle | keys 1, 2, 3 only, not printed | Hint (H / 1), Undo (Backspace / 2), Shuffle (3); H and Backspace new |
| Merge | menu Play, Classic, Relaxed | not printed | (Enter / Space), (Enter / Space / 1), (2) |
| | hint row | "select", "best" for ↑ ↓ (B-16) | "slide left / right", "slide up", "slide down" |
| Solitaire | Play | not printed | Play (Enter / Space) |
| | Undo, New deal, Hint, Auto-complete | 1, 2 only; New deal and Auto-complete no key | Undo (Backspace / 2), New deal (N), Hint (H / 1), Auto-complete (A) |
| | level chips | pointer only | Left / Right change the level (hint chip) |
| Sudoku | level Play, Resume, New puzzle | 1-4 only, not printed | Play (1-4), Resume (1-4), New puzzle (E / M / H / X) |
| | Notes, Erase, Undo, Hint | N, Backspace; no Undo key | Notes (N), Erase (Backspace), Undo (U), Hint (H / Enter) |
| | digit bar | clipped under the key hints at short heights (B-17) | see "B-17" below |
| Word builder | Check, Undo, Clear | keys 1, 2, 3, not printed | Check (1), Undo (Backspace / 2), Clear (3) |
| | letters | arrows + Enter only | type the letter (A-Z) picks it; clipping fixed (B-17) |
| | Next, Done, speaker | not printed | printed (Enter / Space, Q) |
| Word grid | Word search, Crossword | 1, 2, not printed | (Enter / Space / 1), (2) |
| | Finish round, Undo | NO key | Finish round (E), Undo (Backspace); crossword letters typed |
| Flash review | Start, Flip, I knew it, Not yet, Done | keys worked, not printed | (Enter / Space), (1 / →), (2 / ←); Q reads |
| Sort into bins | bins, Next, Done | no numbers | number caps 1-4, (Enter / Space), Q reads |
| Web how-to dialog (all web games) | Got it | Enter did nothing (B-16) | Got it (Enter / Esc), autofocused |

## Not done
- Blockfall, Block puzzle, Wingy: app games, not on the web, apps paused; not audited into code. Blockfall already has `GameKeyboard`; its dialogs, boost sheets and store buttons are app UI.
- Level chips and settings switches on menus (Hints, Show mistakes, Winnable deals, Mahjong tier): reached with Tab and Space or Enter, no printed key.
- Games-web chrome outside the game (All games, Rules, Game menu, catalog): the other agent's craft overlay work; `web_bar.dart` and `craft_shell.dart` not touched.

## B-17 details
- Word builder: the letter tiles were full-width orange bars (a Container with `alignment` stretches in a Wrap); they run past the window and slide under the hint row. Fixed; widget test checks every tile is under 120 dp wide.
- Sudoku: the board was always 480 dp square, so the digit bar and the tool row were below the visible area at 1280x720. The board now takes the height that is left (min 180); test at 1280x720, 844x390, 390x844 checks the digit bar sits above the hint row.
- Bridge builder: hint row "1-4 tile" is now "1-N tile" with N the tile count (up to 9).
- Hint rows (all keyed games) are shown only when the window is 600 wide and 520 tall; on a short window the play area keeps the height.

## Browser check (Chromium, local web builds of ranger and ember with the commits above)
Opened and keyed through: Door runner (how-to dialog Enter/Esc, Start, play, Esc pause screen), True or false (intro, play, answer, Next, results), Balloon pop, Shooter, Flash review, Word builder (typed letters, Check, Space for Next), Bridge builder (intro, play, pause at 1280x720, 390x844, 844x390), Domino chain (390x844, 1280x720), Sudoku (menu, play, hint at 3 sizes), Merge, Mahjong, Solitaire, Ball sort, Block puzzle (pause dialog with Resume and Exit keys), Blockfall (pause screen). No page scroll at any size (scrollHeight equals innerHeight). Screenshots were looked at; fixes from them: Word builder bars, Sudoku clipping, hint words (up / down), Merge Undo and New garden keys, hint row hidden on short windows. Not opened in a browser: Tug of war and head to head, Memory match, Sort into bins, Word grid, Door runner race, Wingy (covered by widget tests only).
